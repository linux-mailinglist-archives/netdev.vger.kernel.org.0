Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43202196008
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 21:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbgC0Urs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 16:47:48 -0400
Received: from mga04.intel.com ([192.55.52.120]:47229 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727685AbgC0Urr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 16:47:47 -0400
IronPort-SDR: 3K/6dgVNz7MT/BZEyuzW8X7+ZTvFGgrljmPwi+MTSGaK823IFdMSOGR0/ulIP+SQgSqQHlRQCa
 2wRi+ciDIdIg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2020 13:47:47 -0700
IronPort-SDR: ykPN9zZOvps005RNOkFGP2hmKNxY60No+9852qIo2dQrAIWSRzpTLK0GKtOmWU8NLpJzLwc9ll
 KUCfKzRRCzMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,313,1580803200"; 
   d="scan'208";a="241054697"
Received: from samudral-mobl.amr.corp.intel.com (HELO [10.251.240.95]) ([10.251.240.95])
  by fmsmga008.fm.intel.com with ESMTP; 27 Mar 2020 13:47:44 -0700
Subject: Re: [RFC] current devlink extension plan for NICs
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "kuba@kernel.org" <kuba@kernel.org>
Cc:     Aya Levin <ayal@mellanox.com>,
        "andrew.gospodarek@broadcom.com" <andrew.gospodarek@broadcom.com>,
        "sburla@marvell.com" <sburla@marvell.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        Tariq Toukan <tariqt@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        "lihong.yang@intel.com" <lihong.yang@intel.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "fmanlunas@marvell.com" <fmanlunas@marvell.com>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>,
        "leon@kernel.org" <leon@kernel.org>,
        Parav Pandit <parav@mellanox.com>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        Alex Vesker <valex@mellanox.com>,
        "snelson@pensando.io" <snelson@pensando.io>,
        "linyunsheng@huawei.com" <linyunsheng@huawei.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "dchickles@marvell.com" <dchickles@marvell.com>,
        "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        "aelior@marvell.com" <aelior@marvell.com>,
        Yuval Avnery <yuvalav@mellanox.com>,
        "drivers@pensando.io" <drivers@pensando.io>,
        mlxsw <mlxsw@mellanox.com>,
        "GR-everest-linux-l2@marvell.com" <GR-everest-linux-l2@marvell.com>,
        Yevgeny Kliteynik <kliteyn@mellanox.com>,
        "vikas.gupta@broadcom.com" <vikas.gupta@broadcom.com>,
        Eran Ben Elisha <eranbe@mellanox.com>
References: <20200319192719.GD11304@nanopsycho.orion>
 <20200319203253.73cca739@kicinski-fedora-PC1C0HJN>
 <20200320073555.GE11304@nanopsycho.orion>
 <20200320142508.31ff70f3@kicinski-fedora-PC1C0HJN>
 <20200321093525.GJ11304@nanopsycho.orion>
 <20200323122123.2a3ff20f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200326144709.GW11304@nanopsycho.orion>
 <20200326145146.GX11304@nanopsycho.orion>
 <20200326133001.1b2694c9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200327074736.GJ11304@nanopsycho.orion>
 <20200327093829.76140a98@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <a02cf0e6-98ad-65c4-0363-8fb9d67d2c9c@intel.com>
 <20200327121010.3e987488@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <ea8a8434b1db2b692489edfd4abbc2274a77228c.camel@mellanox.com>
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Message-ID: <22e86150-925f-0229-3d54-a7d82d504835@intel.com>
Date:   Fri, 27 Mar 2020 13:47:44 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <ea8a8434b1db2b692489edfd4abbc2274a77228c.camel@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/27/2020 12:45 PM, Saeed Mahameed wrote:
> On Fri, 2020-03-27 at 12:10 -0700, Jakub Kicinski wrote:
>> On Fri, 27 Mar 2020 11:49:10 -0700 Samudrala, Sridhar wrote:
>>> On 3/27/2020 9:38 AM, Jakub Kicinski wrote:
>>>> On Fri, 27 Mar 2020 08:47:36 +0100 Jiri Pirko wrote:
>>>>>> So the queues, interrupts, and other resources are also part
>>>>>> of the slice then?
>>>>>
>>>>> Yep, that seems to make sense.
>>>>>   
>>>>>> How do slice parameters like rate apply to NVMe?
>>>>>
>>>>> Not really.
>>>>>   
>>>>>> Are ports always ethernet? and slices also cover endpoints
>>>>>> with
>>>>>> transport stack offloaded to the NIC?
>>>>>
>>>>> devlink_port now can be either "ethernet" or "infiniband".
>>>>> Perhaps,
>>>>> there can be port type "nve" which would contain only some of
>>>>> the
>>>>> config options and would not have a representor "netdev/ibdev"
>>>>> linked.
>>>>> I don't know.
>>>>
>>>> I honestly find it hard to understand what that slice abstraction
>>>> is,
>>>> and which things belong to slices and which to PCI ports (or why
>>>> we even
>>>> have them).
>>>
>>> Looks like slice is a new term for sub function and we can consider
>>> this
>>> as a VMDQ VSI(intel terminology) or even a Queue group of a VSI.
>>>
>>> Today we expose VMDQ VSI via offloaded MACVLAN. This mechanism
>>> should
>>> allow us to expose it as a separate netdev.
>>
>> Kinda. Looks like with the new APIs you guys will definitely be able
>> to
>> expose VMDQ as a full(er) device, and if memory serves me well that's
>> what you wanted initially.
>>
> 
> VMDQ is just a steering based isolated set of rx tx rings pointed at by
> a dumb steering rule in the HW .. i am not sure we can just wrap them
> in their own vendor specific netdev and just call it a slice..
> 
> from what i understand, a real slice is a full isolated HW pipeline
> with its own HW resources and HW based isolation, a slice rings/hw
> resources can never be shared between different slices, just like a vf,
> but without the pcie virtual function back-end..

The above definition of slice matches a VMDQ VSI. It is an isolated set 
of queues/interrupt vectors/rss and packet steering rules can be added 
to steer packets from and to this entity. A PF is associated with its 
own VSI and can spawn multiple VMDQ VSIs similar to VFs.

By default a PF is associated with a single uplink port.

> 
> Why would you need a devlink slice instance for something that has only
> rx/tx rings attributes ? if we are going with such design, then i guess
> a simple rdma app with a pair of QPs can call itself a slice ..
> 
> We need a clear-cut definition of what a Sub-function slice is.. this
> RFC doesn't seem to address that clearly.
> 
>> But the sub-functions are just a subset of slices, PF and VFs also
>> have a slice associated with them.. And all those things have a port,
>> too.
>>
> 
> PFs/VFs, might have more than one port sometimes ..

Yes. When the uplink ports are in a LAG, then a PF/VF/slice should be 
able to send or receive from more than 1 port.

> 
>>>> With devices like NFP and Mellanox CX3 which have one PCI PF
>>>> maybe it
>>>> would have made sense to have a slice that covers multiple ports,
>>>> but
>>>> it seems the proposal is to have port to slice mapping be 1:1.
>>>> And rate
>>>> in those devices should still be per port not per slice.
>>>>
>>>> But this keeps coming back, and since you guys are doing all the
>>>> work,
>>>> if you really really need it..
