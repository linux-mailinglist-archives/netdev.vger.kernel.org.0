Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0D0464FB4
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 15:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349967AbhLAOe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 09:34:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349954AbhLAOey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 09:34:54 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABFA1C061574;
        Wed,  1 Dec 2021 06:31:33 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id 133so20614047wme.0;
        Wed, 01 Dec 2021 06:31:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to;
        bh=AVSg4/WN9KI8amUAzB706KjrJrTp7yyBXe9FwK3kyEQ=;
        b=jM7QXIwvMqX3kHlGHv5N+rmn6xt53uznFdzJZwVuS0WcaCp7zGUlviB+xhqQNShEfm
         g4RufN4aZSwg3eSgZ4IhG6DFcRU/RqEv8a47sK5s9n2SdcENBFrOgrGS5OCOmF99bMrI
         IhmjYYB5Wr5fr4J9VtzbKzGGT4rJHuUBBkj9OwPBEsVz+KVeYHhI4EGBP66oQQzICbaa
         uATXTrOHX2+6mLW+wg1oy8QxNRWdIvfjLsp/HPCMwthDAHKfYUbmnJ7puc1pi4OCbwwQ
         WbEhg6hLQFK/Kj+uaKD1P/QC+3WiLjnwDJeZzYzs4YKitNj63WT7hiqckKyaLK1iS/aK
         fnqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to;
        bh=AVSg4/WN9KI8amUAzB706KjrJrTp7yyBXe9FwK3kyEQ=;
        b=D8zjFHI4MSjPZesVFmKZZkSDTfJuIBTSCbsKvqer0WG1byWVyCniVGOn8MGzrj8E5s
         KNbohMw+1ko8SfjbKcYC/UqNT40rJd4evPGYgqIaZXCAz2KWcoSgfNLIk3Sz08nRhqPZ
         m1ddThVC/el6haesZrHY8C2UTIQ98Fp30VmTtFmbYr9rkp+hl4dFxov6ULvopkZeT5Mf
         h/fH3Zt77x3URpVlBcI+ImfapzuI/JRZ04HsxNsTmqb2pKQHTD026romkSWbehLrMTr/
         tvz9s7N14MKOiFKLNq2GZuTjZkrmWz+DrVP9lQ1Q+ovJebMw7KAkg1rKIXHS47QeDvqQ
         EeQw==
X-Gm-Message-State: AOAM530ve6wb88JrtlHhzEHRg6SxunHLK2wDmb7Qub6uKnzYt8c21HJW
        ERd4uOQ8SStgbpy7Cj7+cS4w5p8TdWM=
X-Google-Smtp-Source: ABdhPJyEsh7sxNG9cVMfb5cRd33/ulVTF1vMZohIgFAzPJSaJTNv9sV4bGcriuctKUR1IHuWJvIZ3w==
X-Received: by 2002:a05:600c:4f87:: with SMTP id n7mr7272120wmq.168.1638369091506;
        Wed, 01 Dec 2021 06:31:31 -0800 (PST)
Received: from [192.168.43.77] (82-132-231-182.dab.02.net. [82.132.231.182])
        by smtp.gmail.com with ESMTPSA id y7sm19250476wrw.55.2021.12.01.06.31.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Dec 2021 06:31:30 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------d3uoUfKURQRySJ6dIsw8imz5"
Message-ID: <4c0170fa-5b6f-ff76-0eff-a83ffec9864d@gmail.com>
Date:   Wed, 1 Dec 2021 14:31:27 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [RFC 00/12] io_uring zerocopy send
Content-Language: en-US
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, Jens Axboe <axboe@kernel.dk>
References: <cover.1638282789.git.asml.silence@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1638282789.git.asml.silence@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------d3uoUfKURQRySJ6dIsw8imz5
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/30/21 15:18, Pavel Begunkov wrote:
> Early proof of concept for zerocopy send via io_uring. This is just
> an RFC, there are details yet to be figured out, but hope to gather
> some feedback.

