Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5981BFDE5
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 16:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbgD3OXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 10:23:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:33834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726783AbgD3OXR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 10:23:17 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D06420873;
        Thu, 30 Apr 2020 14:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588256596;
        bh=wa4iZmsNsnV9kwtN/cSv2L1Cq1T8JX5xTxnk/b/mVoM=;
        h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
        b=THlHc2EhnHkvU/Xnqbs1Updhh5+0dJ2BAttkePnBKEUtGvq0xsju13+L4V/Gd1IMl
         7doZ+Mp0xvsEQs1qa2SFWf3qVR7GafibX9at0gFOsoYAcHJ585C8CXxmT5pq5F8KFT
         iTUqwW09fdugh7yZ6RHzzqYCAcFzX7umgvkauUCs=
Date:   Thu, 30 Apr 2020 15:23:14 +0100
From:   Mark Brown <broonie@kernel.org>
To:     linux-kernel@vger.kernel.org, Jules Irenge <jbi.octave@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
In-Reply-To: <20200429225723.31258-1-jbi.octave@gmail.com>
References: <0/2> <20200429225723.31258-1-jbi.octave@gmail.com>
Subject: Re: [PATCH 0/2] Lock warning cleanup
Message-Id: <158825658829.42351.8658305560393460400.b4-ty@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Apr 2020 23:57:21 +0100, Jules Irenge wrote:
> This patchset proposes a solution to functions that regiter context
> imbalance warnin, we add annotations to fix the warnings.
> 
> Jules Irenge (2):
>   cxgb4: Add missing annotation for service_ofldq()
>   spi: atmel: Add missing annotation for
>     atmel_spi_next_xfer_dma_submit()
> 
> [...]

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git for-5.8

Thanks!

[1/2] cxgb4: Add missing annotation for service_ofldq()
      commit: d7f27df50eea54fd00c26c5dda7bc12d2541e5e4
[2/2] spi: atmel: Add missing annotation for atmel_spi_next_xfer_dma_submit()
      commit: e124e205124c7ab1d35ab19a45b9a70fe4f17d49

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
