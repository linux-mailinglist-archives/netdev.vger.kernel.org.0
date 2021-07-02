Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 144633B9DE1
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 11:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbhGBJH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 05:07:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20893 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230496AbhGBJH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 05:07:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625216696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LHpZpXtlGl518WPRuaRQL8rygDnIJqXUI6Y0K5b7NoM=;
        b=C2MPXsb9uThj0xEOJJMBus+zB9wAUEnMYws2hix0Q0ZTaM4T5e4OoLINP5TPcRfU2BeWrz
        eekefz+Tm2PWkWqr0A8VEiBffdInbJhmZDXULIWulTM67wQ12359Swvksk8APy4lx5XXFf
        V8Yo14lH5yAQyrzeB4q8A4PBvda1ecc=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-aVuEDQ7xMbaHSV8dqSvO8g-1; Fri, 02 Jul 2021 05:04:55 -0400
X-MC-Unique: aVuEDQ7xMbaHSV8dqSvO8g-1
Received: by mail-pj1-f70.google.com with SMTP id r5-20020a17090aad05b02901727bad5ccaso1370785pjq.3
        for <netdev@vger.kernel.org>; Fri, 02 Jul 2021 02:04:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=LHpZpXtlGl518WPRuaRQL8rygDnIJqXUI6Y0K5b7NoM=;
        b=ACu/UMEx9LiHlo6o8Af+e7MD1UfrI1G3itxpac3f8Cn4R1yv15PNTNCHoqSKQ2Pan5
         l60mEBO922qHA7i34QfMq+PhCfxzfEzgDZ0IunBD5TMIm022F56unDyATJl8PFnTndgq
         FF8VjRHFZYQ6cxhM7jcPL3zd2c/XyCth8J0HKKyT8UBxSEOlvV5OyVfIqjjv2dN4J1vJ
         oDMXRfUicHEPRpdGH/X8BckBDS7FyhkHTHAvXDNP5iKDq7jCWcqbsEny0pVnZf0PQk/I
         8HbG2yUXrXk2viM1gd+oZReXzWmoUvvHrPm4ljlNt+uVvkUUYhyvGisEgbmsMwSmuPOI
         Op0g==
X-Gm-Message-State: AOAM533QhK/sO3JoNcD3Rr7lm44wbedcCU53U1As58giB2XKgzGkDNt1
        /hS6rzQruhvNmbgeQSjYlqvMIlJez4Ib0DOrfXqWM+DaN4OQo9taKHN6Q8ApykX1nFOJRwZiMJH
        U2P3GM2ITnQPnDwJC
X-Received: by 2002:a17:90a:2d8c:: with SMTP id p12mr1791pjd.58.1625216694358;
        Fri, 02 Jul 2021 02:04:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJygD2gvYgD+pPILx3MnRJPirTM5Snc+03W7nqAMCUlL8Ysoglr4DEs8YGR/7CD07hbBIX51nA==
X-Received: by 2002:a17:90a:2d8c:: with SMTP id p12mr1748pjd.58.1625216694098;
        Fri, 02 Jul 2021 02:04:54 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id ft21sm2023663pjb.53.2021.07.02.02.04.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jul 2021 02:04:53 -0700 (PDT)
Subject: Re: [PATCH net-next v3 1/3] selftests/ptr_ring: add benchmark
 application for ptr_ring
To:     Yunsheng Lin <linyunsheng@huawei.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, brouer@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, will@kernel.org,
        shuah@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linuxarm@openeuler.org
References: <1625142402-64945-1-git-send-email-linyunsheng@huawei.com>
 <1625142402-64945-2-git-send-email-linyunsheng@huawei.com>
 <e1ec4577-a48f-ff56-b766-1445c2501b9f@redhat.com>
 <91bcade8-f034-4bc7-f329-d5e1849867e7@huawei.com>
 <20210702042838-mutt-send-email-mst@kernel.org>
 <661a84bc-e7c5-bc21-25ac-75a68efa79ca@huawei.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <1fed53f1-f882-ca67-8876-ca6702dcd9cd@redhat.com>
Date:   Fri, 2 Jul 2021 17:04:44 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <661a84bc-e7c5-bc21-25ac-75a68efa79ca@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/7/2 下午4:46, Yunsheng Lin 写道:
> On 2021/7/2 16:30, Michael S. Tsirkin wrote:
>> On Fri, Jul 02, 2021 at 04:17:17PM +0800, Yunsheng Lin wrote:
>>>> Let's reuse ptr_ring.c in tools/virtio/ringtest. Nothing virt specific there.
>>> It *does* have some virtio specific at the end of ptr_ring.c.


They are just wrappers to make ptr ring works like a virtio ring. We can 
split them out into another file if necessary.


>>> It can be argued that the ptr_ring.c in tools/virtio/ringtest
>>> could be refactored to remove the function related to virtio.
>>>
>>> But as mentioned in the previous disscusion [1], the tools/virtio/
>>> seems to have compile error in the latest kernel, it does not seems
>>> right to reuse that.
>>> And most of testcase in tools/virtio/ seems
>>> better be in tools/virtio/ringtest instead，so until the testcase
>>> in tools/virtio/ is compile-error-free and moved to tools/testing/
>>> selftests/, it seems better not to reuse it for now.
>>
>> That's a great reason to reuse - so tools/virtio/ stays working.
>> Please just fix that.


+1


> I understand that you guys like to see a working testcase of virtio.
> I would love to do that if I have the time and knowledge of virtio,
> But I do not think I have the time and I am familiar enough with
> virtio to fix that now.


So ringtest is used for bench-marking the ring performance for different 
format. Virtio is only one of the supported ring format, ptr ring is 
another. Wrappers were used to reuse the same test logic.

Though you may see host/guest in the test, it's in fact done via two 
processes.

We need figure out:

1) why the current ringtest.c does not fit for your requirement (it has 
SPSC test)
2) why can't we tweak the ptr_ring.c to be used by both ring_test and 
your benchmark

If neither of the above work, we can invent new ptr_ring infrastructure 
under tests/

Thanks


>
>

