Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26AF468B99A
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 11:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbjBFKMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 05:12:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbjBFKMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 05:12:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAD6F14223
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 02:11:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08B9C60DFD
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 10:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5A411C433A8;
        Mon,  6 Feb 2023 10:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675678221;
        bh=0oZehrUrwsBTlsHOFhbgiVT1FF0J8ligGNDBnDKxOFc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UzmdZopBcSJTI7C1SSjEnhRBWcQtbVvWdj+aubKu6K5ehwFALuFJvZjKgcCdgF72N
         Zm3KT4PffGpLfmsxwNsprE2xnBd5Sd4JhA57eC5tVI0I00HFKcdOjHK3iH9eSKsj0X
         0yy1SucLqpDhQLN7yPJ77z7rjAbXy3E85xvc/YmFdv/4UWmYu/gg5VAA5bz91BNo+i
         r/aCBXVueL6hvIfQlWOuZFPoOYqK86ArYpY/+JVoc10GylwWYHDDIJIuy6ZlQ/SEev
         PIWj+e3loNY2hsh5B9JLz32CXk1I8auZWXSyqBV5VLHIOWeq5spwverL2IIiEBgzkE
         hRp75EmriMN5Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3917AE55F08;
        Mon,  6 Feb 2023 10:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v6 net-next 00/13] ENETC mqprio/taprio cleanup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167567822122.32454.18057858947281179194.git-patchwork-notify@kernel.org>
Date:   Mon, 06 Feb 2023 10:10:21 +0000
References: <20230204135307.1036988-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230204135307.1036988-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, claudiu.manoil@nxp.com,
        vinicius.gomes@intel.com, kurt@linutronix.de,
        jacob.e.keller@intel.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        simon.horman@corigine.com, irusskikh@marvell.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        thomas.petazzoni@bootlin.com, saeedm@nvidia.com, leon@kernel.org,
        horatiu.vultur@microchip.com, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, daniel.machon@microchip.com,
        UNGLinuxDriver@microchip.com, gerhard@engleder-embedded.com,
        s-vadapalli@ti.com, rogerq@kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Sat,  4 Feb 2023 15:52:54 +0200 you wrote:
> v5->v6:
> - patches 01/17 - 04/17 from previous patch set were merged separately
> - small change to a comment in patch 05/13
> - bug fix to patch 07/13 where we introduced allow_overlapping_txqs but
>   we always set it to false, including for the txtime-assist mode that
>   it was intended for
> - add am65_cpsw to the list of drivers with gate mask per TXQ (10/13)
> v5 at:
> https://patchwork.kernel.org/project/netdevbpf/cover/20230202003621.2679603-1-vladimir.oltean@nxp.com/
> 
> [...]

Here is the summary with links:
  - [v6,net-next,01/13] net/sched: mqprio: refactor nlattr parsing to a separate function
    https://git.kernel.org/netdev/net-next/c/feb2cf3dcfb9
  - [v6,net-next,02/13] net/sched: mqprio: refactor offloading and unoffloading to dedicated functions
    https://git.kernel.org/netdev/net-next/c/5cfb45e2fb71
  - [v6,net-next,03/13] net/sched: move struct tc_mqprio_qopt_offload from pkt_cls.h to pkt_sched.h
    https://git.kernel.org/netdev/net-next/c/9adafe2b8546
  - [v6,net-next,04/13] net/sched: mqprio: allow reverse TC:TXQ mappings
    https://git.kernel.org/netdev/net-next/c/d7045f520a74
  - [v6,net-next,05/13] net/sched: mqprio: allow offloading drivers to request queue count validation
    https://git.kernel.org/netdev/net-next/c/19278d76915d
  - [v6,net-next,06/13] net/sched: mqprio: add extack messages for queue count validation
    https://git.kernel.org/netdev/net-next/c/d404959fa23a
  - [v6,net-next,07/13] net/sched: taprio: centralize mqprio qopt validation
    https://git.kernel.org/netdev/net-next/c/1dfe086dd7ef
  - [v6,net-next,08/13] net/sched: refactor mqprio qopt reconstruction to a library function
    https://git.kernel.org/netdev/net-next/c/9dd6ad674cc7
  - [v6,net-next,09/13] net/sched: taprio: pass mqprio queue configuration to ndo_setup_tc()
    https://git.kernel.org/netdev/net-next/c/09c794c0a88d
  - [v6,net-next,10/13] net/sched: taprio: only pass gate mask per TXQ for igc, stmmac, tsnep, am65_cpsw
    https://git.kernel.org/netdev/net-next/c/522d15ea831f
  - [v6,net-next,11/13] net: enetc: request mqprio to validate the queue counts
    https://git.kernel.org/netdev/net-next/c/735ef62c2f2c
  - [v6,net-next,12/13] net: enetc: act upon the requested mqprio queue configuration
    https://git.kernel.org/netdev/net-next/c/1a353111b6d4
  - [v6,net-next,13/13] net: enetc: act upon mqprio queue config in taprio offload
    https://git.kernel.org/netdev/net-next/c/06b1c9110ad1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


