Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84E263B1238
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 05:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbhFWDd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 23:33:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56626 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230094AbhFWDdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 23:33:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624419068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VZSgP5xqL55dngZG3CanjqGD23m6Wc1RN7v32XWp3kc=;
        b=D0rT+9lKGIV1w9C2Ioin8KLW5yFWmlewxYNLvASOFoxe06tyKATEMZ58Of6am4GfmT5ACq
        SsIryGYe5f7eEAL03BvIlqvfnbkLyMjsVAA9Ocjmdr1Xd1eq8SHx0eBFbVNZeX9L5IL+AH
        22XoJ1041TB3jOG5QupfYXb76lPItiU=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-umUEb2eYPeuKmowOz1BWww-1; Tue, 22 Jun 2021 23:31:06 -0400
X-MC-Unique: umUEb2eYPeuKmowOz1BWww-1
Received: by mail-pl1-f198.google.com with SMTP id x17-20020a1709027c11b0290122d280f05bso321982pll.8
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 20:31:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=VZSgP5xqL55dngZG3CanjqGD23m6Wc1RN7v32XWp3kc=;
        b=nsI4UBaOhVU/BMtwfnjzk7lB2BElrUYt9RStbpwBcb26rjNn+0Y/1AFVwqkwlnsEdv
         0eMUCaHzQRYNd9zOs1dNaf9tnnxjO1eiwolnH2+Hxaeor9Lrgt7B28+lETOUQnXusWkw
         pWbUhB7+VQBI18X87opubV3vMZPpahOqlibwBtQ2be7Gs7cbAv3mAOyd4gkvaPZX8aOU
         5QkKY136p5Nc6OkiDjpGOO45v63m8EnAAbO/Jp6gWCLYs10GYbFD1F+ahZuLQHWd/AUG
         UHKnrWSs6DBnDUsa4wklESJJ2VU2E0UGcneDVtFp4OmU24IvIOBdwHifu9TPKhFxAxnE
         AyXg==
X-Gm-Message-State: AOAM533EBXjBV/OZwfriSebJJ7aRwzpCM9hh/Bqb90e2cuzYZvE3oNh9
        RZxKG9P7j74+a5YvLHoY1rrwUAvnAnu7CtpDCeMQMZvS80PO7XHiQP5WwrL5c17kIlpTtGEr5zy
        WHH3oldnJALBMmuiD
X-Received: by 2002:a17:90b:a4d:: with SMTP id gw13mr7324894pjb.104.1624419065659;
        Tue, 22 Jun 2021 20:31:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzQhXaoy3jxuNbqcv+CnTgPw9skCZRgRJ2b9PqWzTzCghH3uazW1CaiGjP6RnFZCrYeeAvhUQ==
X-Received: by 2002:a17:90b:a4d:: with SMTP id gw13mr7324867pjb.104.1624419065413;
        Tue, 22 Jun 2021 20:31:05 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g4sm658859pfu.134.2021.06.22.20.30.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 20:31:04 -0700 (PDT)
Subject: Re: [PATCH v8 09/10] vduse: Introduce VDUSE - vDPA Device in
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
        Greg KH <gregkh@linuxfoundation.org>, songmuchun@bytedance.com,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20210615141331.407-1-xieyongji@bytedance.com>
 <20210615141331.407-10-xieyongji@bytedance.com>
 <adfb2be9-9ed9-ca37-ac37-4cd00bdff349@redhat.com>
 <CACycT3tAON+-qZev+9EqyL2XbgH5HDspOqNt3ohQLQ8GqVK=EA@mail.gmail.com>
 <1bba439f-ffc8-c20e-e8a4-ac73e890c592@redhat.com>
 <CACycT3uzMJS7vw6MVMOgY4rb=SPfT2srV+8DPdwUVeELEiJgbA@mail.gmail.com>
 <0aeb7cb7-58e5-1a95-d830-68edd7e8ec2e@redhat.com>
 <CACycT3uuooKLNnpPHewGZ=q46Fap2P4XCFirdxxn=FxK+X1ECg@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <e4cdee72-b6b4-d055-9aac-3beae0e5e3e1@redhat.com>
Date:   Wed, 23 Jun 2021 11:30:52 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CACycT3uuooKLNnpPHewGZ=q46Fap2P4XCFirdxxn=FxK+X1ECg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/22 下午4:14, Yongji Xie 写道:
> On Tue, Jun 22, 2021 at 3:50 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>> 在 2021/6/22 下午3:22, Yongji Xie 写道:
>>>> We need fix a way to propagate the error to the userspace.
>>>>
>>>> E.g if we want to stop the deivce, we will delay the status reset until
>>>> we get respose from the userspace?
>>>>
>>> I didn't get how to delay the status reset. And should it be a DoS
>>> that we want to fix if the userspace doesn't give a response forever?
>>
>> You're right. So let's make set_status() can fail first, then propagate
>> its failure via VHOST_VDPA_SET_STATUS.
>>
> OK. So we only need to propagate the failure in the vhost-vdpa case, right?


I think not, we need to deal with the reset for virtio as well:

E.g in register_virtio_devices(), we have:

         /* We always start by resetting the device, in case a previous
          * driver messed it up.  This also tests that code path a 
little. */
       dev->config->reset(dev);

We probably need to make reset can fail and then fail the 
register_virtio_device() as well.

Thanks


>
> Thanks,
> Yongji
>

