Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7604DB3125
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 19:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbfIOR2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 13:28:43 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:34373 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725270AbfIOR2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 13:28:43 -0400
Received: by mail-ed1-f66.google.com with SMTP id c20so22084852eds.1
        for <netdev@vger.kernel.org>; Sun, 15 Sep 2019 10:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8sK7NPSDU3Ax2galupJDpivSjx32jUcdg6VWipe0AVc=;
        b=VsCOy8TSEkBOAzWq+EQtbtHA+pRUvJ8UXMA4QPcgq5RPotKdMUzjwRf6aw+gugi8uN
         Uwbg1z5k+riBIvGF/XwEj4sjt/tMoab80LKdEsmR3+5cf3aZPbgyU8LfbtEV9DzX6vCN
         KHESoN4fMwunMrHXrNKNTRpMQY8i9VXg/8w5+LcZsj0MATJMCwAmrcAVdjUJoBoRZMyP
         O+ZEVD9fQxx5ftLBFv4PeI+HyqfYxpVFV7D1SX0i3/62loq/y1/6l0ZCW76F43N3r5YE
         RW+Xj/h5Gnn1gJYvEvesBBtD9fUJyN0JkVf6s8twm1wCao20pPvhZ5fFhSGsmTvZjuvO
         vMXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8sK7NPSDU3Ax2galupJDpivSjx32jUcdg6VWipe0AVc=;
        b=COu7umI0HFN3cJ23yGl/xVFWT/hZAf2z7Nzb7q3Bbi6QIepTCGQsxuxprtxfoLNswv
         NDHpN+YiHyhRWsg+yNqJYKq5RidZWLWpdRDanDAg8rDA8gIxXA8Rew6wmOmSGOu3fpTx
         FknBwBtvmDCONBiL/0VvL/DZhbaMmEgJ03bywXpBC14DqQZGctLk3zpC1xo6fUfJuHiZ
         RGPrjAGG7VMLiUxJf8M8q2qC5DnPMcbml2CPNyo8dFgJdr53+Zim/38HFcf00gYucd87
         pMPDyrP0SDrvZ0gNhHbk0MTzyCNX9zh3j6j/XWovlPgXdWarpaqVBLbuBeyO1tmiUS3J
         1U5A==
X-Gm-Message-State: APjAAAXRRbmK/6tReJSDVbS0uyK/qE/nMc3DswZxm9OUiUhheg05qBar
        NHnOcmIOkliENF5iIv3d3GBBqG9OCu2TwrO3Ydg=
X-Google-Smtp-Source: APXvYqyA0/kwlvViyDTITPo/5ZEudGXac9ELwRAbAlAocbmKb10OVLLIvUtW2H3XB/p51F2l0ilAyS0NqkOPwdSO1Vk=
X-Received: by 2002:a17:906:9451:: with SMTP id z17mr5823263ejx.90.1568568519347;
 Sun, 15 Sep 2019 10:28:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190915020003.27926-1-olteanv@gmail.com> <20190915020003.27926-5-olteanv@gmail.com>
 <BN8PR12MB326684898CC3CBC27ABEA4E7D38D0@BN8PR12MB3266.namprd12.prod.outlook.com>
In-Reply-To: <BN8PR12MB326684898CC3CBC27ABEA4E7D38D0@BN8PR12MB3266.namprd12.prod.outlook.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sun, 15 Sep 2019 20:28:28 +0300
Message-ID: <CA+h21hrDf0Cmo+S4OGwPcbcyMD9uKbeR0Qh3pimRqKKL0ifhDA@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 4/6] net: dsa: sja1105: Advertise the 8 TX queues
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "vedang.patel@intel.com" <vedang.patel@intel.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "weifeng.voon@intel.com" <weifeng.voon@intel.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "kurt.kanzenbach@linutronix.de" <kurt.kanzenbach@linutronix.de>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jose,

On Sun, 15 Sep 2019 at 19:41, Jose Abreu <Jose.Abreu@synopsys.com> wrote:
>
> From: Vladimir Oltean <olteanv@gmail.com>
> Date: Sep/15/2019, 03:00:01 (UTC+00:00)
>
> > Instead of looking directly at skb->priority during xmit, let's get the
> > netdev queue and the queue-to-traffic-class mapping, and put the
> > resulting traffic class into the dsa_8021q PCP field. The switch is
> > configured with a 1-to-1 PCP-to-ingress-queue-to-egress-queue mapping
> > (see vlan_pmap in sja1105_main.c), so the effect is that we can inject
> > into a front-panel's egress traffic class through VLAN tagging from
> > Linux, completely transparently.
>
> Wouldn't it be better to just rely on skb queue mapping as per userspace
> settings ? I mean this way you cant create some complex scenarios
> without having the VLAN ID need.
>

I think I need to clarify the "without having the VLAN ID need" portion.
This is a DSA switch, and the thing that all these switches have in
common is that their data path is connected to the host system through
an Ethernet port pair (as opposed to e.g. DMA and real queues).
When you send a frame from the host through that Ethernet port, the
switch's natural tendency is to forward/flood it according to FDB
rules, which may not be what you want to achieve (i.e. you may want to
xmit on a specific front-panel port only, to achieve a 'port
multiplier' behavior out of it). Switch vendors achieve that by using
a proprietary frame header which indicates stuff such as: egress port,
QoS priority, etc. The host adds this tag to frames sent towards the
switch, and the switch consumes it.
In the case of sja1105, the frame tagging format is actually
'open-spec', e.g. it is an actual VLAN header, just with a custom
EtherType. Hence the QoS priority in this tagging format is the PCP
field. Other DSA switch vendors still have a 'priority' field in their
tagging format, even though it is not PCP.
So to answer your question, I do need VLAN tagging either way, for
even more basic reasons. But it is VLAN only from the switch's
hardware view. From the operating system's view it is no different
than populating the 'priority' field of any other DSA frame tagger.

> I generally use u32 filter and skbedit queue_mapping action to achieve
> this.
>

The trouble with relying on 'queue_mapping' only is that it's too
open-ended: what does a queue really mean for an Ethernet-managed
switch?
In my interpretation of the mqprio/taprio offloads, the netdev queue
is only an intermediary representation between the qdisc and the NIC's
traffic classes. Now that makes sense, because even though the switch
xmit procedure isn't multi-queue, there is still strict egress
prioritization based on the traffic class mapping (inferred from VLAN
PCP).
I have no idea how people are managing multi-queue net devices without
an mqprio-type offload, if those netdev queues are not of equal
priority. Technically, if you use the 'skbedit queue_mapping' action
with this switch, it is your choice how you manage the
net_device->tc_to_txq array, keeping in mind that tc 7 will have
higher priority over tc 6. Alternatively, you can still use an
mqprio-type offload, specify "num_tc 8 map 0 1 2 3 5 6 7 queues 1@0
1@1 1@2 1@3 1@4 1@5 1@6 1@7", and then just use the 'skbedit priority'
action. Then things would just work.
So I am just using the 'queues' term for this switch to express the
strict priority scheduler. There isn't really any benefit to having
more than one netdev queue exposed per traffic class.

> ---
> Thanks,
> Jose Miguel Abreu

Hope this clarifies,
-Vladimir
