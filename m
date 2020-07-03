Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFC7F213946
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 13:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbgGCLWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 07:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgGCLWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 07:22:52 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6636BC08C5C1
        for <netdev@vger.kernel.org>; Fri,  3 Jul 2020 04:22:52 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id t11so12036474qvk.1
        for <netdev@vger.kernel.org>; Fri, 03 Jul 2020 04:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xGBZZXb+OsEVMVw09kqCb/G/yaUwyhwJ0QNfEfuCWfw=;
        b=V4oo+4PhHE8ey2CKGTM8D5hkTT1xBHrtNz/jo40+iMm9yQ2En3EzdfKqK0COX6PD51
         UZCvFYE1DU9bm83up4OCg+KH8/6Gk5OyhxvZKwvEijAmgaWY9b6itkXyWPHZsV9hS2J8
         cWXfW75kWpz1y2PPVF2d+78TYv/xQRtkJkPrgS0lTWsv6zu8DtlbPnrXQiVQJQFz0Nax
         fh741kuyUlOFy72DbJFvmZepK6ITpEdE03Qs8uoH7at9poj6MMIyoF9K00QPuFPlbzcl
         vroRFTEni9/C48+vihoRZYxPmFwW9fVvR/YJMq25r/RXyD5LQ81I6e6hYlQa77GeBNBR
         4vHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xGBZZXb+OsEVMVw09kqCb/G/yaUwyhwJ0QNfEfuCWfw=;
        b=k6HAPdiHSpFjr4KmP+8FmZJ7F8lx6pGV4RMOOQrrGdEaI7fAD5GpMO3qCB+Jtj58a2
         QbGQQB+ZLQdIMkpZZFL3Zyh7xbpdqLeityStDNCN0pXwPXaDnlxdoGlXbGR1tyCK3N7b
         qGmNXQWykabRRxGdEmLRqNskGBqQtubYjX90Gw7islDe97TMiFZGyT8T/3wHfJR0SroI
         KtQLVALt11+YdQNE+oeBPdzILUPm8QCp9k4qUNd6JYWB51PQ5Si1YvzIGP8CHFLRUp7g
         zSC4llv7+FfezJwOvIHydRI8Q+DQ8ViClqjMiW3D1r2blnbWPelAHDKGrzcTVy/UdvvM
         g4bg==
X-Gm-Message-State: AOAM532RX0UqMRpx3G1WOOztm2ra0Z6Xub/LUilKir/+bMf8WpPLB44T
        LWGwadMmGOVlI2QTvtPPlc4UIw==
X-Google-Smtp-Source: ABdhPJw97LsP01bG2oz0Z60idwh9xTCeWz8yL5252h1Jx6zqfppGulM1CbXvD1SHrE94svoVix7m7Q==
X-Received: by 2002:ad4:4583:: with SMTP id x3mr1296808qvu.133.1593775371649;
        Fri, 03 Jul 2020 04:22:51 -0700 (PDT)
Received: from [192.168.1.117] (23-233-27-60.cpe.pppoe.ca. [23.233.27.60])
        by smtp.googlemail.com with ESMTPSA id h52sm11802257qtb.88.2020.07.03.04.22.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2020 04:22:50 -0700 (PDT)
Subject: Re: [PATCH net-next v2 0/3] ] TC datapath hash api
To:     Ariel Levkovich <lariel@mellanox.com>, netdev@vger.kernel.org
Cc:     jiri@resnulli.us, kuba@kernel.org, xiyou.wangcong@gmail.com,
        ast@kernel.org, daniel@iogearbox.net
References: <20200701184719.8421-1-lariel@mellanox.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <13b36fb1-f93e-dad7-9dba-575909197652@mojatatu.com>
Date:   Fri, 3 Jul 2020 07:22:47 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200701184719.8421-1-lariel@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Several comments:
1) I agree with previous comments that you should
look at incorporating this into skbedit.
Unless incorporating into skbedit introduces huge
complexity, IMO it belongs there.

