Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2AA13954B6
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 06:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbhEaEko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 00:40:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23876 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229803AbhEaEkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 00:40:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622435941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0iOJFSk4M5fATpsyHla9pHiyIsvAdGUk+2E+QqouBgM=;
        b=L+jiF7+tB5YabCr1iLPVY3rCsSGsZ6A7JSlyRiO2h4epTy3tLiPa7nNZrHmYqNlq6Yd07b
        OxTLR3pvLzuRJO3PiWyu12uQTzpGF4Mfm+7w5lQtwKD/lHTk/g4aH3XZ2c0tYYe/ZNl0nl
        jq6N7UPGlmshkP5YkrgBywAon68yOhI=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-391-YnxN45hVNjS9pglZdaFD1w-1; Mon, 31 May 2021 00:39:00 -0400
X-MC-Unique: YnxN45hVNjS9pglZdaFD1w-1
Received: by mail-pj1-f71.google.com with SMTP id i8-20020a17090a7188b029015f9564a698so9703915pjk.8
        for <netdev@vger.kernel.org>; Sun, 30 May 2021 21:38:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=0iOJFSk4M5fATpsyHla9pHiyIsvAdGUk+2E+QqouBgM=;
        b=I7h5Q/49mWpAE+gvbn2FL35eiZpCoyA/AB4EfnpeBPE04iifzFNagz6qRyhXksXC2T
         t1XCc33z0BIv8koBQY8o5/P4vmwOdwNQLU7P0RMhiLdR+Rl7HJsjjHE4NI59cieT0sAX
         SNYsuZQErQQW4CrXRn/wUoCDXzcI3C5CLzxkTwLIt44GndRpGrk6QqlG8jZXXBb1rTQm
         IZRM9MRy+Jd7+da0pI/QMMvZBn+rEwPCasJZeH8oTn6sRR8jJWTocIDRsHvMeFRu7QvH
         hZaBlC3MV9V3lsMSC/JmiLWHPJ42Lewg8gtavrxoIt7Z4vQCv8o3xCWqADDn18Vl1OI0
         I3dg==
X-Gm-Message-State: AOAM530xEOON1O2G3bDpKleZGuTWQvVVH5h/p8jN7bf3dcYWtTGlXfIR
        sS+z7yCGrCB4sLWD8jCt1fEeFRGXjN4YKn7/aHaZOH26ii+kpp3p3UXt60Ihe3tiKd9KezcYZ+B
        qE/uzorDEj4bpfl96
X-Received: by 2002:a17:90b:1489:: with SMTP id js9mr8106336pjb.227.1622435939101;
        Sun, 30 May 2021 21:38:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwECaFWqzow6NdzjEA/SPKPwRYy8BftnnINSbmAd0S9WQ6jOL+NhYjoGxK0mOczJ8jEV1I9Vg==
X-Received: by 2002:a17:90b:1489:: with SMTP id js9mr8106314pjb.227.1622435938816;
        Sun, 30 May 2021 21:38:58 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b20sm1398269pgm.30.2021.05.30.21.38.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 30 May 2021 21:38:58 -0700 (PDT)
Subject: Re: [PATCH v7 11/12] vduse: Introduce VDUSE - vDPA Device in
 Userspace
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Mika_Penttil=c3=a4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, joro@8bytes.org,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20210517095513.850-1-xieyongji@bytedance.com>
 <20210517095513.850-12-xieyongji@bytedance.com>
 <3740c7eb-e457-07f3-5048-917c8606275d@redhat.com>
 <CACycT3uAqa6azso_8MGreh+quj-JXO1piuGnrV8k2kTfc34N2g@mail.gmail.com>
 <5a68bb7c-fd05-ce02-cd61-8a601055c604@redhat.com>
 <CACycT3ve7YvKF+F+AnTQoJZMPua+jDvGMs_ox8GQe_=SGdeCMA@mail.gmail.com>
 <ee00efca-b26d-c1be-68d2-f9e34a735515@redhat.com>
 <CACycT3ufok97cKpk47NjUBTc0QAyfauFUyuFvhWKmuqCGJ7zZw@mail.gmail.com>
 <00ded99f-91b6-ba92-5d92-2366b163f129@redhat.com>
 <CACycT3uK_Fuade-b8FVYkGCKZnne_UGGbYRFwv7WOH2oKCsXSg@mail.gmail.com>
 <f20edd55-20cb-c016-b347-dd71c5406ed8@redhat.com>
 <CACycT3tLj6a7-tbqO9SzCLStwYrOALdkfnt1jxQBv3s0VzD6AQ@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <ea9fd2d2-870f-c4e2-d7a5-af759985c462@redhat.com>
