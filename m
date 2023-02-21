Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4B5969E5CC
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 18:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234996AbjBURUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 12:20:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234991AbjBURUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 12:20:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1886229424;
        Tue, 21 Feb 2023 09:20:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9EDFB8101B;
        Tue, 21 Feb 2023 17:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 739B9C433A0;
        Tue, 21 Feb 2023 17:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677000018;
        bh=BGwB3PgVPJkWobVgXlphApLFPUCac4tlUtWhL3DXGN8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nucwBI0u2dYSlHqc8voK4JM5nYqZ3jtd/hhCWeWYknF//hi3RNB//KkMhbESkMguK
         9C6fLfvnc+ng/cnHIljiQM2wzfzMkWg1HxD9IHV5e0pYYKP63+/4TvRLpxKEPUc6FL
         EJNRtsdt8tLAFF531VaTADH/yq+WeJbsngyXRVCY28MeckpW3ZSx9cN4YRz1qx4SAx
         LpoMPhjXt5UjBKr/G+5k+dxg9AMXO7aed0aHZPCN0IW5bMDWJBbNWDvKLfVnUHJ3JQ
         cu+fnxb7mKl4MJh3aBxAlRQV+0wVHsLP0lzIMAAZZr6EZbAj2kg73WO85IkZQLVz6S
         Lfj9Pj5cz0A1Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 57465C43159;
        Tue, 21 Feb 2023 17:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net-next 00/13] Add tc-mqprio and tc-taprio support for
 preemptible traffic classes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167700001835.28414.2332953868494324085.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Feb 2023 17:20:18 +0000
References: <20230220122343.1156614-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230220122343.1156614-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        vinicius.gomes@intel.com, kurt@linutronix.de,
        gerhard@engleder-embedded.com, amritha.nambiar@intel.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, andrew@lunn.ch, f.fainelli@gmail.com,
        ferenc.fejes@ericsson.com, xiaoliang.yang_1@nxp.com,
        rogerq@kernel.org, pranavi.somisetty@amd.com,
        harini.katakam@amd.com, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, michael.wei.hong.sit@intel.com,
        mohammad.athari.ismail@intel.com, jacob.e.keller@intel.com,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 20 Feb 2023 14:23:30 +0200 you wrote:
> The last RFC in August 2022 contained a proposal for the UAPI of both
> TSN standards which together form Frame Preemption (802.1Q and 802.3):
> https://lore.kernel.org/netdev/20220816222920.1952936-1-vladimir.oltean@nxp.com/
> 
> It wasn't clear at the time whether the 802.1Q portion of Frame Preemption
> should be exposed via the tc qdisc (mqprio, taprio) or via some other
> layer (perhaps also ethtool like the 802.3 portion, or dcbnl), even
> though the options were discussed extensively, with pros and cons:
> https://lore.kernel.org/netdev/20220816222920.1952936-3-vladimir.oltean@nxp.com/
> 
> [...]

Here is the summary with links:
  - [v3,net-next,01/13] net: ethtool: fix __ethtool_dev_mm_supported() implementation
    https://git.kernel.org/netdev/net-next/c/a00da30c052f
  - [v3,net-next,02/13] net: ethtool: create and export ethtool_dev_mm_supported()
    (no matching commit)
  - [v3,net-next,03/13] net/sched: mqprio: simplify handling of nlattr portion of TCA_OPTIONS
    (no matching commit)
  - [v3,net-next,04/13] net/sched: mqprio: add extack to mqprio_parse_nlattr()
    (no matching commit)
  - [v3,net-next,05/13] net/sched: mqprio: add an extack message to mqprio_parse_opt()
    (no matching commit)
  - [v3,net-next,06/13] net/sched: pass netlink extack to mqprio and taprio offload
    (no matching commit)
  - [v3,net-next,07/13] net/sched: mqprio: allow per-TC user input of FP adminStatus
    (no matching commit)
  - [v3,net-next,08/13] net/sched: taprio: allow per-TC user input of FP adminStatus
    (no matching commit)
  - [v3,net-next,09/13] net: enetc: rename "mqprio" to "qopt"
    (no matching commit)
  - [v3,net-next,10/13] net: mscc: ocelot: add support for mqprio offload
    (no matching commit)
  - [v3,net-next,11/13] net: dsa: felix: act upon the mqprio qopt in taprio offload
    (no matching commit)
  - [v3,net-next,12/13] net: mscc: ocelot: add support for preemptible traffic classes
    (no matching commit)
  - [v3,net-next,13/13] net: enetc: add support for preemptible traffic classes
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


