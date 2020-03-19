Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5411918B28D
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 12:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgCSLuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 07:50:00 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:35446 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726188AbgCSLuA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 07:50:00 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id C6646480064;
        Thu, 19 Mar 2020 11:49:57 +0000 (UTC)
Received: from [10.17.20.62] (10.17.20.62) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Thu, 19 Mar
 2020 11:49:53 +0000
Subject: Re: [RFC PATCH v4 10/25] RDMA/irdma: Add driver framework definitions
To:     Jason Gunthorpe <jgg@ziepe.ca>, Parav Pandit <parav@mellanox.com>
CC:     "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>
References: <20200212191424.1715577-1-jeffrey.t.kirsher@intel.com>
 <20200212191424.1715577-11-jeffrey.t.kirsher@intel.com>
 <6f01d517-3196-1183-112e-8151b821bd72@mellanox.com>
 <9DD61F30A802C4429A01CA4200E302A7C60C94AF@fmsmsx124.amr.corp.intel.com>
 <AM0PR05MB4866395BD477FAD269BCAE07D1130@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <9DD61F30A802C4429A01CA4200E302A7C60CE4C4@fmsmsx124.amr.corp.intel.com>
 <b8263bea-fd0f-345e-b497-d5531dc63554@mellanox.com>
 <20200221180427.GL31668@ziepe.ca>
