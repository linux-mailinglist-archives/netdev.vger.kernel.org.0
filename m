Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E469388631
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 06:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241496AbhESEyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 00:54:40 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3591 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233899AbhESEyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 00:54:39 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FlL601mfqzsRmV;
        Wed, 19 May 2021 12:50:32 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 12:53:17 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 19 May 2021 12:53:17 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hui Tang <tanghui20@huawei.com>,
        Steffen Klassert <klassert@kernel.org>,
        Jes Sorensen <jes@trained-monkey.org>,
        Michael Chan <michael.chan@broadcom.com>,
        "Rasesh Mody" <rmody@marvell.com>, <GR-Linux-NIC-Dev@marvell.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Russell King <linux@armlinux.org.uk>,
        Daniele Venzano <venza@brownhat.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Shannon Nelson <snelson@pensando.io>,
        Lee Jones <lee.jones@linaro.org>,
        "Joe Perches" <joe@perches.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Weihang Li <liweihang@huawei.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Yixing Liu <liuyixing1@huawei.com>,
        "Vaibhav Gupta" <vaibhavgupta40@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Miguel Ojeda <ojeda@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jeremy Kerr <jk@ozlabs.org>, Moritz Fischer <mdf@kernel.org>,
        Lucy Yan <lucyyan@google.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Edward Cree <ecree@solarflare.com>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Jason Yan <yanaijie@huawei.com>, Andrew Lunn <andrew@lunn.ch>,
        Colin Ian King <colin.king@canonical.com>,
        Romain Perier <romain.perier@gmail.com>,
        "Allen Pais" <apais@linux.microsoft.com>,
        Luo Jiaxing <luojiaxing@huawei.com>,
        "Wang Hai" <wanghai38@huawei.com>, Qiushi Wu <wu000273@umn.edu>,
        Kees Cook <keescook@chromium.org>,
        Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Gaurav Singh <gaurav1086@gmail.com>, <linux-acenic@sunsite.dk>,
        <linux-parisc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 01/20] net: 3com: remove leading spaces before tabs
Date:   Wed, 19 May 2021 12:45:26 +0800
Message-ID: <1621399671-15517-2-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621399671-15517-1-git-send-email-tanghui20@huawei.com>
References: <1621399671-15517-1-git-send-email-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggemi760-chm.china.huawei.com (10.1.198.146)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a few leading space before tabs and remove it by running the
following commard:

	$ find . -name '*.c' | xargs sed -r -i 's/^[ ]+\t/\t/'
	$ find . -name '*.h' | xargs sed -r -i 's/^[ ]+\t/\t/'

Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/net/ethernet/3com/3c59x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/3com/3c59x.c b/drivers/net/ethernet/3com/3c59x.c
index 741c67e..7d7d3ff 100644
--- a/drivers/net/ethernet/3com/3c59x.c
+++ b/drivers/net/ethernet/3com/3c59x.c
@@ -1464,7 +1464,7 @@ static int vortex_probe1(struct device *gendev, void __iomem *ioaddr, int irq,
 	if (pdev) {
 		vp->pm_state_valid = 1;
 		pci_save_state(pdev);
- 		acpi_set_WOL(dev);
+		acpi_set_WOL(dev);
 	}
 	retval = register_netdev(dev);
 	if (retval == 0)
-- 
2.8.1

