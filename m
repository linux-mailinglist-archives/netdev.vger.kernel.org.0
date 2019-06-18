Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09C8F49F2A
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 13:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729671AbfFRL1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 07:27:32 -0400
Received: from mail-lj1-f182.google.com ([209.85.208.182]:45467 "EHLO
        mail-lj1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729606AbfFRL1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 07:27:32 -0400
Received: by mail-lj1-f182.google.com with SMTP id m23so12693669lje.12
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 04:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=brDAt1OwdjUzZLkFIh3xoh/P/uJSAgSGZ5KoXsrydPw=;
        b=M9P3Ns34+NzQKvAa4XDy5rnRQNHor1wSOLB+3hh7MwAFfhoghi+wqBGkgEqtwltf3O
         LRGxM3kUB9DXS3q2q0YJqO0KSKItgv0z1SEoTzuxoyDo1SFWfYvxdPYZ84V5Lj0JTehy
         hR049RP5O43STv2JpfjSQhrVM0x/Ol2PYsnZDAJwH9C4s5W0Fb45FyPoCWrylnTw+On/
         cg/KTxT0zZZD/jLVkgcT6XOUViYeJFu2CoU73SVhuK3nZmE1Y9KYjBqJ9BFnPNwGN3AU
         4iUxNPsDBCqHr2U8wYHcDVi3wqhd6QWFN1h9FsmJ2yHzzfZt6oDW5oi61EtiBloMKSkL
         Vnkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=brDAt1OwdjUzZLkFIh3xoh/P/uJSAgSGZ5KoXsrydPw=;
        b=iXotE4+6/9YbSb8ncsvMF5iwa1fpn/+ZSJ0megl0rBxi+Q2NoCu7PFTAQsMCdbi63O
         rYKgTE3dwuQrpP1YuachqdRWzJBY7xzrm64XilD8MpMPiOUH0n9WfBPd68EcbXao76Xn
         aHlY3Y2GEzLn78iHMKgDd2RQomc3FmKUO35SvuzUSVQL3+YfCK6FrEaLLD2ONiVT8p4D
         TwASkZOa4xQQvkhH0nv3duSuAi8c37r/NHfQV60ppkSux7v3rXKhMQxXO0NDTw+aNCIn
         vqvqDpWqkxy7nC51E06qWkaBcO1K3KY7002SMIrDMznhDcDhppYUEgku3Bf6DvkDMyNE
         EisA==
X-Gm-Message-State: APjAAAX4hpxKx+NNgLINaTpDmz5u0yCO6M5y9Q2x+Dd0zS+Gu7yTLWLL
        Gr3EkeTsKkntzDIxuMh88rnvdHIq5Lz5o29zl6KJNQ==
X-Google-Smtp-Source: APXvYqx1EYV1tuF+BN/LL6bTsafI8Gy4VLfREm11ef5BPcdANJln2vsAB8Kax781shGnUoh8m7rM3q7wj0i4H+lhzk4=
X-Received: by 2002:a2e:824d:: with SMTP id j13mr61546174ljh.137.1560857250253;
 Tue, 18 Jun 2019 04:27:30 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 18 Jun 2019 16:57:18 +0530
Message-ID: <CA+G9fYs2+-yeYcx7oe228oo9GfDgTuPL1=TemT3R20tzCmcjsw@mail.gmail.com>
Subject: 4.19: udpgso_bench_tx: setsockopt zerocopy: Unknown error 524
To:     "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>, fklassen@appneta.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

selftests: net: udpgso_bench.sh failed on 4.19, 4.14, 4.9 and 4.4 branches.
PASS on stable branch 5.1, mainline and next.
This failure is started happening on 4.19 and older kernel branches after
kselftest upgrade to version 5.1

Is there any possibilities to backport ?

Error:
udpgso_bench_tx: setsockopt zerocopy: Unknown error 524

Test output:
-----------------
selftests: net: udpgso_bench.sh
ipv4
tcp
tcp rx:    469 MB/s     7930 calls/s
tcp tx:    469 MB/s     7961 calls/s   7961 msg/s
tcp rx:    470 MB/s     7941 calls/s
tcp tx:    470 MB/s     7977 calls/s   7977 msg/s
tcp rx:    470 MB/s     7933 calls/s
tcp tx:    470 MB/s     7975 calls/s   7975 msg/s
tcp zerocopy
tcp tx:    357 MB/s     6064 calls/s   6064 msg/s
tcp rx:    357 MB/s     6052 calls/s
tcp tx:    352 MB/s     5981 calls/s   5981 msg/s
tcp rx:    352 MB/s     5979 calls/s
tcp tx:    350 MB/s     5937 calls/s   5937 msg/s
tcp rx:    350 MB/s     5938 calls/s
udp
udp rx:     23 MB/s    16505 calls/s
udp tx:     23 MB/s    16464 calls/s    392 msg/s
udp rx:     23 MB/s    16500 calls/s
udp tx:     23 MB/s    16506 calls/s    393 msg/s
udp rx:     23 MB/s    16396 calls/s
udp gso
udp rx:    536 MB/s     9097 calls/s
udp tx:    545 MB/s     9246 calls/s   9246 msg/s
udp rx:    545 MB/s     9256 calls/s
udp tx:    545 MB/s     9256 calls/s   9256 msg/s
udp rx:    545 MB/s     9259 calls/s
udp tx:    545 MB/s     9258 calls/s   9258 msg/s
udp rx:    545 MB/s     9252 calls/s
udp gso zerocopy
./udpgso_bench_tx: setsockopt zerocopy: Unknown error 524
ipv6
tcp
tcp tx:    470 MB/s     7979 calls/s   7979 msg/s
tcp rx:    470 MB/s     7947 calls/s
tcp rx:    471 MB/s     7979 calls/s
tcp tx:    514 MB/s     8721 calls/s   8721 msg/s
tcp zerocopy
tcp tx:    392 MB/s     6658 calls/s   6658 msg/s
tcp rx:    392 MB/s     6399 calls/s
tcp rx:    350 MB/s     5936 calls/s
tcp tx:    350 MB/s     5945 calls/s   5945 msg/s
tcp rx:    350 MB/s     5937 calls/s
tcp tx:    350 MB/s     5940 calls/s   5940 msg/s
udp
udp rx:     20 MB/s    14802 calls/s
udp tx:     20 MB/s    14921 calls/s    347 msg/s
udp rx:     24 MB/s    17797 calls/s
udp tx:     24 MB/s    17802 calls/s    414 msg/s
udp rx:     17 MB/s    12453 calls/s
udp tx:     17 MB/s    12470 calls/s    290 msg/s
udp rx:     17 MB/s    12409 calls/s
udp tx:    545 MB/s     9257 calls/s   9257 msg/s
udp rx:    545 MB/s     9249 calls/s
udp tx:    545 MB/s     9248 calls/s   9248 msg/s
udp rx:    545 MB/s     9254 calls/s
udp tx:    545 MB/s     9254 calls/s   9254 msg/s
udp rx:    545 MB/s     9260 calls/s
udp gso zerocopy
./udpgso_bench_tx: setsockopt zerocopy: Unknown error 524
not ok 1.. selftests: net: udpgso_bench.sh [FAIL]
selftests: net_udpgso_bench.sh [FAIL]

Best regards
Naresh Kamboju
