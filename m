Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 267471424AF
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 09:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgATIBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 03:01:39 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35934 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725872AbgATIBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 03:01:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579507295;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Iz/qjvodYnEnB5eFL79FzYhZwFSrGU3EpRLL9cwpXcI=;
        b=EURITZ+SqOjV5q7tLanZ7k6cj3rvCr7qPBFeWkFZ7XF0NeUWzqDey1P9JYPhqooprN6qg6
        DG4Es+o7q7Z5QtYZ2Pb0BbyUi8g9PVA+eQlYO6u7UjbtwgoN99sw4lVJ5A/8HCnaGlhJv3
        5ASmLblzD+5ajZwzWH35AFFxwTfTQDk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-68-gYKPL3i1Oa25naBeSRDvIw-1; Mon, 20 Jan 2020 03:01:33 -0500
X-MC-Unique: gYKPL3i1Oa25naBeSRDvIw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CA35A10054E3;
        Mon, 20 Jan 2020 08:01:30 +0000 (UTC)
Received: from [10.72.12.173] (ovpn-12-173.pek2.redhat.com [10.72.12.173])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B046510013A7;
        Mon, 20 Jan 2020 08:01:11 +0000 (UTC)
Subject: Re: [PATCH 5/5] vdpasim: vDPA device simulator
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     "mst@redhat.com" <mst@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tiwei.bie@intel.com" <tiwei.bie@intel.com>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "cunming.liang@intel.com" <cunming.liang@intel.com>,
        "zhihong.wang@intel.com" <zhihong.wang@intel.com>,
        "rob.miller@broadcom.com" <rob.miller@broadcom.com>,
        "xiao.w.wang@intel.com" <xiao.w.wang@intel.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "lingshan.zhu@intel.com" <lingshan.zhu@intel.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "aadam@redhat.com" <aadam@redhat.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Shahaf Shuler <shahafs@mellanox.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "mhabets@solarflare.com" <mhabets@solarflare.com>,
        "kuba@kernel.org" <kuba@kernel.org>
References: <20200116124231.20253-1-jasowang@redhat.com>
 <20200116124231.20253-6-jasowang@redhat.com>
 <20200116154658.GJ20978@mellanox.com>
 <aea2bff8-82c8-2c0f-19ee-e86db73e199f@redhat.com>
 <20200117141021.GW20978@mellanox.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <cd5477b1-7e41-aeeb-c592-09b2ec81566a@redhat.com>
Date:   Mon, 20 Jan 2020 16:01:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200117141021.GW20978@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/1/17 =E4=B8=8B=E5=8D=8810:10, Jason Gunthorpe wrote:
> On Fri, Jan 17, 2020 at 05:32:39PM +0800, Jason Wang wrote:
>> On 2020/1/16 =E4=B8=8B=E5=8D=8811:47, Jason Gunthorpe wrote:
>>> On Thu, Jan 16, 2020 at 08:42:31PM +0800, Jason Wang wrote:
>>>> This patch implements a software vDPA networking device. The datapat=
h
>>>> is implemented through vringh and workqueue. The device has an on-ch=
ip
>>>> IOMMU which translates IOVA to PA. For kernel virtio drivers, vDPA
>>>> simulator driver provides dma_ops. For vhost driers, set_map() metho=
ds
>>>> of vdpa_config_ops is implemented to accept mappings from vhost.
>>>>
>>>> A sysfs based management interface is implemented, devices are
>>>> created and removed through:
>>>>
>>>> /sys/devices/virtual/vdpa_simulator/netdev/{create|remove}
>>> This is very gross, creating a class just to get a create/remove and
>>> then not using the class for anything else? Yuk.
>>
>> It includes more information, e.g the devices and the link from vdpa_s=
im
>> device and vdpa device.
> I feel like regardless of how the device is created there should be a
> consistent virtio centric management for post-creation tasks, such as
> introspection and destruction


Right, actually, this is something that could be done by sysfs as well.=20
Having an intermediate steps as "activate" and introducing attributes=20
for post-creation tasks.


>
> A virto struct device should already have back pointers to it's parent
> device, which should be enough to discover the vdpa_sim, none of the
> extra sysfs munging should be needed.
>
>>>> Netlink based lifecycle management could be implemented for vDPA
>>>> simulator as well.
>>> This is just begging for a netlink based approach.
>>>
>>> Certainly netlink driven removal should be an agreeable standard for
>>> all devices, I think.
>>
>> Well, I think Parav had some proposals during the discussion of mdev
>> approach. But I'm not sure if he had any RFC codes for me to integrate=
 it
>> into vdpasim.
>>
>> Or do you want me to propose the netlink API? If yes, would you prefer=
 to a
>> new virtio dedicated one or be a subset of devlink?
> Well, lets see what feed back Parav has
>
> Jason


Ok.

Thanks

