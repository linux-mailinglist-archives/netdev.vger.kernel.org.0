Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 210E34B50C7
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 13:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353674AbiBNMzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 07:55:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353671AbiBNMy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 07:54:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04C74C43C;
        Mon, 14 Feb 2022 04:54:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C9DE61477;
        Mon, 14 Feb 2022 12:54:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF1EC340E9;
        Mon, 14 Feb 2022 12:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644843286;
        bh=r7IKb+9DggDhLCpCMSDE8pe/YCI7ZnVvJgsKsInBzVw=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=mCVGimMag96xNclq+j7E0EsD4ZpiDxyO3y5NoNua3NiNEa+QrmFIGzcgzcKj9x12S
         775RaIrQN/aHejUFADEdR2SBysAJW5H10XNpr+hGflR3j9ZPjmQ/siQwE2MwMH4qDO
         6fZMib83HiI5Jxgp+CpWr7w+wf44UoTY8D2/m1LtiJ+mKV5qHPIFEzsteNWAyR1XOS
         A9YRvyU4GEmUDCRZ9yARV3tHO7D3ZM0oqYFYvK2CM5/xi50IjEp+y8DyRj6Wfvv++K
         brmPnfjgg1rxHtELt5q+qZBRDgxj/eClFlN+oxpiEoTVrfiqbGvfSt6RYBGgcwEmQj
         C8C0Yhtodp1Jg==
From:   Mark Brown <broonie@kernel.org>
To:     Julia Lawall <Julia.Lawall@inria.fr>, linux-scsi@vger.kernel.org
Cc:     linux-mtd@lists.infradead.org, MPT-FusionLinux.pdl@broadcom.com,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org, linux-media@vger.kernel.org,
        alsa-devel@alsa-project.org
In-Reply-To: <20220210204223.104181-1-Julia.Lawall@inria.fr>
References: <20220210204223.104181-1-Julia.Lawall@inria.fr>
Subject: Re: (subset) [PATCH 0/9] use GFP_KERNEL
Message-Id: <164484328403.12994.4553763831627919088.b4-ty@kernel.org>
Date:   Mon, 14 Feb 2022 12:54:44 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Feb 2022 21:42:14 +0100, Julia Lawall wrote:
> Platform_driver and pci_driver probe functions aren't called with
> locks held and thus don't need GFP_ATOMIC. Use GFP_KERNEL instead.
> 
> All changes have been compile-tested.
> 

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-next

Thanks!

[3/9] ASoC: Intel: bytcr_wm5102: use GFP_KERNEL
      commit: 695c105933cfa04ccf84088342193ae43e37e0f5

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
