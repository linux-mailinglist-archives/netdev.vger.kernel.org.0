Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 810BF31B4EB
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 06:09:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbhBOFJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 00:09:24 -0500
Received: from mo-csw1515.securemx.jp ([210.130.202.154]:56766 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbhBOFJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 00:09:19 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1515) id 11F578P5025130; Mon, 15 Feb 2021 14:07:08 +0900
X-Iguazu-Qid: 34tKUV8MimxRCFy9PH
X-Iguazu-QSIG: v=2; s=0; t=1613365627; q=34tKUV8MimxRCFy9PH; m=v5UP97iVwULMaZ6jab2XzLeMrujUz8tI9/kXWsh5sDw=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1512) id 11F575P6026946;
        Mon, 15 Feb 2021 14:07:05 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id 11F5750s029839;
        Mon, 15 Feb 2021 14:07:05 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 11F574Xi021263;
        Mon, 15 Feb 2021 14:07:04 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>, leon@kernel.org,
        arnd@kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, punit1.agrawal@toshiba.co.jp,
        yuji2.ishikawa@toshiba.co.jp, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 3/4] MAINTAINERS: Add entries for Toshiba Visconti ethernet controller
Date:   Mon, 15 Feb 2021 14:06:54 +0900
X-TSB-HOP: ON
Message-Id: <20210215050655.2532-4-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.30.0.rc2
In-Reply-To: <20210215050655.2532-1-nobuhiro1.iwamatsu@toshiba.co.jp>
References: <20210215050655.2532-1-nobuhiro1.iwamatsu@toshiba.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add entries for Toshiba Visconti ethernet controller binding and driver.

Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index cbf4b94f89d4..6be4bdaabf32 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2641,8 +2641,10 @@ L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/iwamatsu/linux-visconti.git
 F:	Documentation/devicetree/bindings/arm/toshiba.yaml
+F:	Documentation/devicetree/bindings/net/toshiba,visconti-dwmac.yaml
 F:	Documentation/devicetree/bindings/pinctrl/toshiba,tmpv7700-pinctrl.yaml
 F:	arch/arm64/boot/dts/toshiba/
+F:	drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
 F:	drivers/pinctrl/visconti/
 N:	visconti
 
-- 
2.30.0.rc2

