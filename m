Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94551393D3B
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 08:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbhE1Gkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 02:40:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45598 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229719AbhE1Gko (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 02:40:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622183949;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6RpP8rpfd8a3e0y5nF0RPgT5RVi2VhGM0rPjlvoSzx4=;
        b=gDBkzqxqKfaeQ7Oxt0B4O42Rxx8iJ+KkV0cRLpR+v1/ymXcZ2RyWNdQEd9H1xErqpdsmpU
        ubdptE17Ves63meELxr8LXNnSDBJ+xtKlme4FoujSB0IqVUPSIJCYndhJ+2Whg2U5TyJGf
        W2P1AE1/z0j7H437mAmElCaTSoMZIFo=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-goXeMTn0PnWYi8uMesPUdA-1; Fri, 28 May 2021 02:39:08 -0400
X-MC-Unique: goXeMTn0PnWYi8uMesPUdA-1
Received: by mail-pf1-f199.google.com with SMTP id p17-20020a056a0026d1b02902df90210ec4so1907504pfw.2
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 23:39:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=6RpP8rpfd8a3e0y5nF0RPgT5RVi2VhGM0rPjlvoSzx4=;
        b=PAfp1V1qmQ4NLnDVwjYPrITpzYD78dNaxWHuDu10BDVX97BfAPu3U06NNPAcqBoocl
         vCsCFn1bqB9J5WbcDpqk4lGAXSea88tMI/4fgndTCW65+IFTWiYkWfr+QiYJYN3TCR1i
         famyX4tDKCb81UyrsMJUobnOVu0O7YtT2vvmiyXUBkNnVVsCMCllZh8ztxl81RTAH/Nd
         L0PyQAtVKrPPMrnahzBE5WJJw1cjhzMJx9P/i4/AZZZf+6CZ9bLuHp5bgIYc/JXJJUvr
         VccA2QElIdqXn0ciiDSftsHJI7UR7pGZVD1oSswVPMehUwsFw9MEoNG34USVT7toQms2
         Azog==
X-Gm-Message-State: AOAM530eYctHsXUT3WlXzKMhtvn4Lh/yOsfMe6C1Qy1QvGw0OtvBLTPY
        wmAM7sCsbmhzuVJKz9IMSCOvzCfEaXvly/qRFfUhO/AIncV/X2z7u36J1Cb5MwV9c0X4ar2gk/z
        bhqS4L7/EPDCfcj2b
X-Received: by 2002:a17:90a:bd05:: with SMTP id y5mr2664327pjr.229.1622183947112;
        Thu, 27 May 2021 23:39:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxGNmAqjgmxntdDKOd5qocBDSk4ZjOlVFy0XRLBTCjKcdzj+d4zuGqzz/QNeE7UYpYTrC3W9A==
X-Received: by 2002:a17:90a:bd05:: with SMTP id y5mr2664285pjr.229.1622183946816;
        Thu, 27 May 2021 23:39:06 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q24sm3476480pjp.6.2021.05.27.23.38.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 May 2021 23:39:06 -0700 (PDT)
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
 <3cc7407d-9637-227e-9afa-402b6894d8ac@redhat.com>
 <CACycT3s6SkER09KL_Ns9d03quYSKOuZwd3=HJ_s1SL7eH7y5gA@mail.gmail.com>
 <baf0016a-7930-2ae2-399f-c28259f415c1@redhat.com>
 <CACycT3vKZ3y0gga8PrSVtssZfNV0Y-A8=iYZSi9sbpHRNkVf-A@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <503cee35-e5d7-7ccf-347b-73487872ac11@redhat.com>
Date:   Fri, 28 May 2021 14:38:54 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <CACycT3vKZ3y0gga8PrSVtssZfNV0Y-A8=iYZSi9sbpHRNkVf-A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/5/28 上午11:54, Yongji Xie 写道:
> On Fri, May 28, 2021 at 9:33 AM Jason Wang <jasowang@redhat.com> wrote:
>>
>> 在 2021/5/27 下午6:14, Yongji Xie 写道:
>>> On Thu, May 27, 2021 at 4:43 PM Jason Wang <jasowang@redhat.com> wrote:
>>>> 在 2021/5/27 下午4:41, Jason Wang 写道:
>>>>> 在 2021/5/27 下午3:34, Yongji Xie 写道:
>>>>>> On Thu, May 27, 2021 at 1:40 PM Jason Wang <jasowang@redhat.com> wrote:
>>>>>>> 在 2021/5/27 下午1:08, Yongji Xie 写道:
>>>>>>>> On Thu, May 27, 2021 at 1:00 PM Jason Wang <jasowang@redhat.com>
>>>>>>>> wrote:
>>>>>>>>> 在 2021/5/27 下午12:57, Yongji Xie 写道:
>>>>>>>>>> On Thu, May 27, 2021 at 12:13 PM Jason Wang <jasowang@redhat.com>
>>>>>>>>>> wrote:
>>>>>>>>>>> 在 2021/5/17 下午5:55, Xie Yongji 写道:
>>>>>>>>>>>> +
>>>>>>>>>>>> +static int vduse_dev_msg_sync(struct vduse_dev *dev,
>>>>>>>>>>>> +                           struct vduse_dev_msg *msg)
>>>>>>>>>>>> +{
>>>>>>>>>>>> +     init_waitqueue_head(&msg->waitq);
>>>>>>>>>>>> +     spin_lock(&dev->msg_lock);
>>>>>>>>>>>> +     vduse_enqueue_msg(&dev->send_list, msg);
>>>>>>>>>>>> +     wake_up(&dev->waitq);
>>>>>>>>>>>> +     spin_unlock(&dev->msg_lock);
>>>>>>>>>>>> +     wait_event_killable(msg->waitq, msg->completed);
>>>>>>>>>>> What happens if the userspace(malicous) doesn't give a response
>>>>>>>>>>> forever?
>>>>>>>>>>>
>>>>>>>>>>> It looks like a DOS. If yes, we need to consider a way to fix that.
>>>>>>>>>>>
>>>>>>>>>> How about using wait_event_killable_timeout() instead?
>>>>>>>>> Probably, and then we need choose a suitable timeout and more
>>>>>>>>> important,
>>>>>>>>> need to report the failure to virtio.
>>>>>>>>>
>>>>>>>> Makes sense to me. But it looks like some
>>>>>>>> vdpa_config_ops/virtio_config_ops such as set_status() didn't have a
>>>>>>>> return value.  Now I add a WARN_ON() for the failure. Do you mean we
>>>>>>>> need to add some change for virtio core to handle the failure?
>>>>>>> Maybe, but I'm not sure how hard we can do that.
>>>>>>>
>>>>>> We need to change all virtio device drivers in this way.
>>>>> Probably.
>>>>>
>>>>>
>>>>>>> We had NEEDS_RESET but it looks we don't implement it.
>>>>>>>
>>>>>> Could it handle the failure of get_feature() and get/set_config()?
>>>>> Looks not:
>>>>>
>>>>> "
>>>>>
>>>>> The device SHOULD set DEVICE_NEEDS_RESET when it enters an error state
>>>>> that a reset is needed. If DRIVER_OK is set, after it sets
>>>>> DEVICE_NEEDS_RESET, the device MUST send a device configuration change
>>>>> notification to the driver.
>>>>>
>>>>> "
>>>>>
>>>>> This looks implies that NEEDS_RESET may only work after device is
>>>>> probed. But in the current design, even the reset() is not reliable.
>>>>>
>>>>>
>>>>>>> Or a rough idea is that maybe need some relaxing to be coupled loosely
>>>>>>> with userspace. E.g the device (control path) is implemented in the
>>>>>>> kernel but the datapath is implemented in the userspace like TUN/TAP.
>>>>>>>
>>>>>> I think it can work for most cases. One problem is that the set_config
>>>>>> might change the behavior of the data path at runtime, e.g.
>>>>>> virtnet_set_mac_address() in the virtio-net driver and
>>>>>> cache_type_store() in the virtio-blk driver. Not sure if this path is
>>>>>> able to return before the datapath is aware of this change.
>>>>> Good point.
>>>>>
>>>>> But set_config() should be rare:
>>>>>
>>>>> E.g in the case of virtio-net with VERSION_1, config space is read
>>>>> only, and it was set via control vq.
>>>>>
>>>>> For block, we can
>>>>>
>>>>> 1) start from without WCE or
>>>>> 2) we add a config change notification to userspace or
>>>>> 3) extend the spec to use vq instead of config space
>>>>>
>>>>> Thanks
>>>> Another thing if we want to go this way:
>>>>
>>>> We need find a way to terminate the data path from the kernel side, to
>>>> implement to reset semantic.
>>>>
>>> Do you mean terminate the data path in vdpa_reset().
>>
>> Yes.
>>
>>
>>>    Is it ok to just
>>> notify userspace to stop data path asynchronously?
>>
>> For well-behaved userspace, yes but no for buggy or malicious ones.
>>
> But the buggy or malicious daemons can't do anything if my
> understanding is correct.


You're right. I originally thought there can still have bouncing. But 
consider we don't do that during fault.

It should be safe.


>
>> I had an idea, how about terminate IOTLB in this case? Then we're in
>> fact turn datapath off.
>>
> Sorry, I didn't get your point here. What do you mean by terminating
> IOTLB?


I meant terminate the bouncing but it looks safe after a second thought :)

Thanks


>   Remove iotlb mapping? But userspace can still access the mapped
> region.
>
> Thanks,
> Yongji
>

