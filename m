Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8675E62F9F4
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 17:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235371AbiKRQMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 11:12:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235220AbiKRQMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 11:12:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B36154B2C;
        Fri, 18 Nov 2022 08:12:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA41E62619;
        Fri, 18 Nov 2022 16:12:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64E71C433D6;
        Fri, 18 Nov 2022 16:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668787924;
        bh=1GQqeEHD0YLC4JQ4FJH13FF+QYcVbrQm05cErcgbJnk=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=o5ILzd3YUo3qEJRVWh3xdktoDglWM/HW8q2l6PCwqzbHdZ528YTz4v2p9XpT+1+jq
         SRYC54KH9iqxISohUZn8cDpnxr9vtm9lFdY2xC31HtFK/BXneAP2s57xnoKpJn9xnm
         jlXP8/kVlFEEryFjhhz0/x0c2JEbLubGeMt33ziiw23etT7MZ5f52l3u/BUAAZidBx
         fZkvj5MzZ2Z4mNK9hb9aHZT3H/++7a2gU6UbZ5Lx2P+lw4vFtrrkcL2lP5dppk1ISg
         vQbdUVyDPhvGwY6oHBD49ShZgM/y6DOzhdwzkr6YQQ+kL2hNbU+nZzJSNg3MwpY27r
         JeOOI+kGqCeRA==
From:   Mark Brown <broonie@kernel.org>
To:     krzysztof.kozlowski+dt@linaro.org, davem@davemloft.net,
        samuel@sholland.org, lgirdwood@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, calvin.johnson@oss.nxp.com, kuba@kernel.org,
        Corentin Labbe <clabbe@baylibre.com>, pabeni@redhat.com,
        andrew@lunn.ch, jernej.skrabec@gmail.com, wens@csie.org,
        robh+dt@kernel.org, edumazet@google.com
Cc:     devicetree@vger.kernel.org, linux-sunxi@lists.linux.dev,
        linux-sunxi@googlegroups.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <20221115073603.3425396-1-clabbe@baylibre.com>
References: <20221115073603.3425396-1-clabbe@baylibre.com>
Subject: Re: (subset) [PATCH v4 0/3] arm64: add ethernet to orange pi 3
Message-Id: <166878791907.1056942.1081365322638542611.b4-ty@kernel.org>
Date:   Fri, 18 Nov 2022 16:11:59 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-8af31
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Nov 2022 07:36:00 +0000, Corentin Labbe wrote:
> 2 sunxi board still does not have ethernet working, orangepi 1+ and
> orangepi 3.
> This is due to the fact thoses boards have a PHY which need 2 regulators.
> 
> A first attempt by Ondřej Jirman was made to support them was made by adding support in
> stmmac driver:
> https://lore.kernel.org/lkml/20190820145343.29108-6-megous@megous.com/
> Proposal rejected, since regulators need to be handled by the PHY core.
> 
> [...]

Applied to

   broonie/regulator.git for-next

Thanks!

[1/3] regulator: Add of_regulator_bulk_get_all
      commit: 27b9ecc7a9ba1d0014779bfe5a6dbf630899c6e7

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
