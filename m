Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 467626C86E3
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 21:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232107AbjCXUhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 16:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbjCXUhl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 16:37:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E6B61F905;
        Fri, 24 Mar 2023 13:37:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D55CB82608;
        Fri, 24 Mar 2023 20:37:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7BCC4339C;
        Fri, 24 Mar 2023 20:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679690257;
        bh=aWXxTpUzVdWKwRyaJyc6kpA5qikK8OgfqGObFSQG9Q0=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=Ex8Z9pZ4OL5wCGHQ7yY3D0VQ48EbuxFK9fk474Er+4+ws+7Jp/erWuSkCqiCPWMmE
         1l5PLpiJ0S2+1GHj+XrtQgOW+IRFYM3hw3MfT9RAEfE1hyqBDPEv0A7X/Wnlid04hK
         h7RnFqtuSKcGFEsPKfMSv8sYX8qH16qDX0+VrNwoxgMYyWNiTTj7o4716W9zwqPlVS
         wbdj4daIe8ACFK6VBgAy8CbBzrXSWudcHoai4xuh/dw3AD0wyErUyd0LfkrnfyczJQ
         6jDpnioFT9MtJzzXp6un/63S+Emx91/ro/D/8yNhrtSt8W2ryQ8rCa5+m366Eqlw01
         UtfA3opoi6EUA==
From:   Mark Brown <broonie@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rafael@kernel.org,
        Colin Foster <colin.foster@in-advantage.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee@kernel.org>, davem@davemloft.net,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        thomas.petazzoni@bootlin.com
In-Reply-To: <20230324093644.464704-1-maxime.chevallier@bootlin.com>
References: <20230324093644.464704-1-maxime.chevallier@bootlin.com>
Subject: Re: (subset) [RFC 0/7] Introduce a generic regmap-based MDIO
 driver
Message-Id: <167969025376.2727723.12829947448375375074.b4-ty@kernel.org>
Date:   Fri, 24 Mar 2023 20:37:33 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-2eb1a
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Mar 2023 10:36:37 +0100, Maxime Chevallier wrote:
> When the Altera TSE PCS driver was initially introduced, there were
> comments by Russell that the register layout looked very familiar to the
> existing Lynx PCS driver, the only difference being that the TSE PCS
> driver is memory-mapped whereas the Lynx PCS driver sits on an MDIO bus.
> 
> Since then, I've sent a followup to create a wrapper around Lynx, that
> would create a virtual MDIO bus driver that would translate the mdio
> operations to mmio operations [1].
> 
> [...]

Applied to

   broonie/regmap.git for-next

Thanks!

[1/7] regmap: add a helper to translate the register address
      commit: 3f58f6dc4d92ed6fae4a4da0d5b091e00ec10fa8

All being well this means that it will be integrated into the linux-next
tree (usually sometime in the next 24 hours) and sent to Linus during
the next merge window (or sooner if it is a bug fix), however if
problems are discovered then the patch may be dropped or reverted.

You may get further e-mails resulting from automated or manual testing
and review of the tree, please engage with people reporting problems and
send followup patches addressing any issues that are reported if needed.

If any updates are required or you are submitting further changes they
should be sent as incremental updates against current git, existing
patches will not be replaced.

Please add any relevant lists and maintainers to the CCs when replying
to this mail.

Thanks,
Mark

