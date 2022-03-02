Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 201454CACBD
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 19:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244342AbiCBSA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 13:00:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244302AbiCBSA5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 13:00:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3377FCA719
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 10:00:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA695B82163
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 18:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6F0CAC340ED;
        Wed,  2 Mar 2022 18:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646244011;
        bh=nlTfFIX365KxEFPg/9+Sopm5VEjNkxX/VNmOgwNLLeM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sqwlRFyFHsRO46bHFR48o1vCjQC7ts/LKKh9Df8zDu75ErBsypw1N3ha/87Ywylqi
         TMFKTGrr3IFd2V7kcL8t6ZKFxxRVaqmgvne5tOBJJquHwO7mxC4hDpx9ytSfOPYPAb
         NoouQu37WTP+uML6Vy31sqLkYJN8DOWdgJY/ojT89Gvy1jhXY/9X6wfuRKEGB225vr
         ifdI1LGyL5SLviZwqw627jyWeq+520rbsCWfeyCS4VkjB/cbsBayGNJyNArHMZxtJz
         V+ltUZaJUco/UnGhZQYqhuP5lI0iPIpK6mRwTjv0Z54b0uVisRaoeRhKUza3aG4rSG
         0z8MBOJrDY1Tw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4E1ADEAC09D;
        Wed,  2 Mar 2022 18:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] if_ether.h: add industrial fieldbus Ethertypes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164624401131.29389.1572513036155738128.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Mar 2022 18:00:11 +0000
References: <20220228133029.100913-1-daniel@braunwarth.dev>
In-Reply-To: <20220228133029.100913-1-daniel@braunwarth.dev>
To:     Daniel Braunwarth <daniel@braunwarth.dev>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 28 Feb 2022 14:30:27 +0100 you wrote:
> This set of patches adds the Ethertypes for PROFINET and EtherCAT.
> 
> The defines should be used by iproute2 to extend the list of available link
> layer protocols.
> 
> Daniel Braunwarth (2):
>   if_ether.h: add PROFINET Ethertype
>   if_ether.h: add EtherCAT Ethertype
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] if_ether.h: add PROFINET Ethertype
    https://git.kernel.org/netdev/net-next/c/dd0ca255f3d2
  - [net-next,2/2] if_ether.h: add EtherCAT Ethertype
    https://git.kernel.org/netdev/net-next/c/cd73cda742fb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


