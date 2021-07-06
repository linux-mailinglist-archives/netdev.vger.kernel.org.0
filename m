Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBA123BC4CF
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 04:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbhGFChZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 22:37:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42393 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229880AbhGFChY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 22:37:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625538886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HVuNMGPjUFR4EYVE5SY3SOVJbIMJT/f5oi+I5uWxFrM=;
        b=Eqsvfqt9261sxoBWWgwYdPrY1YKxJJ7Gno77b0R1NwOZZx/46z+VHucSdBtgYBN+fv/Nu+
        RKiy6z7DWaeSlwlUsfhfvFqRF745+d45CIm/AX1s1Ud0ZC9iW8iuD60NRp13jEwr/9jeKj
        7CnqGy8g/wQZqJG+6LX9KBjUl0fFssY=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-AvDkasGDPHmf0ErOiHoeqg-1; Mon, 05 Jul 2021 22:34:44 -0400
X-MC-Unique: AvDkasGDPHmf0ErOiHoeqg-1
Received: by mail-pg1-f198.google.com with SMTP id d28-20020a634f1c0000b02902238495b6a7so15088431pgb.16
        for <netdev@vger.kernel.org>; Mon, 05 Jul 2021 19:34:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=HVuNMGPjUFR4EYVE5SY3SOVJbIMJT/f5oi+I5uWxFrM=;
        b=RanqqFJQsrGG860YzZbApZSsZ2ofPlTGos7uzoGhfUv1Cf517PJxXQFTFbmRJbBJ39
         qtj0XKyfU8JIt4l7DV6M0e1WNFN8bk1uzXWhCpcNQh+hy3igYL6XNt8w2gK1caQVCjM4
         bs5+3tDOj9y09wOi48VjSsXGaYtIqznGX10XDt5FjZOKfsm8SI+o0bjyVAyR/AiFm0gG
         qn90Mf4SUeLlDfMagIHWxrbP+DRvvenm51Cp4NvQxgTIJhjEd4awCw7XT8WTPfECdCk1
         PZCQqnAVIUVTzUhuEi2S2sr0MY0Ugfu1E4cbrNS1QkaCdufHVdoQe9mh4dZOfoR9wF/2
         orvA==
X-Gm-Message-State: AOAM5327udBz7MIs3fwNC9AZ7DgAvtnuyoL/UUb8h2hOSKLWyPzPVdlW
        rphdQXRTUlg4+qBhxr4azvRs4ujT0d7EfweNuG+7ykkp5qnP/RiKabnszM+Tn5EJXNyamJGdOfB
        2TQb8zYpYSRy+NO4a
X-Received: by 2002:a63:f556:: with SMTP id e22mr18650446pgk.189.1625538883949;
        Mon, 05 Jul 2021 19:34:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzILej/0FQHGxl4T6zrYB/SOfscbH6OhsOWvj703yvNi6LpSqIaMqZLCnRp/+Zmr1wzG6xIfg==
X-Received: by 2002:a63:f556:: with SMTP id e22mr18650421pgk.189.1625538883702;
        Mon, 05 Jul 2021 19:34:43 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g18sm13838184pfi.199.2021.07.05.19.34.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jul 2021 19:34:42 -0700 (PDT)
Subject: Re: [PATCH v8 10/10] Documentation: Add documentation for VDUSE
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     Yongji Xie <xieyongji@bytedance.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
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
        Greg KH <gregkh@linuxfoundation.org>, songmuchun@bytedance.com,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20210615141331.407-1-xieyongji@bytedance.com>
 <20210615141331.407-11-xieyongji@bytedance.com>
 <YNSCH6l31zwPxBjL@stefanha-x1.localdomain>
 <CACycT3uxnQmXWsgmNVxQtiRhz1UXXTAJFY3OiAJqokbJH6ifMA@mail.gmail.com>
 <YNxCDpM3bO5cPjqi@stefanha-x1.localdomain>
 <CACycT3taKhf1cWp3Jd0aSVekAZvpbR-_fkyPLQ=B+jZBB5H=8Q@mail.gmail.com>
 <YN3ABqCMLQf7ejOm@stefanha-x1.localdomain>
 <CACycT3vo-diHgTSLw_FS2E+5ia5VjihE3qw7JmZR7JT55P-wQA@mail.gmail.com>
 <8320d26d-6637-85c6-8773-49553dfa502d@redhat.com>
 <YOL/9mxkJaokKDHc@stefanha-x1.localdomain>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <5b5107fa-3b32-8a3b-720d-eee6b2a84ace@redhat.com>
