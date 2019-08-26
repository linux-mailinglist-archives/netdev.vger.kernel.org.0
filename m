Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C67B9D920
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 00:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfHZWbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 18:31:05 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:34025 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbfHZWbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 18:31:05 -0400
Received: by mail-ed1-f65.google.com with SMTP id s49so28607998edb.1
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 15:31:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wKTkn/cfLpYcFG9PWLfgZhFXjcpWirs1A1UV0rleWN8=;
        b=tWi+jJcL5kVBWa8lHf9LeRKSJbKI3m9m0SN9lqarjmswdlRDWpLO8t9RKxcyPzc6Id
         ktqCi1DaoSqJmmA4CfXSMrvbzxsmwOvTsTz+6IqGtPT3ruRVOYP2Rj6hT9RJcul1RaIN
         hYyak8be2sJvCzo9upBSzyerQNWAwADowDGbj0WuwHqJWBRe9xyFlcRo2jY3IM6qkPPN
         3FHbAW5a10J5zPWQzfO7K9hvIlEtmsrR9kUHkqSHku+HduTPw4H1BgduSzqHXfnhzH14
         qdDSuILTbPcc0ZvMKJACM3iykouqvqq99UensQPYewq8W97uNEriiCDJk0KpKM+lFKTL
         dmew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wKTkn/cfLpYcFG9PWLfgZhFXjcpWirs1A1UV0rleWN8=;
        b=oL0/bnkD7TjxpwmHNuo3/3DvSqFIKaan72suyB79RG4Nb72gdszQLOn0c7kC+cAhKg
         0eZn+x34BvM1F06uiNFgun0en8aW5dmMph4BbJxqh1yZeb72Ochs7Id5ztesOAmcJcze
         ML4yduxb7YPLd9Q2jdhjPEKdvuNdKxTVKmnkwRq5QlStqKQmChTLaL5rsXTvbOunDpa4
         hS3zUgwnhO8i4Y3JC6HASf++nZ/Z2n1uY602J9p6WebTytbAG/Jb+3fUlCj62NmY8Owc
         l5169AkmUgTcqijhFrakpv7LMtXQ5Vmj087euM1U/RGGbu4HC7GRyU5p5ojSaFQsNRLN
         jwCQ==
X-Gm-Message-State: APjAAAX2+4VZAziNu/cVVcpYMcNI1cRUDfxutUytvxMqNbf+qi3ePQ1a
        0F4D7Fxmu0gSDkUulO1v/7lfdQ==
X-Google-Smtp-Source: APXvYqzo0ITs1aadZO+eWOFSqpMdX5mYmKlGLk1oTfoTvx6MZFydHvbwVeKH55Kuy/GH9gG484ztXQ==
X-Received: by 2002:a17:906:35d1:: with SMTP id p17mr16043168ejb.271.1566858664052;
        Mon, 26 Aug 2019 15:31:04 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id ay8sm3100123ejb.4.2019.08.26.15.31.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Aug 2019 15:31:03 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next] nfp: add AMDA0058 boards to firmware list
Date:   Mon, 26 Aug 2019 15:30:41 -0700
Message-Id: <20190826223041.21100-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add MODULE_FIRMWARE entries for AMDA0058 boards.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_main.c b/drivers/net/ethernet/netronome/nfp/nfp_main.c
index 60e57f08de80..81679647e842 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_main.c
@@ -815,6 +815,8 @@ static void __exit nfp_main_exit(void)
 module_init(nfp_main_init);
 module_exit(nfp_main_exit);
 
+MODULE_FIRMWARE("netronome/nic_AMDA0058-0011_2x40.nffw");
+MODULE_FIRMWARE("netronome/nic_AMDA0058-0012_2x40.nffw");
 MODULE_FIRMWARE("netronome/nic_AMDA0081-0001_1x40.nffw");
 MODULE_FIRMWARE("netronome/nic_AMDA0081-0001_4x10.nffw");
 MODULE_FIRMWARE("netronome/nic_AMDA0096-0001_2x10.nffw");
-- 
2.21.0

