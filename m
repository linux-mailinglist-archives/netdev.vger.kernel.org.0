Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F265153CD1
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 02:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727662AbgBFB7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 20:59:41 -0500
Received: from mx.socionext.com ([202.248.49.38]:48087 "EHLO mx.socionext.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727474AbgBFB7l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Feb 2020 20:59:41 -0500
Received: from unknown (HELO iyokan-ex.css.socionext.com) ([172.31.9.54])
  by mx.socionext.com with ESMTP; 06 Feb 2020 10:59:40 +0900
Received: from mail.mfilter.local (m-filter-1 [10.213.24.61])
        by iyokan-ex.css.socionext.com (Postfix) with ESMTP id 38953603AB;
        Thu,  6 Feb 2020 10:59:40 +0900 (JST)
Received: from 172.31.9.51 (172.31.9.51) by m-FILTER with ESMTP; Thu, 6 Feb 2020 11:00:49 +0900
Received: from plum.e01.socionext.com (unknown [10.213.132.32])
        by kinkan.css.socionext.com (Postfix) with ESMTP id 9A1371A0006;
        Thu,  6 Feb 2020 10:59:39 +0900 (JST)
From:   Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Subject: [PATCH net] net: ethernet: ave: Add capability of rgmii-id mode
Date:   Thu,  6 Feb 2020 10:59:36 +0900
Message-Id: <1580954376-27283-1-git-send-email-hayashi.kunihiko@socionext.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows you to specify the type of rgmii-id that will enable phy
internal delay in ethernet phy-mode.

Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
---
 drivers/net/ethernet/socionext/sni_ave.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/socionext/sni_ave.c b/drivers/net/ethernet/socionext/sni_ave.c
index 3b4c7e6..7c574f2 100644
--- a/drivers/net/ethernet/socionext/sni_ave.c
+++ b/drivers/net/ethernet/socionext/sni_ave.c
@@ -1857,6 +1857,9 @@ static int ave_pro4_get_pinmode(struct ave_private *priv,
 		break;
 	case PHY_INTERFACE_MODE_MII:
 	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
 		priv->pinmode_val = 0;
 		break;
 	default:
@@ -1901,6 +1904,9 @@ static int ave_ld20_get_pinmode(struct ave_private *priv,
 		priv->pinmode_val = SG_ETPINMODE_RMII(0);
 		break;
 	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
 		priv->pinmode_val = 0;
 		break;
 	default:
@@ -1923,6 +1929,9 @@ static int ave_pxs3_get_pinmode(struct ave_private *priv,
 		priv->pinmode_val = SG_ETPINMODE_RMII(arg);
 		break;
 	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
 		priv->pinmode_val = 0;
 		break;
 	default:
-- 
2.7.4