Date:   Tue, 6 Jul 2021 10:34:33 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YOL/9mxkJaokKDHc@stefanha-x1.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/7/5 下午8:49, Stefan Hajnoczi 写道:
> On Mon, Jul 05, 2021 at 11:36:15AM +0800, Jason Wang wrote:
>> 在 2021/7/4 下午5:49, Yongji Xie 写道:
>>>>> OK, I get you now. Since the VIRTIO specification says "Device
>>>>> configuration space is generally used for rarely-changing or
>>>>> initialization-time parameters". I assume the VDUSE_DEV_SET_CONFIG
>>>>> ioctl should not be called frequently.
>>>> The spec uses MUST and other terms to define the precise requirements.
>>>> Here the language (especially the word "generally") is weaker and means
>>>> there may be exceptions.
>>>>
>>>> Another type of access that doesn't work with the VDUSE_DEV_SET_CONFIG
>>>> approach is reads that have side-effects. For example, imagine a field
>>>> containing an error code if the device encounters a problem unrelated to
>>>> a specific virtqueue request. Reading from this field resets the error
>>>> code to 0, saving the driver an extra configuration space write access
>>>> and possibly race conditions. It isn't possible to implement those
>>>> semantics suing VDUSE_DEV_SET_CONFIG. It's another corner case, but it
>>>> makes me think that the interface does not allow full VIRTIO semantics.
>>
>> Note that though you're correct, my understanding is that config space is
>> not suitable for this kind of error propagating. And it would be very hard
>> to implement such kind of semantic in some transports.  Virtqueue should be
>> much better. As Yong Ji quoted, the config space is used for
>> "rarely-changing or intialization-time parameters".
>>
>>
>>> Agreed. I will use VDUSE_DEV_GET_CONFIG in the next version. And to
>>> handle the message failure, I'm going to add a return value to
>>> virtio_config_ops.get() and virtio_cread_* API so that the error can
>>> be propagated to the virtio device driver. Then the virtio-blk device
>>> driver can be modified to handle that.
>>>
>>> Jason and Stefan, what do you think of this way?
> Why does VDUSE_DEV_GET_CONFIG need to support an error return value?
>
> The VIRTIO spec provides no way for the device to report errors from
> config space accesses.
>
> The QEMU virtio-pci implementation returns -1 from invalid
> virtio_config_read*() and silently discards virtio_config_write*()
> accesses.
>
> VDUSE can take the same approach with
> VDUSE_DEV_GET_CONFIG/VDUSE_DEV_SET_CONFIG.
>
>> I'd like to stick to the current assumption thich get_config won't fail.
>> That is to say,
>>
>> 1) maintain a config in the kernel, make sure the config space read can
>> always succeed
>> 2) introduce an ioctl for the vduse usersapce to update the config space.
>> 3) we can synchronize with the vduse userspace during set_config
>>
>> Does this work?
> I noticed that caching is also allowed by the vhost-user protocol
> messages (QEMU's docs/interop/vhost-user.rst), but the device doesn't
> know whether or not caching is in effect. The interface you outlined
> above requires caching.
>
> Is there a reason why the host kernel vDPA code needs to cache the
> configuration space?


Because:

1) Kernel can not wait forever in get_config(), this is the major 
difference with vhost-user.
2) Stick to the current assumption that virtio_cread() should always 
succeed.

Thanks


>
> Here are the vhost-user protocol messages:
>
>    Virtio device config space
>    ^^^^^^^^^^^^^^^^^^^^^^^^^^
>
>    +--------+------+-------+---------+
>    | offset | size | flags | payload |
>    +--------+------+-------+---------+
>
>    :offset: a 32-bit offset of virtio device's configuration space
>
>    :size: a 32-bit configuration space access size in bytes
>
>    :flags: a 32-bit value:
>      - 0: Vhost master messages used for writeable fields
>      - 1: Vhost master messages used for live migration
>
>    :payload: Size bytes array holding the contents of the virtio
>              device's configuration space
>
>    ...
>
>    ``VHOST_USER_GET_CONFIG``
>      :id: 24
>      :equivalent ioctl: N/A
>      :master payload: virtio device config space
>      :slave payload: virtio device config space
>
>      When ``VHOST_USER_PROTOCOL_F_CONFIG`` is negotiated, this message is
>      submitted by the vhost-user master to fetch the contents of the
>      virtio device configuration space, vhost-user slave's payload size
>      MUST match master's request, vhost-user slave uses zero length of
>      payload to indicate an error to vhost-user master. The vhost-user
>      master may cache the contents to avoid repeated
>      ``VHOST_USER_GET_CONFIG`` calls.
>
>    ``VHOST_USER_SET_CONFIG``
>      :id: 25
>      :equivalent ioctl: N/A
>      :master payload: virtio device config space
>      :slave payload: N/A
>
>      When ``VHOST_USER_PROTOCOL_F_CONFIG`` is negotiated, this message is
>      submitted by the vhost-user master when the Guest changes the virtio
>      device configuration space and also can be used for live migration
>      on the destination host. The vhost-user slave must check the flags
>      field, and slaves MUST NOT accept SET_CONFIG for read-only
>      configuration space fields unless the live migration bit is set.
>
> Stefan

