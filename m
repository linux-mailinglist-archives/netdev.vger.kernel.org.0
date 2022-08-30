Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C893D5A67AA
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 17:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbiH3PqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 11:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbiH3PqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 11:46:13 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45FB06C775;
        Tue, 30 Aug 2022 08:46:10 -0700 (PDT)
Received: from jupiter.universe (dyndsl-091-096-062-005.ewe-ip-backbone.de [91.96.62.5])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sre)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id EC7F96601DC3;
        Tue, 30 Aug 2022 16:46:07 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1661874368;
        bh=0TFx+aIcei3lHxXt4Le4PXE+mkoFwuh3ZqXCJ4nXkmo=;
        h=From:To:Cc:Subject:Date:From;
        b=a4gsQhEVprVeJ4q+Z3HyDyP74oWVHQuvluAFx2p0/1Kg7TvcsE3CUPP2NoPNw9D8o
         ER81Yrjn3gGg4L6tqPICdFY+p/ZyKO6Z9VeXtFQZQIFKSbsPKR/pRspXMj1Ow3bzvF
         0e8DxthOj/iH3QmF0mg2WYoWIBwuIvvhkLiyAnZ5T8tQAbfpCEdOUhxCqOpaXU3LB3
         xUhdgCbteKClqlnp5TpmG9V9ZSomLtFUiRWju6uEEQMSWWAWNqNNhbKM/WBCfO8RuR
         r61nyf+xu0NGKb0xKzSY+QRu2i/6ZEM7iJbfWL0cGTARd+tQNajAH6pAwfOXMspkbr
         VXnJnlTzv5UdQ==
Received: by jupiter.universe (Postfix, from userid 1000)
        id 0A94948015C; Tue, 30 Aug 2022 17:46:06 +0200 (CEST)
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
Subject: [PATCHv3 0/2] RK3588 Ethernet Support
Date:   Tue, 30 Aug 2022 17:45:57 +0200
Message-Id: <20220830154559.61506-1-sebastian.reichel@collabora.com>
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

Changes since PATCHv2:
 * Rebased to v6.0-rc1
 * Wrap DT bindings additions at 80 characters
 * Add Acked-by from Krzysztof

Changes since PATCHv1:
 * Drop first patch (not required) and rebase second patch accordingly
 * Rename DT property rockchip,php_grf -> rockchip,php-grf

-- Sebastian

David Wu (1):
  net: ethernet: stmmac: dwmac-rk: Add gmac support for rk3588

Sebastian Reichel (1):
  dt-bindings: net: rockchip-dwmac: add rk3588 gmac compatible

 .../bindings/net/rockchip-dwmac.yaml          |   7 +
 .../devicetree/bindings/net/snps,dwmac.yaml   |   1 +
 .../net/ethernet/stmicro/stmmac/dwmac-rk.c    | 155 ++++++++++++++++++
 3 files changed, 163 insertions(+)

-- 
2.35.1

