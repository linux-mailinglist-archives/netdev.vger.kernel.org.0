Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C32F45979C5
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 00:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234426AbiHQWrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 18:47:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231736AbiHQWru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 18:47:50 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4635174B82
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 15:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660776469; x=1692312469;
  h=from:to:cc:subject:in-reply-to:date:message-id:
   mime-version;
  bh=FYrwwQhE8Uj8Y31ZqFYYFU7jpqXEyhcVVq/v8GPT6+Q=;
  b=Nb7OTZzJwD50pPyPqCEnvF6ZzMiZ6vfSeuu8Q0IcuwjqKnaOXI110L+W
   HbhPhXzgJMyLU3sHc20UJF3W/M1STnaObIaIb2j+TdLwBNIdotpZKgnB5
   oOlKen9/h072HOLQmE0WcvfIAd6lwRVVSfC4a3HrhUiVaCbK66H/ajOL1
   9m/FAndDAw1qvlS5Lny3RrZtMtqf9xFGP0NSltbIwihmGtBxrC65UPCwv
   SjlxMcjUJwM7hW1N02z2Z+5cTVenvgyTYby02+fWZUxuACX7VjTw2HVDg
   hmOM+2OD2Y1kGHL6o2zF6hbVV6/FFOogJXqppIh/eJ3uEXWjIn2zVW8FV
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10442"; a="293409854"
X-IronPort-AV: E=Sophos;i="5.93,244,1654585200"; 
   d="scan'208";a="293409854"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2022 15:47:48 -0700
X-IronPort-AV: E=Sophos;i="5.93,244,1654585200"; 
   d="scan'208";a="853200201"
Received: from kyamada-mobl.amr.corp.intel.com (HELO vcostago-mobl3) ([10.212.63.87])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2022 15:47:48 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>
Subject: Re: [RFC PATCH net-next 0/7] 802.1Q Frame Preemption and 802.3 MAC
 Merge support via ethtool
In-Reply-To: <20220816222920.1952936-1-vladimir.oltean@nxp.com>
Date:   Wed, 17 Aug 2022 15:47:47 -0700
Message-ID: <87k07632ss.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

Vladimir Oltean <vladimir.oltean@nxp.com> writes:

> Vinicius' progress on upstreaming frame preemption support for Intel I226
> seemed to stall, so I decided to give it a go using my own view as well.
> https://patchwork.kernel.org/project/netdevbpf/cover/20220520011538.1098888-1-vinicius.gomes@intel.com/

I was stuck with some internal projects (and some other things) for some
time which left me with very little energy/time to follow up with that
series.

Just let's say that your timing was very good, a few more days I would
have sent another version. I am kind of glad that you decided to take
this torch.

>
> Please don't take this patch set too seriously; I spent only a few
> days working on this, and I'm only posting it as RFC to inform others
> I've started doing this, before I spend too much time to risk colliding
> with someone else's active work.
>
> Compared to Vinicius' previous patches, this is basically a new
> implementation, with the following differences:
>
> - The MAC Merge (mm) and Frame Preemption (fp) settings are split like
>   they were in Vinicius' proposal to have fp as part of tc-taprio. But
>   in my proposal, the fp portion is still part of ethtool, like mm.
>

I have some questions/comments about this part. Mostly related to
"prios" in this context. Will make them in the UAPI patches.

