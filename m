Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88340109DE6
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 13:26:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbfKZM0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 07:26:41 -0500
Received: from dispatchb-us1.ppe-hosted.com ([148.163.129.53]:33426 "EHLO
        dispatchb-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727408AbfKZM0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 07:26:41 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 6CC09B40060;
        Tue, 26 Nov 2019 12:26:38 +0000 (UTC)
Received: from [10.17.20.62] (10.17.20.62) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 26 Nov
 2019 12:26:32 +0000
Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
To:     Parav Pandit <parav@mellanox.com>,
        Jason Wang <jasowang@redhat.com>,
        "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     Dave Ertman <david.m.ertman@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>, Kiran Patil <kiran.patil@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Bie, Tiwei" <tiwei.bie@intel.com>
References: <20191115223355.1277139-1-jeffrey.t.kirsher@intel.com>
 <AM0PR05MB4866CF61828A458319899664D1700@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <a40c09ee-0915-f10c-650e-7539726a887b@redhat.com>
 <30b968cf-0e11-a2c6-5b9f-5518df11dfb7@solarflare.com>
 <22dd6ae3-03f4-1432-2935-8df5e9a449de@redhat.com>
 <AM0PR05MB48660C6FDCC2397045A03139D1490@AM0PR05MB4866.eurprd05.prod.outlook.com>
From:   Martin Habets <mhabets@solarflare.com>
Message-ID: <e8ab3603-59e1-6e1c-67c2-e1a252ba0ac1@solarflare.com>
Date:   Tue, 26 Nov 2019 12:26:31 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <AM0PR05MB48660C6FDCC2397045A03139D1490@AM0PR05MB4866.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.17.20.62]
X-ClientProxiedBy: ukex01.SolarFlarecom.com (10.17.10.4) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25066.003
X-TM-AS-Result: No-18.701500-8.000000-10
X-TMASE-MatchedRID: jFqw+1pFnMzmLzc6AOD8DfHkpkyUphL9F03B4pKYOlpigV5T7Tqql84L
        17Ff01Q6YNyi74Dz4unKlvyYvAsge5tfgr8OpXQ1k3rl+MaNgxB/9Mg6o+wMi2MunwKby/AX8bf
        335SL+13odsFwcKBbWFeW9JSfjqoz5yodNBcVanvxWp8B+pjaLEjkgoGa55VaGlfXMQvierc5lg
        Gvol4htcuyL1xicPTjiRwyBTNWvIkp3x8GZfcBJ+CdOJAyA+r+KsyJ61LbQNE4XREg9Ki10zdhc
        m28o6c5aq8vueB+8A4mILDD37WsMB6ElTNWlXcRhQwmwdAU7bJ+S5m2/8VLmsbqJYow2PWAiLrI
        VMftV9DUg/iVNq54d+krMMfsexf8Yw1f/0r5B94SEYfcJF0pRUyQ5fRSh2654PdcWsl+C/NELTG
        dk31MLk+eXyxfU5RZC3HydM2pinRArPgBK8zY08HsX2PFRfjyI+eq7xVYCex2AfDzADsQvBMGtP
        kUyFbdI46DLox8gbYMz967EGJwve5mL/Sp2zN3G1irzdc6gUrfIfhOVHn3rwgkOX8lkyplSOyNC
        5TSRSgjQqy88D9fRFkfqj4gb6DeBl1FgOhHkQAZSUX8zcPGnzxWJr0lgcJA/+uCP2dxbP2h7GAY
        tRVjIzk81bNX2Ax56ACyz2nhQEqiN61W1OfKwWXaK3KHx/xpg995jv1FbzNXXbZeMl1WD1QZRxa
        evz0mosWfwum7JB5CVuJFH9Q2ZWxT9nh71nDAB0c2kG7Gs6gx8U5ikIj+4hbozYDXkvVASexZj0
        5FuRI5+h7fOIvM3YfPhFyBDiUgCYZuk4xOLzWrm7DrUlmNkF+24nCsUSFNt7DW3B48kkEA+kaY6
        kBmhfoLR4+zsDTtEPs/OvZqkzPS3Rxy14J4N3BOOYXiuTqFDavVaPovLrFbG4rSDCRtF2FwJMCB
        HqTENkUSDDq742k=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--18.701500-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25066.003
