Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F64E557FCA
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 18:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232246AbiFWQ26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 12:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232238AbiFWQ25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 12:28:57 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0222B3E5FD;
        Thu, 23 Jun 2022 09:28:57 -0700 (PDT)
Received: from jupiter.universe (unknown [95.33.159.255])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: sre)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id AFEEC66017E7;
        Thu, 23 Jun 2022 17:28:55 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1656001735;
        bh=hb7b3KYBZVOC05uU3r7FVK013oCraF/sZZUgzcmFY1o=;
        h=From:To:Cc:Subject:Date:From;
        b=ZxAB000LQ9uGKeK/JCqcRIwJdfFmzeV9DvdAdUNbnevvmN9s5iM9zOGsn7gulMpAB
         9sb7LUsGrhEyXY70Fendi0n3L3eTWSyO5Yeie4XkE9/u4A3wd+8d1/LKRgtw1ljIZ5
         gVOVA/L0ys/qGGKfS8+bDAX2Be5xGvH5fQCnponFGttNkWyYPBaZ8MeuA6iXT6Rj0f
         nL+IafZQly37yf8bdE6ppXD0d+U5LuHfVCAvlT7bNXyXHMEnSqljkT3p3ePzp2SXhW
         IvDRire1yR4mfeCEg9v4bNc5SxgJN38FXkR9UNiVGcpQY1Dp3TdITGhfhiWyJkVlN/
         XHFr2jZM80NZA==
Received: by jupiter.universe (Postfix, from userid 1000)
        id 4340C480122; Thu, 23 Jun 2022 18:28:53 +0200 (CEST)
From:   Sebastian Reichel <sebastian.reichel@collabora.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        netdev@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        kernel@collabora.com
Subject: [PATCH 0/3] RK3588 Ethernet Support
Date:   Thu, 23 Jun 2022 18:28:47 +0200
Message-Id: <20220623162850.245608-1-sebastian.reichel@collabora.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RK3588 Ethernet Support

This adds ethernet support for the RK3588(s) SoCs.

-- Sebastian

David Wu (2):
  net: ethernet: stmmac: dwmac-rk: Disable delayline if it is invalid
  net: ethernet: stmmac: dwmac-rk: Add gmac support for rk3588

Sebastian Reichel (1):
  dt-bindings: net: rockchip-dwmac: add rk3588 gmac compatible

 .../bindings/net/rockchip-dwmac.yaml          |   6 +
 .../devicetree/bindings/net/snps,dwmac.yaml   |   1 +
 .../net/ethernet/stmicro/stmmac/dwmac-rk.c    | 205 +++++++++++++++---
 3 files changed, 185 insertions(+), 27 deletions(-)

-- 
2.35.1