From:   Martin Habets <mhabets@solarflare.com>
Message-ID: <745514bf-80a0-db20-044b-220a9f49e71f@solarflare.com>
Date:   Thu, 19 Mar 2020 11:49:52 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200221180427.GL31668@ziepe.ca>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.62]
X-ClientProxiedBy: ukex01.SolarFlarecom.com (10.17.10.4) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25300.003
X-TM-AS-Result: No-12.703500-8.000000-10
X-TMASE-MatchedRID: ZFzIhWOuIzvmLzc6AOD8DfHkpkyUphL9GbJMFqqIm9z5+tteD5Rzha6+
        UxOBi85N24tqHTHJmVXa/g/NGTW3Mk35WIWBwPo02hLNwCAdUPiD33mO/UVvMyE1JvW2fYa9smc
        +HzD5Hmi62ywKGGMysDNFIrN/Vt9sYTXYZm8jWOUr1glPpqgMG3yzRzLq38pIKjjlLG8O6u+Ypu
        G7kpoKR9KnI5FyUdwyBYjoXaYrmv++L9dc5lmniub3p4cnIXGNB4Id7CiQcz+YeMTPaAHLLcCFO
        gbeAbERQgjA2Itda2IUsaXRuE4OZqVIsznpoCaY9VjtTc1fwmA2vbWaKPnQ22AMM0WKD4as1jqf
        1r9/odYCQPxvuU25lKeAlEiFDc3dAqsA4DtLDcxHg88w74mNDuRo6SIMqLecBCzD0Dc8iUtRLTE
        RhRg1g+HdKiXhYPHWNDqav/CGQyuLBJcjq3oXqD2gUycsvOMF1JP9NndNOkV7eGs179ltWfFdHM
        D3AvmRi1xd/4mI/4CFGo7M/s8DiaG06k9cn1gViPIR0a1i6hd3ipg0lIGuKJsoi2XrUn/JyeMtM
        D9QOgChMIDkR/KfwI2j49Ftap9EOwBXM346/+y0MMRbgrM41GDYRJi6QYs1Fkf2abs520Uj7jco
        F6NGbpndNYHoMPQc
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--12.703500-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25300.003
X-MDID: 1584618599-Rx2pbd7JB5q3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/02/2020 18:04, Jason Gunthorpe wrote:
> On Fri, Feb 21, 2020 at 05:23:31PM +0000, Parav Pandit wrote:
>> On 2/21/2020 11:01 AM, Saleem, Shiraz wrote:
>>>> Subject: RE: [RFC PATCH v4 10/25] RDMA/irdma: Add driver framework
>>>> definitions
>>>>
>>>
>>> [....]
>>>
>>>>>>> +static int irdma_devlink_reload_up(struct devlink *devlink,
>>>>>>> +				   struct netlink_ext_ack *extack) {
>>>>>>> +	struct irdma_dl_priv *priv = devlink_priv(devlink);
>>>>>>> +	union devlink_param_value saved_value;
>>>>>>> +	const struct virtbus_dev_id *id = priv->vdev->matched_element;
>>>>>>
>>>>>> Like irdma_probe(), struct iidc_virtbus_object *vo is accesible for
>>>>>> the given
>>>>> priv.
>>>>>> Please use struct iidc_virtbus_object for any sharing between two drivers.
>>>>>> matched_element modification inside the virtbus match() function and
>>>>>> accessing pointer to some driver data between two driver through
>>>>>> this matched_element is not appropriate.
>>>>>
>>>>> We can possibly avoid matched_element and driver data look up here.
>>>>> But fundamentally, at probe time (see irdma_gen_probe) the irdma
>>>>> driver needs to know which generation type of vdev we bound to. i.e. i40e or ice
>>>> ?
>>>>> since we support both.
>>>>> And based on it, extract the driver specific virtbus device object,
>>>>> i.e i40e_virtbus_device vs iidc_virtbus_object and init that device.
>>>>>
>>>>> Accessing driver_data off the vdev matched entry in
>>>>> irdma_virtbus_id_table is how we know this generation info and make the
>>>> decision.
>>>>>
>>>> If there is single irdma driver for two different virtbus device types, it is better to
>>>> have two instances of virtbus_register_driver() with different matching string/id.
>>>> So based on the probe(), it will be clear with virtbus device of interest got added.
>>>> This way, code will have clear separation between two device types.
>>>
>>> Thanks for the feedback!
>>> Is it common place to have multiple driver_register instances of same bus type
>>> in a driver to support different devices? Seems odd.
>>> Typically a single driver that supports multiple device types for a specific bus-type
>>> would do a single bus-specific driver_register and pass in an array of bus-specific
>>> device IDs and let the bus do the match up for you right? And in the probe(), a driver could do device
>>> specific quirks for the device types. Isnt that purpose of device ID tables for pci, platform, usb etc?
>>> Why are we trying to handle multiple virtbus device types from a driver any differently?
>>>
>>
>> If differences in treating the two devices is not a lot, if you have lot
>> of common code, it make sense to do single virtbus_register_driver()
>> with two different ids.
>> In that case, struct virtbus_device_id should have some device specific
>> field like how pci has driver_data.
>>
>> It should not be set by the match() function by virtbus core.
>> This field should be setup in the id table by the hw driver which
>> invokes virtbus_register_device().
> 
> Yes
> 
> I think the basic point here is that the 'id' should specify what
> container_of() is valid on the virtbus_device
> 
> And for things like this where we want to make a many to one
> connection then it makes sense to permute the id for each 'connection
> point'
> 
> ie, if the id was a string like OF uses maybe you'd have
> 
>  intel,i40e,rdma
>  intel,i40e,ethernet
>  intel,ice,rdma
> 
> etc
> 
> A string for match id is often a good idea..
> 
> And I'd suggest introducing a matching alloc so it is all clear and
> type safe:
> 
>    struct mydev_struct mydev;
> 
>    mydev = virtbus_alloc(parent, "intel,i40e,rdma", struct mydev_struct,
>                          vbus_dev);
> 
> 
>    [..]
>    virtbus_register(&mydev->vbus_dev);

I'd like to see something like this as well. In my experiments for a single type of device I've been doing this,
which works fine but is not future-proof:

	struct sfc_rdma_dev *rdev;

	rdev = kzalloc(sizeof(*rdev), GFP_KERNEL);
	if (!rdev)
		return -ENOMEM;

	/* This is like virtbus_dev_alloc() but using our own memory. */
	rdev->vdev.name = SFC_RDMA_DEVNAME;
	rdev->vdev.data = (void *) &rdma_devops;
	rdev->vdev.dev.release = efx_rdma_dev_release;

Martin
