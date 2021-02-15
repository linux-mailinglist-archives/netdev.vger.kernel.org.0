Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5005A31BC7C
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 16:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbhBOP3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 10:29:50 -0500
Received: from mo-csw1514.securemx.jp ([210.130.202.153]:41010 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbhBOP1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 10:27:41 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1514) id 11FFOiIn026354; Tue, 16 Feb 2021 00:24:44 +0900
X-Iguazu-Qid: 34tMK0YvjNCLTBQwAi
X-Iguazu-QSIG: v=2; s=0; t=1613402684; q=34tMK0YvjNCLTBQwAi; m=a/2Etahugq3vZzDXMKjH6kAGtmdFbii5ya0VVu9AyD4=
Received: from imx2.toshiba.co.jp (imx2.toshiba.co.jp [106.186.93.51])
        by relay.securemx.jp (mx-mr1512) id 11FFOhkn037439;
        Tue, 16 Feb 2021 00:24:43 +0900
Received: from enc01.toshiba.co.jp ([106.186.93.100])
        by imx2.toshiba.co.jp  with ESMTP id 11FFOgtV008339;
        Tue, 16 Feb 2021 00:24:42 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.toshiba.co.jp  with ESMTP id 11FFOgHd017699;
        Tue, 16 Feb 2021 00:24:42 +0900
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
Subject: [PATCH v4 3/4] MAINTAINERS: Add entries for Toshiba Visconti ethernet controller
Date:   Tue, 16 Feb 2021 00:24:37 +0900
X-TSB-HOP: ON
Message-Id: <20210215152438.4318-4-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.30.0.rc2
In-Reply-To: <20210215152438.4318-1-nobuhiro1.iwamatsu@toshiba.co.jp>
References: <20210215152438.4318-1-nobuhiro1.iwamatsu@toshiba.co.jp>
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

