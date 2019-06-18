Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0BFE4A037
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 14:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728750AbfFRMGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 08:06:04 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:44415 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726916AbfFRMGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 08:06:03 -0400
Received: by mail-lj1-f194.google.com with SMTP id k18so12796584ljc.11
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 05:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=eViPuB4mPRtq99GLUYp5aCnnWrpv2fPxaUrqbtshaow=;
        b=OzFHA/skb+Cd3TvWb0I7U3fqoUbEdeAqdN4ud+HZoRnMK7mDQ/vDiz2gc8bfTm+QTg
         oeqqo6aT01GA6E5/kqnmzskzYTF8tBSW8k17FIKLDlQS+5YI2eGyQfgYK29K3shxEUzz
         O4ckLDcVheu7R0/1qdxRgcwXxvoWYbN+8p85sQbLGqoSIIh0MNmhHyWAWBZPZzLfwUvy
         9FTigcgftBfssg9DERYI8X1JJc3SiGtqwT07bDp/iZb+I477c4fnrpgXrqyE1cC+jfoi
         Qzx4J9FPnRKGo4YGVqFJWuhuuWPGdGa/lJlpLIzvJ9HUe+hapnsISe1qzXNxuasMRcaW
         nZMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=eViPuB4mPRtq99GLUYp5aCnnWrpv2fPxaUrqbtshaow=;
        b=pMkFuKQWInkPdL8cLsbSUhm1KzE1V1SSOBttaQqE/nPYyo4k4tcPrtBEMsG8qtacf8
         55zwdXUZATQsnZJP15oikF6/P80AB2NwprELhnPcTCtcN7ybbf4km/iYOxlw7uXobU/5
         aLeGYidNgGqqucOvZMoMaPqzP6ekE0h7lW3zXAl9kOHgF6P1va7C7ts3YyfVBpyRekeD
         Oz2QnCRru2D73N5y51XBTdevpTjQt+fiQY82CsoTJ32NOOUrhwzhAQO8274Bdc+1+B4B
         0oLSD0jRGby8lK0ioUZmbs9meOp1kh/nCUUYnDhg71p7Z01uCWtSONkTdXqwFFPmuwZd
         7FLA==
X-Gm-Message-State: APjAAAXKbCIGwaIXqzVQ7pATJ8aS8M394CkhTH+Fy90dH55VGHb7wNGl
        9AKxyk5HoINDg9wnZ4zLjFBtFVRaciQUdMLVfjlcOw==
X-Google-Smtp-Source: APXvYqynedWWS6RMfN+pXeWLkf2H5DM5H4yMJ5FcjVlUXuJ+N1JPU/Ap4AsjrjX3+umUXW+mGzRZGfQvvOr3ws24C8w=
X-Received: by 2002:a2e:8495:: with SMTP id b21mr21465480ljh.149.1560859561469;
 Tue, 18 Jun 2019 05:06:01 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 18 Jun 2019 17:35:50 +0530
Message-ID: <CA+G9fYufHb5N_NMd4RQnr3jJjqQ8b4Nj1CZXecWvDQPohFUewA@mail.gmail.com>
Subject: next: arm64: build error: implicit declaration of function '__cookie_v6_init_sequence'
To:     Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>, kafai@fb.com,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linux -next build failed on arm64 and arm.

In file included from net/ipv6/af_inet6.c:41:0:
include/linux/netfilter_ipv6.h: In function 'nf_ipv6_cookie_init_sequence':
include/linux/netfilter_ipv6.h:174:9: error: implicit declaration of
function '__cookie_v6_init_sequence'; did you mean
'cookie_init_sequence'? [-Werror=implicit-function-declaration]
  return __cookie_v6_init_sequence(iph, th, mssp);
         ^~~~~~~~~~~~~~~~~~~~~~~~~
         cookie_init_sequence
include/linux/netfilter_ipv6.h: In function 'nf_cookie_v6_check':
include/linux/netfilter_ipv6.h:189:9: error: implicit declaration of
function '__cookie_v6_check'; did you mean '__cookie_v4_check'?
[-Werror=implicit-function-declaration]
  return __cookie_v6_check(iph, th, cookie);
         ^~~~~~~~~~~~~~~~~
         __cookie_v4_check
  CC      net/core/net-traces.o
  CC      drivers/char/tpm/eventlog/acpi.o
  CC      fs/proc/page.o
cc1: some warnings being treated as errors
scripts/Makefile.build:278: recipe for target 'net/ipv6/af_inet6.o' failed
make[3]: *** [net/ipv6/af_inet6.o] Error 1
scripts/Makefile.build:489: recipe for target 'net/ipv6' failed
make[2]: *** [net/ipv6] Error 2

Best regards
Naresh Kamboju
