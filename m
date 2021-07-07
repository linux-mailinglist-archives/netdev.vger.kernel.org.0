Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B27D3BE58F
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 11:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbhGGJ1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 05:27:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48610 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230497AbhGGJ1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 05:27:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625649865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6o/7kaTqPTYt2A7Z0zjqMN0nvm6hpJh6BNtPQwdwRLU=;
        b=FItZTbmcMZHkWreQUZuurxv8W63dsBctQVZQZcHB4yMb3NFkodMWT6U8kIr4hmNGc4+2Eb
        BotDAW93ZvlpndlBtLGfk8zSC8itL5dEzKBpHO3MhKkiCx5OvCdVtLJhfi/1PN848WmLGx
        DVx5nLy4dYlAoN3Kn7WorKqdr2+KR4c=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-NNRN_gJ0NGqRiVzmvB5DZA-1; Wed, 07 Jul 2021 05:24:24 -0400
X-MC-Unique: NNRN_gJ0NGqRiVzmvB5DZA-1
Received: by mail-pg1-f200.google.com with SMTP id o9-20020a6561490000b0290226fc371410so1302009pgv.8
        for <netdev@vger.kernel.org>; Wed, 07 Jul 2021 02:24:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=6o/7kaTqPTYt2A7Z0zjqMN0nvm6hpJh6BNtPQwdwRLU=;
        b=jI6lfCQ3HubogVy7ZvHuviBFHWhIZj/J8W6f2HvqtjVCqtCpsO8kHWEVh1rtH4MOlh
         7f90zeEYiGjxBu9GiEhYJR5DsVIMydhyGrY+RmqNyemk3N1MiOWWZVIJ9A/dO+4mUlqk
         2pQ5iDHV4MwTov5dU/O5g6DD/yWgo5398ZLCSnEWVZf59AyYGWNGU+5sx4fOULGyj835
         NXCd3EkBzadiYHcHEGS2DNTQ8QunHO7IPQbxaR1+GXW4lKgRoj8iLSq+o5F6dzPwhJcr
         Uq75ZHuBwG19pXp4bc62jfmVL4IHKYApuKKNMK0XmPuBR8cZra9qbRfSWPKqnypALyba
         p5Xg==
X-Gm-Message-State: AOAM533tih4lRiIANaQCVi8oSRf2r0lE0j759t25/jnAVIupymOmupb5
        FFegWCltetRaQyo2befFw0ipMQPswMjd8Qwi/AnqVGf7+5JImiekJzqth66UUKGY1lLpFmxdTOo
        xzHnwkegPYRAQ+Ztr
X-Received: by 2002:a63:d908:: with SMTP id r8mr25178216pgg.414.1625649863836;
        Wed, 07 Jul 2021 02:24:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzhom9V3zcwokImKdubLhhEYAw1OEUfXMki4J5NNqR0Ed07VLuH+WgHu4YOpQSJUGm/lh1JIQ==
X-Received: by 2002:a63:d908:: with SMTP id r8mr25178193pgg.414.1625649863513;
        Wed, 07 Jul 2021 02:24:23 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id md15sm5946056pjb.30.2021.07.07.02.24.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jul 2021 02:24:23 -0700 (PDT)
Subject: Re: [PATCH v8 10/10] Documentation: Add documentation for VDUSE
To:     Stefan Hajnoczi <stefanha@redhat.com>
References: <CACycT3taKhf1cWp3Jd0aSVekAZvpbR-_fkyPLQ=B+jZBB5H=8Q@mail.gmail.com>
 <YN3ABqCMLQf7ejOm@stefanha-x1.localdomain>
 <CACycT3vo-diHgTSLw_FS2E+5ia5VjihE3qw7JmZR7JT55P-wQA@mail.gmail.com>
 <8320d26d-6637-85c6-8773-49553dfa502d@redhat.com>
 <YOL/9mxkJaokKDHc@stefanha-x1.localdomain>
 <5b5107fa-3b32-8a3b-720d-eee6b2a84ace@redhat.com>
 <YOQtG3gDOhHDO5CQ@stefanha-x1.localdomain>
 <CACGkMEs2HHbUfarum8uQ6wuXoDwLQUSXTsa-huJFiqr__4cwRg@mail.gmail.com>
 <YOSOsrQWySr0andk@stefanha-x1.localdomain>
 <100e6788-7fdf-1505-d69c-bc28a8bc7a78@redhat.com>
 <YOVr801d01YOPzLL@stefanha-x1.localdomain>
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        "bcrl@kvack.org" <bcrl@kvack.org>,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Mika_Penttil=c3=a4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, joro@8bytes.org,
        gregkh@linuxfoundation.org,
        "songmuchun@bytedance.com" <songmuchun@bytedance.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <a03c8627-7dac-2255-a2d9-603fc623b618@redhat.com>
