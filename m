Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB8F65A33F1
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 04:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236173AbiH0Cu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 22:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231895AbiH0CuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 22:50:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE59D3997
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 19:50:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F6E5B833B7
        for <netdev@vger.kernel.org>; Sat, 27 Aug 2022 02:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DD4B2C433D6;
        Sat, 27 Aug 2022 02:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661568615;
        bh=5dt9XRCeuF9vMxhvmsCg3uXzDCui/0/cKNtHYj12SLQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Fw6iK2dmnXKYmNoZuzBylKygbzii1+k0Jhzr7UEjoFFoEuFklOPlMfC5disvROiQF
         enbpmR3fgzUIOyglT6PwkkSEIhXYHj72Cy1vFsOfBUNejRVrv1l1yUZnPZhPd7eJ98
         rpAV/rIwWdnsClN7oYHO9wcXyhVOqAx6BtSKFSF4HTiXYw4+KnnibCk/QquDLKdK9N
         id46FAjooX/ky99leG18JJZGHP0pe+p97f2FlrMqtcCdEcN00upSuH+O5wWXSR+ux8
         5zfmKeQIdil04DPjLUo+ITbX1ePrNXgBZNzTG1wTOsmAWrph7js75j89ddLH5VMf66
         cTwQkgzShKK4Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C6E55C0C3EC;
        Sat, 27 Aug 2022 02:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/2] openvswitch: allow specifying ifindex of new
 interfaces
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166156861581.29832.23248456121709382.git-patchwork-notify@kernel.org>
Date:   Sat, 27 Aug 2022 02:50:15 +0000
References: <20220825020450.664147-1-andrey.zhadchenko@virtuozzo.com>
In-Reply-To: <20220825020450.664147-1-andrey.zhadchenko@virtuozzo.com>
To:     Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
Cc:     netdev@vger.kernel.org, dev@openvswitch.org, pshelar@ovn.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ptikhomirov@virtuozzo.com,
        alexander.mikhalitsyn@virtuozzo.com, avagin@google.com,
        brauner@kernel.org, i.maximets@ovn.org, aconole@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 25 Aug 2022 05:04:48 +0300 you wrote:
> Hi!
> 
> CRIU currently do not support checkpoint/restore of OVS configurations, but
> there was several requests for it. For example,
> https://github.com/lxc/lxc/issues/2909
> 
> The main problem is ifindexes of newly created interfaces. We realy need to
> preserve them after restore. Current openvswitch API does not allow to
> specify ifindex. Most of the time we can just create an interface via
> generic netlink requests and plug it into ovs but datapaths (generally any
> OVS_VPORT_TYPE_INTERNAL) can only be created via openvswitch requests which
> do not support selecting ifindex.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/2] openvswitch: allow specifying ifindex of new interfaces
    https://git.kernel.org/netdev/net-next/c/54c4ef34c4b6
  - [net-next,v3,2/2] openvswitch: add OVS_DP_ATTR_PER_CPU_PIDS to get requests
    https://git.kernel.org/netdev/net-next/c/347541e299d5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


