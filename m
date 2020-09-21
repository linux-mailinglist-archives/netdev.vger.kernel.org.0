Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A75E272FC5
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 19:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730342AbgIUQ72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 12:59:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:40096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730308AbgIUQ7O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 12:59:14 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CAA5235FD;
        Mon, 21 Sep 2020 16:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600707553;
        bh=ilYPXYXOrK02dbgWO785dFtleHl2+7nPjk6K0R/PBvw=;
        h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
        b=yyPOpwzx1pKltzf4H+v0LidZoBubumrt/74zHAY5TzeAVoIQ8re/YX4A1pDxLKPo6
         Vv1/tJnpF8BhoP6or7Ck079oNkAaG4N9D7DU/T8PUoATLp0KQqEJ2DLkYD20jr0P0O
         GwH9D2LvhnnnkrNBzbXQKA7gy9dil44xEFwmKaEQ=
Date:   Mon, 21 Sep 2020 17:58:21 +0100
From:   Mark Brown <broonie@kernel.org>
To:     linux-spi@vger.kernel.org, Julia Lawall <Julia.Lawall@inria.fr>
Cc:     linux-serial@vger.kernel.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-media@vger.kernel.org, linux-block@vger.kernel.org,
        Yossi Leybovich <sleybo@amazon.com>,
        linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
        dmaengine@vger.kernel.org, linux-pci@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-rdma@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        rds-devel@oss.oracle.com
In-Reply-To: <1600601186-7420-1-git-send-email-Julia.Lawall@inria.fr>
References: <1600601186-7420-1-git-send-email-Julia.Lawall@inria.fr>
Subject: Re: [PATCH 00/14] drop double zeroing
Message-Id: <160070750168.56292.17961674601916397869.b4-ty@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 20 Sep 2020 13:26:12 +0200, Julia Lawall wrote:
> sg_init_table zeroes its first argument, so the allocation of that argument
> doesn't have to.

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git for-next

Thanks!

[1/1] spi/topcliff-pch: drop double zeroing
      commit: ca03dba30f2b8ff45a2972c6691e4c96d8c52b3b

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
