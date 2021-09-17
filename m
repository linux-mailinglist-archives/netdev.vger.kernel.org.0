Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46B35410105
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 23:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244692AbhIQWBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 18:01:14 -0400
Received: from www62.your-server.de ([213.133.104.62]:35142 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbhIQWBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 18:01:13 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mRLta-0003vX-Rc; Fri, 17 Sep 2021 23:59:46 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mRLta-000XXb-Ga; Fri, 17 Sep 2021 23:59:46 +0200
Subject: Re: [syzbot] general protection fault in bpf_skb_cgroup_id
To:     syzbot <syzbot+33f36d0754d4c5c0e102@syzkaller.appspotmail.com>,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
References: <000000000000f152a305cc374d7b@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a0ad330c-3caa-5c56-3f1c-c600fe6dacbe@iogearbox.net>
Date:   Fri, 17 Sep 2021 23:59:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <000000000000f152a305cc374d7b@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26297/Thu Sep 16 15:59:37 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/17/21 11:06 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    2865ba82476a Merge git://git.kernel.org/pub/scm/linux/kern..
> git tree:       bpf
> console output: https://syzkaller.appspot.com/x/log.txt?x=15089853300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c31c0936547df9ea
> dashboard link: https://syzkaller.appspot.com/bug?extid=33f36d0754d4c5c0e102
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14dbd7ed300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1586f83b300000
> 
> Bisection is inconclusive: the first bad commit could be any of:
> 
> 0e6491b55970 bpf: Add oversize check before call kvcalloc()
> 2f1aaf3ea666 bpf, mm: Fix lockdep warning triggered by stack_map_get_build_id_offset()
> 8520e224f547 bpf, cgroups: Fix cgroup v2 fallback on v1/v2 mixed mode
> 3a029e1f3d6e selftests/bpf: Fix build of task_pt_regs test for arm64
> d8079d8026f8 bpf, selftests: Add cgroup v1 net_cls classid helpers
> 43d2b88c29f2 bpf, selftests: Add test case for mixed cgroup v1/v2
> 49ca6153208f bpf: Relicense disassembler as GPL-2.0-only OR BSD-2-Clause
> 2865ba82476a Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16b5ccdd300000

I'll take a look at the report.

Thanks,
Daniel
