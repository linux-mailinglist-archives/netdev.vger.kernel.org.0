Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3602CB4B9
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 06:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbgLBFxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 00:53:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21314 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725902AbgLBFxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 00:53:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606888301;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RFNrxlfJJuhhi00J7j2KUdF0PQdEfquJMmeof7OL03I=;
        b=V88KFLgCbOMdmAdXnHUPgKlzc872hzZ4O+29x4WRB9I4dJ2dHL+m7T6gmz0yvLnAcx7QOp
        IG+RkasuLY+mYumxhHg6bfcqobxwpfMfrlNdq+L24KL9udiXdFiuMAOHow/7KCu9cwuSvs
        xbPzwNyWk/jSgYOwFE6VkBF6lvBRgvk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-539-Wo0SWSAAPmu0ji6cCiaN2Q-1; Wed, 02 Dec 2020 00:51:38 -0500
X-MC-Unique: Wo0SWSAAPmu0ji6cCiaN2Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B64D1817B8C;
        Wed,  2 Dec 2020 05:51:36 +0000 (UTC)
Received: from [10.72.13.145] (ovpn-13-145.pek2.redhat.com [10.72.13.145])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 726EC5B4A0;
        Wed,  2 Dec 2020 05:51:30 +0000 (UTC)
Subject: Re: [External] Re: [PATCH 0/7] Introduce vdpa management tool
To:     Parav Pandit <parav@nvidia.com>,
        Yongji Xie <xieyongji@bytedance.com>
Cc:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, Eli Cohen <elic@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20201112064005.349268-1-parav@nvidia.com>
 <5b2235f6-513b-dbc9-3670-e4c9589b4d1f@redhat.com>
 <CACycT3sYScObb9nN3g7L3cesjE7sCZWxZ5_5R1usGU9ePZEeqA@mail.gmail.com>
 <182708df-1082-0678-49b2-15d0199f20df@redhat.com>
 <CACycT3votu2eyacKg+w12xZ_ujEOgTY0f8A7qcpbM-fwTpjqAw@mail.gmail.com>
 <7f80eeed-f5d3-8c6f-1b8c-87b7a449975c@redhat.com>
 <CACycT3uw6KJgTo+dBzSj07p2P_PziD+WBfX4yWVX-nDNUD2M3A@mail.gmail.com>
 <DM6PR12MB4330173AF4BA08FE12F68B5BDCF40@DM6PR12MB4330.namprd12.prod.outlook.com>
 <CACycT3tTCmEzY37E5196Q2mqME2v+KpAp7Snn8wK4XtRKHEqEw@mail.gmail.com>
 <BY5PR12MB4322C80FB3C76B85A2D095CCDCF40@BY5PR12MB4322.namprd12.prod.outlook.com>
 <CACycT3vNXvNVUP+oqzv-MMgtzneeeZUoMaDVtEws7VizH0V+mA@mail.gmail.com>
 <BY5PR12MB4322446CDB07B3CC5603F7D1DCF30@BY5PR12MB4322.namprd12.prod.outlook.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <3d91bf80-1a35-9f79-dbca-596358acc0a7@redhat.com>
