Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7218718A
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 07:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405439AbfHIFfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 01:35:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46326 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726212AbfHIFfl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 01:35:41 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 76B7B8E90C;
        Fri,  9 Aug 2019 05:35:41 +0000 (UTC)
Received: from [10.72.12.241] (ovpn-12-241.pek2.redhat.com [10.72.12.241])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F54C60BF3;
        Fri,  9 Aug 2019 05:35:33 +0000 (UTC)
Subject: Re: [PATCH V4 0/9] Fixes for metadata accelreation
To:     David Miller <davem@davemloft.net>
Cc:     mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, jgg@ziepe.ca
References: <20190807070617.23716-1-jasowang@redhat.com>
 <20190808.221543.450194346419371363.davem@davemloft.net>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <1aaec9aa-7832-35e2-a58d-99bcc2998ce8@redhat.com>
Date:   Fri, 9 Aug 2019 13:35:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190808.221543.450194346419371363.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Fri, 09 Aug 2019 05:35:41 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/8/9 下午1:15, David Miller wrote:
> From: Jason Wang <jasowang@redhat.com>
> Date: Wed,  7 Aug 2019 03:06:08 -0400
>
>> This series try to fix several issues introduced by meta data
>> accelreation series. Please review.
>   ...
>
> My impression is that patch #7 will be changed to use spinlocks so there
> will be a v5.
>

Yes. V5 is on the way.

Thanks

