Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 890CB4DBCFF
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 03:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231821AbiCQCbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 22:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352892AbiCQCb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 22:31:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC64F1FA50
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 19:30:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64BBBB81A71
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 02:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 23FEEC340EC;
        Thu, 17 Mar 2022 02:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647484211;
        bh=kRZmaRQo4Qo7q50nmZvErqNXMeGDbND10jbshDCmUOY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bkd3TwKEI3WBZIrTnNgShYYx9J6Or4wb8cS2joMG6/ThD/StMhIkOdBvfsLieN659
         BPL2/vwg8G3fVSj+qIABPkkIbZb2yYlevI9y/vuib3cy07vOw71oj/rRq3RO36PjqS
         AAGHilLb4r5UhTDd5NrEtuwb3/mxdLWg4bFOUISCNHlZMtR1AjmT/AApYPS0aqF+wK
         vzH9hdCTa/Poguh82DWlGAGNVTZ5MiK7buaGxTHkbAwY+XiMgyPBCDEcKwaFUPWHLs
         gqPM77HN4pTGZ6h4GvPR38GJZa7DkFeMD+IWp2oOvQoxOUXzIVkzTJDVBn+wjbz2cg
         GirvL4U5Ou5rg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0BC0FE8DD5B;
        Thu, 17 Mar 2022 02:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] bareudp: use ipv6_mod_enabled to check if IPv6 enabled
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164748421104.27087.14378649894398681843.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Mar 2022 02:30:11 +0000
References: <20220315062618.156230-1-liuhangbin@gmail.com>
In-Reply-To: <20220315062618.156230-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, gnault@redhat.com, davem@davemloft.net,
        martin.varghese@nokia.com, jishi@redhat.com
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 15 Mar 2022 14:26:18 +0800 you wrote:
> bareudp_create_sock() use AF_INET6 by default if IPv6 CONFIG enabled.
> But if user start kernel with ipv6.disable=1, the bareudp sock will
> created failed, which cause the interface open failed even with ethertype
> ip. e.g.
> 
>  # ip link add bareudp1 type bareudp dstport 2 ethertype ip
>  # ip link set bareudp1 up
>  RTNETLINK answers: Address family not supported by protocol
> 
> [...]

Here is the summary with links:
  - [net] bareudp: use ipv6_mod_enabled to check if IPv6 enabled
    https://git.kernel.org/netdev/net-next/c/e077ed58c243

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


