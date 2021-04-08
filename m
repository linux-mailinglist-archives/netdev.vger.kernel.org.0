Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10A43358EE3
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 23:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232541AbhDHVAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 17:00:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232431AbhDHVAV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 17:00:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8FDC161182;
        Thu,  8 Apr 2021 21:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617915609;
        bh=PuCS4J8rXsqANn5db5V71zMk0qvEBPtyIiYJ1Exqwuw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=g49wspv8yethubgbCOYKTdXmc7zjTY6eVHSX6q3cUWtf9NO7q5kS7mD/dSxc5Yqar
         oc70HSy3YSyCDEI9ln845bemh8Uye0J8JjfZjjannJ66tGmqbG6P0GRgWz2hdejCUg
         lLoU86HXB86W/JdTK41IS5Z0etRQJMAngdIBqWuDmtgInFlsJs7fuKUesYKYzXSgLN
         bdDLweZol5k+TJItkyIDMQbuQ0Wdt5Mx3Nlvd+gcaABjY4aCb1iOkqgkmg92BSm1cz
         XbLhXc4gSghm+a6OJ8yS6RA8Ggir/OOYN/5L3j/adGOIUOKexe+fVGcsEJabOSX95t
         PODpnWun0QiSA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8366C60A2A;
        Thu,  8 Apr 2021 21:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] Additional tests for action API
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161791560953.3868.15124831862666525546.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Apr 2021 21:00:09 +0000
References: <20210407154643.1690050-1-vladbu@nvidia.com>
In-Reply-To: <20210407154643.1690050-1-vladbu@nvidia.com>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     netdev@vger.kernel.org, memxor@gmail.com, xiyou.wangcong@gmail.com,
        davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, toke@redhat.com, marcelo.leitner@gmail.com,
        dcaratti@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 7 Apr 2021 18:46:41 +0300 you wrote:
> Add two new tests for action create/change code.
> 
> Vlad Buslov (2):
>   tc-testing: add simple action test to verify batch add cleanup
>   tc-testing: add simple action test to verify batch change cleanup
> 
>  .../tc-testing/tc-tests/actions/simple.json   | 59 +++++++++++++++++++
>  1 file changed, 59 insertions(+)

Here is the summary with links:
  - [net-next,1/2] tc-testing: add simple action test to verify batch add cleanup
    https://git.kernel.org/netdev/net-next/c/79749ae19de6
  - [net-next,2/2] tc-testing: add simple action test to verify batch change cleanup
    https://git.kernel.org/netdev/net-next/c/652e3124c3ee

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


