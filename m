Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4384DDC5A9
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 15:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2634032AbfJRNBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 09:01:36 -0400
Received: from www62.your-server.de ([213.133.104.62]:45398 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2410223AbfJRNBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 09:01:35 -0400
Received: from 55.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.55] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iLRsm-0000UA-Qr; Fri, 18 Oct 2019 15:01:28 +0200
Date:   Fri, 18 Oct 2019 15:01:28 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     syzbot <syzbot+710043c5d1d5b5013bc7@syzkaller.appspotmail.com>
Cc:     ast@kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        hawk@kernel.org, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Subject: Re: BUG: unable to handle kernel paging request in
 is_bpf_text_address
Message-ID: <20191018130128.GC26267@pc-63.home>
References: <000000000000410cbb059528d6f7@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000410cbb059528d6f7@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25606/Fri Oct 18 10:58:40 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 17, 2019 at 10:45:09PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    283ea345 coccinelle: api/devm_platform_ioremap_resource: r..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=122f199b600000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=f0a8b0a0736a2ac1
> dashboard link: https://syzkaller.appspot.com/bug?extid=710043c5d1d5b5013bc7
> compiler:       clang version 9.0.0 (/home/glider/llvm/clang
> 80fee25776c2fb61e74c1ecb1a523375c2500b69)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=142676bb600000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11a2cebb600000

I'll take a look, thanks!
