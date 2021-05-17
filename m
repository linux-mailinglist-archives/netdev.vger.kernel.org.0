Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7295382B02
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 13:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236769AbhEQL33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 07:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236684AbhEQL32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 07:29:28 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FF5FC061573;
        Mon, 17 May 2021 04:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ki3+tsvw0l9avC0LZmElq90RxHeKpxQAWRBtoDZLG7U=; b=jEUyKbdH4S8dLaODGEz/kwaDiJ
        Br13KGOmPTXWbEmZT8jeC7kpe3G0obKnBW91Xte98XtD9mnrnJvukSWtQz9ggiewJwCFTXwT9iGew
        ViCm44or0/+8JszLUdYjcT2vfQtEx+3qCQQsfJi0Q7m7qivq1Ln3iuOtfSgmwFXZS25dHY/NRxvUT
        Z3d35IoWX2mJqq6s8KGn0fu+x1WsClQ6z1F1LeBl69ezaUUnvQ1azgYdMbYNboTPPQVfI92pTxut+
        AWafEFDsas6Sauq53ab/Me8zLmODZiWmh9cMgO03LRuXc2ksXGnRy3CNsn1EshFBAoUIXebuStdHD
        j1/DfiIw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1libPc-00Ej3l-4q; Mon, 17 May 2021 11:27:52 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 6CF6E30022A;
        Mon, 17 May 2021 13:27:49 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 31B682028F059; Mon, 17 May 2021 13:27:49 +0200 (CEST)
Date:   Mon, 17 May 2021 13:27:49 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     syzbot <syzbot+0fb24f56fa707081e4f2@syzkaller.appspotmail.com>
Cc:     acme@kernel.org, alexander.shishkin@linux.intel.com,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, jolsa@redhat.com,
        kafai@fb.com, kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, mingo@redhat.com, namhyung@kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Subject: Re: [syzbot] WARNING in __perf_install_in_context
Message-ID: <YKJTNcpqVN6gNIHV@hirez.programming.kicks-ass.net>
References: <000000000000b3d89a05c284718f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000b3d89a05c284718f@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 17, 2021 at 03:56:22AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    18a3c5f7 Merge tag 'for_linus' of git://git.kernel.org/pub..
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux.git fixes
> console output: https://syzkaller.appspot.com/x/log.txt?x=1662c153d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=b8ac1fe5995f69d7
> dashboard link: https://syzkaller.appspot.com/bug?extid=0fb24f56fa707081e4f2
> userspace arch: riscv64
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+0fb24f56fa707081e4f2@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 8643 at kernel/events/core.c:2781 __perf_install_in_context+0x1c0/0x47c kernel/events/core.c:2781
> Modules linked in:
> CPU: 1 PID: 8643 Comm: syz-executor.0 Not tainted 5.12.0-rc8-syzkaller-00011-g18a3c5f7abfd #0
> Hardware name: riscv-virtio,qemu (DT)

How serious should I take this thing? ARM64 and x86_64 don't show these
errors.
