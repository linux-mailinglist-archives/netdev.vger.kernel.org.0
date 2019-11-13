Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE679FB195
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 14:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbfKMNlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 08:41:50 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:34618 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727032AbfKMNlt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 08:41:49 -0500
Received: by mail-lf1-f68.google.com with SMTP id y186so2012449lfa.1
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 05:41:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=7VCmbEVddaGiCCPH6BV+lZcmBJTHDXU7QLX9bBBFD+o=;
        b=fLRGbGddTVjrMg7NvQKf2dOxVkisty4DDw/FMCI9gPqU66vAZlxSbO4xoEKpbyONE9
         4P/kSYntUDOiM16n2T6v+yx7mJMvQnLPjg1jU1sNO4dy7CdNpkvQ5h6Cn7PLwhYb3WM1
         zxCB+5oVkDxLum4MK7tzFw1yVjAf8pgXSMMvaeE5lYX49msnwbnzm1FF0AKqucq/v+wK
         cb5vn4/ed67OB84VqK1U+g3rCl/41VBZFU92VxfQYzSsZMPrbDKB16AvDELxEwxpyoXA
         18NTiENwdpPVk8oj8z6hlHMejbAniWoqgPyJ+sV4sMSa7WWhbmsxrfESfR4UGdSr+14l
         k8rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=7VCmbEVddaGiCCPH6BV+lZcmBJTHDXU7QLX9bBBFD+o=;
        b=nUcwqgLmciANz/weZyeYk4ozK1ENPyb7IOBmDJ8UqMc8vABq5FJVrhPMC0Ky34z/XW
         gxoL2Xsr5SKL5Cxhbe26LuNkAfB1pY50HaCikU19/BUlU4izXuvC3TbRBZO3h+WfhBzj
         UkjWA8o/jc08Bosq00aYLYsZoP2Axuu1WS7VhMwM3F/LaMHOpI2eYqNuc0so8p9d6bk2
         L0GgGcfHVMkmPprgBFWX/Bt4oEQcxQDYLnuMnkRXGQWgoSZDXyoY+JpKNEsODsoW686P
         ipdm89+vix+G7DC5w757LHaLhdgpdGEApa/1Pu6sOsToZF3az2SdV8SJau9MhY9/o0gi
         7LJw==
X-Gm-Message-State: APjAAAVJ084FSu92bvWnMZifLdGQmy69Kpf+Lz6+6heBliTwl1tLa7kF
        Rt39tToNftoFsY0iogqQO3s9BQ==
X-Google-Smtp-Source: APXvYqxVMqq98NlHyqRGjR6gNOmNfE6nWSJ5oK3cqMKxY5IDDe5Vz08ABJHvBR9aN/e+9Lyz61hnyw==
X-Received: by 2002:ac2:51b5:: with SMTP id f21mr2728379lfk.159.1573652507050;
        Wed, 13 Nov 2019 05:41:47 -0800 (PST)
Received: from khorivan (57-201-94-178.pool.ukrtel.net. [178.94.201.57])
        by smtp.gmail.com with ESMTPSA id n133sm1147966lfd.88.2019.11.13.05.41.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 05:41:46 -0800 (PST)
Date:   Wed, 13 Nov 2019 15:41:44 +0200
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Po Liu <po.liu@nxp.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>
Subject: Re: [EXT] Re: [v2,net-next, 1/2] enetc: Configure the Time-Aware
 Scheduler via tc-taprio offload
Message-ID: <20191113134142.GA2508@khorivan>
Mail-Followup-To: Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>
References: <20191111042715.13444-2-Po.Liu@nxp.com>
 <20191112082823.28998-1-Po.Liu@nxp.com>
 <20191112210958.GB1833@khorivan>
 <VE1PR04MB6496EB580B65AFDA43DC1E9A92760@VE1PR04MB6496.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <VE1PR04MB6496EB580B65AFDA43DC1E9A92760@VE1PR04MB6496.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 13, 2019 at 03:45:08AM +0000, Po Liu wrote:
