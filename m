Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12136481C78
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 14:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239538AbhL3NaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 08:30:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52830 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239514AbhL3NaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 08:30:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0C43B81C52;
        Thu, 30 Dec 2021 13:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 93BB0C36AEC;
        Thu, 30 Dec 2021 13:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640871009;
        bh=MBCCPISAwIuV2IgcqTzqAI4VZBsEfHTUkt9lOE8w5bY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Jh5Fm5fBuiNsCUUbPIVU8+MFNtaiNCgRosGM6ZBfNdc4SmgjBs6Te8NE4cBNdP3c3
         s+TTB/GSse9BkV2JH6Bvq0vAWYdHeXdZgzInJoPICMnesRuQjC50qk2vufii6w9dEu
         drc0w05aNPWjlFmumGBpd6P7tD6ki9EGZOYsH3CMzVjdjqzW8UPsPZKuzWlgjPoRzm
         +KMFw7NE8vk+S8yREhndtiLHvIxwAClfNRApxqd+G8uhe5lgVItYUArVcXHj3hF7gr
         UfvouAK0ZSnuZBGARtEtROTDQkqr+6D54IECPu5xLWRhqI8fZMRI3ucsAUVHptjaTZ
         Mc7LDLWn2+Uhg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7C474C395E4;
        Thu, 30 Dec 2021 13:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] Documentation: fix outdated interpretation of
 ip_no_pmtu_disc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164087100950.9335.18212536955460808575.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Dec 2021 13:30:09 +0000
References: <20211230032856.584972-1-xu.xin16@zte.com.cn>
In-Reply-To: <20211230032856.584972-1-xu.xin16@zte.com.cn>
To:     CGEL <cgel.zte@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, corbet@lwn.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, xu.xin16@zte.com.cn, zealci@zte.com.cn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 30 Dec 2021 03:28:56 +0000 you wrote:
> From: xu xin <xu.xin16@zte.com.cn>
> 
> The updating way of pmtu has changed, but documentation is still in the
> old way. So this patch updates the interpretation of ip_no_pmtu_disc and
> min_pmtu.
> 
> See commit 28d35bcdd3925 ("net: ipv4: don't let PMTU updates increase
> route MTU")
> 
> [...]

Here is the summary with links:
  - [v2] Documentation: fix outdated interpretation of ip_no_pmtu_disc
    https://git.kernel.org/netdev/net/c/be1c5b53227b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