For larger audience, registered buffers is an io_uring feature
where it pins in advance the userspace memory and keeps it as
an array of pages (bvec in particular).
There is extra logic to make sure the pages stay referenced when
there are inflight requests using it, so they can avoid grabbing
extra page references.

Also, as was asked, attaching a standalone .c version of the
benchmark. Requires any relatively up-to-date liburing installed.

gcc -luring -O2 -o send-zc ./send-zc.c

There are also a couple of options added:

./send-zc [options] [-r <nr_submit_batching>] [-f] udp

-r <nr_submit_batch> is @nr_reqs from the cover-letter, 8 by default,
-f sets @flush to true, false by default.


> Benchmarking udp (65435 bytes) with a dummy net device (mtu=0xffff):
> The best case io_uring=116079 MB/s vs msg_zerocopy=47421 MB/s,
> or 2.44 times faster.
> 
> № | test:                                | BW (MB/s)  | speedup
> 1 | msg_zerocopy (non-zc)                |  18281     | 0.38
> 2 | msg_zerocopy -z (baseline)           |  47421     | 1
> 3 | io_uring (@flush=false, nr_reqs=1)   |  96534     | 2.03
> 4 | io_uring (@flush=true,  nr_reqs=1)   |  89310     | 1.88
> 5 | io_uring (@flush=false, nr_reqs=8)   | 116079     | 2.44
> 6 | io_uring (@flush=true,  nr_reqs=8)   | 109722     | 2.31
> 
> Based on selftests/.../msg_zerocopy but more limited. You can use
> msg_zerocopy -r as usual for receive side.
> 
[...]

-- 
Pavel Begunkov
--------------d3uoUfKURQRySJ6dIsw8imz5
Content-Type: text/x-csrc; charset=UTF-8; name="send-zc.c"
Content-Disposition: attachment; filename="send-zc.c"
Content-Transfer-Encoding: base64