>Hi Ivan,
>
>> -----Original Message-----
>> From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
>> Sent: 2019年11月13日 5:10
>> To: Po Liu <po.liu@nxp.com>
>> Cc: Claudiu Manoil <claudiu.manoil@nxp.com>; davem@davemloft.net; linux-
>> kernel@vger.kernel.org; netdev@vger.kernel.org; vinicius.gomes@intel.com;
>> Vladimir Oltean <vladimir.oltean@nxp.com>; Alexandru Marginean
>> <alexandru.marginean@nxp.com>; Xiaoliang Yang
>> <xiaoliang.yang_1@nxp.com>; Roy Zang <roy.zang@nxp.com>; Mingkai Hu
>> <mingkai.hu@nxp.com>; Jerry Huang <jerry.huang@nxp.com>; Leo Li
>> <leoyang.li@nxp.com>
>> Subject: [EXT] Re: [v2,net-next, 1/2] enetc: Configure the Time-Aware Scheduler
>> via tc-taprio offload
>>
>> Caution: EXT Email
>>
>> Hello,
>>
>> On Tue, Nov 12, 2019 at 08:42:49AM +0000, Po Liu wrote:
>> >ENETC supports in hardware for time-based egress shaping according to
>> >IEEE 802.1Qbv. This patch implement the Qbv enablement by the hardware
>> >offload method qdisc tc-taprio method.
>> >Also update cbdr writeback to up level since control bd ring may
>> >writeback data to control bd ring.
>> >
>> >Signed-off-by: Po Liu <Po.Liu@nxp.com>
>> >Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>> >Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
>> >---
>> >changes:
>> >- introduce a local define CONFIG_FSL_ENETC_QOS to fix the various
>> >  configurations will result in link errors.
>> >  Since the CONFIG_NET_SCH_TAPRIO depends on many Qos configs. Not
>> >  to use it directly in driver. Add it to CONFIG_FSL_ENETC_QOS depends
>> >  on list, so only CONFIG_NET_SCH_TAPRIO enabled, user can enable this
>> >  tsn feature, or else, return not support.
>> >
>> > drivers/net/ethernet/freescale/enetc/Kconfig  |  10 ++
>> > drivers/net/ethernet/freescale/enetc/Makefile |   1 +
>> > drivers/net/ethernet/freescale/enetc/enetc.c  |  19 ++-
>> > drivers/net/ethernet/freescale/enetc/enetc.h  |   7 +
>> > .../net/ethernet/freescale/enetc/enetc_cbdr.c |   5 +-
>> > .../net/ethernet/freescale/enetc/enetc_hw.h   | 150 ++++++++++++++++--
>> > .../net/ethernet/freescale/enetc/enetc_qos.c  | 130 +++++++++++++++
>> > 7 files changed, 300 insertions(+), 22 deletions(-) create mode 100644
>> > drivers/net/ethernet/freescale/enetc/enetc_qos.c
>> >
>>
>> [...]
>>
>> >
>> >@@ -1483,6 +1479,19 @@ int enetc_setup_tc(struct net_device *ndev, enum
>> tc_setup_type type,
>> >       return 0;
>> > }
>> >
>> >+int enetc_setup_tc(struct net_device *ndev, enum tc_setup_type type,
>> >+                 void *type_data)
>> >+{
>> >+      switch (type) {
>> >+      case TC_SETUP_QDISC_MQPRIO:
>> >+              return enetc_setup_tc_mqprio(ndev, type_data);
>> Sorry didn't see v2, so i duplicate my question here:
>>
>> This patch is for taprio offload, I see that mqprio is related and is part of taprio
>> offload configuration. But taprio offload has own mqprio settings.
>> The taprio mqprio part is not offloaded with TC_SETUP_QDISC_MQPRIO.
>>
>> So, a combination of mqprio and tario qdiscs used.
>> Could you please share the commands were used for your setup?
>>
>
>Example command:
>tc qdisc replace dev eth0 parent root handle 100  taprio num_tc 8 map 0 1 2 3 4 5 6 7 queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 base-time 01 sched-entry S 02 300000 flags 0x2

So, the TC_SETUP_QDISC_MQPRIO is really not required here, and mqprio qdisc is
not used. Then why is it here, should be placed in separate patch at least.

But even the comb mqprio qdisc and taprio qdisc are used together then taprio
requires hw offload also. I'm Ok to add it later to taprio, and I'm asking
about it because I need it also, what ever way it could be added.

Not clear how you combined mqprio qdisc and taprio now to get it working
From this command:

tc qdisc replace dev eth0 parent root handle 100  taprio num_tc 8 map 0 1 2 3 4 
5 6 7 queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 base-time 01 sched-entry S 02 
300000 flags 0x2

I can conclude that some default h/w mapping (one to one) were used and no need
to use mqprio qdisc, the command above is enough.

Is it true?
Then move it to spearate patch please as it's not taprio related yet.

>
>> And couple interesting questions about all of this:
>> - The taprio qdisc has to have mqprio settings, but if it's done with mqprio then
>> it just skipped (by reading tc class num).
>> - If no separate mqprio qdisc configuration then mqprio conf from taprio is set,
>> who should restore tc mappings when taprio qdisc is unloaded?
>> Maybe there is reason to implement TC_SETUP_QDISC_MQPRIO offload in
>> taprio since it's required feature?
>

[...]

>>
>> >+
>> >+      /* Configure the (administrative) gate control list using the
>> >+       * control BD descriptor.
>> >+       */
>> >+      gcl_config = &cbd.gcl_conf;
>> >+
>> >+      data_size = sizeof(struct tgs_gcl_data) + gcl_len *
>> >+ sizeof(struct gce);
>> >+
>> >+      gcl_data = kzalloc(data_size, __GFP_DMA | GFP_KERNEL);
>> >+      if (!gcl_data)
>> >+              return -ENOMEM;
>> >+
>> >+      gce = (struct gce *)(gcl_data + 1);
>> >+
>> >+      /* Since no initial state config in taprio, set gates open as default.
>> >+       */
>> tc-taprio and IEEE Qbv allows to change configuration in flight, so that oper
>> state is active till new admin start time. So, here comment says it does initial
>> state config, if in-flight feature is not supported then error has to be returned
>> instead of silently rewriting configuration. But if it can be implemented then
>> state should be remembered/verified in order to not brake oper configuration?
>
>I think this is ok as per standard. Also see this comment in
>net/sched/sch_taprio.c:

From the code above (duplicate for convenience):
      if (admin_conf->enable) {
              enetc_wr(&priv->si->hw,
                       ENETC_QBV_PTGCR_OFFSET,
                       temp & (~ENETC_QBV_TGE));
              usleep_range(10, 20);
              enetc_wr(&priv->si->hw,
                       ENETC_QBV_PTGCR_OFFSET,
                       temp | ENETC_QBV_TGE);
      } else {
              enetc_wr(&priv->si->hw,
                       ENETC_QBV_PTGCR_OFFSET,
                       temp & (~ENETC_QBV_TGE));
              return 0;
      }

I see that's not true, as Simon noted, you have same command:

enetc_wr(&priv->si->hw, ENETC_QBV_PTGCR_OFFSET, temp & (~ENETC_QBV_TGE));

before enabling and for disabling. I guess it's stop command, that is disable
qbv. So, before enabling new configuration with enetc_setup_tc(), the tario is
inited|cleared|reseted|rebooted|defaulted|offed but not updated. It means no
in-flight capabilities or they are ignored.

JFI, it's possible to do first time:

tc qdisc replace dev eth0 parent root handle 100  taprio num_tc 8 map 0 1 2 3 4 
5 6 7 queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 base-time 01 sched-entry S 02 
300000 flags 0x2

and then:

tc qdisc replace dev eth0 parent root handle 100  taprio base-time 01 
sched-entry S 02 200000 flags 0x2

Do it many times, but w/o mqprio configuration.

So, this function must return error if it cannot be done, as above commands
suppose that configuration can be updated in runtime, that is, set ADMIN cycle
while OPER cycle is still active for some time and not broken like it's done
now. If it can be achieved then no need to do
enetc_wr(&priv->si->hw, ENETC_QBV_PTGCR_OFFSET, temp & (~ENETC_QBV_TGE));
when admin_conf->enable.

So or return error, or do it appropriately.

>
>	/* Until the schedule starts, all the queues are open */
>I would change the comment.
>
>> >+      gcl_config->atc = 0xff;
>> >+      gcl_config->acl_len = cpu_to_le16(gcl_len);
>>
>> Ok, this is maximum number of schedules.
>> According to tc-taprio it's possible to set cycle period more then schedules
>> actually can consume. If cycle time is more, then last gate's state can be kept
>> till the end of cycle. But if last schedule has it's own interval set then gates
>> should be closed till the end of cycle or no? if it has to be closed, then one more
>> endl schedule should be present closing gates at the end of list for the rest cycle
>> time. Can be implemented in h/w but just to be sure, how it's done in h/w?
>>
>There is already check the list len in up code.
>if (admin_conf->num_entries > enetc_get_max_gcl_len(&priv->si->hw))
>	return -EINVAL;
>gcl_len = admin_conf->num_entries;

I mean +1 schedule to finalize the cycle with closed gates if last schedule
has provided time interval. If I set couple schedules, with intervals, and cycle
time more then those schedules consume, then I suppose the gates closed for the
rest time of cycle, probably.

Example:

sched1 ----> shced2 ----> time w/o scheds -> cycle end
gate 1       gate 2       no gates

But if shced2 is last one then gate 2 is opened till the end of cycle.
So, to close gate one more shched is needed with closed gates to finalize it.
Or it's supposed that gate2 is opened till the end of cycle,
How is it in you case. Or this is can be provided by configuration from tc?

It's question not statement. Just though. Anyway i'll verify later it can be
done with tc and how it's done in sw version, just interesting how your h/w
works.

>
>> >+
>> >+      if (!admin_conf->base_time) {
>> >+              gcl_data->btl =
>> >+                      cpu_to_le32(enetc_rd(&priv->si->hw, ENETC_SICTR0));
>> >+              gcl_data->bth =
>> >+                      cpu_to_le32(enetc_rd(&priv->si->hw, ENETC_SICTR1));

[...]

-- 
Regards,
Ivan Khoronzhuk
