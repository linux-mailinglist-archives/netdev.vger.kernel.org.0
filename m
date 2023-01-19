Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3032C674027
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 18:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbjASRkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 12:40:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbjASRkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 12:40:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D03A48EFFA;
        Thu, 19 Jan 2023 09:40:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C3AE61D03;
        Thu, 19 Jan 2023 17:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BF09FC433EF;
        Thu, 19 Jan 2023 17:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674150016;
        bh=RDy0BCu6KO5KA76KYd1NYpvtCLPTq7pk1ZJwS/KxH0o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kwN0JjYgNgvrjUFB6dgUC8WqoZr1auuCSR7qlf5qheaiYqaKtZMIQboJknqh+cK3S
         2/sU+0Ta3PQt5GhPTlToYc/zKVnMeqrRQmQOqSO5UgzR377Mcs2DcYtVRzFtVvPd3/
         xjV94N4pygOz1fJ91EuuYCxlJG7wtoepsbD4QSgtSQ5mKd43jrZoogsCIqB5U0zGbL
         j8xE28l+8PlqnLwdC9+h8yP40pcQAZloqUtHkfboU1XNoYFR0cekP7/Emzgi4fYXl2
         AnZj5NJBv2ML/jeC96p+gW25n/mI78PcptfL/ZISsnwP0vPVFrWitJqCBga7BUo9GK
         qR91tz6yqPmew==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9E89DC39564;
        Thu, 19 Jan 2023 17:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] net: dsa: microchip: ksz9477: port map correction in
 ALU table entry register
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167415001664.6484.3707763521396064033.git-patchwork-notify@kernel.org>
Date:   Thu, 19 Jan 2023 17:40:16 +0000
References: <20230118174735.702377-1-rakesh.sankaranarayanan@microchip.com>
In-Reply-To: <20230118174735.702377-1-rakesh.sankaranarayanan@microchip.com>
To:     Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 18 Jan 2023 23:17:35 +0530 you wrote:
> ALU table entry 2 register in KSZ9477 have bit positions reserved for
> forwarding port map. This field is referred in ksz9477_fdb_del() for
> clearing forward port map and alu table.
> 
> But current fdb_del refer ALU table entry 3 register for accessing forward
> port map. Update ksz9477_fdb_del() to get forward port map from correct
> alu table entry register.
> 
> [...]

Here is the summary with links:
  - [v2,net] net: dsa: microchip: ksz9477: port map correction in ALU table entry register
    https://git.kernel.org/netdev/net/c/6c977c5c2e4c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


