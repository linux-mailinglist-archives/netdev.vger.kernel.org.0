Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6765C61437F
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 04:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbiKADK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 23:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiKADKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 23:10:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5590F13F29
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 20:10:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD02AB81B81
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 03:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 732C7C43142;
        Tue,  1 Nov 2022 03:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667272218;
        bh=+A5Vpsclv2/wc+EubDwA4y2rkXrgoeprFW7xy1olkHY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=smzeURzUZ5X/x/PkAi936QIZ6pE6+qEsSYfYa0RmZSw0yrFiCKWo5n6kGC5OKdPEw
         Tq3fZls/ZsQvdIN7c5/be/ntuMyazVGj7xqiZWh9NMlQcS51Nby3Qr71u3V4uIy7jq
         yvNivJNMCzMkd2/Qwb/wmEUG1UVceRNRsK2HUnGmK8I5eH+qkUulQAu1sg3e5voAns
         erPVHqm5qBJ06FWQQD76X0RrHbN3/7ldiP/Wivkd/qJo3JeVkchxU7GZ1DlojXp0JI
         gIdXSgLYkkjT1cR+9zsYiujP8OroER2XUV/IJWnd7/aLuFK5aH94kCAb/Sofs2xuIw
         juKjvGV0NV2mQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5C078C41621;
        Tue,  1 Nov 2022 03:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv7 net-next 0/4] rtnetlink: Honour NLM_F_ECHO flag in
 rtnl_{new, del}link
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166727221837.414.15349239814238519138.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Nov 2022 03:10:18 +0000
References: <20221028084224.3509611-1-liuhangbin@gmail.com>
In-Reply-To: <20221028084224.3509611-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, idosch@nvidia.com,
        petrm@nvidia.com, florent.fourcot@wifirst.fr, razor@blackwall.org,
        nicolas.dichtel@6wind.com, gnault@redhat.com, dsahern@kernel.org
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 28 Oct 2022 04:42:20 -0400 you wrote:
> Netlink messages are used for communicating between user and kernel space.
> When user space configures the kernel with netlink messages, it can set the
> NLM_F_ECHO flag to request the kernel to send the applied configuration back
> to the caller. This allows user space to retrieve configuration information
> that are filled by the kernel (either because these parameters can only be
> set by the kernel or because user space let the kernel choose a default
> value).
> 
> [...]

Here is the summary with links:
  - [PATCHv7,net-next,1/4] rtnetlink: pass netlink message header and portid to rtnl_configure_link()
    https://git.kernel.org/netdev/net-next/c/1d997f101307
  - [PATCHv7,net-next,2/4] net: add new helper unregister_netdevice_many_notify
    https://git.kernel.org/netdev/net-next/c/77f4aa9a2a17
  - [PATCHv7,net-next,3/4] rtnetlink: Honour NLM_F_ECHO flag in rtnl_newlink_create
    https://git.kernel.org/netdev/net-next/c/d88e136cab37
  - [PATCHv7,net-next,4/4] rtnetlink: Honour NLM_F_ECHO flag in rtnl_delete_link
    https://git.kernel.org/netdev/net-next/c/f3a63cce1b4f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


