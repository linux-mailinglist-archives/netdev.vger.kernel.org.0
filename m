Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7CD3929AE
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 10:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235392AbhE0Im4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 04:42:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35044 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235284AbhE0Imy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 04:42:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622104877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yN1LmC6tLlwHE2JSmI5/WtXdvMUbtIRH+V/hkQT9TzA=;
        b=JHr2dwA3m2wYjgaiPOSQfPpwDC+2/4Kn0W3j/E/U/xkC//oJoDjRUEufaik8zryPnbVqud
        VKJoyzyamPL8qu1XV9EQZIF1HIKZoNhwYYZl7/Vaja4vLyA24C0aeAtGJm+FMkXi0zljyA
        Y5e031OIUryvuOalYF1tg/hwv8fELw4=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-587-ntt6xPNxPf6xy9jX_JOrdw-1; Thu, 27 May 2021 04:41:15 -0400
X-MC-Unique: ntt6xPNxPf6xy9jX_JOrdw-1
Received: by mail-pg1-f199.google.com with SMTP id v12-20020a63d54c0000b02902167d3d2f08so2515699pgi.13
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 01:41:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=yN1LmC6tLlwHE2JSmI5/WtXdvMUbtIRH+V/hkQT9TzA=;
        b=WkKdqd9D+71cRs/U6lynGyi5Uo2bKMoN3xDmlxgHLqKz0uNIxnrdmkMa7sEXZ47AAW
         /eQeDSMmxrrRVkbV7qe3NzSB4fQFw+T2fMOd9snckEWzxEwnThaMCuNisN87vPk6Az1M
         zbHw1q2A1iQpm7+aoDM35s8Ts6KRP1NIBpBEBk4EsmLQpdkBeeS7E3oxN03bKq0zruLZ
         ih61PvjH5lwzuB/SO711jmuo/EALc9RmW7IJMOuU3iyyhswOJCxLg8h8euetubX04x+V
         FUJcdSkViF9B/tNSbRsY74WQx3sj5EpXdM3zMMoAONbfRdpYU/e6IHO8OlBU2V6V+FpC
         oByg==
X-Gm-Message-State: AOAM532AqJR8G8HDTckElUJ/pCmdAAzjUE4zU9UADcT1hD0i1sG6JFu0
        dFsrYb2AnM3RQ47b4V/VKmSgsqWt7QkY5a8VB+fbhfuV2YVKfTugiyJtZAMcapymd9VgDKase1+
        nQVp/UjoTQFkIMACs
X-Received: by 2002:a17:902:d508:b029:ef:b008:f4ad with SMTP id b8-20020a170902d508b02900efb008f4admr2333588plg.8.1622104874603;
        Thu, 27 May 2021 01:41:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzvPNDcYkAS3faf7fevSyiFC8ZU6oTJ+el34W9W0mGRDdwfnLELCNOSU91eRydTJVumJh4SSA==
X-Received: by 2002:a17:902:d508:b029:ef:b008:f4ad with SMTP id b8-20020a170902d508b02900efb008f4admr2333565plg.8.1622104874245;
        Thu, 27 May 2021 01:41:14 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a12sm1513042pfg.102.2021.05.27.01.41.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 May 2021 01:41:13 -0700 (PDT)
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
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <00ded99f-91b6-ba92-5d92-2366b163f129@redhat.com>
Date:   Thu, 27 May 2021 16:41:01 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <CACycT3ufok97cKpk47NjUBTc0QAyfauFUyuFvhWKmuqCGJ7zZw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/5/27 下午3:34, Yongji Xie 写道:
> On Thu, May 27, 2021 at 1:40 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>> 在 2021/5/27 下午1:08, Yongji Xie 写道:
>>> On Thu, May 27, 2021 at 1:00 PM Jason Wang <jasowang@redhat.com> wrote:
>>>> 在 2021/5/27 下午12:57, Yongji Xie 写道:
>>>>> On Thu, May 27, 2021 at 12:13 PM Jason Wang <jasowang@redhat.com> wrote:
>>>>>> 在 2021/5/17 下午5:55, Xie Yongji 写道:
>>>>>>> +
>>>>>>> +static int vduse_dev_msg_sync(struct vduse_dev *dev,
>>>>>>> +                           struct vduse_dev_msg *msg)
>>>>>>> +{
>>>>>>> +     init_waitqueue_head(&msg->waitq);
>>>>>>> +     spin_lock(&dev->msg_lock);
>>>>>>> +     vduse_enqueue_msg(&dev->send_list, msg);
>>>>>>> +     wake_up(&dev->waitq);
>>>>>>> +     spin_unlock(&dev->msg_lock);
>>>>>>> +     wait_event_killable(msg->waitq, msg->completed);
>>>>>> What happens if the userspace(malicous) doesn't give a response forever?
>>>>>>
>>>>>> It looks like a DOS. If yes, we need to consider a way to fix that.
>>>>>>
>>>>> How about using wait_event_killable_timeout() instead?
>>>> Probably, and then we need choose a suitable timeout and more important,
>>>> need to report the failure to virtio.
>>>>
>>> Makes sense to me. But it looks like some
>>> vdpa_config_ops/virtio_config_ops such as set_status() didn't have a
>>> return value.  Now I add a WARN_ON() for the failure. Do you mean we
>>> need to add some change for virtio core to handle the failure?
>>
>> Maybe, but I'm not sure how hard we can do that.
>>
> We need to change all virtio device drivers in this way.


Probably.


>
>> We had NEEDS_RESET but it looks we don't implement it.
>>
> Could it handle the failure of get_feature() and get/set_config()?


Looks not:

"

The device SHOULD set DEVICE_NEEDS_RESET when it enters an error state 
that a reset is needed. If DRIVER_OK is set, after it sets 
DEVICE_NEEDS_RESET, the device MUST send a device configuration change 
notification to the driver.

"

This looks implies that NEEDS_RESET may only work after device is 
probed. But in the current design, even the reset() is not reliable.


>
>> Or a rough idea is that maybe need some relaxing to be coupled loosely
>> with userspace. E.g the device (control path) is implemented in the
>> kernel but the datapath is implemented in the userspace like TUN/TAP.
>>
> I think it can work for most cases. One problem is that the set_config
> might change the behavior of the data path at runtime, e.g.
> virtnet_set_mac_address() in the virtio-net driver and
> cache_type_store() in the virtio-blk driver. Not sure if this path is
> able to return before the datapath is aware of this change.


Good point.

But set_config() should be rare:

E.g in the case of virtio-net with VERSION_1, config space is read only, 
and it was set via control vq.

For block, we can

1) start from without WCE or
2) we add a config change notification to userspace or
3) extend the spec to use vq instead of config space

Thanks


>
> Thanks,
> Yongji
>

