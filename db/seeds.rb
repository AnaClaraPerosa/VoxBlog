require 'net/http'
require 'json'
require 'securerandom'

API_URL = 'http://localhost:3000'

TOTAL_POSTS = 200_000
BATCH_SIZE = 500
TOTAL_BATCHES = TOTAL_POSTS / BATCH_SIZE
LOGINS = 100.times.map { |i| "user#{i}" }
IPS = 50.times.map { |i| "192.168.0.#{i}" }

def send_batch(posts_batch)
  uri = URI("#{API_URL}/posts/batch")
  body = { posts: posts_batch }.to_json

  headers = {
    'Content-Type' => 'application/json'
  }

  response = Net::HTTP.post(uri, body, headers)

  unless response.is_a?(Net::HTTPSuccess)
    puts "Erro ao enviar batch: #{response.code} - #{response.body}"
    return false
  end

  json = JSON.parse(response.body)
  puts "Batch de #{posts_batch.size} criado com sucesso (total enviado: #{json["created"]})"
  true
end

created_count = 0

TOTAL_BATCHES.times do |i|
  posts = Array.new(BATCH_SIZE) do
    {
      title: SecureRandom.hex(8),
      body: SecureRandom.hex(32),
      login: LOGINS.sample,
      ip: IPS.sample
    }
  end

  success = false
  tries = 0

  while !success && tries < 3
    success = send_batch(posts)
    tries += 1
    puts "Tentando novamente..." unless success
    sleep 0.5 unless success
  end

  if success
    created_count += BATCH_SIZE
    puts "Total criado até agora: #{created_count}"
  else
    puts "Falha ao criar batch #{i + 1}, mesmo após 3 tentativas."
  end
end

puts "Finalizado! Total de posts esperados: #{TOTAL_POSTS}, total criado: #{created_count}"