Date:   Mon, 31 May 2021 12:38:47 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <CACycT3tLj6a7-tbqO9SzCLStwYrOALdkfnt1jxQBv3s0VzD6AQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/5/31 下午12:27, Yongji Xie 写道:
> On Fri, May 28, 2021 at 10:31 AM Jason Wang <jasowang@redhat.com> wrote:
>>
>> 在 2021/5/27 下午9:17, Yongji Xie 写道:
>>> On Thu, May 27, 2021 at 4:41 PM Jason Wang <jasowang@redhat.com> wrote:
>>>> 在 2021/5/27 下午3:34, Yongji Xie 写道:
>>>>> On Thu, May 27, 2021 at 1:40 PM Jason Wang <jasowang@redhat.com> wrote:
>>>>>> 在 2021/5/27 下午1:08, Yongji Xie 写道:
>>>>>>> On Thu, May 27, 2021 at 1:00 PM Jason Wang <jasowang@redhat.com> wrote:
>>>>>>>> 在 2021/5/27 下午12:57, Yongji Xie 写道:
>>>>>>>>> On Thu, May 27, 2021 at 12:13 PM Jason Wang <jasowang@redhat.com> wrote:
>>>>>>>>>> 在 2021/5/17 下午5:55, Xie Yongji 写道:
>>>>>>>>>>> +
>>>>>>>>>>> +static int vduse_dev_msg_sync(struct vduse_dev *dev,
>>>>>>>>>>> +                           struct vduse_dev_msg *msg)
>>>>>>>>>>> +{
>>>>>>>>>>> +     init_waitqueue_head(&msg->waitq);
>>>>>>>>>>> +     spin_lock(&dev->msg_lock);
>>>>>>>>>>> +     vduse_enqueue_msg(&dev->send_list, msg);
>>>>>>>>>>> +     wake_up(&dev->waitq);
>>>>>>>>>>> +     spin_unlock(&dev->msg_lock);
>>>>>>>>>>> +     wait_event_killable(msg->waitq, msg->completed);
>>>>>>>>>> What happens if the userspace(malicous) doesn't give a response forever?
>>>>>>>>>>
>>>>>>>>>> It looks like a DOS. If yes, we need to consider a way to fix that.
>>>>>>>>>>
>>>>>>>>> How about using wait_event_killable_timeout() instead?
>>>>>>>> Probably, and then we need choose a suitable timeout and more important,
>>>>>>>> need to report the failure to virtio.
>>>>>>>>
>>>>>>> Makes sense to me. But it looks like some
>>>>>>> vdpa_config_ops/virtio_config_ops such as set_status() didn't have a
>>>>>>> return value.  Now I add a WARN_ON() for the failure. Do you mean we
>>>>>>> need to add some change for virtio core to handle the failure?
>>>>>> Maybe, but I'm not sure how hard we can do that.
>>>>>>
>>>>> We need to change all virtio device drivers in this way.
>>>> Probably.
>>>>
>>>>
>>>>>> We had NEEDS_RESET but it looks we don't implement it.
>>>>>>
>>>>> Could it handle the failure of get_feature() and get/set_config()?
>>>> Looks not:
>>>>
>>>> "
>>>>
>>>> The device SHOULD set DEVICE_NEEDS_RESET when it enters an error state
>>>> that a reset is needed. If DRIVER_OK is set, after it sets
>>>> DEVICE_NEEDS_RESET, the device MUST send a device configuration change
>>>> notification to the driver.
>>>>
>>>> "
>>>>
>>>> This looks implies that NEEDS_RESET may only work after device is
>>>> probed. But in the current design, even the reset() is not reliable.
>>>>
>>>>
>>>>>> Or a rough idea is that maybe need some relaxing to be coupled loosely
>>>>>> with userspace. E.g the device (control path) is implemented in the
>>>>>> kernel but the datapath is implemented in the userspace like TUN/TAP.
>>>>>>
>>>>> I think it can work for most cases. One problem is that the set_config
>>>>> might change the behavior of the data path at runtime, e.g.
>>>>> virtnet_set_mac_address() in the virtio-net driver and
>>>>> cache_type_store() in the virtio-blk driver. Not sure if this path is
>>>>> able to return before the datapath is aware of this change.
>>>> Good point.
>>>>
>>>> But set_config() should be rare:
>>>>
>>>> E.g in the case of virtio-net with VERSION_1, config space is read only,
>>>> and it was set via control vq.
>>>>
>>>> For block, we can
>>>>
>>>> 1) start from without WCE or
>>>> 2) we add a config change notification to userspace or
>>> I prefer this way. And I think we also need to do similar things for
>>> set/get_vq_state().
>>
>> Yes, I agree.
>>
> Hi Jason,
>
> Now I'm working on this. But I found the config change notification
> must be synchronous in the virtio-blk case, which means the kernel
> still needs to wait for the response from userspace in set_config().
> Otherwise, some I/Os might still run the old way after we change the
> cache_type in sysfs.
>
> The simple ways to solve this problem are:
>
> 1. Only support read-only config space, disable WCE as you suggested
> 2. Add a return value to set_config() and handle the failure only in
> virtio-blk driver
> 3. Print some warnings after timeout since it only affects the
> dataplane which is under userspace's control
>
> Any suggestions?


Let's go without WCE first and make VDUSE work first. We can then think 
of a solution for WCE on top.

Thanks


>
> Thanks,
> Yongji
>

