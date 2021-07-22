Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B336B3D23D0
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 14:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbhGVMJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 08:09:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:33818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230418AbhGVMJ3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 08:09:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6DE8A6137D;
        Thu, 22 Jul 2021 12:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626958204;
        bh=AvAnfgKMbAk4r38gt31QaTzOXYtSEjrqgjjEm8zkC90=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pIvMbeUqf8ddP7bv3Id3MXZNGZo3PMF6TrcY9NT8kNsy2v3q7xc9Ili6qdImyUPQY
         jvD3UZRlldE5YQpRK3tLaxsLSn1RAeNZZkbacHNEVfiywuD5yiD5vVsQUDI1V7z6ZZ
         4/+rpbGNTnqJoqySI1LCQY5uL3jgxYvgFzu43aSqgde01CbM8pidHG5rNIYfDBzoEL
         NPHM+lIc0of5sZNjrsXhVkh/kpPueQqYOcfGN+H8U4kmmSVDgJa/0jyOsmnTQrdt1Y
         04OZiJSMaMK1YdWRdkNCZbxSkaagrVIVmiHlWVwlKyN1lC4T6YxazXrCm8k6uT0JCI
         4OV1If1dnUTmg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5E9E860C29;
        Thu, 22 Jul 2021 12:50:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] nfp: fix return statement in nfp_net_parse_meta()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162695820438.13905.1765103600393643547.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Jul 2021 12:50:04 +0000
References: <20210722112502.24472-1-simon.horman@corigine.com>
In-Reply-To: <20210722112502.24472-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com, niklas.soderlund@corigine.com,
        louis.peens@corigine.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 22 Jul 2021 13:25:02 +0200 you wrote:
> From: Niklas Söderlund <niklas.soderlund@corigine.com>
> 
> The return type of the function is bool and while NULL do evaluate to
> false it's not very nice, fix this by explicitly returning false. There
> is no functional change.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund@corigine.com>
> Signed-off-by: Louis Peens <louis.peens@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> 
> [...]

Here is the summary with links:
  - [net-next] nfp: fix return statement in nfp_net_parse_meta()
    https://git.kernel.org/netdev/net-next/c/4431531c482a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


