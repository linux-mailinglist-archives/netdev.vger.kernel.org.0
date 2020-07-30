Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED02233B56
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 00:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730684AbgG3W26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 18:28:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:41070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730641AbgG3W25 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 18:28:57 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D06520829;
        Thu, 30 Jul 2020 22:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596148137;
        bh=YH9+ICW/3hXRtSm64orqu19oSdQuuWKrMUBevTvaXkE=;
        h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
        b=F+0Ydd/Fgutk16gkyGj2gECpPoXbH4sg6UlFq9catgilRzwkQfA9O7G1w0Kz6j0y8
         QrQ7gUCMeXm93qiW40R2H2WfV9+NT2PCbOx4GxEs87RdYK42aWEzohK3Bf2m4JuD5e
         DShs/tsbsdcOdvIawMZxl9W+REGJfO6Zjj0yspI8=
Date:   Thu, 30 Jul 2020 23:28:36 +0100
From:   Mark Brown <broonie@kernel.org>
To:     linux-rdma@vger.kernel.org, Julia Lawall <Julia.Lawall@inria.fr>
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <1595761112-11003-1-git-send-email-Julia.Lawall@inria.fr>
References: <1595761112-11003-1-git-send-email-Julia.Lawall@inria.fr>
Subject: Re: [PATCH 0/7] drop unnecessary list_empty
Message-Id: <159614804536.1473.16638498246526574558.b4-ty@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 26 Jul 2020 12:58:25 +0200, Julia Lawall wrote:
> The various list iterators are able to handle an empty list.
> The only effect of avoiding the loop is not initializing some
> index variables.
> Drop list_empty tests in cases where these variables are not
> used.
> 
> The semantic patch that makes these changes is as follows:
> (http://coccinelle.lip6.fr/)
> 
> [...]

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-next

Thanks!

[1/1] ASoC: Intel: drop unnecessary list_empty
      commit: a383308e50244a28fe927b9c1acbe0a963bf186b

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