Date:   Wed, 2 Dec 2020 13:51:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <BY5PR12MB4322446CDB07B3CC5603F7D1DCF30@BY5PR12MB4322.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/12/2 下午12:53, Parav Pandit wrote:
>
>> From: Yongji Xie <xieyongji@bytedance.com>
>> Sent: Wednesday, December 2, 2020 9:00 AM
>>
>> On Tue, Dec 1, 2020 at 11:59 PM Parav Pandit <parav@nvidia.com> wrote:
>>>
>>>
>>>> From: Yongji Xie <xieyongji@bytedance.com>
>>>> Sent: Tuesday, December 1, 2020 7:49 PM
>>>>
>>>> On Tue, Dec 1, 2020 at 7:32 PM Parav Pandit <parav@nvidia.com> wrote:
>>>>>
>>>>>
>>>>>> From: Yongji Xie <xieyongji@bytedance.com>
>>>>>> Sent: Tuesday, December 1, 2020 3:26 PM
>>>>>>
>>>>>> On Tue, Dec 1, 2020 at 2:25 PM Jason Wang <jasowang@redhat.com>
>>>> wrote:
>>>>>>>
>>>>>>> On 2020/11/30 下午3:07, Yongji Xie wrote:
>>>>>>>>>> Thanks for adding me, Jason!
>>>>>>>>>>
>>>>>>>>>> Now I'm working on a v2 patchset for VDUSE (vDPA Device in
>>>>>>>>>> Userspace) [1]. This tool is very useful for the vduse device.
>>>>>>>>>> So I'm considering integrating this into my v2 patchset.
>>>>>>>>>> But there is one problem：
>>>>>>>>>>
>>>>>>>>>> In this tool, vdpa device config action and enable action
>>>>>>>>>> are combined into one netlink msg: VDPA_CMD_DEV_NEW. But
>>>>>>>>>> in
>>>> vduse
>>>>>>>>>> case, it needs to be splitted because a chardev should be
>>>>>>>>>> created and opened by a userspace process before we enable
>>>>>>>>>> the vdpa device (call vdpa_register_device()).
>>>>>>>>>>
>>>>>>>>>> So I'd like to know whether it's possible (or have some
>>>>>>>>>> plans) to add two new netlink msgs something like:
>>>>>>>>>> VDPA_CMD_DEV_ENABLE
>>>>>> and
>>>>>>>>>> VDPA_CMD_DEV_DISABLE to make the config path more flexible.
>>>>>>>>>>
>>>>>>>>> Actually, we've discussed such intermediate step in some
>>>>>>>>> early discussion. It looks to me VDUSE could be one of the users of
>> this.
>>>>>>>>> Or I wonder whether we can switch to use anonymous
>>>>>>>>> inode(fd) for VDUSE then fetching it via an VDUSE_GET_DEVICE_FD
>> ioctl?
>>>>>>>> Yes, we can. Actually the current implementation in VDUSE is
>>>>>>>> like this.  But seems like this is still a intermediate step.
>>>>>>>> The fd should be binded to a name or something else which
>>>>>>>> need to be configured before.
>>>>>>>
>>>>>>> The name could be specified via the netlink. It looks to me
>>>>>>> the real issue is that until the device is connected with a
>>>>>>> userspace, it can't be used. So we also need to fail the
>>>>>>> enabling if it doesn't
>>>> opened.
>>>>>> Yes, that's true. So you mean we can firstly try to fetch the fd
>>>>>> binded to a name/vduse_id via an VDUSE_GET_DEVICE_FD, then use
>>>>>> the name/vduse_id as a attribute to create vdpa device? It looks fine to
>> me.
>>>>> I probably do not well understand. I tried reading patch [1] and
>>>>> few things
>>>> do not look correct as below.
>>>>> Creating the vdpa device on the bus device and destroying the
>>>>> device from
>>>> the workqueue seems unnecessary and racy.
>>>>> It seems vduse driver needs
>>>>> This is something should be done as part of the vdpa dev add
>>>>> command,
>>>> instead of connecting two sides separately and ensuring race free
>>>> access to it.
>>>>> So VDUSE_DEV_START and VDUSE_DEV_STOP should possibly be avoided.
>>>>>
>>>> Yes, we can avoid these two ioctls with the help of the management tool.
>>>>
>>>>> $ vdpa dev add parentdev vduse_mgmtdev type net name foo2
>>>>>
>>>>> When above command is executed it creates necessary vdpa device
>>>>> foo2
>>>> on the bus.
>>>>> When user binds foo2 device with the vduse driver, in the probe(),
>>>>> it
>>>> creates respective char device to access it from user space.
>>>>
>>> I see. So vduse cannot work with any existing vdpa devices like ifc, mlx5 or
>> netdevsim.
>>> It has its own implementation similar to fuse with its own backend of choice.
>>> More below.
>>>
>>>> But vduse driver is not a vdpa bus driver. It works like vdpasim
>>>> driver, but offloads the data plane and control plane to a user space process.
>>> In that case to draw parallel lines,
>>>
>>> 1. netdevsim:
>>> (a) create resources in kernel sw
>>> (b) datapath simulates in kernel
>>>
>>> 2. ifc + mlx5 vdpa dev:
>>> (a) creates resource in hw
>>> (b) data path is in hw
>>>
>>> 3. vduse:
>>> (a) creates resources in userspace sw
>>> (b) data path is in user space.
>>> hence creates data path resources for user space.
>>> So char device is created, removed as result of vdpa device creation.
>>>
>>> For example,
>>> $ vdpa dev add parentdev vduse_mgmtdev type net name foo2
>>>
>>> Above command will create char device for user space.
>>>
>>> Similar command for ifc/mlx5 would have created similar channel for rest of
>> the config commands in hw.
>>> vduse channel = char device, eventfd etc.
>>> ifc/mlx5 hw channel = bar, irq, command interface etc Netdev sim
>>> channel = sw direct calls
>>>
>>> Does it make sense?
>> In my understanding, to make vdpa work, we need a backend (datapath
>> resources) and a frontend (a vdpa device attached to a vdpa bus). In the above
>> example, it looks like we use the command "vdpa dev add ..."
>>   to create a backend, so do we need another command to create a frontend?
>>
> For block device there is certainly some backend to process the IOs.
> Sometimes backend to be setup first, before its front end is exposed.
> "vdpa dev add" is the front end command who connects to the backend (implicitly) for network device.
>
> vhost->vdpa_block_device->backend_io_processor (usr,hw,kernel).
>
> And it needs a way to connect to backend when explicitly specified during creation time.
> Something like,
> $ vdpa dev add parentdev vdpa_vduse type block name foo3 handle <uuid>
> In above example some vendor device specific unique handle is passed based on backend setup in hardware/user space.
>
> In below 3 examples, vdpa block simulator is connecting to backend block or file.
>
> $ vdpa dev add parentdev vdpa_blocksim type block name foo4 blockdev /dev/zero
>
> $ vdpa dev add parentdev vdpa_blocksim type block name foo5 blockdev /dev/sda2 size=100M offset=10M
>
> $ vdpa dev add parentdev vdpa_block filebackend_sim type block name foo6 file /root/file_backend.txt
>
> Or may be backend connects to the created vdpa device is bound to the driver.
> Can vduse attach to the created vdpa block device through the char device and establish the channel to receive IOs, and to setup the block config space?


I think it can work.

Another thing I wonder it that, do we consider more than one VDUSE 
parentdev(or management dev)? This allows us to have separated devices 
implemented via different processes.

If yes, VDUSE ioctl needs to be extended to register/unregister parentdev.

Thanks


>
>> Thanks,
>> Yongji

