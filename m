Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03C2072253
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 00:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387576AbfGWWXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 18:23:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:39342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727821AbfGWWXi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 18:23:38 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02FCA2184B;
        Tue, 23 Jul 2019 22:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563920617;
        bh=uBsA8GDHuhAVNuUiMbR5RWdtNhGExXIqRYqiBQBznVM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=wmqoLBNEU59749cAIdtDiPO8nvp7PxJQI9ewxTcc+L1Xd7lnuJv+9qwibx5sHtUan
         RqW9eXOhlRopxUm3/OKqHcynaQp6bLqrndRcXz9mJUp66kNSAOb3fR67OaD5nAJOWF
         /LBHk+b1AjIHOOVAj4oRNERceeD1w80KpDyBeD10=
Date:   Tue, 23 Jul 2019 15:23:36 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     syzbot <syzbot+5134cdf021c4ed5aaa5f@syzkaller.appspotmail.com>
Cc:     catalin.marinas@arm.com, davem@davemloft.net, dvyukov@google.com,
        jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-rdma@vger.kernel.org, neilb@suse.de, netdev@vger.kernel.org,
        rds-devel@oss.oracle.com, ross.zwisler@linux.intel.com,
        santosh.shilimkar@oracle.com, syzkaller-bugs@googlegroups.com,
        torvalds@linux-foundation.org, willy@linux.intel.com
Subject: Re: memory leak in rds_send_probe
Message-Id: <20190723152336.29ed51551d8c9600bb316b52@linux-foundation.org>
In-Reply-To: <00000000000034c84a058e608d45@google.com>
References: <000000000000ad1dfe058e5b89ab@google.com>
        <00000000000034c84a058e608d45@google.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Jul 2019 15:17:00 -0700 syzbot <syzbot+5134cdf021c4ed5aaa5f@syzkaller.appspotmail.com> wrote:

> syzbot has bisected this bug to:
> 
> commit af49a63e101eb62376cc1d6bd25b97eb8c691d54
> Author: Matthew Wilcox <willy@linux.intel.com>
> Date:   Sat May 21 00:03:33 2016 +0000
> 
>      radix-tree: change naming conventions in radix_tree_shrink
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=176528c8600000
> start commit:   c6dd78fc Merge branch 'x86-urgent-for-linus' of git://git...
> git tree:       upstream
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=14e528c8600000
> console output: https://syzkaller.appspot.com/x/log.txt?x=10e528c8600000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=8de7d700ea5ac607
> dashboard link: https://syzkaller.appspot.com/bug?extid=5134cdf021c4ed5aaa5f
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=145df0c8600000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=170001f4600000
> 
> Reported-by: syzbot+5134cdf021c4ed5aaa5f@syzkaller.appspotmail.com
> Fixes: af49a63e101e ("radix-tree: change naming conventions in  
> radix_tree_shrink")
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

That's rather hard to believe.  af49a63e101eb6237 simply renames a
couple of local variables.

