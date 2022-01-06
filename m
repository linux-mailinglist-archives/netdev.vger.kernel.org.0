Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 468C2486446
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 13:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238315AbiAFMUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 07:20:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237905AbiAFMUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 07:20:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CBCCC061245
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 04:20:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B91AB61B8E
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 12:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 206D9C36AE5;
        Thu,  6 Jan 2022 12:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641471611;
        bh=12OotoVsJaeI6f2cZK5P3rMC7BRm3oc20PdjjfBYHhE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AzcE9aiW0Uz9Mrdqv+pEwl4wSBWr/ovDqDqBhabakcqR8DAnl80it6b4ZipqY7wJR
         rIEfCoeRrBQTrwpprfB++PZWwg1DkV5rdmz+RIhkBtG/jzwVGNvRkXBZCO/pUFShj0
         cqe0Ao8zr/KYUQC9aE63EmXBtrqpyu7sT4bu95oL80zv8tnnGN4fUuWNlqc8Ey/h69
         5kf+Z/fudE3cHxNaBW4OJnrnEPnHbd99Tp5B9K2EOYPWJiGSvglQkx6GHxz/ihwxCY
         dkNp9kwS4v0Z82Ocw51l3Es76xaF9fF/L3Vkwgw17SIq+w8+az1g8HusTQO0ccUCNP
         3au+mg2C8O+sw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F38E2F7940C;
        Thu,  6 Jan 2022 12:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull request (net-next): ipsec-next 2022-01-06
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164147161099.27983.16789363428870680293.git-patchwork-notify@kernel.org>
Date:   Thu, 06 Jan 2022 12:20:10 +0000
References: <20220106091350.3038869-1-steffen.klassert@secunet.com>
In-Reply-To: <20220106091350.3038869-1-steffen.klassert@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     davem@davemloft.net, kuba@kernel.org, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 6 Jan 2022 10:13:43 +0100 you wrote:
> 1) Fix some clang_analyzer warnings about never read variables.
>    From luo penghao.
> 
> 2) Check for pols[0] only once in xfrm_expand_policies().
>    From Jean Sacren.
> 
> 3) The SA curlft.use_time was updated only on SA cration time.
>    Update whenever the SA is used. From Antony Antony
> 
> [...]

Here is the summary with links:
  - pull request (net-next): ipsec-next 2022-01-06
    https://git.kernel.org/netdev/net/c/c4251db3b9d2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


