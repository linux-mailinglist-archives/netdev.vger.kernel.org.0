Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95C972E19D9
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 09:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728166AbgLWIQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 03:16:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58139 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727670AbgLWIQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 03:16:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608711286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u0U6heNY7fxOOhdzytPgLhxCjf8UFXUIBZYCgUBbqf4=;
        b=iIMVhk3gC8aX6+dHB57JL6bu1BifZ/q9tmnGkWpw+IUZYQQh6ibZ38OzyZmAUfrrR20a3O
        CRGmp3R1YLdObpgPNcOY0SYH6dPfL2oV76daQP8mDLSpZDydhZiTuA42Sufp9WYR0FLUEZ
        sNLwarLDn6/S/zCW5IFTIYZ+Y22G6Sg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-6cTF2La4MIuhN7JQfCiujg-1; Wed, 23 Dec 2020 03:14:42 -0500
X-MC-Unique: 6cTF2La4MIuhN7JQfCiujg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 460971005513;
        Wed, 23 Dec 2020 08:14:40 +0000 (UTC)
Received: from [10.72.12.54] (ovpn-12-54.pek2.redhat.com [10.72.12.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2AE6060C69;
        Wed, 23 Dec 2020 08:14:28 +0000 (UTC)
Subject: Re: [RFC v2 00/13] Introduce VDUSE - vDPA Device in Userspace
From:   Jason Wang <jasowang@redhat.com>
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        stefanha@redhat.com, sgarzare@redhat.com, parav@nvidia.com,
        akpm@linux-foundation.org, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net
Cc:     linux-aio@kvack.org, kvm@vger.kernel.org, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org
References: <20201222145221.711-1-xieyongji@bytedance.com>
 <c892652a-3f57-c337-8c67-084ba6d10834@redhat.com>
Message-ID: <faa0b9ba-c230-931b-86c6-624a302f6637@redhat.com>
Date:   Wed, 23 Dec 2020 16:14:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c892652a-3f57-c337-8c67-084ba6d10834@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/12/23 下午2:38, Jason Wang wrote:
>>
>> V1 to V2:
>> - Add vhost-vdpa support
>
>
> I may miss something but I don't see any code to support that. E.g 
> neither set_map nor dma_map/unmap is implemented in the config ops.
>
> Thanks 


Speak too fast :(

I saw a new config ops was introduced.

Let me dive into that.

Thanks

