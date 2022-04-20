Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B782E5085AE
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 12:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377579AbiDTKXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 06:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377576AbiDTKXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 06:23:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA5A514013
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 03:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A563B81E8D
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 10:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4BC44C385AB;
        Wed, 20 Apr 2022 10:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650450012;
        bh=bhTDgN1syetQcCHBqAiW+bmbNgcDc5afidyr9JpZPsU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=N/Rw/0/9fK2fG2bB9r+ZdDJ7JI+hIjJIri7JdkNAjL0QpGZAJE5nAxDICDWzv9KO7
         ae1t15NN0lexiTTUhIOgIjstOiNiI0SQezl9W19mcPRjXq5tmvZtC7huZ13K2rVkE2
         pC0SA9VgepcQfVBr8jmlnTUiW5WbC/1Yc49RQXldIQwConeXh1WEufkWW+FLouCgg4
         S0rRyjqh+68sfNkYOwOVXDQEx0CWRy34XNFClK0hBmHW8kY4rU/uxANXjEWaXfdHip
         pXeNQID8WAKUkGiZruO0Tj/0vMUQMiX0I6C/GGpZJET3kmyZCvydET0xwt264P3p0i
         p0XBYsZb0lg0A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 38653E7399D;
        Wed, 20 Apr 2022 10:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/5] net/sched: flower: match on the number of
 vlan tags
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165045001222.14273.12695834432509654330.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Apr 2022 10:20:12 +0000
References: <20220419081434.5192-1-boris.sukholitko@broadcom.com>
In-Reply-To: <20220419081434.5192-1-boris.sukholitko@broadcom.com>
To:     Boris Sukholitko <boris.sukholitko@broadcom.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        gustavoars@kernel.org, vladimir.oltean@nxp.com,
        edumazet@google.com, zhangkaiheb@126.com,
        komachi.yoshiki@gmail.com, pabeni@redhat.com,
        ilya.lifshits@broadcom.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 19 Apr 2022 11:14:29 +0300 you wrote:
> Hi,
> 
> Our customers in the fiber telecom world have network configurations
> where they would like to control their traffic according to the number
> of tags appearing in the packet.
> 
> For example, TR247 GPON conformance test suite specification mostly
> talks about untagged, single, double tagged packets and gives lax
> guidelines on the vlan protocol vs. number of vlan tags.
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/5] net/sched: flower: Helper function for vlan ethtype checks
    https://git.kernel.org/netdev/net-next/c/285ba06b0edb
  - [net-next,v4,2/5] net/sched: flower: Reduce identation after is_key_vlan refactoring
    https://git.kernel.org/netdev/net-next/c/6ee59e554d33
  - [net-next,v4,3/5] flow_dissector: Add number of vlan tags dissector
    https://git.kernel.org/netdev/net-next/c/34951fcf26c5
  - [net-next,v4,4/5] net/sched: flower: Add number of vlan tags filter
    https://git.kernel.org/netdev/net-next/c/b40003128226
  - [net-next,v4,5/5] net/sched: flower: Consider the number of tags for vlan filters
    https://git.kernel.org/netdev/net-next/c/99fdb22bc5e9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


