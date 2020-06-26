Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F3020B6FB
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 19:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725917AbgFZR2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 13:28:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:42468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725806AbgFZR2A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 13:28:00 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EC9A20707;
        Fri, 26 Jun 2020 17:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593192479;
        bh=nN4I280MnrMDu0MHsHYDVRh28jhRIPVeDpZFSCYAt1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ac1ydLUqB6G+7Oc8CaDyDf47R8SNmkFspP+BcRiolw3rsmaZp466Zte8cjDfr84ta
         NSXu6WoleUhAiALjZJbiFwKDLWS6TSy4Swf5+swmxwMFd+urwQvpdsUSfANTlr0Obl
         MmgMFXYv/ZE+GbtfLJwC3Dueg2fikVjuj9edqM60=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 4/8] docs: networking: move ray_cs to the hw driver section
Date:   Fri, 26 Jun 2020 10:27:27 -0700
Message-Id: <20200626172731.280133-5-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200626172731.280133-1-kuba@kernel.org>
References: <20200626172731.280133-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move ray_cs into Wi-Fi driver docs subdirectory.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/device_drivers/wifi/index.rst        | 1 +
 Documentation/networking/{ => device_drivers/wifi}/ray_cs.rst | 0
 Documentation/networking/index.rst                            | 1 -
 drivers/net/wireless/Kconfig                                  | 3 ++-
 4 files changed, 3 insertions(+), 2 deletions(-)
 rename Documentation/networking/{ => device_drivers/wifi}/ray_cs.rst (100%)

diff --git a/Documentation/networking/device_drivers/wifi/index.rst b/Documentation/networking/device_drivers/wifi/index.rst
index fb394f5de4a9..bf91a87c7acf 100644
--- a/Documentation/networking/device_drivers/wifi/index.rst
+++ b/Documentation/networking/device_drivers/wifi/index.rst
@@ -10,6 +10,7 @@ Wi-Fi Device Drivers
 
    intel/ipw2100
    intel/ipw2200
+   ray_cs
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/ray_cs.rst b/Documentation/networking/device_drivers/wifi/ray_cs.rst
similarity index 100%
rename from Documentation/networking/ray_cs.rst
rename to Documentation/networking/device_drivers/wifi/ray_cs.rst
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 76831e9d7c9a..9f8230c325af 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -95,7 +95,6 @@ Linux Networking Documentation
    ppp_generic
    proc_net_tcp
    radiotap-headers
-   ray_cs
    rds
    regulatory
    rxrpc
diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 8ab62bb6b853..2c6dd50b6935 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -57,7 +57,8 @@ config PCMCIA_RAYCS
 	help
 	  Say Y here if you intend to attach an Aviator/Raytheon PCMCIA
 	  (PC-card) wireless Ethernet networking card to your computer.
-	  Please read the file <file:Documentation/networking/ray_cs.rst> for
+	  Please read the file
+	  <file:Documentation/networking/device_drivers/wifi/ray_cs.rst> for
 	  details.
 
 	  To compile this driver as a module, choose M here: the module will be
-- 
2.26.2

