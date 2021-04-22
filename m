Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4AF03687F5
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 22:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239583AbhDVUat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 16:30:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:34400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239509AbhDVUap (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 16:30:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5BEB561450;
        Thu, 22 Apr 2021 20:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619123410;
        bh=BdBk3Sx9WMV/A5l9vmCm/YYwjH5Rc1ca/ukGmZHjK1U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Kv81NI++JCJBBwzfbSLFBx0p2CUH9fC4S1ON9EQqBiteS4eByuvALP0AX0sM1dWyM
         fJ85jcQ2bJETaIdy1bpbi6QiC6YspXX2j0SQEB3632/aza4n8xCS7sInye5aHFV0Bi
         yONc+cXRn6PCsdCBPehD4DQAiOPjFTzHsY4e653nMFSXxqVjDkz9vGGXk2GR/yeMxP
         2zOFxUo5yPgOiuwZpWKIaEE6KGZjykuuxddRO7kkfPSVQn+on0Ui0WXBK2se7U7p2u
         +6uhhezTwz+pSKERF2r4yuVLqrffOAe9XUT0uZM9WW/j39UOODeEI3njX0fQ1TCAHE
         lUHqvQvYCeaRg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 56B8660A53;
        Thu, 22 Apr 2021 20:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: wwan: core: Return poll error in case of
 port removal
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161912341035.26269.1097808472059831001.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Apr 2021 20:30:10 +0000
References: <1619100361-1330-1-git-send-email-loic.poulain@linaro.org>
In-Reply-To: <1619100361-1330-1-git-send-email-loic.poulain@linaro.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     kuba@kernel.org, davem@davemloft.net, leon@kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 22 Apr 2021 16:06:01 +0200 you wrote:
> Ensure that the poll system call returns proper error flags when port
> is removed (nullified port ops), allowing user side to properly fail,
> without further read or write.
> 
> Fixes: 9a44c1cc6388 ("net: Add a WWAN subsystem")
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: wwan: core: Return poll error in case of port removal
    https://git.kernel.org/netdev/net-next/c/57e222475545

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


