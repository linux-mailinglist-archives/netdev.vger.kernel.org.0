Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71D96388634
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 06:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238323AbhESE41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 00:56:27 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:3028 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233899AbhESE40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 00:56:26 -0400
Received: from dggems704-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FlL8c1WKkzmX8V;
        Wed, 19 May 2021 12:52:48 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 dggems704-chm.china.huawei.com (10.3.19.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 12:55:03 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 19 May 2021 12:55:02 +0800
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
        Shannon Nelson <snelson@pensando.io>,
        "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>,
        Joe Perches <joe@perches.com>,
        "Lee Jones" <lee.jones@linaro.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Yixing Liu <liuyixing1@huawei.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Miguel Ojeda <ojeda@kernel.org>,
        "Geert Uytterhoeven" <geert@linux-m68k.org>,
        Mike Rapoport <rppt@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jeremy Kerr <jk@ozlabs.org>, Moritz Fischer <mdf@kernel.org>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Lucy Yan <lucyyan@google.com>,
        Edward Cree <ecree@solarflare.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        "Jason Yan" <yanaijie@huawei.com>, Andrew Lunn <andrew@lunn.ch>,
        Romain Perier <romain.perier@gmail.com>,
        Wang Hai <wanghai38@huawei.com>,
        Colin Ian King <colin.king@canonical.com>,
        Luo Jiaxing <luojiaxing@huawei.com>,
        Allen Pais <apais@linux.microsoft.com>,
        Kees Cook <keescook@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Gaurav Singh <gaurav1086@gmail.com>, <linux-acenic@sunsite.dk>,
        <linux-parisc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 02/20] net: alteon: remove leading spaces before tabs
Date:   Wed, 19 May 2021 12:45:27 +0800
Message-ID: <1621399671-15517-3-git-send-email-tanghui20@huawei.com>
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

There are a few leading spaces before tabs and remove it by running the
following commard:

	$ find . -name '*.c' | xargs sed -r -i 's/^[ ]+\t/\t/'
	$ find . -name '*.h' | xargs sed -r -i 's/^[ ]+\t/\t/'

Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/net/ethernet/alteon/acenic.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/alteon/acenic.c b/drivers/net/ethernet/alteon/acenic.c
index 1a7e4df..9dc12b1 100644
--- a/drivers/net/ethernet/alteon/acenic.c
+++ b/drivers/net/ethernet/alteon/acenic.c
@@ -1883,16 +1883,16 @@ static u32 ace_handle_event(struct net_device *dev, u32 evtcsm, u32 evtprd)
 				}
 			}
 
- 			if (ACE_IS_TIGON_I(ap)) {
- 				struct cmd cmd;
- 				cmd.evt = C_SET_RX_JUMBO_PRD_IDX;
- 				cmd.code = 0;
- 				cmd.idx = 0;
- 				ace_issue_cmd(ap->regs, &cmd);
- 			} else {
- 				writel(0, &((ap->regs)->RxJumboPrd));
- 				wmb();
- 			}
+			if (ACE_IS_TIGON_I(ap)) {
+				struct cmd cmd;
+				cmd.evt = C_SET_RX_JUMBO_PRD_IDX;
+				cmd.code = 0;
+				cmd.idx = 0;
+				ace_issue_cmd(ap->regs, &cmd);
+			} else {
+				writel(0, &((ap->regs)->RxJumboPrd));
+				wmb();
+			}
 
 			ap->jumbo = 0;
 			ap->rx_jumbo_skbprd = 0;
@@ -2489,9 +2489,9 @@ static netdev_tx_t ace_start_xmit(struct sk_buff *skb,
 		}
 	}
 
- 	wmb();
- 	ap->tx_prd = idx;
- 	ace_set_txprd(regs, ap, idx);
+	wmb();
+	ap->tx_prd = idx;
+	ace_set_txprd(regs, ap, idx);
 
 	if (flagsize & BD_FLG_COAL_NOW) {
 		netif_stop_queue(dev);
-- 
2.8.1

