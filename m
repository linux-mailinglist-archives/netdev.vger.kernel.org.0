Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73FF44D9C81
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 14:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348801AbiCONmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 09:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348757AbiCONmS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 09:42:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45DA152E66;
        Tue, 15 Mar 2022 06:41:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD8FFB81677;
        Tue, 15 Mar 2022 13:41:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A13C340E8;
        Tue, 15 Mar 2022 13:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647351662;
        bh=gvl9SFrDd+2JfY4XpOU21w5Fgp3RnrxgO3xzRNMW3ig=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=FpIzPAInqwcWVe7lVXyZMo10uysAvQH5/+0FSS06nOQud/sjKtVu2eXUrgVVwDtnS
         K9saXWWZ1hCdhU07mL3gP1lbyLMM5ncodj0hAGG1sCe8guzPWwUCxCvCMd4UnYk0ij
         MiKnX5ElR8cklFLsknUpJxfH63KChYC/OCTeoHADKe2d7sJJxnj+KlqJSXMWCfA0RW
         7IMl8VYJBtsy0LvBdpwYawlVvfm1y/uovTsdBOXZktA8NvrkBJg6F9XHpbVdi97yvv
         ktn0TMEJDT+qVku5scquwwLC4arp4ujY52Gxd5XtzcUD53EHdZUC9sEswg4SOYFru/
         p422dM8tR7ngQ==
From:   Mark Brown <broonie@kernel.org>
To:     Julia Lawall <Julia.Lawall@inria.fr>, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Shayne Chen <shayne.chen@mediatek.com>,
        linux-media@vger.kernel.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        linux-perf-users@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Sean Wang <sean.wang@mediatek.com>,
        linux-arm-msm@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        platform-driver-x86@vger.kernel.org,
        kernel-janitors@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        target-devel@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-s390@vger.kernel.org,
        Jonas Karlman <jonas@kwiboo.se>, linux-sunxi@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-power@fi.rohmeurope.com,
        linux-omap@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-leds@vger.kernel.org, linux-spi@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, linux-clk@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org,
        Namhyung Kim <namhyung@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        linux-wireless@vger.kernel.org
In-Reply-To: <20220314115354.144023-1-Julia.Lawall@inria.fr>
References: <20220314115354.144023-1-Julia.Lawall@inria.fr>
Subject: Re: (subset) [PATCH 00/30] fix typos in comments
Message-Id: <164735165474.3687547.1964402001196947729.b4-ty@kernel.org>
Date:   Tue, 15 Mar 2022 13:40:54 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Mar 2022 12:53:24 +0100, Julia Lawall wrote:
> Various spelling mistakes in comments.
> Detected with the help of Coccinelle.
> 

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git for-next

Thanks!

[21/30] spi: sun4i: fix typos in comments
        commit: 2002c13243d595e211c0dad6b8e2e87f906f474b

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