LyogU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IE1JVCAqLwovKiBiYXNlZCBvbiBsaW51eC1r
ZXJuZWwvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvbmV0L21zZ196ZXJvY29weS5jICovCi8q
IGdjYyAtbHVyaW5nIC1PMiAtbyBzZW5kLXpjIC4vc2VuZC16Yy5jICovCiNpbmNsdWRlIDxz
dGRpby5oPgojaW5jbHVkZSA8c3RkbGliLmg+CiNpbmNsdWRlIDxzdGRpbnQuaD4KI2luY2x1
ZGUgPGFzc2VydC5oPgoKI2luY2x1ZGUgPGVycm5vLmg+CiNpbmNsdWRlIDxmY250bC5oPgoj
aW5jbHVkZSA8dW5pc3RkLmg+CiNpbmNsdWRlIDxzeXMvc29ja2V0Lmg+CiNpbmNsdWRlIDxz
eXMvdGltZS5oPgojaW5jbHVkZSA8c3lzL3Jlc291cmNlLmg+CiNpbmNsdWRlIDxzeXMvdW4u
aD4KI2luY2x1ZGUgPG5ldGluZXQvaW4uaD4KI2luY2x1ZGUgPGFycGEvaW5ldC5oPgojaW5j
bHVkZSA8ZXJyb3IuaD4KI2luY2x1ZGUgPGxpbWl0cy5oPgojaW5jbHVkZSA8bGludXgvZXJy
cXVldWUuaD4KI2luY2x1ZGUgPGxpbnV4L2lmX3BhY2tldC5oPgojaW5jbHVkZSA8bGludXgv
aXB2Ni5oPgojaW5jbHVkZSA8bGludXgvc29ja2V0Lmg+CiNpbmNsdWRlIDxsaW51eC9zb2Nr
aW9zLmg+CiNpbmNsdWRlIDxuZXQvZXRoZXJuZXQuaD4KI2luY2x1ZGUgPG5ldC9pZi5oPgoj
aW5jbHVkZSA8bmV0aW5ldC9pcC5oPgojaW5jbHVkZSA8bmV0aW5ldC9pcDYuaD4KI2luY2x1
ZGUgPG5ldGluZXQvdGNwLmg+CiNpbmNsdWRlIDxuZXRpbmV0L3VkcC5oPgojaW5jbHVkZSA8
c3RkYm9vbC5oPgojaW5jbHVkZSA8c3RyaW5nLmg+CiNpbmNsdWRlIDxzeXMvaW9jdGwuaD4K
I2luY2x1ZGUgPHN5cy9zdGF0Lmg+CiNpbmNsdWRlIDxzeXMvdHlwZXMuaD4KI2luY2x1ZGUg
PHN5cy93YWl0Lmg+CiNpbmNsdWRlIDxzeXMvbW1hbi5oPgojaW5jbHVkZSA8c3lzL3N5c2Nh
bGwuaD4KCiNpbmNsdWRlIDxsaWJ1cmluZy5oPgoKZW51bSB7CglJT1JJTkdfT1BfU0VORFpD
IAkJPSA0MCwKCglJT1JJTkdfU0VORFpDX0ZMVVNICQk9ICgxVSA8PCAwKSwKCUlPUklOR19T
RU5EWkNfRklYRURfQlVGCQk9ICgxVSA8PCAxKSwKCglJT1JJTkdfUkVHSVNURVJfVFhfQ1RY
CQk9IDIwLAoJSU9SSU5HX1VOUkVHSVNURVJfVFhfQ1RYCT0gMjEsCn07CgpzdHJ1Y3QgaW9f
dXJpbmdfdHhfY3R4X3JlZ2lzdGVyIHsKCV9fdTY0IHRhZzsKfTsKCnN0YXRpYyBpbmxpbmUg
aW50IF9fX19zeXNfaW9fdXJpbmdfcmVnaXN0ZXIoaW50IGZkLCB1bnNpZ25lZCBvcGNvZGUs
CgkJCQkJICAgIGNvbnN0IHZvaWQgKmFyZywgdW5zaWduZWQgbnJfYXJncykKewoJaW50IHJl
dDsKCglyZXQgPSBzeXNjYWxsKF9fTlJfaW9fdXJpbmdfcmVnaXN0ZXIsIGZkLCBvcGNvZGUs
IGFyZywgbnJfYXJncyk7CglyZXR1cm4gKHJldCA8IDApID8gLWVycm5vIDogcmV0Owp9Cgoj
aWZuZGVmIFNPX1pFUk9DT1BZCiNkZWZpbmUgU09fWkVST0NPUFkJNjAKI2VuZGlmCiNkZWZp
bmUgWkNfVEFHIDEzNjYKCnN0YXRpYyBib29sIGZpeGVkX2ZpbGVzOwpzdGF0aWMgYm9vbCB6
YzsKc3RhdGljIGJvb2wgZmx1c2g7CnN0YXRpYyBpbnQgbnJfcmVxczsKc3RhdGljIGJvb2wg
Zml4ZWRfYnVmOwoKc3RhdGljIGludCAgY2ZnX2ZhbWlseQkJPSBQRl9VTlNQRUM7CnN0YXRp
YyBpbnQgIGNmZ19wYXlsb2FkX2xlbjsKc3RhdGljIGludCAgY2ZnX3BvcnQJCT0gODAwMDsK
c3RhdGljIGludCAgY2ZnX3J1bnRpbWVfbXMJPSA0MjAwOwoKc3RhdGljIHNvY2tsZW5fdCBj
ZmdfYWxlbjsKc3RhdGljIHN0cnVjdCBzb2NrYWRkcl9zdG9yYWdlIGNmZ19kc3RfYWRkcjsK
CnN0YXRpYyBjaGFyIHBheWxvYWRbSVBfTUFYUEFDS0VUXSBfX2F0dHJpYnV0ZV9fKChhbGln
bmVkKDQwOTYpKSk7CgpzdGF0aWMgdW5zaWduZWQgbG9uZyBnZXR0aW1lb2ZkYXlfbXModm9p
ZCkKewoJc3RydWN0IHRpbWV2YWwgdHY7CgoJZ2V0dGltZW9mZGF5KCZ0diwgTlVMTCk7Cgly
ZXR1cm4gKHR2LnR2X3NlYyAqIDEwMDApICsgKHR2LnR2X3VzZWMgLyAxMDAwKTsKfQoKc3Rh
dGljIHZvaWQgZG9fc2V0c29ja29wdChpbnQgZmQsIGludCBsZXZlbCwgaW50IG9wdG5hbWUs
IGludCB2YWwpCnsKCWlmIChzZXRzb2Nrb3B0KGZkLCBsZXZlbCwgb3B0bmFtZSwgJnZhbCwg
c2l6ZW9mKHZhbCkpKQoJCWVycm9yKDEsIGVycm5vLCAic2V0c29ja29wdCAlZC4lZDogJWQi
LCBsZXZlbCwgb3B0bmFtZSwgdmFsKTsKfQoKc3RhdGljIHZvaWQgc2V0dXBfc29ja2FkZHIo
aW50IGRvbWFpbiwgY29uc3QgY2hhciAqc3RyX2FkZHIsCgkJCSAgIHN0cnVjdCBzb2NrYWRk
cl9zdG9yYWdlICpzb2NrYWRkcikKewoJc3RydWN0IHNvY2thZGRyX2luNiAqYWRkcjYgPSAo
dm9pZCAqKSBzb2NrYWRkcjsKCXN0cnVjdCBzb2NrYWRkcl9pbiAqYWRkcjQgPSAodm9pZCAq
KSBzb2NrYWRkcjsKCglzd2l0Y2ggKGRvbWFpbikgewoJY2FzZSBQRl9JTkVUOgoJCW1lbXNl
dChhZGRyNCwgMCwgc2l6ZW9mKCphZGRyNCkpOwoJCWFkZHI0LT5zaW5fZmFtaWx5ID0gQUZf
SU5FVDsKCQlhZGRyNC0+c2luX3BvcnQgPSBodG9ucyhjZmdfcG9ydCk7CgkJaWYgKHN0cl9h
ZGRyICYmCgkJICAgIGluZXRfcHRvbihBRl9JTkVULCBzdHJfYWRkciwgJihhZGRyNC0+c2lu
X2FkZHIpKSAhPSAxKQoJCQllcnJvcigxLCAwLCAiaXB2NCBwYXJzZSBlcnJvcjogJXMiLCBz
dHJfYWRkcik7CgkJYnJlYWs7CgljYXNlIFBGX0lORVQ2OgoJCW1lbXNldChhZGRyNiwgMCwg
c2l6ZW9mKCphZGRyNikpOwoJCWFkZHI2LT5zaW42X2ZhbWlseSA9IEFGX0lORVQ2OwoJCWFk
ZHI2LT5zaW42X3BvcnQgPSBodG9ucyhjZmdfcG9ydCk7CgkJaWYgKHN0cl9hZGRyICYmCgkJ
ICAgIGluZXRfcHRvbihBRl9JTkVUNiwgc3RyX2FkZHIsICYoYWRkcjYtPnNpbjZfYWRkcikp
ICE9IDEpCgkJCWVycm9yKDEsIDAsICJpcHY2IHBhcnNlIGVycm9yOiAlcyIsIHN0cl9hZGRy
KTsKCQlicmVhazsKCWRlZmF1bHQ6CgkJZXJyb3IoMSwgMCwgImlsbGVnYWwgZG9tYWluIik7
Cgl9Cn0KCnN0YXRpYyBpbnQgZG9fc2V0dXBfdHgoaW50IGRvbWFpbiwgaW50IHR5cGUsIGlu
dCBwcm90b2NvbCkKewoJaW50IGZkOwoKCWZkID0gc29ja2V0KGRvbWFpbiwgdHlwZSwgcHJv
dG9jb2wpOwoJaWYgKGZkID09IC0xKQoJCWVycm9yKDEsIGVycm5vLCAic29ja2V0IHQiKTsK
Cglkb19zZXRzb2Nrb3B0KGZkLCBTT0xfU09DS0VULCBTT19TTkRCVUYsIDEgPDwgMjEpOwoJ
ZG9fc2V0c29ja29wdChmZCwgU09MX1NPQ0tFVCwgU09fWkVST0NPUFksIDEpOwoKCWlmIChj
b25uZWN0KGZkLCAodm9pZCAqKSAmY2ZnX2RzdF9hZGRyLCBjZmdfYWxlbikpCgkJZXJyb3Io
MSwgZXJybm8sICJjb25uZWN0Iik7CglyZXR1cm4gZmQ7Cn0KCnN0YXRpYyBpbmxpbmUgc3Ry
dWN0IGlvX3VyaW5nX2NxZSAqd2FpdF9jcWVfZmFzdChzdHJ1Y3QgaW9fdXJpbmcgKnJpbmcp
CnsKCXN0cnVjdCBpb191cmluZ19jcWUgKmNxZTsKCXVuc2lnbmVkIGhlYWQ7CglpbnQgcmV0
OwoKCWlvX3VyaW5nX2Zvcl9lYWNoX2NxZShyaW5nLCBoZWFkLCBjcWUpCgkJcmV0dXJuIGNx
ZTsKCglyZXQgPSBpb191cmluZ193YWl0X2NxZShyaW5nLCAmY3FlKTsKCWlmIChyZXQpCgkJ
ZXJyb3IoMSwgcmV0LCAid2FpdCBjcWUiKTsKCXJldHVybiBjcWU7Cn0KCnN0YXRpYyB2b2lk
IGRvX3R4KGludCBkb21haW4sIGludCB0eXBlLCBpbnQgcHJvdG9jb2wpCnsKCXVuc2lnbmVk
IGxvbmcgc2VxID0gMCwgZWFnYWluX3JlcXMgPSAwLCBwYWNrZXRzID0gMCwgYnl0ZXMgPSAw
OwoJc3RydWN0IGlvX3VyaW5nIHJpbmc7CglzdHJ1Y3QgaW92ZWMgaW92OwoJdWludDY0X3Qg
dHN0b3A7CglpbnQgaSwgZmQsIHJldDsKCglmZCA9IGRvX3NldHVwX3R4KGRvbWFpbiwgdHlw
ZSwgcHJvdG9jb2wpOwoKCXJldCA9IGlvX3VyaW5nX3F1ZXVlX2luaXQoNTEyLCAmcmluZywg
MCk7CglpZiAocmV0KQoJCWVycm9yKDEsIHJldCwgImlvX3VyaW5nOiBxdWV1ZSBpbml0Iik7
CgoJc3RydWN0IGlvX3VyaW5nX3R4X2N0eF9yZWdpc3RlciByID0geyAudGFnID0gWkNfVEFH
LCB9OwoJcmV0ID0gX19fX3N5c19pb191cmluZ19yZWdpc3RlcihyaW5nLnJpbmdfZmQsIElP
UklOR19SRUdJU1RFUl9UWF9DVFgsICh2b2lkICopJnIsIDEpOwoJaWYgKHJldCkKCQllcnJv
cigxLCByZXQsICJpb191cmluZzogdHggY3R4IHJlZ2lzdHJhdGlvbiIpOwoKCXJldCA9IGlv
X3VyaW5nX3JlZ2lzdGVyX2ZpbGVzKCZyaW5nLCAmZmQsIDEpOwoJaWYgKHJldCA8IDApCgkJ
ZXJyb3IoMSwgcmV0LCAiaW9fdXJpbmc6IGZpbGVzIHJlZ2lzdHJhdGlvbiIpOwoKCWlvdi5p
b3ZfYmFzZSA9IHBheWxvYWQ7Cglpb3YuaW92X2xlbiA9IGNmZ19wYXlsb2FkX2xlbjsKCXJl
dCA9IGlvX3VyaW5nX3JlZ2lzdGVyX2J1ZmZlcnMoJnJpbmcsICZpb3YsIDEpOwoJaWYgKHJl
dCA8IDApCgkJZXJyb3IoMSwgcmV0LCAiaW9fdXJpbmc6IGJ1ZmZlciByZWdpc3RyYXRpb24i
KTsKCgl0c3RvcCA9IGdldHRpbWVvZmRheV9tcygpICsgY2ZnX3J1bnRpbWVfbXM7CglkbyB7
CgkJc3RydWN0IGlvX3VyaW5nX3NxZSAqc3FlOwoJCXN0cnVjdCBpb191cmluZ19jcWUgKmNx
ZTsKCQlpbnQgbnJfY3FlcyA9IGZsdXNoID8gbnJfcmVxcyAqIDIgOiBucl9yZXFzOwoKCQlm
b3IgKGkgPSAwOyBpIDwgbnJfcmVxczsgaSsrKSB7CgkJCXNxZSA9IGlvX3VyaW5nX2dldF9z
cWUoJnJpbmcpOwoJCQlpb191cmluZ19wcmVwX3NlbmQoc3FlLCBmZCwgcGF5bG9hZCwgY2Zn
X3BheWxvYWRfbGVuLCBNU0dfRE9OVFdBSVQpOwoJCQlzcWUtPnVzZXJfZGF0YSA9IDE7CgkJ
CWlmIChmaXhlZF9maWxlcykgewoJCQkJc3FlLT5mZCA9IDA7CgkJCQlzcWUtPmZsYWdzID0g
SU9TUUVfRklYRURfRklMRTsKCQkJfQoKCQkJaWYgKHpjKSB7CgkJCQlzcWUtPm9wY29kZSA9
IElPUklOR19PUF9TRU5EWkM7CgkJCQlzcWUtPnNwbGljZV9mZF9pbiA9IDA7IC8qIHNxZS0+
dHhfY3R4X2lkeCA9IDA7ICovCgkJCQlzcWUtPmlvcHJpbyA9IDA7CgkJCQlzcWUtPm9mZiA9
IDA7CgkJCQlzcWUtPl9fcGFkMlswXSA9IDA7CgoJCQkJaWYgKGZsdXNoKQoJCQkJCXNxZS0+
aW9wcmlvIHw9IElPUklOR19TRU5EWkNfRkxVU0g7CgkJCQlpZiAoZml4ZWRfYnVmKSB7CgkJ
CQkJc3FlLT5pb3ByaW8gfD0gSU9SSU5HX1NFTkRaQ19GSVhFRF9CVUY7CgkJCQkJc3FlLT5i
dWZfaW5kZXggPSAwOwoJCQkJfQoJCQl9CgkJfQoKCQlyZXQgPSBpb191cmluZ19zdWJtaXQo
JnJpbmcpOwoJCWlmIChyZXQgIT0gbnJfcmVxcykKCQkJZXJyb3IoMSwgcmV0LCAic3VibWl0
Iik7CgoJCWZvciAoaSA9IDA7IGkgPCBucl9jcWVzOyBpKyspIHsKCQkJY3FlID0gd2FpdF9j
cWVfZmFzdCgmcmluZyk7CgoJCQlpZiAoY3FlLT51c2VyX2RhdGEgPT0gWkNfVEFHKSB7CgkJ
CQlpZiAoc2VxICE9IGNxZS0+cmVzKQoJCQkJCWVycm9yKDEsIC1FSU5WQUwsICJzZXF1ZW5j
ZXMgZG9uJ3QgbWF0Y2ggJXUhPSV1IiwKCQkJCQkJKGludClzZXEsIGNxZS0+cmVzKTsKCQkJ
CXNlcSsrOwoJCQl9IGVsc2UgaWYgKGNxZS0+dXNlcl9kYXRhID09IDEpIHsKCQkJCWlmIChj
cWUtPnJlcyA+IDApIHsKCQkJCQlwYWNrZXRzKys7CgkJCQkJYnl0ZXMgKz0gY3FlLT5yZXM7
CgkJCQl9IGVsc2UgaWYgKGNxZS0+cmVzID09IC1FQUdBSU4pIHsKCQkJCQlpZiAoZmx1c2gp
CgkJCQkJCW5yX2NxZXMtLTsKCQkJCQllYWdhaW5fcmVxcysrOwoJCQkJfSBlbHNlIHsKCQkJ
CQllcnJvcigxLCBjcWUtPnJlcywgInNlbmQgcmV0Iik7CgkJCQl9CgkJCX0gZWxzZSB7CgkJ
CQllcnJvcigxLCBjcWUtPnVzZXJfZGF0YSwgInVzZXJfZGF0YSIpOwoJCQl9CgoJCQlpb191
cmluZ19jcWVfc2VlbigmcmluZywgY3FlKTsKCQl9Cgl9IHdoaWxlIChnZXR0aW1lb2ZkYXlf
bXMoKSA8IHRzdG9wKTsKCglpZiAoY2xvc2UoZmQpKQoJCWVycm9yKDEsIGVycm5vLCAiY2xv
c2UiKTsKCglmcHJpbnRmKHN0ZGVyciwgInR4PSVsdSAoJWx1IE1CKSB0eGM9JWx1LCBuciBF
QUdBSU49JWx1XG4iLAoJCXBhY2tldHMsIGJ5dGVzID4+IDIwLCBzZXEsIGVhZ2Fpbl9yZXFz
KTsKCglpb191cmluZ19xdWV1ZV9leGl0KCZyaW5nKTsKfQoKc3RhdGljIHZvaWQgZG9fdGVz
dChpbnQgZG9tYWluLCBpbnQgdHlwZSwgaW50IHByb3RvY29sKQp7CglpbnQgaTsKCglmb3Ig
KGkgPSAwOyBpIDwgSVBfTUFYUEFDS0VUOyBpKyspCgkJcGF5bG9hZFtpXSA9ICdhJyArIChp
ICUgMjYpOwoKCWRvX3R4KGRvbWFpbiwgdHlwZSwgcHJvdG9jb2wpOwp9CgpzdGF0aWMgdm9p
ZCB1c2FnZShjb25zdCBjaGFyICpmaWxlcGF0aCkKewoJZXJyb3IoMSwgMCwgIlVzYWdlOiAl
cyBbb3B0aW9uc10gPHRlc3Q+IiwgZmlsZXBhdGgpOwp9CgpzdGF0aWMgdm9pZCBwYXJzZV9v
cHRzKGludCBhcmdjLCBjaGFyICoqYXJndikKewoJY29uc3QgaW50IG1heF9wYXlsb2FkX2xl
biA9IHNpemVvZihwYXlsb2FkKSAtCgkJCQkgICAgc2l6ZW9mKHN0cnVjdCBpcHY2aGRyKSAt
CgkJCQkgICAgc2l6ZW9mKHN0cnVjdCB0Y3BoZHIpIC0KCQkJCSAgICA0MCAvKiBtYXggdGNw
IG9wdGlvbnMgKi87CglpbnQgYzsKCWNoYXIgKmRhZGRyID0gTlVMTDsKCgljZmdfcGF5bG9h
ZF9sZW4gPSBtYXhfcGF5bG9hZF9sZW47CgoJZml4ZWRfZmlsZXMgPSAxOwoJemMgPSAxOwoJ
Zmx1c2ggPSAwICYmIHpjOwoJbnJfcmVxcyA9IDg7CglmaXhlZF9idWYgPSAxICYmIHpjOwoK
CXdoaWxlICgoYyA9IGdldG9wdChhcmdjLCBhcmd2LCAiNDZEOmk6cDpzOnQ6cjpmIikpICE9
IC0xKSB7CgkJc3dpdGNoIChjKSB7CgkJY2FzZSAnNCc6CgkJCWlmIChjZmdfZmFtaWx5ICE9
IFBGX1VOU1BFQykKCQkJCWVycm9yKDEsIDAsICJQYXNzIG9uZSBvZiAtNCBvciAtNiIpOwoJ
CQljZmdfZmFtaWx5ID0gUEZfSU5FVDsKCQkJY2ZnX2FsZW4gPSBzaXplb2Yoc3RydWN0IHNv
Y2thZGRyX2luKTsKCQkJYnJlYWs7CgkJY2FzZSAnNic6CgkJCWlmIChjZmdfZmFtaWx5ICE9
IFBGX1VOU1BFQykKCQkJCWVycm9yKDEsIDAsICJQYXNzIG9uZSBvZiAtNCBvciAtNiIpOwoJ
CQljZmdfZmFtaWx5ID0gUEZfSU5FVDY7CgkJCWNmZ19hbGVuID0gc2l6ZW9mKHN0cnVjdCBz
b2NrYWRkcl9pbjYpOwoJCQlmcHJpbnRmKHN0ZGVyciwgImlwdjZcbiIpOwoJCQlleGl0KC0x
KTsKCQkJYnJlYWs7CgkJY2FzZSAnRCc6CgkJCWRhZGRyID0gb3B0YXJnOwoJCQlicmVhazsK
CQljYXNlICdwJzoKCQkJY2ZnX3BvcnQgPSBzdHJ0b3VsKG9wdGFyZywgTlVMTCwgMCk7CgkJ
CWJyZWFrOwoJCWNhc2UgJ3MnOgoJCQljZmdfcGF5bG9hZF9sZW4gPSBzdHJ0b3VsKG9wdGFy
ZywgTlVMTCwgMCk7CgkJCWJyZWFrOwoJCWNhc2UgJ3QnOgoJCQljZmdfcnVudGltZV9tcyA9
IDIwMCArIHN0cnRvdWwob3B0YXJnLCBOVUxMLCAxMCkgKiAxMDAwOwoJCQlicmVhazsKCQlj
YXNlICdyJzoKCQkJbnJfcmVxcyA9IHN0cnRvdWwob3B0YXJnLCBOVUxMLCAwKTsKCQkJYnJl
YWs7CgkJY2FzZSAnZic6CgkJCWlmICghemMpCgkJCQllcnJvcigxLCAwLCAiRmx1c2ggc2hv
dWxkIGJlIHVzZWQgd2l0aCB6YyBvbmx5Iik7CgkJCWZsdXNoID0gMTsKCQkJYnJlYWs7CgkJ
fQoJfQoKCXNldHVwX3NvY2thZGRyKGNmZ19mYW1pbHksIGRhZGRyLCAmY2ZnX2RzdF9hZGRy
KTsKCglpZiAoY2ZnX3BheWxvYWRfbGVuID4gbWF4X3BheWxvYWRfbGVuKQoJCWVycm9yKDEs
IDAsICItczogcGF5bG9hZCBleGNlZWRzIG1heCAoJWQpIiwgbWF4X3BheWxvYWRfbGVuKTsK
CglpZiAob3B0aW5kICE9IGFyZ2MgLSAxKQoJCXVzYWdlKGFyZ3ZbMF0pOwp9CgppbnQgbWFp
bihpbnQgYXJnYywgY2hhciAqKmFyZ3YpCnsKCWNvbnN0IGNoYXIgKmNmZ190ZXN0OwoKCXBh
cnNlX29wdHMoYXJnYywgYXJndik7CgoJY2ZnX3Rlc3QgPSBhcmd2W2FyZ2MgLSAxXTsKCglp
ZiAoIXN0cmNtcChjZmdfdGVzdCwgInJhdyIpKQoJCWRvX3Rlc3QoY2ZnX2ZhbWlseSwgU09D
S19SQVcsIElQUFJPVE9fRUdQKTsKCWVsc2UgaWYgKCFzdHJjbXAoY2ZnX3Rlc3QsICJ0Y3Ai
KSkKCQlkb190ZXN0KGNmZ19mYW1pbHksIFNPQ0tfU1RSRUFNLCAwKTsKCWVsc2UgaWYgKCFz
dHJjbXAoY2ZnX3Rlc3QsICJ1ZHAiKSkKCQlkb190ZXN0KGNmZ19mYW1pbHksIFNPQ0tfREdS
QU0sIDApOwoJZWxzZQoJCWVycm9yKDEsIDAsICJ1bmtub3duIGNmZ190ZXN0ICVzIiwgY2Zn
X3Rlc3QpOwoKCXJldHVybiAwOwp9Cg==
--------------d3uoUfKURQRySJ6dIsw8imz5--

