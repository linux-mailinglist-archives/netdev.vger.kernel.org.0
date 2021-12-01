Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59D554650AC
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 16:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243580AbhLAPDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 10:03:38 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57326 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234427AbhLAPDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 10:03:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A882B81FE6
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 15:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4EDA0C53FCF;
        Wed,  1 Dec 2021 15:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638370812;
        bh=Oq+F1LUn2R8fSmR/zCpVuG6Bc8KJZFMlzEIGmNOFq9E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aq0ipk0JQ50K2iZNrl9kWefF3hOXJXCCRHB3Zj8vlA5BjnRF9eCGY1FYYFFYr78Y3
         3CJTDB1WiK8LvJbr8rX/qRE0zvnNCED+UYrsvsMejrsbCud9upkGRHGVqI91yaWVEb
         LEKecdlzU4FL2WM8Nn7P+ep3aID/xzl+YPFE0lUGUYVrmIZJrcB/6W7xeleCx3PFb+
         oct/LMpiLOPzZonBP1o1TvglrwLaHKOfSLT4FEAZL0S0uajFb937XnroJY/4CQ36yG
         tRoyaEaEtMtWLzn5hdNjC4a+H/IuYzXEczMILU8VXVIeAh5rpTXg/oyPoW/kDaEvc/
         iF+TSjd2k9Ktw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 37EAC60A59;
        Wed,  1 Dec 2021 15:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/6] mv88e6xxx fixes (mainly 88E6393X family)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163837081222.15182.6326131384377421175.git-patchwork-notify@kernel.org>
Date:   Wed, 01 Dec 2021 15:00:12 +0000
References: <20211130170151.7741-1-kabel@kernel.org>
In-Reply-To: <20211130170151.7741-1-kabel@kernel.org>
To:     =?utf-8?q?Marek_Beh=C3=BAn_=3Ckabel=40kernel=2Eorg=3E?=@ci.codeaurora.org
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, rmk+kernel@armlinux.org.uk,
        kuba@kernel.org, davem@davemloft.net, olteanv@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 30 Nov 2021 18:01:45 +0100 you wrote:
> Hello,
> 
> sending v2 of these fixes.
> 
> Original cover letter:
> 
> So I managed to discovered how to fix inband AN for 2500base-x mode on
> 88E6393x (Amethyst) family.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/6] net: dsa: mv88e6xxx: Fix application of erratum 4.8 for 88E6393X
    https://git.kernel.org/netdev/net/c/21635d9203e1
  - [net,v2,2/6] net: dsa: mv88e6xxx: Drop unnecessary check in mv88e6393x_serdes_erratum_4_6()
    https://git.kernel.org/netdev/net/c/8c3318b4874e
  - [net,v2,3/6] net: dsa: mv88e6xxx: Save power by disabling SerDes trasmitter and receiver
    https://git.kernel.org/netdev/net/c/7527d66260ac
  - [net,v2,4/6] net: dsa: mv88e6xxx: Add fix for erratum 5.2 of 88E6393X family
    https://git.kernel.org/netdev/net/c/93fd8207bed8
  - [net,v2,5/6] net: dsa: mv88e6xxx: Fix inband AN for 2500base-x on 88E6393X family
    https://git.kernel.org/netdev/net/c/163000dbc772
  - [net,v2,6/6] net: dsa: mv88e6xxx: Link in pcs_get_state() if AN is bypassed
    https://git.kernel.org/netdev/net/c/ede359d8843a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