X-MDID: 1574771200-4Qi-RFoW_L7m
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/11/2019 16:19, Parav Pandit wrote:
> 
> 
>> From: Jason Wang <jasowang@redhat.com>
>> Sent: Friday, November 22, 2019 3:14 AM
>>
>> On 2019/11/21 下午11:10, Martin Habets wrote:
>>> On 19/11/2019 04:08, Jason Wang wrote:
>>>> On 2019/11/16 上午7:25, Parav Pandit wrote:
>>>>> Hi Jeff,
>>>>>
>>>>>> From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
>>>>>> Sent: Friday, November 15, 2019 4:34 PM
>>>>>>
>>>>>> From: Dave Ertman <david.m.ertman@intel.com>
>>>>>>
>>>>>> This is the initial implementation of the Virtual Bus,
>>>>>> virtbus_device and virtbus_driver.  The virtual bus is a software
>>>>>> based bus intended to support lightweight devices and drivers and
>>>>>> provide matching between them and probing of the registered drivers.
>>>>>>
>>>>>> The primary purpose of the virual bus is to provide matching
>>>>>> services and to pass the data pointer contained in the
>>>>>> virtbus_device to the virtbus_driver during its probe call.  This
>>>>>> will allow two separate kernel objects to match up and start
>> communication.
>>>>>>
>>>>> It is fundamental to know that rdma device created by virtbus_driver will
>> be anchored to which bus for an non abusive use.
>>>>> virtbus or parent pci bus?
>>>>> I asked this question in v1 version of this patch.
>>>>>
>>>>> Also since it says - 'to support lightweight devices', documenting that
>> information is critical to avoid ambiguity.
>>>>>
>>>>> Since for a while I am working on the subbus/subdev_bus/xbus/mdev [1]
>> whatever we want to call it, it overlaps with your comment about 'to support
>> lightweight devices'.
>>>>> Hence let's make things crystal clear weather the purpose is 'only
>> matching service' or also 'lightweight devices'.
>>>>> If this is only matching service, lets please remove lightweight devices
>> part..
>>>>
>>>> Yes, if it's matching + lightweight device, its function is almost a duplication
>> of mdev. And I'm working on extending mdev[1] to be a generic module to
>> support any types of virtual devices a while. The advantage of mdev is:
>>>>
>>>> 1) ready for the userspace driver (VFIO based)
>>>> 2) have a sysfs/GUID based management interface
>>> In my view this virtual-bus is more generic and more flexible than mdev.
>>
>>
>> Even after the series [1] here?

I have been following that series. It does make mdev more flexible, and almost turns it into a real bus.
Even with those improvements to mdev the virtual-bus is in my view still more generic and more flexible,
and hence more future-proof.

>>
>>> What for you are the advantages of mdev to me are some of it's
>> disadvantages.
>>>
>>> The way I see it we can provide rdma support in the driver using virtual-bus.
>>
> This is fine, because it is only used for matching service.
> 
>>
>> Yes, but since it does matching only, you can do everything you want.
>> But it looks to me Greg does not want a bus to be an API multiplexer. So if a
>> dedicated bus is desired, it won't be much of code to have a bus on your own.

I did not intend for it to be a multiplexer. And I very much prefer a generic bus over a any driver specific bus.

> Right. virtbus shouldn't be a multiplexer.
> Otherwise mdev can be improved (abused) exactly the way virtbus might. Where 'mdev m stands for multiplexer too'. :-)
> No, we shouldn’t do that.
> 
> Listening to Greg and Jason G, I agree that virtbus shouldn't be a multiplexer.
> There are few basic differences between subfunctions and matching service device object.
> Subfunctions over period of time will have several attributes, few that I think of right away are:
> 1. BAR resource info, write combine info
> 2. irq vectors details
> 3. unique id assigned by user (while virtbus will not assign such user id as they are auto created for matching service for PF/VF)
> 4. rdma device created by matched driver resides on pci bus or parent device
> While rdma and netdev created on over subfunctions are linked to their own 'struct device'.

This is more aligned with my thinking as well, although I do not call these items subfunctions.
There can be different devices for different users, where multiple can be active at the same time (with some constraints).

One important thing to note is that there may not not be a netdev device. What we traditionally call
a "network driver" will then only manage the virtualised devices.

> Due to that sysfs view for these two different types of devices is bit different.
> Putting both on same bus just doesn't appear right with above fundamental differences of core layer.

Can you explain which code layer you mean?

>>
>>> At the moment we would need separate mdev support in the driver for
>>> vdpa, but I hope at some point mdev would become a layer on top of virtual-
>> bus.
> 
> How is it optimal to create multiple 'struct device' for single purpose?
> Especially when one wants to create hundreds of such devices to begin with.
> User facing tool should be able to select device type and place the device on right bus.

At this point I think it is not possible to create a solution that is optimal right now for all use cases.
With the virtual bus we do have a solid foundation going forward, for the users we know now and for
future ones. Optimisation is something that needs to happen over time, without breaking existing users.

As for the user facing tool, the only one I know of that always works is "echo" into a sysfs file.

Best regards,
Martin
