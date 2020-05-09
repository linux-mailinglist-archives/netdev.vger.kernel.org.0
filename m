Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37FD01CC4C2
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 23:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbgEIVlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 17:41:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50014 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbgEIVlQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 17:41:16 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jXXDb-00049o-8Z; Sat, 09 May 2020 21:41:11 +0000
From:   Colin King <colin.king@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: usb: ax88179_178a: remove redundant assignment to variable ret
Date:   Sat,  9 May 2020 22:41:11 +0100
Message-Id: <20200509214111.505920-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable ret is being initializeed with a value that is never read
and it is being updated later with a new value. The initialization
is redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/usb/ax88179_178a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index b05bb11a02cb..950711448f39 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -860,7 +860,7 @@ static int ax88179_set_eee(struct net_device *net, struct ethtool_eee *edata)
 {
 	struct usbnet *dev = netdev_priv(net);
 	struct ax88179_data *priv = (struct ax88179_data *)dev->data;
-	int ret = -EOPNOTSUPP;
+	int ret;
 
 	priv->eee_enabled = edata->eee_enabled;
 	if (!priv->eee_enabled) {
-- 
2.25.1

