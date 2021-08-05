Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65CE13E11CA
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 12:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240106AbhHEKAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 06:00:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:59842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240021AbhHEKAT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 06:00:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9C1B361108;
        Thu,  5 Aug 2021 10:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628157605;
        bh=nhfHHaTG+BB6zlYyzCgWIha6OSgDvkxetAeXUhsmXqM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Q2q0ZEq8b39SiaZImETqZoMsxseKE5ES+lQC5KjVsWCfbdzC/YVBUJA3xffwnNnxJ
         ST2hJjHN/at6Ri4oUom1E037HK1qL3iMvl9ydtJ6e1OUmURUiX7YrhFtkYitJy+joP
         bKcm9CiYxG1Rn6Dhy67Tfnys/Rkno42nRlri3yijCYzHQ+rrwtc8QdYtBA38iZnu43
         8FWi0+BpD/4sMOKX6Lqz2r6AsyfGyDKYxAImHwykqKOgsQCNcndwfesPuxliNo52PH
         v6h14ROeL66EyfthpejFBE5A8g1TdyRBZwvt7bGvBlTFXF80BhkCrekOrIgcRC7Jni
         0DoIhv5q2h4og==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8DAD760A7C;
        Thu,  5 Aug 2021 10:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] mctp: remove duplicated assignment of pointer hdr
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162815760557.30466.3323577657561138862.git-patchwork-notify@kernel.org>
Date:   Thu, 05 Aug 2021 10:00:05 +0000
References: <20210804121530.110521-1-colin.king@canonical.com>
In-Reply-To: <20210804121530.110521-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     jk@codeconstruct.com.au, matt@codeconstruct.com.au,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed,  4 Aug 2021 13:15:30 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The pointer hdr is being initialized and also re-assigned with the
> same value from the call to function mctp_hdr. Static analysis reports
> that the initializated value is unused. The second assignment is
> duplicated and can be removed.
> 
> [...]

Here is the summary with links:
  - [next] mctp: remove duplicated assignment of pointer hdr
    https://git.kernel.org/netdev/net-next/c/df7ba0eb25ed

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


