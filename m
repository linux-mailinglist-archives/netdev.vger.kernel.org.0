Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2796E3617F3
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 05:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236366AbhDPDDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 23:03:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25639 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234751AbhDPDDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 23:03:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618542200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ikyH2z8Vt7uMI/VG6XB6eSk4QGEm2QFd/gz535ClrYI=;
        b=LME/u4BdDS2d6uVI+gvTjLYA0fTc9mkKVcHkc0XLoeFyEUA8Y01lWUtAysPZiocbi0hbyE
        v373lnXB3REEuJ8KTgnJw5Dan0TwraVoBqNzQ5UJjMQ5eh9C34DDKtjSTLss8k0hlseQoj
        Txd/sSk5h9svb/OdjYxjKabJmAEYlIg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-68-ByMz4XzrPpGli7s2BmtqTA-1; Thu, 15 Apr 2021 23:03:16 -0400
X-MC-Unique: ByMz4XzrPpGli7s2BmtqTA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D9EB81744F;
        Fri, 16 Apr 2021 03:03:14 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-140.pek2.redhat.com [10.72.13.140])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F395B60BE5;
        Fri, 16 Apr 2021 03:02:58 +0000 (UTC)
Subject: Re: [PATCH v6 10/10] Documentation: Add documentation for VDUSE
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Mika_Penttil=c3=a4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20210331080519.172-1-xieyongji@bytedance.com>
 <20210331080519.172-11-xieyongji@bytedance.com>
 <YHb44R4HyLEUVSTF@stefanha-x1.localdomain>
 <CACycT3uNR+nZY5gY0UhPkeOyi7Za6XkX4b=hasuDcgqdc7fqfg@mail.gmail.com>
 <YHfo8pc7dIO9lNc3@stefanha-x1.localdomain>
 <80b31814-9e41-3153-7efb-c0c2fab44feb@redhat.com>
 <02c19c22-13ea-ea97-d99b-71edfee0b703@redhat.com>
 <CACycT3tL7URz3n-KhMAwYH+Sn1e1TSyfU+RKcc8jpPDJ7WcZ2w@mail.gmail.com>
 <5beabeaf-52a6-7ee5-b666-f3616ea82811@redhat.com>
 <CACycT3tyksBYxgbQLFJ-mFCKkaWotucM5_ho_K3q4wMpR0P=gw@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <17e3312e-686b-c5dd-852d-e9ffb7f4c707@redhat.com>
Date:   Fri, 16 Apr 2021 11:02:57 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <CACycT3tyksBYxgbQLFJ-mFCKkaWotucM5_ho_K3q4wMpR0P=gw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/4/16 上午10:58, Yongji Xie 写道:
> On Fri, Apr 16, 2021 at 10:20 AM Jason Wang <jasowang@redhat.com> wrote:
>>
>> 在 2021/4/15 下午7:17, Yongji Xie 写道:
>>> On Thu, Apr 15, 2021 at 5:05 PM Jason Wang <jasowang@redhat.com> wrote:
>>>> 在 2021/4/15 下午4:36, Jason Wang 写道:
>>>>>> Please state this explicitly at the start of the document. Existing
>>>>>> interfaces like FUSE are designed to avoid trusting userspace.
>>>>> There're some subtle difference here. VDUSE present a device to kernel
>>>>> which means IOMMU is probably the only thing to prevent a malicous
>>>>> device.
>>>>>
>>>>>
>>>>>> Therefore
>>>>>> people might think the same is the case here. It's critical that people
>>>>>> are aware of this before deploying VDUSE with virtio-vdpa.
>>>>>>
>>>>>> We should probably pause here and think about whether it's possible to
>>>>>> avoid trusting userspace. Even if it takes some effort and costs some
>>>>>> performance it would probably be worthwhile.
>>>>> Since the bounce buffer is used the only attack surface is the
>>>>> coherent area, if we want to enforce stronger isolation we need to use
>>>>> shadow virtqueue (which is proposed in earlier version by me) in this
>>>>> case. But I'm not sure it's worth to do that.
>>>>
>>>> So this reminds me the discussion in the end of last year. We need to
>>>> make sure we don't suffer from the same issues for VDUSE at least
>>>>
>>>> https://yhbt.net/lore/all/c3629a27-3590-1d9f-211b-c0b7be152b32@redhat.com/T/#mc6b6e2343cbeffca68ca7a97e0f473aaa871c95b
>>>>
>>>> Or we can solve it at virtio level, e.g remember the dma address instead
>>>> of depending on the addr in the descriptor ring
>>>>
>>> I might miss something. But VDUSE has recorded the dma address during
>>> dma mapping, so we would not do bouncing if the addr/length is invalid
>>> during dma unmapping. Is it enough?
>>
>> E.g malicous device write a buggy dma address in the descriptor ring, so
>> we had:
>>
>> vring_unmap_one_split(desc->addr, desc->len)
>>       dma_unmap_single()
>>           vduse_dev_unmap_page()
>>               vduse_domain_bounce()
>>
>> And in vduse_domain_bounce() we had:
>>
>>           while (size) {
>>                   map = &domain->bounce_maps[iova >> PAGE_SHIFT];
>>                   offset = offset_in_page(iova);
>>                   sz = min_t(size_t, PAGE_SIZE - offset, size);
>>
>> This means we trust the iova which is dangerous and exacly the issue
>> mentioned in the above link.
>>
>>   From VDUSE level need to make sure iova is legal.
>>
> I think we already do that in vduse_domain_bounce():
>
>      while (size) {
>          map = &domain->bounce_maps[iova >> PAGE_SHIFT];
>
>          if (WARN_ON(!map->bounce_page ||
>              map->orig_phys == INVALID_PHYS_ADDR))
>              return;


So you don't check whether iova is legal before using it, so it's at 
least a possible out of bound access of the bounce_maps[] isn't it? (e.g 
what happens if iova is ULLONG_MAX).


>
>
>>   From virtio level, we should not truse desc->addr.
>>
> We would not touch desc->addr after vring_unmap_one_split(). So I'm
> not sure what we need to do at the virtio level.


I think the point is to record the dma addres/len somewhere instead of 
reading them from descriptor ring.

Thanks


>
> Thanks,
> Yongji
>

