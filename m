Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49C602E2A17
	for <lists+netdev@lfdr.de>; Fri, 25 Dec 2020 08:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728334AbgLYHBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Dec 2020 02:01:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35208 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726875AbgLYHBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Dec 2020 02:01:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608879603;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FXXaFNVTGUVp9lrtyUaIa3Klg2oiiWfo9NKoxtJtuRE=;
        b=KZ+WXm0k5yWvhKSQPX5vEU1jXcBqfIMn2yzP+klggmxH4QXsNNpt5yn44N8ESEEh5D/Ro8
        sqDlpEQSVj/2ilU0Ul9GIpe9dqIlhQ2gqd9jic4dQ0JVfhi93ReIvFiEGPhQuSkpabA/No
        Rfd7vXWrNCUIEEiPS1bKqRx852LPTwc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-583-GcigxxwTOgOrBiQwDAAu7g-1; Fri, 25 Dec 2020 02:00:00 -0500
X-MC-Unique: GcigxxwTOgOrBiQwDAAu7g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D7CB180A093;
        Fri, 25 Dec 2020 06:59:58 +0000 (UTC)
Received: from [10.72.12.97] (ovpn-12-97.pek2.redhat.com [10.72.12.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CD6625D9CC;
        Fri, 25 Dec 2020 06:59:22 +0000 (UTC)
Subject: Re: [RFC v2 06/13] vduse: Introduce VDUSE - vDPA Device in Userspace
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, sgarzare@redhat.com,
        Parav Pandit <parav@nvidia.com>, akpm@linux-foundation.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        axboe@kernel.dk, bcrl@kvack.org, corbet@lwn.net,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20201222145221.711-1-xieyongji@bytedance.com>
 <20201222145221.711-7-xieyongji@bytedance.com>
 <468be90d-1d98-c819-5492-32a2152d2e36@redhat.com>
 <CACycT3vYb_CdWz3wZ1OY=KynG=1qZgaa_Ngko2AO0JHn_fFXEA@mail.gmail.com>
 <26ea3a3d-b06b-6256-7243-8ca9eae61bce@redhat.com>
 <CACycT3uKb1P7zXyCBYWDb6VhGXV0cdJPH3CPcRzjwz57tyODgA@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <a47ecb89-b677-2001-5573-d71be5edd4c9@redhat.com>
Date:   Fri, 25 Dec 2020 14:59:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CACycT3uKb1P7zXyCBYWDb6VhGXV0cdJPH3CPcRzjwz57tyODgA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/12/24 下午4:34, Yongji Xie wrote:
>> Yes, the disadvantage is the performance. But it should be simpler (I
>> guess) and we know it can succeed.
>>
> Yes, another advantage is that we can support the VM using anonymous memory.


Exactly.


>
>>> I think I can try this in v3. And the
>>> MMU-based IOMMU implementation can be a future optimization in the
>>> virtio-vdpa case. What's your opinion?
>> Maybe I was wrong, but I think we can try as what has been proposed here
>> first and use shadow virtqueue as backup plan if we fail.
>>
> OK, I will continue to work on this proposal.


Thanks

>

