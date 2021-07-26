Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20ADA3D6925
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 23:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233452AbhGZVTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 17:19:20 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45114 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbhGZVTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 17:19:19 -0400
Received: from localhost (unknown [51.219.3.84])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 4D483501F2189;
        Mon, 26 Jul 2021 14:59:39 -0700 (PDT)
Date:   Mon, 26 Jul 2021 22:59:31 +0100 (BST)
Message-Id: <20210726.225931.53899469422140706.davem@davemloft.net>
To:     vvs@virtuozzo.com
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
Subject: Re: [PATCH v6 00/16] memcg accounting from
From:   David Miller <davem@davemloft.net>
In-Reply-To: <fdb0666c-7b8e-2062-64f4-5bef64fad950@virtuozzo.com>
References: <9bf9d9bd-03b1-2adb-17b4-5d59a86a9394@virtuozzo.com>
        <fdb0666c-7b8e-2062-64f4-5bef64fad950@virtuozzo.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Mon, 26 Jul 2021 14:59:47 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


This series does not apply cleanly to net-next, please respin.

Thank you.
