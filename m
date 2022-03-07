Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0887D4D0881
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 21:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245302AbiCGUkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 15:40:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245305AbiCGUkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 15:40:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 472F470849;
        Mon,  7 Mar 2022 12:39:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 005ACB81706;
        Mon,  7 Mar 2022 20:39:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B852C340FF;
        Mon,  7 Mar 2022 20:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646685548;
        bh=2AJXQfaXAVGMfsXh7g2oy6EAKDefCtmzA26vSc+eQ2E=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=dpuYYw1i4ooZDW0rFRlF7JnE6b/MvLRIK6HG6LsUQ1FvxFdwzOXmCi8mB4FRhZd/b
         44CiaGrvcl273QzJilYHOJPErc+iWys3knkYpuoXZ4JaMqMyJyM8twGOQtgm+He+dx
         EeU57aROywzhEu2YrOiWMOnGHQjQs+g2rDYPiAfKG0RawHqUI2mpu9cqxMlSbANswh
         81ebZrZ4OYNOyMvbIVwzcPDtpveoPaJ985h9NGgUtYQM9eLDgnIGM43r9KdTd2kp+m
         fmbtOgqdwejdVpsSXM2onxr2j+lYppHU+JOB1WKD0yrsiUHNMiwnV+5tqQ5xL2qp6U
         Ec5CewIrT2hFg==
From:   Mark Brown <broonie@kernel.org>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        kuninori.morimoto.gx@renesas.com
Cc:     ast@kernel.org, f.suligoi@asem.it, songliubraving@fb.com,
        kafai@fb.com, lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        kpsingh@kernel.org, yhs@fb.com, netdev@vger.kernel.org,
        andrii@kernel.org, tiwai@suse.com, alsa-devel@alsa-project.org,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        bpf@vger.kernel.org, perex@perex.cz
In-Reply-To: <20220302062844.46869-1-jiasheng@iscas.ac.cn>
References: <20220302062844.46869-1-jiasheng@iscas.ac.cn>
Subject: Re: [PATCH v3] ASoC: fsi: Add check for clk_enable
Message-Id: <164668554489.3137316.16865303001337424021.b4-ty@kernel.org>
Date:   Mon, 07 Mar 2022 20:39:04 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Mar 2022 14:28:44 +0800, Jiasheng Jiang wrote:
> As the potential failure of the clk_enable(),
> it should be better to check it and return error
> if fails.
> 
> 

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-next

Thanks!

[1/1] ASoC: fsi: Add check for clk_enable
      commit: 405afed8a728f23cfaa02f75bbc8bdd6b7322123

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
