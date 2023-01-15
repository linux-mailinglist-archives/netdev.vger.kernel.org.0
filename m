Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB24966B19F
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 15:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbjAOOrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 09:47:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbjAOOrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 09:47:09 -0500
Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF034125A6;
        Sun, 15 Jan 2023 06:47:06 -0800 (PST)
Received: from ip5b412258.dynamic.kabel-deutschland.de ([91.65.34.88] helo=phil.lan)
        by gloria.sntech.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <heiko@sntech.de>)
        id 1pH4Hd-0007bK-G9; Sun, 15 Jan 2023 15:46:53 +0100
From:   Heiko Stuebner <heiko@sntech.de>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Wu <david.wu@rock-chips.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Anand Moon <anand@edgeble.ai>, Jagan Teki <jagan@edgeble.ai>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Heiko Stuebner <heiko@sntech.de>, Johan Jonker <jbx6244@gmail.com>,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: (subset) [PATCH v5 linux-next 1/4] dt-bindings: net: rockchip-dwmac: fix rv1126 compatible warning
Date:   Sun, 15 Jan 2023 15:46:48 +0100
Message-Id: <167379396100.36245.5527378985031920206.b4-ty@sntech.de>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230111172437.5295-1-anand@edgeble.ai>
References: <20230111172437.5295-1-anand@edgeble.ai>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_PASS,
        T_SPF_HELO_TEMPERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Jan 2023 17:24:31 +0000, Anand Moon wrote:
> Fix compatible string for RV1126 gmac, and constrain it to
> be compatible with Synopsys dwmac 4.20a.
> 
> fix below warning
> $ make CHECK_DTBS=y rv1126-edgeble-neu2-io.dtb
> arch/arm/boot/dts/rv1126-edgeble-neu2-io.dtb: ethernet@ffc40000:
> 		 compatible: 'oneOf' conditional failed, one must be fixed:
>         ['rockchip,rv1126-gmac', 'snps,dwmac-4.20a'] is too long
>         'rockchip,rv1126-gmac' is not one of ['rockchip,rk3568-gmac', 'rockchip,rk3588-gmac']
> 
> [...]

Applied, thanks!

[2/4] ARM: dts: rockchip: rv1126: Add ethernet rgmiim1 pin-control
      commit: bdcb1f4e19cbbe9ee8197078d25a2d4c27216ab1
[3/4] ARM: dts: Add Ethernet GMAC node for RV1126 SoC
      commit: 594a76a4465a96bc11f8ecf4504907afb064ce41
[4/4] ARM: dts: rockchip: rv1126: Enable Ethernet for Neu2-IO
      commit: aa3555c5fd3d2f5114ae7d28f7897072b5e6e60a

Best regards,
-- 
Heiko Stuebner <heiko@sntech.de>
