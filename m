Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD4C105517
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 16:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbfKUPKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 10:10:38 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:60890 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726396AbfKUPKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 10:10:38 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 3EC90B40086;
        Thu, 21 Nov 2019 15:10:33 +0000 (UTC)
Received: from [10.17.20.62] (10.17.20.62) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Thu, 21 Nov
 2019 15:10:29 +0000
Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
To:     Jason Wang <jasowang@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
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
From:   Martin Habets <mhabets@solarflare.com>
Message-ID: <30b968cf-0e11-a2c6-5b9f-5518df11dfb7@solarflare.com>
Date:   Thu, 21 Nov 2019 15:10:28 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <a40c09ee-0915-f10c-650e-7539726a887b@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.17.20.62]
X-ClientProxiedBy: ukex01.SolarFlarecom.com (10.17.10.4) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25056.003
X-TM-AS-Result: No-19.137600-8.000000-10
X-TMASE-MatchedRID: pS5owHKhBO1EgaBf5eVRwvZvT2zYoYOwC/ExpXrHizxG7aLtT3oj+1V6
        aspoCMU5Vdnu62RDFl3KlvyYvAsge5tfgr8OpXQ1k3rl+MaNgxB/9Mg6o+wMi2MunwKby/AX8bf
        335SL+13odsFwcKBbWFeW9JSfjqoz5yodNBcVanvxWp8B+pjaLEjkgoGa55VaGlfXMQvierc5lg
        Gvol4htcuyL1xicPTjiRwyBTNWvIkp3x8GZfcBJ+CdOJAyA+r+KsyJ61LbQNE4XREg9Ki10zdhc
        m28o6c5aq8vueB+8A4mILDD37WsMB6ElTNWlXcRKhQHv3RCSeobqh1kJGkuzuQydRUvl3QT6I9N
        7ME4lokxicNUzIllOzgKnJS0afWRUjOzl6DaSNi8coKUcaOOvRhH6ApagZfO31GU/N5W5BCwYDW
        nvg3cdYXq9ri0zfwLZ9lUscLzlMdarFKFj/o9tEaMPBFKXyAUjhdrcmlB7cPwOeqRlsRlmL7Ito
        zLGgGlFr4+WtcC2nG8mPUQrzsMxcTbdJDW4qIevOAv94sAIMRPEvlTYRZqW2+fXVEQ/fGeKXRoJ
        DhFIVLfJak/J36VrfYx6jUoivPIoY4CCMZTc/2ie2FBq5CMBsnlJe2gk8vIU20Pec0W1lZiQVtY
        RZRKYoI5J68buzlI7MOZRXlUGwukTrky6gW005QIUr76ankw+KgiyLtJrSCd9kYGaE+7T3d7bci
        /LVuNWgY0bZC9uZO88GErcrkUGR4YrUf5Zsout0cS/uxH87AHgh3sKJBzP7cykxYb8lUiKRF4XB
        XsUf59LQinZ4QefNQdB5NUNSsi1GcRAJRT6PP3FLeZXNZS4DXnYt5w4ccjtcsE/u6ZQxsQVhgP3
        pPVUJFMT0dtEBA7U7BMBGNa2anSQta5VZxu6g==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--19.137600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25056.003
X-MDID: 1574349035-oAJ5_rzQ6a9u
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/11/2019 04:08, Jason Wang wrote:
> 
> On 2019/11/16 上午7:25, Parav Pandit wrote:
>> Hi Jeff,
>>
>>> From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
>>> Sent: Friday, November 15, 2019 4:34 PM
>>>
>>> From: Dave Ertman <david.m.ertman@intel.com>
>>>
>>> This is the initial implementation of the Virtual Bus, virtbus_device and
>>> virtbus_driver.  The virtual bus is a software based bus intended to support
>>> lightweight devices and drivers and provide matching between them and
>>> probing of the registered drivers.
>>>
>>> The primary purpose of the virual bus is to provide matching services and to
>>> pass the data pointer contained in the virtbus_device to the virtbus_driver
>>> during its probe call.  This will allow two separate kernel objects to match up
>>> and start communication.
>>>
>> It is fundamental to know that rdma device created by virtbus_driver will be anchored to which bus for an non abusive use.
>> virtbus or parent pci bus?
>> I asked this question in v1 version of this patch.
>>
>> Also since it says - 'to support lightweight devices', documenting that information is critical to avoid ambiguity.
>>
>> Since for a while I am working on the subbus/subdev_bus/xbus/mdev [1] whatever we want to call it, it overlaps with your comment about 'to support lightweight devices'.
>> Hence let's make things crystal clear weather the purpose is 'only matching service' or also 'lightweight devices'.
>> If this is only matching service, lets please remove lightweight devices part..
> 
> 
> Yes, if it's matching + lightweight device, its function is almost a duplication of mdev. And I'm working on extending mdev[1] to be a generic module to support any types of virtual devices a while. The advantage of mdev is:
> 
> 1) ready for the userspace driver (VFIO based)
> 2) have a sysfs/GUID based management interface

In my view this virtual-bus is more generic and more flexible than mdev.
What for you are the advantages of mdev to me are some of it's disadvantages.

The way I see it we can provide rdma support in the driver using virtual-bus.
At the moment we would need separate mdev support in the driver for vdpa, but I hope at some point mdev
would become a layer on top of virtual-bus.
Besides these users we also support internal tools for our hardware factory provisioning, and for testing/debugging.
I could easily imagine such tools using a virtual-bus device. With mdev those interfaces would be more convoluted.

> So for 1, it's not clear that how userspace driver would be supported here, or it's completely not being accounted in this series? For 2, it looks to me that this series leave it to the implementation, this means management to learn several vendor specific interfaces which seems a burden.
> 
> Note, technically Virtual Bus could be implemented on top of [1] with the full lifecycle API.

Seems easier to me to do that the other way around: mdev could be implemented on top of virtual-bus.

Best regards,
Martin

> [1] https://lkml.org/lkml/2019/11/18/261
> 
> 
>>
>> You additionally need modpost support for id table integration to modifo, modprobe and other tools.
>> A small patch similar to this one [2] is needed.
>> Please include in the series.
>>
>> [..]
> 
> 
> And probably a uevent method. But rethinking of this, matching through a single virtual bus seems not good. What if driver want to do some specific matching? E.g for virtio, we may want a vhost-net driver that only match networking device. With a single bus, it probably means you need another bus on top and provide the virtio specific matching there. This looks not straightforward as allowing multiple type of buses.
> 
> Thanks
> 
