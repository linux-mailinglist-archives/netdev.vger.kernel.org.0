Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 963AA1CB9C7
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 23:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbgEHV3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 17:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727088AbgEHV3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 17:29:00 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E731C061A0C
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 14:29:00 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id x17so3575135wrt.5
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 14:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=aJu03RAR+fBuOgEXCUaBj9BLea50GnrYbuATt+GBSuU=;
        b=i//b39rgrnb0Gurd8lq8W2RvlD/XcQNkIYJVJSV9VirSe/h0qHdpffvMrlZtWc3h2m
         l9D5LRbW1ceshhpe4nUXcyFkpvQ2cqCNgYUpmlz+6uXd7gfNkPortS4qECCuVslzZlXG
         M4ty71sCqGEzdivRC0dfZVmRva+W+I8wQeoA4LOdc8VlkdX/xueB+8NqxruSlCyUjU8E
         dZ9xFYJ5eYjdcNGS7ODcgfwujdTDkz+l270t9N7f6609lMHbSnsXZcBHwYlRv9zEvAKp
         ictKHz6E/MrZ7W9/ZeTWrY4CizBiXhIXodnqwEZg423vnJnX67FsGkkgUFhsJOUD+3bi
         5I9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=aJu03RAR+fBuOgEXCUaBj9BLea50GnrYbuATt+GBSuU=;
        b=L5Gm6L2uvyB2l/W6+r7uYgPWC0JT+pq5luF8AflnrLkxVyflIPx4qO/e1e54nsgM3o
         zaKqccl6wggoflny20eEysGRpQoHSDHHJ6nxlbYg8lyaO1PZA9/y/fIn83rExAAHeo8m
         EazD5R8zeeoQq2X41y/f+Wwm7U7cl5+TVYDvug85YbnXs42EIqsaM/nCwGMcL4nrxrmB
         pcibWBnTP+LmT6x704SlQSZVp3+wJ3RV7VLyJ5Qd1LwRZ0jNWybtF00pm1opPodVHDtD
         kr9X1eSbDyiVB9DpjwAgZPY3k9PHymeeTgWfmZExJXoVWsGwRAUAGvEB6gc2a2VhtqxR
         dbnA==
X-Gm-Message-State: AGi0Puby6ehrKEMB1C3R/HHdE55AjUEmgQyr4UgS/CsE/Puf+T9bGy80
        K9I16+tLbL3/uAfTxKfvbrqhMLRX
X-Google-Smtp-Source: APiQypInct5zgg3XQ0obEej96c/q/yVB/xGTFVy+A0IKj2XJjXxfgOB0tFE4QKpRwdFfGRW6c5cXNg==
X-Received: by 2002:a5d:6387:: with SMTP id p7mr141872wru.193.1588973338534;
        Fri, 08 May 2020 14:28:58 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f28:5200:b9ec:f867:184c:fa95? (p200300EA8F285200B9ECF867184CFA95.dip0.t-ipconnect.de. [2003:ea:8f28:5200:b9ec:f867:184c:fa95])
        by smtp.googlemail.com with ESMTPSA id u67sm3133710wmu.3.2020.05.08.14.28.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 May 2020 14:28:58 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/4] r8169: sync few functionalities with vendor
 driver
Message-ID: <ae5fb819-26e4-d796-2783-2ed5212d0146@gmail.com>
Date:   Fri, 8 May 2020 23:28:51 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add few helpers (with names copied from vendor drivers) to make clearer
what the respective code is doing. In addition improve reset preparation
for chips from RTL8168g.

Heiner Kallweit (4):
  r8169: add helper r8168g_wait_ll_share_fifo_ready
  r8169: add helper rtl_enable_rxdvgate
  r8169: add helper rtl_wait_txrx_fifo_empty
  r8169: improve reset handling for chips from RTL8168g

 drivers/net/ethernet/realtek/r8169_main.c | 63 ++++++++++++++---------
 1 file changed, 39 insertions(+), 24 deletions(-)

-- 
2.26.2

