Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9FE211361B
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 21:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbfLDUEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 15:04:00 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33437 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727033AbfLDUEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 15:04:00 -0500
Received: by mail-pf1-f194.google.com with SMTP id y206so381007pfb.0;
        Wed, 04 Dec 2019 12:03:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+OdMqVzUj6WvcnoNuOeLlw4Z2rBRaftuL3BvYZInvZ8=;
        b=YZ5GJZ16ZLo8TmIpcoHWo0OH5dVqqXeCM8U+/V+JOOcoBUppCWNR+9VOLemCcFLFoO
         B19Ejz1697SpvZq0siV/srTDU+bGp913SLV/h3TwIPeqBet/9EcIgBQHTe2yQ4/pGmmU
         YUfBROgB7Xpi0ynDkqfQJa9uDIDnT3k47sg0UDeBeWvOF2k1nREuPfEUFb8hySmugQQQ
         Qa4V2F0LBSS+EElrf8J/7BOxriKxwIEXqX56v1LPYbpxmNXbThqPJGhfzRJJB5aFTozV
         W/O/Tm+bEwSaujOGTE4hAcGx+wHqe/MMvAQArBaO0h43IH8RBkMM2Koo28Vqh9XOJhjZ
         +ddA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+OdMqVzUj6WvcnoNuOeLlw4Z2rBRaftuL3BvYZInvZ8=;
        b=PjeBbxTaREdlqANVL5CwEmsBskFidQFqRCLRpY3LNFGMQQjjvvcKmOfH+tWJZe03O4
         oatxFT5Kvqwd/5JsMPZb8+ZXKbiH7a94DH/f03kRUaLViR9xX758F5F+i50MN5wc9gbf
         sOI5zY7H6VyR4s+xqDotOXQGMEqJHfuqR20zq8fZ5e1Yk5IPAHfCQdRS82fie9Jw8soM
         wOE5QvW+aabH6iAL9dTaGtZg+4B3SZFSNsXGWbpKxgbBv5g4+xWg9UOB6zj6hJwI36Ii
         GCd2gnRhXf/fd6Z+4ZSkmNH+fiBDU7jZxLEL/DM2G81Z3C+aggn3WVRU6YGqOSR99UO6
         C6IQ==
X-Gm-Message-State: APjAAAWIWaKBCWl4UZr3ZQ4Fo/rUzfr+6zTP6eJAQRkAOZDpb6HKMaV5
        YujWLvuqa5UIcxi6VL2DfdE=
X-Google-Smtp-Source: APXvYqxIhnX8thQjmt8iuhBBU6ma7W8uPSUf7YesCllGRzMI6W6eaFebhaDb+YyKeNwrbljnm4XNsw==
X-Received: by 2002:a63:f961:: with SMTP id q33mr5403005pgk.350.1575489839279;
        Wed, 04 Dec 2019 12:03:59 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id r14sm8994697pfh.10.2019.12.04.12.03.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2019 12:03:58 -0800 (PST)
Subject: Re: [PATCH] selftests: net: ip_defrag: increase netdev_max_backlog
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, shuah@kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        posk@google.com
References: <20191204195321.406365-1-cascardo@canonical.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <483097a3-92ec-aedd-60d9-ab7f58b9708d@gmail.com>
Date:   Wed, 4 Dec 2019 12:03:57 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191204195321.406365-1-cascardo@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/4/19 11:53 AM, Thadeu Lima de Souza Cascardo wrote:
> When using fragments with size 8 and payload larger than 8000, the backlog
> might fill up and packets will be dropped, causing the test to fail. This
> happens often enough when conntrack is on during the IPv6 test.
> 
> As the larger payload in the test is 10000, using a backlog of 1250 allow
> the test to run repeatedly without failure. At least a 1000 runs were
> possible with no failures, when usually less than 50 runs were good enough
> for showing a failure.
> 
> As netdev_max_backlog is not a pernet setting, this sets the backlog to
> 1000 during exit to prevent disturbing following tests.
> 

Hmmm... I would prefer not changing a global setting like that.
This is going to be flaky since we often run tests in parallel (using different netns)

What about adding a small delay after each sent packet ?

diff --git a/tools/testing/selftests/net/ip_defrag.c b/tools/testing/selftests/net/ip_defrag.c
index c0c9ecb891e1d78585e0db95fd8783be31bc563a..24d0723d2e7e9b94c3e365ee2ee30e9445deafa8 100644
--- a/tools/testing/selftests/net/ip_defrag.c
+++ b/tools/testing/selftests/net/ip_defrag.c
@@ -198,6 +198,7 @@ static void send_fragment(int fd_raw, struct sockaddr *addr, socklen_t alen,
                error(1, 0, "send_fragment: %d vs %d", res, frag_len);
 
        frag_counter++;
+       usleep(1000);
 }
 
 static void send_udp_frags(int fd_raw, struct sockaddr *addr,

