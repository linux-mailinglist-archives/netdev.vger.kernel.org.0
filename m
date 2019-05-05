Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5043D13EA2
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 11:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727507AbfEEJUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 05:20:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49678 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726965AbfEEJUm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 May 2019 05:20:42 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 50F6C3091749;
        Sun,  5 May 2019 09:20:42 +0000 (UTC)
Received: from [10.72.12.197] (ovpn-12-197.pek2.redhat.com [10.72.12.197])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EC3AF5DA5B;
        Sun,  5 May 2019 09:20:32 +0000 (UTC)
Subject: Re: [RFC PATCH V3 0/6] vhost: accelerate metadata access
To:     mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     peterx@redhat.com, aarcange@redhat.com,
        James.Bottomley@hansenpartnership.com, hch@infradead.org,
        davem@davemloft.net, jglisse@redhat.com, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
        christophe.de.dinechin@gmail.com, jrdr.linux@gmail.com
References: <20190423055420.26408-1-jasowang@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <831c343f-c547-f68c-19fe-d89e8f259d87@redhat.com>
Date:   Sun, 5 May 2019 17:20:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190423055420.26408-1-jasowang@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Sun, 05 May 2019 09:20:42 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/4/23 下午1:54, Jason Wang wrote:
> This series tries to access virtqueue metadata through kernel virtual
> address instead of copy_user() friends since they had too much
> overheads like checks, spec barriers or even hardware feature
> toggling. This is done through setup kernel address through direct
> mapping and co-opreate VM management with MMU notifiers.
>
> Test shows about 23% improvement on TX PPS. TCP_STREAM doesn't see
> obvious improvement.


Ping. Comments are more than welcomed.

Thanks

