Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07203396CB6
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 07:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232516AbhFAFWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 01:22:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:35798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232732AbhFAFWM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 01:22:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 081AD6136E;
        Tue,  1 Jun 2021 05:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622524805;
        bh=iVUNTREHe5pmoduLTm8TwUY5m0X11N1UAhTg9STXuwg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eukooJg1MnjDR2TZNrtL9zQAy3zOqWUVALpRoDq1MuNdBuNyqI3FlNQD2A/AqQ+is
         dbIpGF2h11CQSn7AsBEeo+Tj/oIiKcDXUvxLjd9HwMYdG8vsLxz0mv/Rt48blYsB02
         //vbBRulo/sXMLoRbKr0s5HCYUtrtX5v11pBpKdkyLiN1NCji4wACd1pmDBhxxFfr+
         5kzXsmYTJtJYz44hErmerubjVFszPwx1HPN+L4Uv/Xk8BSmpED862FZ12sA0X5724Z
         GD83JBxciNZAMmucEO1zztfm3JdngXap96bpk7aIhC0fFw4CL0YfSetzm3DEKgw0ME
         cQfOHVatNvZ9Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EEC3960BCF;
        Tue,  1 Jun 2021 05:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/10] net: sealevel: clean up some code style issues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162252480497.23898.11185065116991612070.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Jun 2021 05:20:04 +0000
References: <1622355874-18933-1-git-send-email-huangguangbin2@huawei.com>
In-Reply-To: <1622355874-18933-1-git-send-email-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, xie.he.0141@gmail.com,
        ms@dev.tdt.de, willemb@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com,
        tanhuazhong@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sun, 30 May 2021 14:24:24 +0800 you wrote:
> This patchset clean up some code style issues.
> 
> Peng Li (10):
>   net: sealevel: remove redundant blank lines
>   net: sealevel: add blank line after declarations
>   net: sealevel: fix the code style issue about "foo* bar"
>   net: sealevel: open brace '{' following struct go on the same line
>   net: sealevel: add some required spaces
>   net: sealevel: remove redundant initialization for statics
>   net: sealevel: fix a code style issue about switch and case
>   net: sealevel: remove meaningless comments
>   net: sealevel: fix the comments style issue
>   net: sealevel: fix the alignment issue
> 
> [...]

Here is the summary with links:
  - [net-next,01/10] net: sealevel: remove redundant blank lines
    https://git.kernel.org/netdev/net-next/c/801f0a1cf96f
  - [net-next,02/10] net: sealevel: add blank line after declarations
    https://git.kernel.org/netdev/net-next/c/58f30eea85a3
  - [net-next,03/10] net: sealevel: fix the code style issue about "foo* bar"
    https://git.kernel.org/netdev/net-next/c/8be88e3ccee4
  - [net-next,04/10] net: sealevel: open brace '{' following struct go on the same line
    https://git.kernel.org/netdev/net-next/c/f090d1c38107
  - [net-next,05/10] net: sealevel: add some required spaces
    https://git.kernel.org/netdev/net-next/c/52499d202dc6
  - [net-next,06/10] net: sealevel: remove redundant initialization for statics
    https://git.kernel.org/netdev/net-next/c/40e8ee9d467d
  - [net-next,07/10] net: sealevel: fix a code style issue about switch and case
    https://git.kernel.org/netdev/net-next/c/cc51e3f36e62
  - [net-next,08/10] net: sealevel: remove meaningless comments
    https://git.kernel.org/netdev/net-next/c/04d7ad8cca9c
  - [net-next,09/10] net: sealevel: fix the comments style issue
    https://git.kernel.org/netdev/net-next/c/b086ebfce34f
  - [net-next,10/10] net: sealevel: fix the alignment issue
    https://git.kernel.org/netdev/net-next/c/e24b60851936

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


