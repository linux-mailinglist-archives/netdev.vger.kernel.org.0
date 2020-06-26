Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35DAD20B6F9
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 19:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727980AbgFZR2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 13:28:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:42478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725977AbgFZR2A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 13:28:00 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5B0020FC3;
        Fri, 26 Jun 2020 17:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593192479;
        bh=wB1ZXCIF+9Z4KrQQNZ2bM+mZza87ec23HzWi2L715KY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jxfwO50FVtVwdmWQJgQiQtpQxd2QAXhKn4SuBBO9deiL3qasldz1JVlBxSD4mvNJ7
         o1wZDNuruqzugfMaud9LxhdDaz2kl47uS5eTR/5miAwf4soPkLWeGrODV2Ygfak74+
         hgmdpTAKwY3GE3UHkIpqqpufnj0/wzJrirFbHryw=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        luobin9@huawei.com
Subject: [PATCH net-next 5/8] docs: networking: move remaining Ethernet driver docs to the hw section
Date:   Fri, 26 Jun 2020 10:27:28 -0700
Message-Id: <20200626172731.280133-6-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200626172731.280133-1-kuba@kernel.org>
References: <20200626172731.280133-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move docs for hinic and altera_tse under device_drivers/ethernet.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
--
CC: luobin9@huawei.com
---
 .../{ => device_drivers/ethernet/altera}/altera_tse.rst         | 0
 .../networking/{ => device_drivers/ethernet/huawei}/hinic.rst   | 0
 Documentation/networking/device_drivers/ethernet/index.rst      | 2 ++
 Documentation/networking/index.rst                              | 2 --
 MAINTAINERS                                                     | 2 +-
 5 files changed, 3 insertions(+), 3 deletions(-)
 rename Documentation/networking/{ => device_drivers/ethernet/altera}/altera_tse.rst (100%)
 rename Documentation/networking/{ => device_drivers/ethernet/huawei}/hinic.rst (100%)

diff --git a/Documentation/networking/altera_tse.rst b/Documentation/networking/device_drivers/ethernet/altera/altera_tse.rst
similarity index 100%
rename from Documentation/networking/altera_tse.rst
rename to Documentation/networking/device_drivers/ethernet/altera/altera_tse.rst
diff --git a/Documentation/networking/hinic.rst b/Documentation/networking/device_drivers/ethernet/huawei/hinic.rst
similarity index 100%
rename from Documentation/networking/hinic.rst
rename to Documentation/networking/device_drivers/ethernet/huawei/hinic.rst
diff --git a/Documentation/networking/device_drivers/ethernet/index.rst b/Documentation/networking/device_drivers/ethernet/index.rst
index fd3873024da8..cbb75a1818c0 100644
--- a/Documentation/networking/device_drivers/ethernet/index.rst
+++ b/Documentation/networking/device_drivers/ethernet/index.rst
@@ -13,6 +13,7 @@ Device drivers for Ethernet and Ethernet-based virtual function devices.
    3com/3c509
    3com/vortex
    amazon/ena
+   altera/altera_tse
    aquantia/atlantic
    chelsio/cxgb
    cirrus/cs89x0
@@ -24,6 +25,7 @@ Device drivers for Ethernet and Ethernet-based virtual function devices.
    freescale/dpaa2/index
    freescale/gianfar
    google/gve
+   huawei/hinic
    intel/e100
    intel/e1000
    intel/e1000e
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 9f8230c325af..9bc8ecc79d94 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -38,7 +38,6 @@ Linux Networking Documentation
    nfc
    6lowpan
    6pack
-   altera_tse
    arcnet-hardware
    arcnet
    atm
@@ -62,7 +61,6 @@ Linux Networking Documentation
    generic_netlink
    gen_stats
    gtp
-   hinic
    ila
    ipddp
    ip_dynaddr
diff --git a/MAINTAINERS b/MAINTAINERS
index bdde85c12b74..e5a1da603924 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7913,7 +7913,7 @@ HUAWEI ETHERNET DRIVER
 M:	Bin Luo <luobin9@huawei.com>
 L:	netdev@vger.kernel.org
 S:	Supported
-F:	Documentation/networking/hinic.rst
+F:	Documentation/networking/device_drivers/ethernet/huawei/hinic.rst
 F:	drivers/net/ethernet/huawei/hinic/
 
 HUGETLB FILESYSTEM
-- 
2.26.2

