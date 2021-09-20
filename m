Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40CB141117E
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 11:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234397AbhITJBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 05:01:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:48816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231731AbhITJBe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 05:01:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 46373606A5;
        Mon, 20 Sep 2021 09:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632128407;
        bh=Q4/WHtF6XZKLPVnHPQFHZpDo6MP4Tu1TnOZW46rowWc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KuabqWxBZnb1af2G9QSWtwXcwmGIVTjRJeL/qr8rBzQ3fFmyNP27QizYAC8FThRxQ
         HGsbcjsV3ifG9JFxlFt7qeqq20oeNX/l9RGexuLJ/EfkHfNlZccUEV1GipeYl86vhJ
         lqqpuG6TDMrFDSpSi2K5Tzm6PfmNnFRy5zahW2SSZqf+eSeG/SrYtOQCpUQ1zzr56e
         jwzZN/zUGemZjml3JhnCT6CIQjl4EWVV5hTiLZHrDe7j8pgEOg9wHZ59mWY3xJ8S2g
         4QJBT2y3O3sJXquy/IIE7N72ujAuTD/pXPuXr2SHSZtj2Gv49qF0McgY63lB8Vn1ww
         7A/ekVfmOsn1g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 33E1160A53;
        Mon, 20 Sep 2021 09:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH v2 0/3] Improve support for qca8327 internal
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163212840720.23095.12575289730466674498.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Sep 2021 09:00:07 +0000
References: <20210919162817.26924-1-ansuelsmth@gmail.com>
In-Reply-To: <20210919162817.26924-1-ansuelsmth@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sun, 19 Sep 2021 18:28:14 +0200 you wrote:
> With more test with the qca8327 switch, it was discovered that the
> internal phy can have 2 different phy id based on the switch serial
> code. This patch address this and report the 2 different variant.
> Also adds support for resume/suspend as it was requested in another
> patch and improve the spacing and naming following how other phy are
> defined in the same driver.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/3] net: phy: at803x: add support for qca 8327 A variant internal phy
    https://git.kernel.org/netdev/net-next/c/b4df02b562f4
  - [net-next,v2,2/3] net: phy: at803x: add resume/suspend function to qca83xx phy
    https://git.kernel.org/netdev/net-next/c/15b9df4ece17
  - [net-next,v2,3/3] net: phy: at803x: fix spacing and improve name for 83xx phy
    https://git.kernel.org/netdev/net-next/c/d44fd8604a4a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


