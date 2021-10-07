Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E880842534D
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 14:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241451AbhJGMmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 08:42:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:36934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241308AbhJGMmB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 08:42:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D9DB26105A;
        Thu,  7 Oct 2021 12:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633610407;
        bh=9QYYTaK+kVd8SbmgunpDonwt4mshRzizoAr1N05fM8I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sjncDF1cMHXug46UquQ/F14VKy2an2UYca9SXfy/ojOQ4J5OOXekJ+zkhcftdDVhM
         dK17CPWjOY7FIDKQ4ior4FetVFII7KXsFx8nkBLBL6GqmCLfuDNB7dYo6CQyomCpuu
         AeZCLFD9j2bVvvCuAOaDTtkhHcXToJqPxx+kP2glorTPRdtcl97X+2DYVSFRIVb/GC
         NV2eXyWQWsY9rAS/HD+0VBvyFAcwy21Etga0iuZyDxU+QmuZ0wCfm3fk6IW+yfSjMg
         JihZfcrixzXgcjNCFbFDLN/Qt56akX1K04fZkJn/bkli6Q0XSXMUuEyDnueipwYCKM
         dKvrHJxMG4law==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CBEE960A23;
        Thu,  7 Oct 2021 12:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/2] nfc: pn533: Constify ops-structs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163361040783.21496.12115033090736934737.git-patchwork-notify@kernel.org>
Date:   Thu, 07 Oct 2021 12:40:07 +0000
References: <20211006224738.51354-1-rikard.falkeborn@gmail.com>
In-Reply-To: <20211006224738.51354-1-rikard.falkeborn@gmail.com>
To:     Rikard Falkeborn <rikard.falkeborn@gmail.com>
Cc:     krzysztof.kozlowski@canonical.com, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nfc@lists.01.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master)
by David S. Miller <davem@davemloft.net>:

On Thu,  7 Oct 2021 00:47:36 +0200 you wrote:
> Constify a couple of ops-structs. This allows the compiler to put the
> static structs in read-only memory.
> 
> Rikard Falkeborn (2):
>   nfc: pn533: Constify serdev_device_ops
>   nfc: pn533: Constify pn533_phy_ops
> 
> [...]

Here is the summary with links:
  - [1/2] nfc: pn533: Constify serdev_device_ops
    https://git.kernel.org/netdev/net-next/c/be5f60d8b6f9
  - [2/2] nfc: pn533: Constify pn533_phy_ops
    https://git.kernel.org/netdev/net-next/c/bc642817b6d9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


