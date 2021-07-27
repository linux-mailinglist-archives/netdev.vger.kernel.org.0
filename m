Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 904863D6DA1
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 06:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235186AbhG0EpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 00:45:02 -0400
Received: from relay.sw.ru ([185.231.240.75]:35166 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235147AbhG0EpB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 00:45:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=/+c65/gT4Io1ufXamU1e2psgnYkOi5vjG8kGJF++OHo=; b=Ui+jyG8CSoRsIhhdk
        CgYVGe+dD8MtMbyE9CEOdC4C2Toq4wq6hHORYH5UyU1pz03B+ZK3/1TFXc3+X96ZASFPJ/fWQFcdu
        mFeW/8GMwrtOgRkkMWE3BsNlLXvF5m+1Ntd1aA6IZ9l+D+Kb4qH/GtNobsZES4dxVFFlLZm8/HzNk
        =;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1m8ExW-005LMz-8H; Tue, 27 Jul 2021 07:44:50 +0300
Subject: Re: [PATCH v6 00/16] memcg accounting from OpenVZ
To:     David Miller <davem@davemloft.net>
Cc:     akpm@linux-foundation.org, tj@kernel.org, cgroups@vger.kernel.org,
        mhocko@kernel.org, hannes@cmpxchg.org, vdavydov.dev@gmail.com,
        guro@fb.com, shakeelb@google.com, nglaive@gmail.com,
        viro@zeniv.linux.org.uk, adobriyan@gmail.com, avagin@gmail.com,
        bp@alien8.de, christian.brauner@ubuntu.com, dsahern@kernel.org,
        0x7f454c46@gmail.com, edumazet@google.com, ebiederm@xmission.com,
        gregkh@linuxfoundation.org, yoshfuji@linux-ipv6.org, hpa@zytor.com,
        mingo@redhat.com, kuba@kernel.org, bfields@fieldses.org,
        jlayton@kernel.org, axboe@kernel.dk, jirislaby@kernel.org,
        ktkhai@virtuozzo.com, oleg@redhat.com, serge@hallyn.com,
        tglx@linutronix.de, lizefan.x@bytedance.com,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <9bf9d9bd-03b1-2adb-17b4-5d59a86a9394@virtuozzo.com>
 <fdb0666c-7b8e-2062-64f4-5bef64fad950@virtuozzo.com>
 <20210726.225931.53899469422140706.davem@davemloft.net>
From:   Vasily Averin <vvs@virtuozzo.com>
Message-ID: <6f21a0e0-bd36-b6be-1ffa-0dc86c06c470@virtuozzo.com>
Date:   Tue, 27 Jul 2021 07:44:49 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210726.225931.53899469422140706.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/27/21 12:59 AM, David Miller wrote:
> 
> This series does not apply cleanly to net-next, please respin.

Dear David,
I found that you have already approved net-related patches of this series and included them into net-next.
So I'll respin v7 without these patches.

Thank you,
	Vasily Averin