Date:   Wed, 7 Jul 2021 17:24:08 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YOVr801d01YOPzLL@stefanha-x1.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/7/7 下午4:55, Stefan Hajnoczi 写道:
> On Wed, Jul 07, 2021 at 11:43:28AM +0800, Jason Wang wrote:
>> 在 2021/7/7 上午1:11, Stefan Hajnoczi 写道:
>>> On Tue, Jul 06, 2021 at 09:08:26PM +0800, Jason Wang wrote:
>>>> On Tue, Jul 6, 2021 at 6:15 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
>>>>> On Tue, Jul 06, 2021 at 10:34:33AM +0800, Jason Wang wrote:
>>>>>> 在 2021/7/5 下午8:49, Stefan Hajnoczi 写道:
>>>>>>> On Mon, Jul 05, 2021 at 11:36:15AM +0800, Jason Wang wrote:
>>>>>>>> 在 2021/7/4 下午5:49, Yongji Xie 写道:
>>>>>>>>>>> OK, I get you now. Since the VIRTIO specification says "Device
>>>>>>>>>>> configuration space is generally used for rarely-changing or
>>>>>>>>>>> initialization-time parameters". I assume the VDUSE_DEV_SET_CONFIG
>>>>>>>>>>> ioctl should not be called frequently.
>>>>>>>>>> The spec uses MUST and other terms to define the precise requirements.
>>>>>>>>>> Here the language (especially the word "generally") is weaker and means
>>>>>>>>>> there may be exceptions.
>>>>>>>>>>
>>>>>>>>>> Another type of access that doesn't work with the VDUSE_DEV_SET_CONFIG
>>>>>>>>>> approach is reads that have side-effects. For example, imagine a field
>>>>>>>>>> containing an error code if the device encounters a problem unrelated to
>>>>>>>>>> a specific virtqueue request. Reading from this field resets the error
>>>>>>>>>> code to 0, saving the driver an extra configuration space write access
>>>>>>>>>> and possibly race conditions. It isn't possible to implement those
>>>>>>>>>> semantics suing VDUSE_DEV_SET_CONFIG. It's another corner case, but it
>>>>>>>>>> makes me think that the interface does not allow full VIRTIO semantics.
>>>>>>>> Note that though you're correct, my understanding is that config space is
>>>>>>>> not suitable for this kind of error propagating. And it would be very hard
>>>>>>>> to implement such kind of semantic in some transports.  Virtqueue should be
>>>>>>>> much better. As Yong Ji quoted, the config space is used for
>>>>>>>> "rarely-changing or intialization-time parameters".
>>>>>>>>
>>>>>>>>
>>>>>>>>> Agreed. I will use VDUSE_DEV_GET_CONFIG in the next version. And to
>>>>>>>>> handle the message failure, I'm going to add a return value to
>>>>>>>>> virtio_config_ops.get() and virtio_cread_* API so that the error can
>>>>>>>>> be propagated to the virtio device driver. Then the virtio-blk device
>>>>>>>>> driver can be modified to handle that.
>>>>>>>>>
>>>>>>>>> Jason and Stefan, what do you think of this way?
>>>>>>> Why does VDUSE_DEV_GET_CONFIG need to support an error return value?
>>>>>>>
>>>>>>> The VIRTIO spec provides no way for the device to report errors from
>>>>>>> config space accesses.
>>>>>>>
>>>>>>> The QEMU virtio-pci implementation returns -1 from invalid
>>>>>>> virtio_config_read*() and silently discards virtio_config_write*()
>>>>>>> accesses.
>>>>>>>
>>>>>>> VDUSE can take the same approach with
>>>>>>> VDUSE_DEV_GET_CONFIG/VDUSE_DEV_SET_CONFIG.
>>>>>>>
>>>>>>>> I'd like to stick to the current assumption thich get_config won't fail.
>>>>>>>> That is to say,
>>>>>>>>
>>>>>>>> 1) maintain a config in the kernel, make sure the config space read can
>>>>>>>> always succeed
>>>>>>>> 2) introduce an ioctl for the vduse usersapce to update the config space.
>>>>>>>> 3) we can synchronize with the vduse userspace during set_config
>>>>>>>>
>>>>>>>> Does this work?
>>>>>>> I noticed that caching is also allowed by the vhost-user protocol
>>>>>>> messages (QEMU's docs/interop/vhost-user.rst), but the device doesn't
>>>>>>> know whether or not caching is in effect. The interface you outlined
>>>>>>> above requires caching.
>>>>>>>
>>>>>>> Is there a reason why the host kernel vDPA code needs to cache the
>>>>>>> configuration space?
>>>>>> Because:
>>>>>>
>>>>>> 1) Kernel can not wait forever in get_config(), this is the major difference
>>>>>> with vhost-user.
>>>>> virtio_cread() can sleep:
>>>>>
>>>>>     #define virtio_cread(vdev, structname, member, ptr)                     \
>>>>>             do {                                                            \
>>>>>                     typeof(((structname*)0)->member) virtio_cread_v;        \
>>>>>                                                                             \
>>>>>                     might_sleep();                                          \
>>>>>                     ^^^^^^^^^^^^^^
>>>>>
>>>>> Which code path cannot sleep?
>>>> Well, it can sleep but it can't sleep forever. For VDUSE, a
>>>> buggy/malicious userspace may refuse to respond to the get_config.
>>>>
>>>> It looks to me the ideal case, with the current virtio spec, for VDUSE is to
>>>>
>>>> 1) maintain the device and its state in the kernel, userspace may sync
>>>> with the kernel device via ioctls
>>>> 2) offload the datapath (virtqueue) to the userspace
>>>>
>>>> This seems more robust and safe than simply relaying everything to
>>>> userspace and waiting for its response.
>>>>
>>>> And we know for sure this model can work, an example is TUN/TAP:
>>>> netdevice is abstracted in the kernel and datapath is done via
>>>> sendmsg()/recvmsg().
>>>>
>>>> Maintaining the config in the kernel follows this model and it can
>>>> simplify the device generation implementation.
>>>>
>>>> For config space write, it requires more thought but fortunately it's
>>>> not commonly used. So VDUSE can choose to filter out the
>>>> device/features that depends on the config write.
>>> This is the problem. There are other messages like SET_FEATURES where I
>>> guess we'll face the same challenge.
>>
>> Probably not, userspace device can tell the kernel about the device_features
>> and mandated_features during creation, and the feature negotiation could be
>> done purely in the kernel without bothering the userspace.


