Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 972E555DCE8
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238263AbiF0RH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 13:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235646AbiF0RHz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 13:07:55 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A634818B1A;
        Mon, 27 Jun 2022 10:07:53 -0700 (PDT)
Received: from jupiter.universe (dyndsl-095-033-171-114.ewe-ip-backbone.de [95.33.171.114])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sre)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 47624660183A;
        Mon, 27 Jun 2022 18:07:52 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1656349672;
        bh=+by28bja4DISFnG9bIrL3DrLLe1IkOzJjONdUzVByVQ=;
        h=From:To:Cc:Subject:Date:From;
        b=iYs+67OGIzYfY610OpTT3UfBtOvdtqeeT43OaWV23N82g6B13zRAOZWJ2tKkAPVGg
         DUx1UK14WCt9AWu32xcASOndFIq9jp0nvwlIkO9NpZ9mVXNwXTRdNwuBdxG1qmni9h
         VNPNKVpZAgSGC4tLnuHhiw9PUMspvtob7X14177jFDRFrxZGeZOnXZHBCm9jy7Ld2m
         0cvQyKkZ0dAhtlXBYJar5njaIA7cAeQZTgWNGJJHmcFNAjlezBq6jMDjCtv6EMBTnn
         fDNt4pMPIw0Gv/MX3dTlDMfYEEpaj/c6zeLxc8Cg9PKm2xK34I90UspqKSMbdOGxze
         2jC+H3LW4hmcg==
Received: by jupiter.universe (Postfix, from userid 1000)
        id EB80B4800E4; Mon, 27 Jun 2022 19:07:49 +0200 (CEST)
From:   Sebastian Reichel <sebastian.reichel@collabora.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        kernel@collabora.com
Subject: [PATCHv2 0/2] RK3588 Ethernet Support
Date:   Mon, 27 Jun 2022 19:07:45 +0200
Message-Id: <20220627170747.137386-1-sebastian.reichel@collabora.com>
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

This adds ethernet support for the RK3588(s) SoCs.

Changes since PATCHv1:
 * Drop first patch (not required) and rebase second patch accordingly
 * Rename DT property rockchip,php_grf -> rockchip,php-grf

-- Sebastian

David Wu (1):
  net: ethernet: stmmac: dwmac-rk: Add gmac support for rk3588

Sebastian Reichel (1):
  dt-bindings: net: rockchip-dwmac: add rk3588 gmac compatible

 .../bindings/net/rockchip-dwmac.yaml          |   6 +
 .../devicetree/bindings/net/snps,dwmac.yaml   |   1 +
 .../net/ethernet/stmicro/stmmac/dwmac-rk.c    | 155 ++++++++++++++++++
 3 files changed, 162 insertions(+)

-- 
2.35.1

