Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A23043A03D4
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 21:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237044AbhFHTWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 15:22:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:39614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238808AbhFHTUI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 15:20:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 004DE610A1;
        Tue,  8 Jun 2021 19:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623179406;
        bh=KfRXZ8aquxRN75qIbjZceZN5bOQiPylZvMBgdyfO4O0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OTcLhGLmZwcR6ZWhSNqEQIVvg42wWjFSgcOlOoJ6Z3HGT6umoa9OwWUglotYkj8+s
         chthAtvY+GfWeKWkLqcT1Sjop8t+fZh0rd9ftYUqKliAtV0JHX7J1WNs9FW+gRRusU
         /AT5KGbuHS5xJjuQAwlTTCZWLjUKoS+vEwZ6ZbwCy4Kiwd3rM3fmkDE3iwb56h2dJd
         5hyQ/NiZLgYl1kkFJhIe17t6kiqdLQuoSVWHv+SDRdMaT1bgPTFAOkReEnef/+RgME
         rQ8CbanUtFB4wfjc8IThIVCW6NByVQQRAryjNK/P9w0Vl4hwjCrYBhb+7TZumaFI9f
         VzIjTRrhiwk8w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E231A60A22;
        Tue,  8 Jun 2021 19:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/16] net: farsync: clean up some code style issues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162317940592.2276.12187264761710444622.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Jun 2021 19:10:05 +0000
References: <1623139962-34847-1-git-send-email-huangguangbin2@huawei.com>
In-Reply-To: <1623139962-34847-1-git-send-email-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, xie.he.0141@gmail.com,
        ms@dev.tdt.de, willemb@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 8 Jun 2021 16:12:26 +0800 you wrote:
> From: Peng Li <lipeng321@huawei.com>
> 
> This patchset clean up some code style issues.
> 
> Peng Li (16):
>   net: farsync: remove redundant blank lines
>   net: farsync: add blank line after declarations
>   net: farsync: fix the code style issue about "foo* bar"
>   net: farsync: move out assignment in if condition
>   net: farsync: remove redundant initialization for statics
>   net: farsync: fix the comments style issue
>   net: farsync: remove trailing whitespaces
>   net: farsync: code indent use tabs where possible
>   net: farsync: fix the code style issue about macros
>   net: farsync: add some required spaces
>   net: farsync: remove redundant braces {}
>   net: farsync: remove redundant spaces
>   net: farsync: remove unnecessary parentheses
>   net: farsync: fix the alignment issue
>   net: farsync: remove redundant return
>   net: farsync: replace comparison to NULL with "fst_card_array[i]"
> 
> [...]

Here is the summary with links:
  - [net-next,01/16] net: farsync: remove redundant blank lines
    https://git.kernel.org/netdev/net-next/c/34de4c85f393
  - [net-next,02/16] net: farsync: add blank line after declarations
    https://git.kernel.org/netdev/net-next/c/50d4c363366a
  - [net-next,03/16] net: farsync: fix the code style issue about "foo* bar"
    https://git.kernel.org/netdev/net-next/c/8ea4bfb30abc
  - [net-next,04/16] net: farsync: move out assignment in if condition
    https://git.kernel.org/netdev/net-next/c/40996bcfe965
  - [net-next,05/16] net: farsync: remove redundant initialization for statics
    https://git.kernel.org/netdev/net-next/c/8ccac4a58aa8
  - [net-next,06/16] net: farsync: fix the comments style issue
    https://git.kernel.org/netdev/net-next/c/14b9764ccfeb
  - [net-next,07/16] net: farsync: remove trailing whitespaces
    https://git.kernel.org/netdev/net-next/c/d70711da30f0
  - [net-next,08/16] net: farsync: code indent use tabs where possible
    https://git.kernel.org/netdev/net-next/c/3a950181f6f5
  - [net-next,09/16] net: farsync: fix the code style issue about macros
    https://git.kernel.org/netdev/net-next/c/7619ab161892
  - [net-next,10/16] net: farsync: add some required spaces
    https://git.kernel.org/netdev/net-next/c/37947a9be3d1
  - [net-next,11/16] net: farsync: remove redundant braces {}
    https://git.kernel.org/netdev/net-next/c/fa8d10b54760
  - [net-next,12/16] net: farsync: remove redundant spaces
    https://git.kernel.org/netdev/net-next/c/b64b5aee7358
  - [net-next,13/16] net: farsync: remove redundant parentheses
    https://git.kernel.org/netdev/net-next/c/ae1be3fad569
  - [net-next,14/16] net: farsync: fix the alignment issue
    https://git.kernel.org/netdev/net-next/c/d2a1054b8b02
  - [net-next,15/16] net: farsync: remove redundant return
    https://git.kernel.org/netdev/net-next/c/f01f906ffefc
  - [net-next,16/16] net: farsync: replace comparison to NULL with "fst_card_array[i]"
    https://git.kernel.org/netdev/net-next/c/f23a3da78a31

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


