Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94DC36C24E9
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 23:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbjCTWvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 18:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjCTWvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 18:51:51 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C51DC618D;
        Mon, 20 Mar 2023 15:51:50 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 32KMpcEx073323;
        Mon, 20 Mar 2023 17:51:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1679352698;
        bh=MbZ+XusRii1Zr2oBrUBsSXvshFMoC8qFnlsIDV2dSJk=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=cbD4765Zx/NVzHop9GaDA9/qLELx8cIHqAfcS6BNwAHWa3Ifb09PwlaD9WmjBGj8q
         IUSmd/iRV3JWqg4Ojm97+cXwtiKACYgwiZOUzdtc8nyfz07dkJfYswaWX7efQAsIz4
         Z18Nlfb80rlV05x4I8G0B1fvMQZCrAeJh//I+f/I=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 32KMpcvS085675
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 20 Mar 2023 17:51:38 -0500
Received: from DFLE112.ent.ti.com (10.64.6.33) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Mon, 20
 Mar 2023 17:51:38 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Mon, 20 Mar 2023 17:51:38 -0500
Received: from localhost (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 32KMpcrq105587;
        Mon, 20 Mar 2023 17:51:38 -0500
From:   Nishanth Menon <nm@ti.com>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, Nishanth Menon <nm@ti.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-gpio@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>, Tero Kristo <kristo@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>
Subject: Re: [PATCH V2 0/3] pinctrl/arm: dt-bindings: k3: Deprecate header with register constants
Date:   Mon, 20 Mar 2023 17:51:37 -0500
Message-ID: <167935265938.210951.6816039958932466588.b4-ty@ti.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315155228.1566883-1-nm@ti.com>
References: <20230315155228.1566883-1-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nishanth Menon,

On Wed, 15 Mar 2023 10:52:25 -0500, Nishanth Menon wrote:
> This is an updated series to move the pinctrl bindings over to arch as
> the definitions are hardware definitions without driver usage.
> 
> This series was triggered by the discussion in [1]
> 
> v1: https://lore.kernel.org/linux-arm-kernel/20230311131325.9750-1-nm@ti.com/
> 
> [...]

I have applied the following to branch ti-k3-dts-next on [1].
Thank you!

[1/3] dt-bindings: net: ti: k3-am654-cpsw-nuss: Drop pinmux header
      commit: c680fa2a09a9550284546d2deeb31640ec3b56c8
[2/3] arm64: dts: ti: Use local header for pinctrl register values
      commit: fe49f2d776f7994dc60dd04712a437fd0bdc67a0
[3/3] dt-bindings: pinctrl: k3: Deprecate header with register constants
      commit: f2de003e1426ccbefa281a066040da7699f6d461

All being well this means that it will be integrated into the linux-next
tree (usually sometime in the next 24 hours) and sent up the chain during
the next merge window (or sooner if it is a relevant bug fix), however if
problems are discovered then the patch may be dropped or reverted.

You may get further e-mails resulting from automated or manual testing
and review of the tree, please engage with people reporting problems and
send followup patches addressing any issues that are reported if needed.

If any updates are required or you are submitting further changes they
should be sent as incremental updates against current git, existing
patches will not be replaced.

Please add any relevant lists and maintainers to the CCs when replying
to this mail.

[1] git://git.kernel.org/pub/scm/linux/kernel/git/ti/linux.git
-- 
Regards,
Nishanth Menon
Key (0xDDB5849D1736249D) / Fingerprint: F8A2 8693 54EB 8232 17A3  1A34 DDB5 849D 1736 249D

