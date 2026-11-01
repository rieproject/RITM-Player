// Platform tanpa backend/dekoder OS (Linux build uji): hanya WAV + file sink.
#if !defined(_WIN32) && !defined(__APPLE__)
#include "backend/backend.hpp"
#include "decode/decoder.hpp"
namespace ritm {
std::unique_ptr<Backend> createSystemBackend() { return nullptr; }
std::unique_ptr<Decoder> openSystemDecoder(const FileRegion&, const std::string&, std::string&) { return nullptr; }
}  // namespace ritm
#endif
