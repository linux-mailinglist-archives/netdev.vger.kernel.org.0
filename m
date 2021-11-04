Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5EFB444D03
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 02:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbhKDBj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 21:39:58 -0400
Received: from rere.qmqm.pl ([91.227.64.183]:27339 "EHLO rere.qmqm.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231220AbhKDBjz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 21:39:55 -0400
Received: from remote.user (localhost [127.0.0.1])
        by rere.qmqm.pl (Postfix) with ESMTPSA id 4Hl5pw63sZz8K;
        Thu,  4 Nov 2021 02:37:12 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=rere.qmqm.pl; s=1;
        t=1635989836; bh=h/WnKEaJ3r2sYaIw5151DIcICUXY5nyCeVGfTKIhiyc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aAyK08Skdngle/aZhEk4p1aBOceovedKWY0KoFevgu2z0x9XhaoO5qceg/r0sK28t
         4Q+9ZFAdKRxwGGr/kgEGBtwejq3ifmrb448bfl3djxaXNd88d7JjOmHR22MgFzq7Pw
         mLdKR/sdEmw+2eLgGqcbf8CeStJTfTmNqfPDbhvLVrvoolyB4MuyTH1yRGFefAHmNc
         vT63DiKND7k/NuRfcVItyV9IvKgyyTcFuqRQm12dfzVUGd7df0bNu6Od/QKsMuw1On
         XE4JHDnimlcNX1KjPW3lZemUgYTsmCXM4yypJ9bFWILvqNTxNoygYyvoezsQ05cMoS
         896bcst1V7bxA==
X-Virus-Status: Clean
X-Virus-Scanned: clamav-milter 0.103.3 at mail
Date:   Thu, 4 Nov 2021 02:37:11 +0100
From:   =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     akpm@linux-foundation.org, keescook@chromium.org,
        rostedt@goodmis.org, mathieu.desnoyers@efficios.com,
        arnaldo.melo@gmail.com, pmladek@suse.com, peterz@infradead.org,
        viro@zeniv.linux.org.uk, valentin.schneider@arm.com,
        qiang.zhang@windriver.com, robdclark@chromium.org,
        christian@brauner.io, dietmar.eggemann@arm.com, mingo@redhat.com,
        juri.lelli@redhat.com, vincent.guittot@linaro.org,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, dennis.dalessandro@cornelisnetworks.com,
        mike.marciniszyn@cornelisnetworks.com, dledford@redhat.com,
        jgg@ziepe.ca, linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, oliver.sang@intel.com, lkp@intel.com
Subject: Re: [PATCH v7 00/11] extend task comm from 16 to 24
Message-ID: <YYM5R95a7jgB2TPO@qmqm.qmqm.pl>
References: <20211101060419.4682-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211101060419.4682-1-laoar.shao@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 01, 2021 at 06:04:08AM +0000, Yafang Shao wrote:
> There're many truncated kthreads in the kernel, which may make trouble
> for the user, for example, the user can't get detailed device
> information from the task comm.
> 
> This patchset tries to improve this problem fundamentally by extending
> the task comm size from 16 to 24, which is a very simple way. 
[...]

Hi,

I've tried something like this a few years back. My attempt got mostly
lost in the mailing lists, but I'm still carrying the patches in my
tree [1]. My target was userspace thread names, and it turned out more
involved than I had time for.

[1] https://rere.qmqm.pl/git/?p=linux;a=commit;h=2c3814268caf2b1fee6d1a0b61fd1730ce135d4a
    and its parents

Best Regards
Micha³ Miros³aw
