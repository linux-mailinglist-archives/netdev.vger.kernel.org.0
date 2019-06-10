Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7863ADC1
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 05:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387587AbfFJDu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 23:50:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54932 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387457AbfFJDu6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 Jun 2019 23:50:58 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D9A5D3082B15;
        Mon, 10 Jun 2019 03:50:57 +0000 (UTC)
Received: from [10.72.12.206] (ovpn-12-206.pek2.redhat.com [10.72.12.206])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1AB5660BEC;
        Mon, 10 Jun 2019 03:50:46 +0000 (UTC)
Subject: Re: [PATCH net-next 0/6] vhost: accelerate metadata access
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterx@redhat.com, James.Bottomley@hansenpartnership.com,
        hch@infradead.org, davem@davemloft.net, jglisse@redhat.com,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        linux-parisc@vger.kernel.org, christophe.de.dinechin@gmail.com,
        jrdr.linux@gmail.com
References: <20190524081218.2502-1-jasowang@redhat.com>
 <20190605162631-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <c233324c-cb66-c0ab-45c4-6e6e0499bb22@redhat.com>
Date:   Mon, 10 Jun 2019 11:50:45 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190605162631-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Mon, 10 Jun 2019 03:50:58 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/6/6 上午4:27, Michael S. Tsirkin wrote:
> On Fri, May 24, 2019 at 04:12:12AM -0400, Jason Wang wrote:
>> Hi:
>>
>> This series tries to access virtqueue metadata through kernel virtual
>> address instead of copy_user() friends since they had too much
>> overheads like checks, spec barriers or even hardware feature
>> toggling like SMAP. This is done through setup kernel address through
>> direct mapping and co-opreate VM management with MMU notifiers.
>>
>> Test shows about 23% improvement on TX PPS. TCP_STREAM doesn't see
>> obvious improvement.
>>
>> Thanks
> Thanks this is queued for next.
>
> Did you want to rebase and repost packed ring support on top?
> IIUC it's on par with split ring with these patches.
>
>

Yes, it's on the way.

Thanks

