Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4B82620F4C
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 12:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233576AbiKHLkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 06:40:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233103AbiKHLkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 06:40:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF6ED390
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 03:40:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7880761519
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 11:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C0FEFC433D7;
        Tue,  8 Nov 2022 11:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667907615;
        bh=76uXIZQHab1ZSHeahLzNp8mSFFNHLlQqN3QbDYsb8FA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=APS0Ac2/s1jsjAlGmSIcX1/sFLdg1oJLG7erB50zYSUpLGo5oqvu8xjeWz9l436+7
         CnwFAb8iSO4/62vAG5BcEDVHw0yJgRoUjvuuhcQ/5AGByhI2nQRC94S8P/z6wTZi3O
         vTChiACPLXFMlDgu9eZppVKKvVyX1/jyaQdsafE7dNhPitj9f4nFj2uV7MKhXoblwK
         yUViqD27T659NfeP/DjynTEKwICIzpq/FXGxMHtjQ1f8QbMNVopFc8vtg5DlFMbBn3
         J24sBb/yiYjYsNgHwvwK8BBRWOjVpOpxAASopnBC21HWtUSS4iwYXyDfFGtI/LmqH5
         pGij1g2/dSN6A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9F95FC4166D;
        Tue,  8 Nov 2022 11:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv4 net-next 0/4] net: add helper support in tc act_ct for ovs
 offloading
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166790761564.31853.8147147674470922681.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Nov 2022 11:40:15 +0000
References: <cover.1667766782.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1667766782.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        ovs-dev@openvswitch.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pshelar@ovn.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        pablo@netfilter.org, fw@strlen.de, marcelo.leitner@gmail.com,
        dcaratti@redhat.com, ozsh@nvidia.com, paulb@nvidia.com,
        i.maximets@ovn.org, echaudro@redhat.com, aconole@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Sun,  6 Nov 2022 15:34:13 -0500 you wrote:
> Ilya reported an issue that FTP traffic would be broken when the OVS flow
> with ct(commit,alg=ftp) installed in the OVS kernel module, and it was
> caused by that TC didn't support the ftp helper offloaded from OVS.
> 
> This patchset is to add the helper support in act_ct for OVS offloading
> in kernel net/sched.
> 
> [...]

Here is the summary with links:
  - [PATCHv4,net-next,1/4] net: move the ct helper function to nf_conntrack_helper for ovs and tc
    https://git.kernel.org/netdev/net-next/c/ca71277f36e0
  - [PATCHv4,net-next,2/4] net: move add ct helper function to nf_conntrack_helper for ovs and tc
    https://git.kernel.org/netdev/net-next/c/f96cba2eb923
  - [PATCHv4,net-next,3/4] net: sched: call tcf_ct_params_free to free params in tcf_ct_init
    https://git.kernel.org/netdev/net-next/c/1913894100ca
  - [PATCHv4,net-next,4/4] net: sched: add helper support in act_ct
    https://git.kernel.org/netdev/net-next/c/a21b06e73191

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


