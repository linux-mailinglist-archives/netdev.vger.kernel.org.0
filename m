Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA51E219032
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 21:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbgGHTJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 15:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgGHTJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 15:09:16 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4272BC061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 12:09:16 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id f23so48248761iof.6
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 12:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=amTQnbtsKNtMNqCXfEBd0Nmd5ZK1LyIUAIpJJi0ybCI=;
        b=o2uB9OHc31evcQCEVh0hy1Z8qC9Cg2uvqrgLlbMllRlCSqYk+aPVp4lrnY3IMv501p
         3G+l7ZONlcs/3+EShy4KKmqLyWsCTx9nn0WdvUNKpeuRkjeQTTspeVzffEeJkZ2hDKKv
         dLIt9SWsxdrPFc8UpJENMfZmZuodiMrpkgI4HtDaBTO6wk/JwXLKUKSZrcsEvszFklhx
         gABsp2UhDBwq8yS5xZqm4jL3AROCykBf5hHGCgNPPmpkxSyBRScKZiwuV0rV7RIhe3ab
         NaSiWBu8EY8ysoTwdEWM9Z7sRKyd9dSTaYZo9Yjz2Ftctu57u3Bkm++ec+6O+rLlfLUD
         Bahg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=amTQnbtsKNtMNqCXfEBd0Nmd5ZK1LyIUAIpJJi0ybCI=;
        b=iU7NYSbjpCJQuVhyslZL/rJCg4fFv3G0wiWVZQnTt3w/YbDLLLTqA2bfzZvWq753s/
         WPTf2GSw+5Lp1PXP5fYs4rmRS9M522b3z+V0Hnq98a+Jbq+X3KJtjbxDvVEPEuE5A0er
         hpcBZg+SHJE0MLgLGtoJs90GBD/b8hmGsrUGCecnd0uzZ26EqVuKPp1RD4oRwNIeVLbj
         hnXYtBeK8Y0cOZi1d280OA3YLjYlc0rV+OUcgH6ui1KTpSunS4VlTS3ySoXotdp+68vA
         4BbA/I/OFCN4sV7q9tkb11ZSDo7rKydLGpDE60++Byy2JrqhdaM3OMNsTHA3oirVs4IG
         6TQw==
X-Gm-Message-State: AOAM531pMfQQ+Gd6VUB/yRnnSZjz5k5h2lvMurcD3jyAw3kcXKEF7eIo
        p6Tf9I+bJ9RjfeqcMOkdV8zK9OvKHpS8hK62M1Q=
X-Google-Smtp-Source: ABdhPJy7ERCm4JMski2SDoCaOKVFZb14PWKVp2Ka5vMrxdPspnrgIze2kPs+RZhn2srz6VVEFZHXYi/h+FTgOEvnxqM=
X-Received: by 2002:a5e:c311:: with SMTP id a17mr9035100iok.12.1594235355674;
 Wed, 08 Jul 2020 12:09:15 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1593209494.git.petrm@mellanox.com> <79417f27b7c57da5c0eb54bb6d074d3a472d9ebf.1593209494.git.petrm@mellanox.com>
 <CAM_iQpXvwPGz=kKBFKQAkoJ0hwijC9M03SV9arC++gYBAU5VKw@mail.gmail.com>
 <87a70bic3n.fsf@mellanox.com> <CAM_iQpWjod0oLew-jSN+KUXkoPYkJYWyePHsvLyW4f2JbYQFRw@mail.gmail.com>
 <873662i3rc.fsf@mellanox.com> <87y2nugepz.fsf@mellanox.com>
In-Reply-To: <87y2nugepz.fsf@mellanox.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 8 Jul 2020 12:09:04 -0700
Message-ID: <CAM_iQpUbPidrm+DucpDO4yTaW=o3Pw=mYNTon9uYi4_O36Aw+A@mail.gmail.com>
Subject: Re: [PATCH net-next v1 2/5] net: sched: Introduce helpers for qevent blocks
To:     Petr Machata <petrm@mellanox.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 8, 2020 at 9:21 AM Petr Machata <petrm@mellanox.com> wrote:
>
> Actually I guess I could qdisc_refcount_inc() the current qdisc so that
> it doesn't go away. Then when enqueing I could access the child
> directly, not relying on the now-obsolete cache from the beginning of
> the enqueue function. I suppose that a similar approach could be used in
> other users of tcf_classify() as well. What do you think?

The above example is just a quick one I can think of, there could be
more race conditions that lead to other kinds of bugs.

I am sure you can fix that one, but the point is that it is hard to
audit and fix them all. The best solution here is of course not to
release that lock, but again it requires some more work to avoid
the deadlock.

Thanks.
