Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9C0A441B59
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 13:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232548AbhKAMxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 08:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232507AbhKAMxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 08:53:22 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24FEBC061714;
        Mon,  1 Nov 2021 05:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=RL3hnt8gJU6frPUOEVXfNSSid9qg9EK1F0andJuRsYo=; b=PklqNkLpc8XThjjoH0WQp5PHjp
        2P0kfCnLEMG73lnHd2wpZacv9Z0T6gd9jcv1KHpBh55JQBxZy3WKjvaSKGVRxPm7lxpw1wmTifrLF
        WeubHfJwD7K1qzjPZ0h2/0cKQ8A93IceSwN4QnBJdLlQOWOgO7nru9NYqtVE/OI9PV42yGYYMmLdq
        tO+2Rz8um+32jqjtFqQSnsk97MMI97giaV/eAmi2Ioe0uhmHAaFoO2pzBHvIBc+R8yWFzr5kMr+KE
        mY2g9prbvDtsYBHabFLAxx5w2GljEq6zAZE8SEv3DSLtCFDfW/zXix/UnxIcHi1L3i1zlPg/LOLG9
        ZtD9luvA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mhWgN-003lwE-9H; Mon, 01 Nov 2021 12:45:15 +0000
Date:   Mon, 1 Nov 2021 12:44:59 +0000
From:   Matthew Wilcox <willy@infradead.org>
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
Message-ID: <YX/hS6nRisiiFiBD@casper.infradead.org>
References: <20211101060419.4682-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

It can't be that simple if we're on v7 and at 11 patches!

It would be helpful if you included links to earlier postings.  I can
only find v5 and v6 in my inbox, so I fear I'm going to re-ask some
questions which were already answered.

Why can't we shorten the names of these kthreads?  You didn't
give any examples, so I can't suggest any possibilities.