> - We have statistics, actually 2 kinds. First we have MAC merge layer
>   stats, which are exposed as protocol-specific stats:
>
>   ethtool --json --include-statistics --show-mm eno2
>   [ {
>           "ifname": "eno2",
>           "verify-status": "SUCCEEDED",
>           "verify-time": 10,
>           "supported": true,
>           "enabled": true,
>           "active": true,
>           "add-frag-size": 0,
>           "statistics": {
>               "MACMergeFrameAssErrorCount": 0,
>               "MACMergeFrameSmdErrorCount": 0,
>               "MACMergeFrameAssOkCount": 0,
>               "MACMergeFragCountRx": 0,
>               "MACMergeFragCountTx": 0,
>               "MACMergeHoldCount": 0
>           }
>       } ]
>
>   and then we also have the usual standardized statistics counters, but
>   replicated for the pMAC:
>
>   ethtool -S eno0 --groups pmac-rmon
>   Standard stats for eno0:
>   pmac-rmon-etherStatsUndersizePkts: 0
>   pmac-rmon-etherStatsOversizePkts: 0
>   pmac-rmon-etherStatsFragments: 0
>   pmac-rmon-etherStatsJabbers: 0
>   rx-pmac-rmon-etherStatsPkts64to64Octets: 0
>   rx-pmac-rmon-etherStatsPkts65to127Octets: 0
>   rx-pmac-rmon-etherStatsPkts128to255Octets: 0
>   rx-pmac-rmon-etherStatsPkts256to511Octets: 0
>   rx-pmac-rmon-etherStatsPkts512to1023Octets: 0
>   rx-pmac-rmon-etherStatsPkts1024to1522Octets: 0
>   rx-pmac-rmon-etherStatsPkts1523to9000Octets: 0
>   tx-pmac-rmon-etherStatsPkts64to64Octets: 0
>   tx-pmac-rmon-etherStatsPkts65to127Octets: 0
>   tx-pmac-rmon-etherStatsPkts128to255Octets: 0
>   tx-pmac-rmon-etherStatsPkts256to511Octets: 0
>   tx-pmac-rmon-etherStatsPkts512to1023Octets: 0
>   tx-pmac-rmon-etherStatsPkts1024to1522Octets: 0
>   tx-pmac-rmon-etherStatsPkts1523to9000Octets: 0
>
>   ethtool -S eno0 --groups eth-pmac-mac
>   Standard stats for eno0:
>   eth-pmac-mac-FramesTransmittedOK: 0
>   eth-pmac-mac-SingleCollisionFrames: 0
>   eth-pmac-mac-MultipleCollisionFrames: 0
>   eth-pmac-mac-FramesReceivedOK: 0
>   eth-pmac-mac-FrameCheckSequenceErrors: 0
>   eth-pmac-mac-AlignmentErrors: 0
>   eth-pmac-mac-OctetsTransmittedOK: 0
>   eth-pmac-mac-FramesWithDeferredXmissions: 0
>   eth-pmac-mac-LateCollisions: 0
>   eth-pmac-mac-FramesAbortedDueToXSColls: 0
>   eth-pmac-mac-FramesLostDueToIntMACXmitError: 0
>   eth-pmac-mac-CarrierSenseErrors: 0
>   eth-pmac-mac-OctetsReceivedOK: 0
>   eth-pmac-mac-FramesLostDueToIntMACRcvError: 0
>   eth-pmac-mac-MulticastFramesXmittedOK: 0
>   eth-pmac-mac-BroadcastFramesXmittedOK: 0
>   eth-pmac-mac-MulticastFramesReceivedOK: 0
>   eth-pmac-mac-BroadcastFramesReceivedOK: 0
>
>   ethtool -S eno0 --groups eth-pmac-ctrl
>   Standard stats for eno0:
>   eth-pmac-ctrl-MACControlFramesTransmitted: 0
>   eth-pmac-ctrl-MACControlFramesReceived: 0
>
>   What also exists but is not exported here are PAUSE stats for the
>   pMAC. Since those are also protocol-specific stats, I'm not sure how
>   to mix the 2 (MAC Merge layer + PAUSE). Maybe just extend
>   ETHTOOL_A_PAUSE_STAT_TX_FRAMES and ETHTOOL_A_PAUSE_STAT_RX_FRAMES with
>   the pMAC variants?
>
> - Finally, the hardware I'm working with (here, the test vehicle is the
>   NXP ENETC from LS1028A, although I have patches for the Felix switch
>   as well, but those need a bit of a revolution in the driver to go in
>   first). This hardware is not without its flaws, but at least allows me
>   to concentrate on the UAPI portions for this series.
>
> I also have a kselftest written, but it's for the Felix switch (covers
> forwarding latency) and so it's not included here.
>
> Are there objections in exposing the UAPI for this new feature in this way?
>

I really liked the statistics part, even though the hardware I am
working right now with doesn't provide all of them.

> Also, there is no documentation associated with this patch set, other
> than the code. Life is too short to write documentation for an RFC, sorry.
> I may get kdoc related kernel bot warnings because I copy-pasted ethtool
> structure definitions from here and there, but I didn't fill in the
> descriptions of all their fields. All those fields are as truthful to
> the standards as possible rather than my own variables or names, so
> please refer to those specs for now.
>
> Vladimir Oltean (7):
>   net: ethtool: netlink: introduce ethnl_update_bool()
>   net: ethtool: add support for Frame Preemption and MAC Merge layer
>   net: ethtool: stats: make stats_put_stats() take input from multiple
>     sources
>   net: ethtool: stats: replicate standardized counters for the pMAC
>   net: enetc: parameterize port MAC stats to also cover the pMAC
>   net: enetc: expose some standardized ethtool counters
>   net: enetc: add support for Frame Preemption and MAC Merge layer
>
>  .../ethernet/freescale/enetc/enetc_ethtool.c  | 399 +++++++++++++++---
>  .../net/ethernet/freescale/enetc/enetc_hw.h   | 132 +++---
>  include/linux/ethtool.h                       |  68 +++
>  include/uapi/linux/ethtool.h                  |  15 +
>  include/uapi/linux/ethtool_netlink.h          |  86 ++++
>  net/ethtool/Makefile                          |   3 +-
>  net/ethtool/fp.c                              | 295 +++++++++++++
>  net/ethtool/mm.c                              | 228 ++++++++++
>  net/ethtool/netlink.c                         |  38 ++
>  net/ethtool/netlink.h                         |  34 ++
>  net/ethtool/stats.c                           | 218 +++++++---
>  11 files changed, 1338 insertions(+), 178 deletions(-)
>  create mode 100644 net/ethtool/fp.c
>  create mode 100644 net/ethtool/mm.c
>
> -- 
> 2.34.1
>


Cheers,
-- 
Vinicius
