Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0EF93C320A
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 04:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbhGJC4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 22:56:32 -0400
Received: from relay.sw.ru ([185.231.240.75]:37668 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230317AbhGJC4c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 22:56:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=DvvjK9wvjret8pU1Pj5Lq7SIL4y20uZLc1aae0vdGec=; b=DICbeliw9gTCfmXZ6
        umqBTcFC6y0z4aLCHjZmYIoFqQvlqz+AFm5DePt69Xp/wwE8WE4p2vLK1z+sun2ewR3KPNZcW9kXq
        gYEZzINKkFr5fRrNoNX8mP+K9DKzBwe+xyGpSqh+apJ06q4HjcKAOXsEzF4HgS3t2VIEVdXs+OPBw
        =;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1m237g-003W99-5k; Sat, 10 Jul 2021 05:53:44 +0300
Subject: Re: [PATCH IPV6 v2 1/4] ipv6: allocate enough headroom in
 ip6_finish_output2()
To:     David Miller <davem@davemloft.net>
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1cbf3c7b-455e-f3a5-cc2c-c18ce8be4ce1@gmail.com>
 <cover.1625818825.git.vvs@virtuozzo.com>
 <4f6a2b28-a137-2e19-bf62-5a8767d0d0ac@virtuozzo.com>
 <20210709.105847.2246373390622335461.davem@davemloft.net>
From:   Vasily Averin <vvs@virtuozzo.com>
Message-ID: <e5c78a48-47b9-85f9-bc60-eda0b7164ceb@virtuozzo.com>
Date:   Sat, 10 Jul 2021 05:53:43 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210709.105847.2246373390622335461.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear David,
I'm happy to hear you again.

On 7/9/21 8:58 PM, David Miller wrote:
> Please do not use inline in foo.c files, let the compiler decde.

Thank you for the hint, I did not know it, and will follow him next time.
This time I'm going to move this helper somewhere anyway: 
either to net/core/skbuff.c as exported function where it will lost inline anyway,
or to include/linux/skbuff.h where inline is (it seems?) acceptable.

Could you please help me to find better name for this helper?

I would like to change its current name: 'skb_expand_head' looks very similar
to widely used 'pskb_expand_head' but have different semantic.
I afraid they can be accidentally misused in future.

Thank you,
	Vasily Averin.
