Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD97158CB3
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 11:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728312AbgBKKcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 05:32:10 -0500
Received: from mail-pl1-f176.google.com ([209.85.214.176]:46770 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727805AbgBKKcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 05:32:10 -0500
Received: by mail-pl1-f176.google.com with SMTP id y8so4086280pll.13
        for <netdev@vger.kernel.org>; Tue, 11 Feb 2020 02:32:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AyB66NTdq7yhWz2AFMXQKr3S67on8v3ZkrNHdXM+tzE=;
        b=Mfl5x80uxOkKtCtfeM0FiW685byJ37gX42wier6gqJtgdlFiCaPaDCDs57aRg4xdSo
         8InMOBGab2PrUhUVZrQoywZfiNM2ByPC3PK+KRq5ut9++buasRlczoS0WdzfxYrOpjE/
         HfSMitPYdnnroRWm8heq8HUm5Rpek2Cv19MmF1nOLrx04dWGlZO/gwCYP88nuUXnxUoz
         HZGHjtqmObAPvG7/q94Ke4MWs9FrV5dxsJnOpV34FediTZ5A8nWH7Zsz2YcXXqAb2aIr
         NbgKodoT0TNGACn4LSfZDILO4ykbN53K4/izZPbyg6BZofLTgPHBAP3LLUoeuIv6sKzK
         0aWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AyB66NTdq7yhWz2AFMXQKr3S67on8v3ZkrNHdXM+tzE=;
        b=Cuu1xzKTLteYWhdcfM6t89iw4fjjE5MEWcVrFnlUC7BEDU39FRLI0EbKALVneSao6m
         /reS36HLzB0LHzA/haRc1hhPyT+a8zCjDoIzq/jJ3Sm619VXhROoJCunYdRgd1bW2Hau
         WM66BoM247SuuiHh6Fid374DYmDReeqGvGfzt9Su5YhxCgTblss+qu1JcZDEDVVIhv1u
         50DuQt4GzVndqKBdv1LXZaHVYlU7/UEFfNVSN5Qlgz7GJtAlGf5lFzBqFgw6Af1GlXaa
         Rje5Wr7eGcukuYL2cKCaP02SrJoRENqkhMP3aiuFIBqPrtTtv6xMByJpCn2et2eYpNzN
         krUw==
X-Gm-Message-State: APjAAAUR1rtElLopx9OHptgT45haQzN8D9CA6a7yUr7V+uO/LV14Lpmo
        oRiT4iKVQJq/heONOyp3wXgK1wOxEU0=
X-Google-Smtp-Source: APXvYqzO3ggnJthwsP1Pyz6aHh9EI/+UhAKmBVLfk/D0iI2Fe9B/wnQUFKlIiX6Rmyvlo/GiiufuYg==
X-Received: by 2002:a17:90a:8a08:: with SMTP id w8mr2856696pjn.125.1581417129446;
        Tue, 11 Feb 2020 02:32:09 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w128sm3311858pgb.53.2020.02.11.02.32.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 02:32:09 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Tom Herbert <tom@herbertland.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] net/flow_dissector: remove unexist field description
Date:   Tue, 11 Feb 2020 18:31:54 +0800
Message-Id: <20200211103154.3943-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

@thoff has moved to struct flow_dissector_key_control.

Fixes: 42aecaa9bb2b ("net: Get skb hash over flow_keys structure")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 include/net/flow_dissector.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index d93017a7ce5c..e9391e877f9a 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -33,7 +33,6 @@ enum flow_dissect_ret {
 
 /**
  * struct flow_dissector_key_basic:
- * @thoff: Transport header offset
  * @n_proto: Network header protocol (eg. IPv4/IPv6)
  * @ip_proto: Transport header protocol (eg. TCP/UDP)
  */
-- 
2.19.2