2) I think it would make sense to create a skb hash classifier
instead of tying this entirely to flower i.e i should not
have to change u32 just so i can support hash classification.
So policy would be something of the sort:

$ tc filter add dev ens1f0_0 ingress \
prio 1 chain 0 proto ip \
flower ip_proto tcp \
action skbedit hash bpf object-file <file> \
action goto chain 2

$ tc filter add dev ens1f0_0 ingress \
prio 1 chain 2 proto ip \
handle 0x0 skbhash  flowid 1:11 mask 0xf  \
action mirred egress redirect dev ens1f0_1

$ tc filter add dev ens1f0_0 ingress \
prio 1 chain 2 proto ip \
handle 0x1 skbhash  flowid 1:11 mask 0xf  \
action mirred egress redirect dev ens1f0_2

IOW, we maintain current modularity as opposed
to dumping everything into flower.
Ive always wanted to write the skbhash classifier but
time was scarce. At one point i had some experiment
where I would copy skb hash into mark in the driver
and use fw classifier for further processing.
It was ugly.

cheers,
jamal

On 2020-07-01 2:47 p.m., Ariel Levkovich wrote:
> Supporting datapath hash allows user to set up rules that provide
> load balancing of traffic across multiple vports and for ECMP path
> selection while keeping the number of rule at minimum.
> 
> Instead of matching on exact flow spec, which requires a rule per
> flow, user can define rules based on hashing on the packet headers
> and distribute the flows to different buckets. The number of rules
> in this case will be constant and equal to the number of buckets.
> 
> The datapath hash functionality is achieved in two steps -
> performing the hash action and then matching on the result, as
> part of the packet's classification.
> 
> The api allows user to define a filter with a tc hash action
> where the hash function can be standard asymetric hashing that Linux
> offers or alternatively user can provide a bpf program that
> performs hash calculation on a packet.
> 
> Usage is as follows:
> 
> $ tc filter add dev ens1f0_0 ingress \
> prio 1 chain 0 proto ip \
> flower ip_proto tcp \
> action hash bpf object-file <file> \
> action goto chain 2
> 
> $ tc filter add dev ens1f0_0 ingress \
> prio 1 chain 0 proto ip \
> flower ip_proto udp \
> action hash bpf asym_l4 basis <basis> \
> action goto chain 2
> 
> $ tc filter add dev ens1f0_0 ingress \
> prio 1 chain 2 proto ip \
> flower hash 0x0/0xf  \
> action mirred egress redirect dev ens1f0_1
> 
> $ tc filter add dev ens1f0_0 ingress \
> prio 1 chain 2 proto ip \
> flower hash 0x1/0xf  \
> action mirred egress redirect dev ens1f0_2
> 
> Ariel Levkovich (3):
>    net/sched: Introduce action hash
>    net/flow_dissector: add packet hash dissection
>    net/sched: cls_flower: Add hash info to flow classification
> 
>   include/linux/skbuff.h              |   4 +
>   include/net/act_api.h               |   2 +
>   include/net/flow_dissector.h        |   9 +
>   include/net/tc_act/tc_hash.h        |  22 ++
>   include/uapi/linux/pkt_cls.h        |   4 +
>   include/uapi/linux/tc_act/tc_hash.h |  32 +++
>   net/core/flow_dissector.c           |  17 ++
>   net/sched/Kconfig                   |  11 +
>   net/sched/Makefile                  |   1 +
>   net/sched/act_hash.c                | 389 ++++++++++++++++++++++++++++
>   net/sched/cls_api.c                 |   1 +
>   net/sched/cls_flower.c              |  16 ++
>   12 files changed, 508 insertions(+)
>   create mode 100644 include/net/tc_act/tc_hash.h
>   create mode 100644 include/uapi/linux/tc_act/tc_hash.h
>   create mode 100644 net/sched/act_hash.c
> 

