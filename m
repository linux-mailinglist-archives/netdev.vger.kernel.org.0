Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D822415D60
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 14:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240759AbhIWMBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 08:01:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:33040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240774AbhIWMBj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 08:01:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BFFBC61107;
        Thu, 23 Sep 2021 12:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632398407;
        bh=pFhadGqaUlWhFfy3qXxoZiXMh5hpFD5xoyQCVN3vMUw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kS+/d37DzP4KKeYUZhVO6kx7RIZdg+yCH7xJbWDc5l8Jyp6Ox7QoVxsl3D6nfWPzy
         3PlYmCn/7Ph0i7gf4w4Ra2ZS5uBX8IU+ucbHGHzTpjTYvX9UhTztlgtdW+AQ92FSju
         P0DKxIbrhL3rrS3pkEyFhZcCrRXk7I8TqmrydQ84KN/hqEq7VTUuhbMrPJ/cN6q1tL
         d5cvt0UkKa/XKTN0CAEmWmp0UkMg4iU3vSDvpCCpq5iZPNtDAGSNFiDO5cuZKlHjsd
         xWRnb2POcbi17mg45C1uNNqGeqh7xBrp+OydUqqJQ/mNLsV81Ga2ahg0ctmifb1yxx
         sFHYHJuFeQGkw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B348960A3A;
        Thu, 23 Sep 2021 12:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] nfc: st-nci: Add SPI ID matching DT compatible
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163239840772.772.10437868687021356237.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Sep 2021 12:00:07 +0000
References: <20210922183037.11977-1-broonie@kernel.org>
In-Reply-To: <20210922183037.11977-1-broonie@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 22 Sep 2021 19:30:37 +0100 you wrote:
> Currently autoloading for SPI devices does not use the DT ID table, it uses
> SPI modalises. Supporting OF modalises is going to be difficult if not
> impractical, an attempt was made but has been reverted, so ensure that
> module autoloading works for this driver by adding the part name used in
> the compatible to the list of SPI IDs.
> 
> Fixes: 96c8395e2166 ("spi: Revert modalias changes")
> Signed-off-by: Mark Brown <broonie@kernel.org>
> 
> [...]

Here is the summary with links:
  - nfc: st-nci: Add SPI ID matching DT compatible
    https://git.kernel.org/netdev/net/c/31339440b2d0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


