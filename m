Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB424471582
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 20:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231800AbhLKTEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 14:04:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231765AbhLKTEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 14:04:54 -0500
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E15C061714
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 11:04:53 -0800 (PST)
Received: by mail-qk1-x72d.google.com with SMTP id l25so1456446qkl.5
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 11:04:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Hj/BaJFtkHtANbg5deZgoRZhXs9FQCrAg5vaoKHBA7I=;
        b=rJ0GSjGbbPktCSFa/WOoX6zvFUuXOhW1fHlQfbllZRuYzNws8UYKIL/67glUBOnaKr
         7Y9MjA0Vz10Cq9z5+GpDErGM6x0Ubae0ub0iOHetvjlOfbuT5ryWw0gy2G/GsWkh4ZX4
         qSepzruHC77G/O6Gz1+/SygZvTBCPTc51oQbF5lt7LPeNcMdMVfFEC+k7Y1nUND3lgmA
         Y4LJRhS9CXlO7I0NAy6qX3yrfpcgnepds4mZBAD6rJjFfCN99QbWcil+glBltCPRar8G
         +8OJmy/G7dGnjRtcXp3sr/bTJYdD53zzXEFRnZewMr4jLn7fcLzjs/fCnFlH7V96tgID
         G/mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Hj/BaJFtkHtANbg5deZgoRZhXs9FQCrAg5vaoKHBA7I=;
        b=RLcUmn8RRWAPrSh9RVkxXWLJ15iQKA7Hf3kbcxReqOkhSFERihnTrKPkW9RGAaaUsR
         9vg9Wb1KhwFdDy49mNSfMpl4TI2Ld0YEnf7r9qNqWu0Bekb7c5hWHBGCcujCqO/gOWNv
         7VGyHU1yK09PjmrartyoRfJ37xWm6YxbwvIiBzOFNGdcmOIqpVMFptmc7QaiPgalSdaL
         9sD5/zBtSGb5hUQyi2GsUuDCFdZ+j+jT7jHD340A8VHUXAfqkiUpFii5o7NXRaLagVrN
         U10GLNLT+2liaSt8wFMxATMG99CsC6JohmAf8LK3nQ2b4CKb7F05Uo8qvOK8SVVOMYXq
         kGKA==
X-Gm-Message-State: AOAM530reXgAN9d0fRiMWNIOX3eMY2mWBoqaTBlbjCklH7Tx2rfcYdUy
        P9sd/sXF3TWKeUULYqW1foWCPA==
X-Google-Smtp-Source: ABdhPJzqUkVq9AlOGmcp8tHVuY9LIFrmRLW5OPJT58OQa2UXuua4WDRdZA5BVNoTN55mKQb9JtCBDA==
X-Received: by 2002:a05:620a:2697:: with SMTP id c23mr26587516qkp.103.1639249493053;
        Sat, 11 Dec 2021 11:04:53 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.googlemail.com with ESMTPSA id l2sm4941347qtk.41.2021.12.11.11.04.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Dec 2021 11:04:52 -0800 (PST)
Message-ID: <7a3d97d0-85c3-842b-aba0-73e0cb4a925c@mojatatu.com>
Date:   Sat, 11 Dec 2021 14:04:50 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v6 net-next 00/12] allow user to offload tc action to net
 device
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com
References: <20211209092806.12336-1-simon.horman@corigine.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <20211209092806.12336-1-simon.horman@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I believe these patches are functionally ready. There is still some
nitpick.

On the general patch: Why not Cc the maintainers for the drivers you
are touching? I know the changes seem trivial but it is good courtesy.
 From your logs driver files touched:

    drivers/net/dsa/ocelot/felix_vsc9959.c        |   4 +-
    drivers/net/dsa/sja1105/sja1105_flower.c      |   2 +-
    drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |   2 +-
    .../net/ethernet/freescale/enetc/enetc_qos.c  |   6 +-
    .../ethernet/mellanox/mlx5/core/en/rep/tc.c   |   3 +
    .../ethernet/mellanox/mlxsw/spectrum_flower.c |   2 +-
    drivers/net/ethernet/mscc/ocelot_flower.c     |   2 +-
    .../ethernet/netronome/nfp/flower/offload.c   |   3 +

Also - shouldnt the history be all inclusive? You obly have V5 here.
Maybe with lore or patchwork this is no longer necessary and all
history can be retrieved in the future?

Individual patch comments to follow.

cheers,
jamal

