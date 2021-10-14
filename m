Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 104E042D7A2
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 13:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbhJNLEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 07:04:30 -0400
Received: from mx24.baidu.com ([111.206.215.185]:34716 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230080AbhJNLE3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 07:04:29 -0400
Received: from BJHW-Mail-Ex06.internal.baidu.com (unknown [10.127.64.16])
        by Forcepoint Email with ESMTPS id 087AB845C0EE394F5166;
        Thu, 14 Oct 2021 19:02:22 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BJHW-Mail-Ex06.internal.baidu.com (10.127.64.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Thu, 14 Oct 2021 19:02:21 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Thu, 14 Oct 2021 19:02:21 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <qiangqing.zhang@nxp.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <robh+dt@kernel.org>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Cai Huoqing <caihuoqing@baidu.com>
Subject: [PATCH] MAINTAINERS: Update the devicetree documentation path of imx fec driver
Date:   Thu, 14 Oct 2021 19:02:14 +0800
Message-ID: <20211014110214.3254-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BC-Mail-EX02.internal.baidu.com (172.31.51.42) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
X-Baidu-BdMsfe-DateCheck: 1_BJHW-Mail-Ex06_2021-10-14 19:02:22:028
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the devicetree documentation path
to "Documentation/devicetree/bindings/net/fsl,fec.yaml"
since 'fsl-fec.txt' has been converted to 'fsl,fec.yaml' already.

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
*resend +Cc others.

 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7cfd63ce7122..9b255cf4fca8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7509,7 +7509,7 @@ FREESCALE IMX / MXC FEC DRIVER
 M:	Joakim Zhang <qiangqing.zhang@nxp.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
-F:	Documentation/devicetree/bindings/net/fsl-fec.txt
+F:	Documentation/devicetree/bindings/net/fsl,fec.yaml
 F:	drivers/net/ethernet/freescale/fec.h
 F:	drivers/net/ethernet/freescale/fec_main.c
 F:	drivers/net/ethernet/freescale/fec_ptp.c
-- 
2.25.1

