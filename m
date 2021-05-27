Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5034D3926B1
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 07:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234895AbhE0FB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 01:01:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60917 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234780AbhE0FB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 01:01:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622091624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WvNDULJK9zHRMwqe44K4RR3WKdtWUGMATeJjP7wtcZY=;
        b=NDtWKxXflWKORfZfpS8usxxdcshPF4pmZYzmD78XoKBYFnnu+ibNVFPwHx/XsjFqdusYKM
        bUPl27kzIvHrx9YhUT/KBKd1lEZdQ0uMB1BtnrB+4mXPgwzqu6xbD3D9jSRKeH4P3hfmMl
        s/sQafws2J2ultk4BmYRPa+kPhmqLwA=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-431-AYMtHtY3MBqECIEkVWkz5g-1; Thu, 27 May 2021 01:00:22 -0400
X-MC-Unique: AYMtHtY3MBqECIEkVWkz5g-1
Received: by mail-pf1-f199.google.com with SMTP id l199-20020a6288d00000b02902db317806d5so2109252pfd.18
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 22:00:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=WvNDULJK9zHRMwqe44K4RR3WKdtWUGMATeJjP7wtcZY=;
        b=jqrDxYBkPduhS0LRGiDoncMSZZH11jYE1ytuMlS4DKib1ECyAOA6VION623f9zflHa
         dtUD2RTfKRHiPyeMwivQgNwl3N8+ga+70NW7batVjHw/pku3523Z6ndqTR3HD7fvahpQ
         OkenaXOF0X1YXr2NiAYYtlD90VkvBheJuTsfIoTrW+r4qIDvxjqGyJiLdPIvTHwi6tSk
         aLX3093rkawJtSwL//xd1kLDpkYXYdlwgPSDtcGMaomYcD4D5maDpx/onBeIaGCzSS4r
         DJEODrlGlsCtptD9aLsUhG35r6/Q8TLdfNFnatWeSUl5hS4S0vzlnLmDAo7m/Rf2bXch
         eLSg==
X-Gm-Message-State: AOAM532fx8Gc9OOPsN/nY6n8Ihe2nuE7qiYoiFyTVaEm57nvw8iRTybz
        8UXgtG0cVix6CzZQpM46mafpbSpuKCT8qEjYNc2gqFxUHwlOiLr/BgVQirWjvJXW/3BDEA/yeB2
        rId5dw8h2MG7C8hcT
X-Received: by 2002:a17:90b:1d8f:: with SMTP id pf15mr1854842pjb.36.1622091621396;
        Wed, 26 May 2021 22:00:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxbQssOI3XI76V4pKYYsFesmyrvxjTc0EKTWn6Zl6xKwlpjIji0dLlRJIWAqJ1uNqyHlcKbWw==
X-Received: by 2002:a17:90b:1d8f:: with SMTP id pf15mr1854461pjb.36.1622091616242;
        Wed, 26 May 2021 22:00:16 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u5sm715334pfi.179.2021.05.26.22.00.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 May 2021 22:00:15 -0700 (PDT)
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
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <5a68bb7c-fd05-ce02-cd61-8a601055c604@redhat.com>
Date:   Thu, 27 May 2021 13:00:07 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <CACycT3uAqa6azso_8MGreh+quj-JXO1piuGnrV8k2kTfc34N2g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/5/27 下午12:57, Yongji Xie 写道:
> On Thu, May 27, 2021 at 12:13 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>> 在 2021/5/17 下午5:55, Xie Yongji 写道:
>>> +
>>> +static int vduse_dev_msg_sync(struct vduse_dev *dev,
>>> +                           struct vduse_dev_msg *msg)
>>> +{
>>> +     init_waitqueue_head(&msg->waitq);
>>> +     spin_lock(&dev->msg_lock);
>>> +     vduse_enqueue_msg(&dev->send_list, msg);
>>> +     wake_up(&dev->waitq);
>>> +     spin_unlock(&dev->msg_lock);
>>> +     wait_event_killable(msg->waitq, msg->completed);
>>
>> What happens if the userspace(malicous) doesn't give a response forever?
>>
>> It looks like a DOS. If yes, we need to consider a way to fix that.
>>
> How about using wait_event_killable_timeout() instead?


Probably, and then we need choose a suitable timeout and more important, 
need to report the failure to virtio.

Thanks


>
> Thanks,
> Yongji
>

