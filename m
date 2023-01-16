Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18D8666C309
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 15:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232829AbjAPO7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 09:59:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232942AbjAPO6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 09:58:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E24012F36;
        Mon, 16 Jan 2023 06:49:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEB9160FD7;
        Mon, 16 Jan 2023 14:49:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACBFCC433D2;
        Mon, 16 Jan 2023 14:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673880551;
        bh=SYGWAHn0hIePrfmTmgN0T/xH1F9Dw0NE2z1mOy81IJQ=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=utiXRpd/+bO4PGgblAGfbKSGuqIcwnK/RRHdbbkHCIgRrgDHaMN+yUuLz/O7oWQRI
         eU7HGDOTxjz15DvYmtvk1u9zum+1lVKuCpK8RBFPKvDYewu/K65l1iilGDGOBJc7Dz
         DBy6hQJyALlSIxqRyf+dNeBipg6pMcfFVhwrH34n0j3wV4SZDo7GMloZj5At7Zz2TN
         ueJUG4VDL+dYzdpeY0xU9zULJDTTc6MeuPTsOoTxAzTNabcTRKQdP0iF+kXn7pfOQ4
         E7jJMHcbp9kxrcn+pNxK1mY7dZn42ejRePd75AOmXfp79Oqr9zrdle38F/+/YJ3ivU
         I0Zxp/krSZCdg==
From:   Mark Brown <broonie@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Walle <michael@walle.cc>
Cc:     Sander Vanheule <sander@svanheule.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
In-Reply-To: <20230116111509.4086236-1-michael@walle.cc>
References: <20230116111509.4086236-1-michael@walle.cc>
Subject: Re: [PATCH net-next] regmap: Rework regmap_mdio_c45_{read|write} for
 new C45 API.
Message-Id: <167388054729.388650.12953940088120724088.b4-ty@kernel.org>
Date:   Mon, 16 Jan 2023 14:49:07 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12-dev-69c4d
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Jan 2023 12:15:09 +0100, Michael Walle wrote:
> The MDIO subsystem is getting rid of MII_ADDR_C45 and thus also
> encoding associated encoding of the C45 device address and register
> address into one value. regmap-mdio also uses this encoding for the
> C45 bus.
> 
> Move to the new C45 helpers for MDIO access and provide regmap-mdio
> helper macros.
> 
> [...]

Applied to

   broonie/regmap.git for-next

Thanks!

[1/1] regmap: Rework regmap_mdio_c45_{read|write} for new C45 API.
      commit: 7b3c4c370c09313e22b555e79167e73d233611d1

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
