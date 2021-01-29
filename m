Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00C11308395
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 03:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbhA2CK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 21:10:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:56822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229786AbhA2CKw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 21:10:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8A0F764DE7;
        Fri, 29 Jan 2021 02:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611886211;
        bh=OvnSxpLjRlTEeYZ7Woli+x536UZ6By+qJ+YMimzU1fk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=COdSNrkNQJsZaFQPyjebtfBfaK9DRCcgP+zoFs8etmhQOgoYEx5DWPfoLeQaV4Fzy
         JPPVDnUU/yOaq9vkqmbcfdI7OtDk+zhLhX6pP/iBmF/Lj+3UTxrigYjvzClYm3OgyR
         /eIOs4zC5Peie2NPhPZLOLYszHJT29XguwUEnJvGsDog3Wa0dm2uZ/gFmyJzgamCFz
         ltsyg5myHx/JVrSw4bJxADuRFQo91KzpiQ9yefwr3e1KWn+tCN0dW4Id9zu1kk/E8f
         8GFXSqU/Ldb5TQewVWzncyN19YZqbgwgcJU3o14LzHwtMKwYI6vx1renTN2EA+iIKo
         8a63/9ohIXGnw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 760886530E;
        Fri, 29 Jan 2021 02:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/2] net: usb: qmi_wwan: new mux_id sysfs file
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161188621147.7700.12554853482960702205.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Jan 2021 02:10:11 +0000
References: <20210127153433.12237-1-dnlplm@gmail.com>
In-Reply-To: <20210127153433.12237-1-dnlplm@gmail.com>
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     bjorn@mork.no, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        aleksander@aleksander.es
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 27 Jan 2021 16:34:31 +0100 you wrote:
> Hello,
> 
> this patch series add a sysfs file to let userspace know which mux
> id has been used to create a qmimux network interface.
> 
> I'm aware that adding new sysfs files is not usually the right path,
> but my understanding is that this piece of information can't be
> retrieved in any other way and its absence restricts how
> userspace application (e.g. like libqmi) can take advantage of the
> qmimux implementation in qmi_wwan.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] net: usb: qmi_wwan: add qmap id sysfs file for qmimux interfaces
    https://git.kernel.org/netdev/net-next/c/e594ad980ec2
  - [net-next,v2,2/2] net: qmi_wwan: document qmap/mux_id sysfs file
    https://git.kernel.org/netdev/net-next/c/b4b91e24094a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