(For some reason I drop the list accidentally, adding them back, sorry)


> Sorry, I confused the messages. I meant SET_STATUS. It's a synchronous
> interface where the driver waits for the device.


It depends on how we define "synchronous" here. If I understand 
correctly, the spec doesn't expect there will be any kind of failure for 
the operation of set_status itself.

Instead, anytime it want any synchronization, it should be done via 
get_status():

1) re-read device status to make sure FEATURES_OK is set during feature 
negotiation
2) re-read device status to be 0 to make sure the device has finish the 
reset


>
> VDUSE currently doesn't wait for the device emulation process to handle
> this message (no reply is needed) but I think this is a mistake because
> VDUSE is not following the VIRTIO device model.


With the trick that is done for FEATURES_OK above, I think we don't need 
to wait for the reply.

If userspace takes too long to respond, it can be detected since 
get_status() doesn't return the expected value for long time.

And for the case that needs a timeout, we probably can use NEEDS_RESET.


>
> I strongly suggest designing the VDUSE interface to match the VIRTIO
> device model (or at least the vDPA interface).


I fully agree with you and that is what we want to achieve in this series.


> Defining a custom
> interface for VDUSE avoids some implementation complexity and makes it
> easier to deal with untrusted userspace, but it's impossible to
> implement certain VIRTIO features or devices. It also fragments VIRTIO
> more than necessary; we have a standard, let's stick to it.


Yes.


>
>>> I agree that caching the contents of configuration space in the kernel
>>> helps, but if there are other VDUSE messages with the same problem then
>>> an attacker will exploit them instead.
>>>
>>> I think a systematic solution is needed. It would be necessary to
>>> enumerate the virtio_vdpa and vhost_vdpa cases separately to figure out
>>> where VDUSE messages are synchronous/time-sensitive.
>>
>> This is the case of reset and needs more thought. We should stick a
>> consistent uAPI for the userspace.
>>
>> For vhost-vDPA, it needs synchronzied with the userspace and we can wait for
>> ever.
> The VMM should still be able to handle signals when a vhost_vdpa ioctl
> is waiting for a reply from the VDUSE userspace process. Or if that's
> not possible then there needs to be a way to force disconnection from
> VDUSE so the VMM can be killed.


Note that VDUSE works under vDPA bus, so vhost should be transport to VDUSE.

But we can detect this via whether or not the bounce buffer is used.

Thanks


>
> Stefan

