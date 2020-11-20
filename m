Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 897622BB4D2
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 20:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbgKTTFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 14:05:01 -0500
Received: from mga02.intel.com ([134.134.136.20]:9321 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728076AbgKTTFB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 14:05:01 -0500
IronPort-SDR: 4zufoNuOFPoZGc8FzMJqn3znsOtane1EosHYeCA7VOwfKAQBULdKtIY6eAbI3VyYJraIJc5Uqg
 7Vso+ndp34Tw==
X-IronPort-AV: E=McAfee;i="6000,8403,9811"; a="158565661"
X-IronPort-AV: E=Sophos;i="5.78,357,1599548400"; 
   d="scan'208";a="158565661"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2020 11:05:00 -0800
IronPort-SDR: QBKjPBBsZEmFGsx663jgoy4cwnhq5ufK9+gxSEnrTms1yZQn13aH6MIFzLPrazf/ZGDRW0XrtJ
 sO49+RDyXMZw==
X-IronPort-AV: E=Sophos;i="5.78,357,1599548400"; 
   d="scan'208";a="533658276"
Received: from samudral-mobl.amr.corp.intel.com (HELO [10.212.234.235]) ([10.212.234.235])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2020 11:04:59 -0800
Subject: Re: [PATCH net-next 00/13] Add mlx5 subfunction support
To:     Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@gmail.com>, Jason Gunthorpe <jgg@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <20201112192424.2742-1-parav@nvidia.com>
 <20201116145226.27b30b1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <cdd576ebad038a3a9801e7017b7794e061e3ddcc.camel@kernel.org>
 <20201116175804.15db0b67@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BY5PR12MB43229F23C101AFBCD2971534DCE20@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20201117091120.0c933a4c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20201117184954.GV917484@nvidia.com>
 <20201118181423.28f8090e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <96e59cf0-1423-64af-1da9-bd740b393fa8@gmail.com>
 <20201119172930.11ab9e68@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAKgT0Uf4i9hrq6Z4dx03sv_ubVpZwKm5Tiz+-UwJp38cTyZg+g@mail.gmail.com>
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Message-ID: <102d20e1-c78f-09cb-fabb-efdc59f61eb8@intel.com>
Date:   Fri, 20 Nov 2020 11:04:58 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <CAKgT0Uf4i9hrq6Z4dx03sv_ubVpZwKm5Tiz+-UwJp38cTyZg+g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/20/2020 9:58 AM, Alexander Duyck wrote:
> On Thu, Nov 19, 2020 at 5:29 PM Jakub Kicinski <kuba@kernel.org> wrote:
>>
>> On Wed, 18 Nov 2020 21:35:29 -0700 David Ahern wrote:
>>> On 11/18/20 7:14 PM, Jakub Kicinski wrote:
>>>> On Tue, 17 Nov 2020 14:49:54 -0400 Jason Gunthorpe wrote:
>>>>> On Tue, Nov 17, 2020 at 09:11:20AM -0800, Jakub Kicinski wrote:
>>>>>
>>>>>>> Just to refresh all our memory, we discussed and settled on the flow
>>>>>>> in [2]; RFC [1] followed this discussion.
>>>>>>>
>>>>>>> vdpa tool of [3] can add one or more vdpa device(s) on top of already
>>>>>>> spawned PF, VF, SF device.
>>>>>>
>>>>>> Nack for the networking part of that. It'd basically be VMDq.
>>>>>
>>>>> What are you NAK'ing?
>>>>
>>>> Spawning multiple netdevs from one device by slicing up its queues.
>>>
>>> Why do you object to that? Slicing up h/w resources for virtual what
>>> ever has been common practice for a long time.
>>
>> My memory of the VMDq debate is hazy, let me rope in Alex into this.
>> I believe the argument was that we should offload software constructs,
>> not create HW-specific APIs which depend on HW availability and
>> implementation. So the path we took was offloading macvlan.
> 
> I think it somewhat depends on the type of interface we are talking
> about. What we were wanting to avoid was drivers spawning their own
> unique VMDq netdevs and each having a different way of doing it. The
> approach Intel went with was to use a MACVLAN offload to approach it.
> Although I would imagine many would argue the approach is somewhat
> dated and limiting since you cannot do many offloads on a MACVLAN
> interface.

Yes. We talked about this at netdev 0x14 and the limitations of macvlan 
based offloads.
https://netdevconf.info/0x14/session.html?talk-hardware-acceleration-of-container-networking-interfaces

Subfunction seems to be a good model to expose VMDq VSI or SIOV ADI as a 
netdev for kernel containers. AF_XDP ZC in a container is one of the 
usecase this would address. Today we have to pass the entire PF/VF to a 
container to do AF_XDP.

Looks like the current model is to create a subfunction of a specific 
type on auxiliary bus, do some configuration to assign resources and 
then activate the subfunction.

> 
> With the VDPA case I believe there is a set of predefined virtio
> devices that are being emulated and presented so it isn't as if they
> are creating a totally new interface for this.
> 
> What I would be interested in seeing is if there are any other vendors
> that have reviewed this and sign off on this approach. What we don't
> want to see is Nivida/Mellanox do this one way, then Broadcom or Intel
> come along later and have yet another way of doing this. We need an
> interface and feature set that will work for everyone in terms of how
> this will look going forward.