On 2021-12-09 04:27, Simon Horman wrote:
> Baowen Zheng says:
> 
> Allow use of flow_indr_dev_register/flow_indr_dev_setup_offload to offload
> tc actions independent of flows.
> 
> The motivation for this work is to prepare for using TC police action
> instances to provide hardware offload of OVS metering feature - which calls
> for policers that may be used by multiple flows and whose lifecycle is
> independent of any flows that use them.
> 
> This patch includes basic changes to offload drivers to return EOPNOTSUPP
> if this feature is used - it is not yet supported by any driver.
> 
> Tc cli command to offload and quote an action:
> 
>   # tc qdisc del dev $DEV ingress && sleep 1 || true
>   # tc actions delete action police index 200 || true
> 
>   # tc qdisc add dev $DEV ingress
>   # tc qdisc show dev $DEV ingress
> 
>   # tc actions add action police rate 100mbit burst 10000k index 200 skip_sw
>   # tc -s -d actions list action police
>   total acts 1
> 
>           action order 0:  police 0xc8 rate 100Mbit burst 10000Kb mtu 2Kb action reclassify
>           overhead 0b linklayer ethernet
>           ref 1 bind 0  installed 142 sec used 0 sec
>           Action statistics:
>           Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>           backlog 0b 0p requeues 0
>           skip_sw in_hw in_hw_count 1
>           used_hw_stats delayed
> 
>   # tc filter add dev $DEV protocol ip parent ffff: \
>           flower skip_sw ip_proto tcp action police index 200
>   # tc -s -d filter show dev $DEV protocol ip parent ffff:
>   filter pref 49152 flower chain 0
>   filter pref 49152 flower chain 0 handle 0x1
>     eth_type ipv4
>     ip_proto tcp
>     skip_sw
>     in_hw in_hw_count 1
>           action order 1:  police 0xc8 rate 100Mbit burst 10000Kb mtu 2Kb action
>           reclassify overhead 0b linklayer ethernet
>           ref 2 bind 1  installed 300 sec used 0 sec
>           Action statistics:
>           Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>           backlog 0b 0p requeues 0
>           skip_sw in_hw in_hw_count 1
>           used_hw_stats delayed
> 
>   # tc filter add dev $DEV protocol ipv6 parent ffff: \
>           flower skip_sw ip_proto tcp action police index 200
>   # tc -s -d filter show dev $DEV protocol ipv6 parent ffff:
>     filter pref 49151 flower chain 0
>     filter pref 49151 flower chain 0 handle 0x1
>     eth_type ipv6
>     ip_proto tcp
>     skip_sw
>     in_hw in_hw_count 1
>           action order 1:  police 0xc8 rate 100Mbit burst 10000Kb mtu 2Kb action
>           reclassify overhead 0b linklayer ethernet
>           ref 3 bind 2  installed 761 sec used 0 sec
>           Action statistics:
>           Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>           backlog 0b 0p requeues 0
>           skip_sw in_hw in_hw_count 1
>           used_hw_stats delayed
> 
>   # tc -s -d actions list action police
>   total acts 1
> 
>            action order 0:  police 0xc8 rate 100Mbit burst 10000Kb mtu 2Kb action reclassify overhead 0b linklayer ethernet
>            ref 3 bind 2  installed 917 sec used 0 sec
>            Action statistics:
>            Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>            backlog 0b 0p requeues 0
>            skip_sw in_hw in_hw_count 1
>           used_hw_stats delayed
> 
> Changes compared to v5 patches:
> * Fix issue reported by Dan Carpenter found using Smatch.
> 
> Baowen Zheng (12):
>    flow_offload: fill flags to action structure
>    flow_offload: reject to offload tc actions in offload drivers
>    flow_offload: add index to flow_action_entry structure
>    flow_offload: return EOPNOTSUPP for the unsupported mpls action type
>    flow_offload: add ops to tc_action_ops for flow action setup
>    flow_offload: allow user to offload tc action to net device
>    flow_offload: add skip_hw and skip_sw to control if offload the action
>    flow_offload: add process to update action stats from hardware
>    net: sched: save full flags for tc action
>    flow_offload: add reoffload process to update hw_count
>    flow_offload: validate flags of filter and actions
>    selftests: tc-testing: add action offload selftest for action and
>      filter
> 
>   drivers/net/dsa/ocelot/felix_vsc9959.c        |   4 +-
>   drivers/net/dsa/sja1105/sja1105_flower.c      |   2 +-
>   drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |   2 +-
>   .../net/ethernet/freescale/enetc/enetc_qos.c  |   6 +-
>   .../ethernet/mellanox/mlx5/core/en/rep/tc.c   |   3 +
>   .../ethernet/mellanox/mlxsw/spectrum_flower.c |   2 +-
>   drivers/net/ethernet/mscc/ocelot_flower.c     |   2 +-
>   .../ethernet/netronome/nfp/flower/offload.c   |   3 +
>   include/linux/netdevice.h                     |   1 +
>   include/net/act_api.h                         |  27 +-
>   include/net/flow_offload.h                    |  20 +-
>   include/net/pkt_cls.h                         |  27 +-
>   include/net/tc_act/tc_gate.h                  |   5 -
>   include/uapi/linux/pkt_cls.h                  |   9 +-
>   net/core/flow_offload.c                       |  46 +-
>   net/sched/act_api.c                           | 450 +++++++++++++++++-
>   net/sched/act_bpf.c                           |   2 +-
>   net/sched/act_connmark.c                      |   2 +-
>   net/sched/act_csum.c                          |  19 +
>   net/sched/act_ct.c                            |  21 +
>   net/sched/act_ctinfo.c                        |   2 +-
>   net/sched/act_gact.c                          |  38 ++
>   net/sched/act_gate.c                          |  51 +-
>   net/sched/act_ife.c                           |   2 +-
>   net/sched/act_ipt.c                           |   2 +-
>   net/sched/act_mirred.c                        |  50 ++
>   net/sched/act_mpls.c                          |  54 ++-
>   net/sched/act_nat.c                           |   2 +-
>   net/sched/act_pedit.c                         |  36 +-
>   net/sched/act_police.c                        |  27 +-
>   net/sched/act_sample.c                        |  32 +-
>   net/sched/act_simple.c                        |   2 +-
>   net/sched/act_skbedit.c                       |  38 +-
>   net/sched/act_skbmod.c                        |   2 +-
>   net/sched/act_tunnel_key.c                    |  54 +++
>   net/sched/act_vlan.c                          |  48 ++
>   net/sched/cls_api.c                           | 263 ++--------
>   net/sched/cls_flower.c                        |   9 +-
>   net/sched/cls_matchall.c                      |   9 +-
>   net/sched/cls_u32.c                           |  12 +-
>   .../tc-testing/tc-tests/actions/police.json   |  24 +
>   .../tc-testing/tc-tests/filters/matchall.json |  24 +
>   42 files changed, 1144 insertions(+), 290 deletions(-)
> 

