Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2AF94E3889
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 06:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236711AbiCVFlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 01:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236692AbiCVFlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 01:41:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B1454FC64
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 22:40:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51FF96135E
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 05:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ACD0EC340F2;
        Tue, 22 Mar 2022 05:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647927610;
        bh=g1DxoEdEqEZNNW4JwwSnCdcT0QgNfeNZNijDchP0ozM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=p/ACr+6qwpwRWLL2d0W6jOgkZln753q9NjfvB5qpmno0da4sjTfKtEoUBvqWoEVSv
         1MIJXtE6lE1hicVEXOyh8nMl4K/1FI+Doj6dNXoXC7+0CB/ljju+WfUwyBTsWrs8ZB
         ogdkxIkNFG06w9JNpcm8t4g5+8Lv87vgFU6uU6h4DkQKuU25yOfihLmO53ZYicVcXh
         +FkhhUFpTGyfqAJk1peoj8S5sZwR0oOHI8wnUdyEkaJ+TjLomjq/QVf6eCFuhIV3f4
         UayDzaQATJp9Ie63y4Q/PQAfzXed8lisvBrzG1HwJFUPyzu/liUo9ws9j5y3M6L4Ny
         eB5HOO+wfk0UQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8A81BE6D406;
        Tue, 22 Mar 2022 05:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] openvswitch: always update flow key after nat
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164792761056.20534.2752037495326713572.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Mar 2022 05:40:10 +0000
References: <20220318124319.3056455-1-aconole@redhat.com>
In-Reply-To: <20220318124319.3056455-1-aconole@redhat.com>
To:     Aaron Conole <aconole@redhat.com>
Cc:     netdev@vger.kernel.org, dev@openvswitch.org, pshelar@ovn.org,
        i.maximets@ovn.org, dceara@redhat.com, nusiddiq@redhat.com,
        echaudro@redhat.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 18 Mar 2022 08:43:19 -0400 you wrote:
> During NAT, a tuple collision may occur.  When this happens, openvswitch
> will make a second pass through NAT which will perform additional packet
> modification.  This will update the skb data, but not the flow key that
> OVS uses.  This means that future flow lookups, and packet matches will
> have incorrect data.  This has been supported since
> 5d50aa83e2c8 ("openvswitch: support asymmetric conntrack").
> 
> [...]

Here is the summary with links:
  - [net,v2] openvswitch: always update flow key after nat
    https://git.kernel.org/netdev/net/c/60b44ca6bd75

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


