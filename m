Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F57A361780
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 04:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238194AbhDPCVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 22:21:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25314 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235046AbhDPCVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 22:21:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618539645;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=55n7LvBDiipqYGJEcb5TaYPCz2MnXHE0bIABWMH3IxI=;
        b=DyVw+AOZssoKrsDY/NVupasK2wN6TSl3xCCj3w+57xpZM28HDTN/vk9KJXlvOfsYn2mh1P
        xPuFy9boDTqBPrv03e+ITdlx3L6euZhahyCdNFzql5/+bywJ6ZGlIF0684HnhIMpllzBcX
        bDjYxt7Iop+DIPkFX3NqHPqIoBeBTq4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-Ig8URrppP2-56H43IdpRdw-1; Thu, 15 Apr 2021 22:20:41 -0400
X-MC-Unique: Ig8URrppP2-56H43IdpRdw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0D2138030A1;
        Fri, 16 Apr 2021 02:20:40 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-140.pek2.redhat.com [10.72.13.140])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 864C16294D;
        Fri, 16 Apr 2021 02:20:27 +0000 (UTC)
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
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <5beabeaf-52a6-7ee5-b666-f3616ea82811@redhat.com>
Date:   Fri, 16 Apr 2021 10:20:25 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <CACycT3tL7URz3n-KhMAwYH+Sn1e1TSyfU+RKcc8jpPDJ7WcZ2w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/4/15 下午7:17, Yongji Xie 写道:
> On Thu, Apr 15, 2021 at 5:05 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>> 在 2021/4/15 下午4:36, Jason Wang 写道:
>>>> Please state this explicitly at the start of the document. Existing
>>>> interfaces like FUSE are designed to avoid trusting userspace.
>>>
>>> There're some subtle difference here. VDUSE present a device to kernel
>>> which means IOMMU is probably the only thing to prevent a malicous
>>> device.
>>>
>>>
>>>> Therefore
>>>> people might think the same is the case here. It's critical that people
>>>> are aware of this before deploying VDUSE with virtio-vdpa.
>>>>
>>>> We should probably pause here and think about whether it's possible to
>>>> avoid trusting userspace. Even if it takes some effort and costs some
>>>> performance it would probably be worthwhile.
>>>
>>> Since the bounce buffer is used the only attack surface is the
>>> coherent area, if we want to enforce stronger isolation we need to use
>>> shadow virtqueue (which is proposed in earlier version by me) in this
>>> case. But I'm not sure it's worth to do that.
>>
>>
>> So this reminds me the discussion in the end of last year. We need to
>> make sure we don't suffer from the same issues for VDUSE at least
>>
>> https://yhbt.net/lore/all/c3629a27-3590-1d9f-211b-c0b7be152b32@redhat.com/T/#mc6b6e2343cbeffca68ca7a97e0f473aaa871c95b
>>
>> Or we can solve it at virtio level, e.g remember the dma address instead
>> of depending on the addr in the descriptor ring
>>
> I might miss something. But VDUSE has recorded the dma address during
> dma mapping, so we would not do bouncing if the addr/length is invalid
> during dma unmapping. Is it enough?


E.g malicous device write a buggy dma address in the descriptor ring, so 
we had:

vring_unmap_one_split(desc->addr, desc->len)
     dma_unmap_single()
         vduse_dev_unmap_page()
             vduse_domain_bounce()

And in vduse_domain_bounce() we had:

         while (size) {
                 map = &domain->bounce_maps[iova >> PAGE_SHIFT];
                 offset = offset_in_page(iova);
                 sz = min_t(size_t, PAGE_SIZE - offset, size);

This means we trust the iova which is dangerous and exacly the issue 
mentioned in the above link.

 From VDUSE level need to make sure iova is legal.

 From virtio level, we should not truse desc->addr.

Thanks


>
> Thanks,
> Yongji
>

