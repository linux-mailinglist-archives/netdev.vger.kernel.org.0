Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7345C2D7BA8
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 17:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390394AbgLKQxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 11:53:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389310AbgLKQxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 11:53:11 -0500
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51464C0613CF
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 08:52:31 -0800 (PST)
Received: by mail-lj1-x242.google.com with SMTP id y22so11620419ljn.9
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 08:52:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gcYa6L8/Uvmo8K/EulzmKdbBwrm2l0qNtAQPuKYVhqY=;
        b=U/7El6pBOXXYoZfPWWJm/jWo8/q8rucNE5gS5ABbrNaANd2ktZGueaG/SQqFTqvo0R
         1n1TDNAKdmoZ0xLNmerGdfW4HizQYpSO7zqmiPbA4HKhlXOdwhP4AVBboErVf0/81ZTG
         CieavYHs9d9joPYucrh2vPIDFPgfyFw/2YAdBe6mQVzQ8FQuqQDKYKtBQOecHWEDv3r/
         DSdOYBCAmS9TdegDPmj3TVUzLyuDHxEJjgxwuqYCq9I2zccXiA0pMr2LjalHQqvxIEOP
         5o6okyl4fcKV5ACoDUpNgyh/lh/MXxdtkyvibrEApC5s2My39S9c1Hu7NTz+/F04XFWe
         sb0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gcYa6L8/Uvmo8K/EulzmKdbBwrm2l0qNtAQPuKYVhqY=;
        b=Kgg7j9giVDPH9oQUpRP7KIq/54QWPGKlLvLV9mjD4rStWrvbQyS0fGcL4P0mkXPO+D
         LQdgDzubfPJDd13tidvlQmFhSbemME/yqqwXSpoOGr6NrbsVeYzS0Z1i0d115ImzTAnm
         dq3+riqnfvGhwMmd9X6ck/zPYehmI30GLvQSD1HKJic1tbyqGt3pclSpba9mE4T5K2tN
         NFCT5katRzF67t/hvfbGTppKKooJCnGoxeCyPvKQjtIdw2oU0PJn2aDLob9vU4PPPS2j
         kzb6xAuMSWkC51uH/PZRJFEIMD6EULfyVM+ibpIbEi7pTIMV3NttIg3veRNJICNd+2t4
         gLrQ==
X-Gm-Message-State: AOAM531TzpXn3du73Z7fpTD+h/9U3pb6yc1qIkzlF9lePEw8LPQR2I4J
        N2wOEcoFAUgd9QP+Hn3oLX7hxw==
X-Google-Smtp-Source: ABdhPJye9T5ssjW8E4P4GjH7FfhvM4AF2Z7qy2IXAxEr3xcVcZvzwNt1lx/ahswXlmOuVwPVDngHew==
X-Received: by 2002:a05:651c:2da:: with SMTP id f26mr5829320ljo.134.1607705549818;
        Fri, 11 Dec 2020 08:52:29 -0800 (PST)
Received: from gilgamesh.semihalf.com (193-106-246-138.noc.fibertech.net.pl. [193.106.246.138])
        by smtp.gmail.com with ESMTPSA id h23sm860741lfc.246.2020.12.11.08.52.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Dec 2020 08:52:29 -0800 (PST)
From:   Marcin Wojtas <mw@semihalf.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        mcroce@microsoft.com, sven.auhagen@voleatech.de, andrew@lunn.ch,
        Marcin Wojtas <mw@semihalf.com>
Subject: [PATCH v2] MAINTAINERS: add mvpp2 driver entry
Date:   Fri, 11 Dec 2020 17:51:14 +0100
Message-Id: <20201211165114.26290-1-mw@semihalf.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since its creation Marvell NIC driver for Armada 375/7k8k and
CN913x SoC families mvpp2 has been lacking an entry in MAINTAINERS,
which sometimes lead to unhandled bugs that persisted
across several kernel releases.

Signed-off-by: Marcin Wojtas <mw@semihalf.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6f474153dbec..975f24409b35 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10513,6 +10513,14 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/marvell/mvneta.*
 
+MARVELL MVPP2 ETHERNET DRIVER
+M:	Marcin Wojtas <mw@semihalf.com>
+M:	Russell King <linux@armlinux.org.uk>
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/net/marvell-pp2.txt
+F:	drivers/net/ethernet/marvell/mvpp2/
+
 MARVELL MWIFIEX WIRELESS DRIVER
 M:	Amitkumar Karwar <amitkarwar@gmail.com>
 M:	Ganapathi Bhat <ganapathi.bhat@nxp.com>
-- 
2.29.0

