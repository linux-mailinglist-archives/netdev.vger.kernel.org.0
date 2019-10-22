Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48373E0653
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 16:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbfJVOZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 10:25:33 -0400
Received: from www62.your-server.de ([213.133.104.62]:43736 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbfJVOZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 10:25:33 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iMv6C-0003zB-Dh; Tue, 22 Oct 2019 16:25:24 +0200
Received: from [178.197.249.13] (helo=pc-63.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iMv6C-000NS0-0T; Tue, 22 Oct 2019 16:25:24 +0200
Subject: Re: KASAN: use-after-free Read in is_bpf_text_address
To:     syzbot <syzbot+0cd01c9e0f5cd37a357e@syzkaller.appspotmail.com>,
        ast@kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        hawk@kernel.org, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
References: <000000000000da1dfc0595801e46@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <32ff9867-ceeb-de21-afca-70eeb8282e89@iogearbox.net>
Date:   Tue, 22 Oct 2019 16:25:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <000000000000da1dfc0595801e46@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25610/Tue Oct 22 10:54:26 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/22/19 3:53 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    4fe34d61 Merge branch 'x86-urgent-for-linus' of git://git...
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=15b01a60e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=f0a8b0a0736a2ac1
> dashboard link: https://syzkaller.appspot.com/bug?extid=0cd01c9e0f5cd37a357e
> compiler:       clang version 9.0.0 (/home/glider/llvm/clang 80fee25776c2fb61e74c1ecb1a523375c2500b69)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=161f89f7600000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16e2d0f8e00000

Fixed by (also just checked via syz test): https://patchwork.ozlabs.org/patch/1181358/

Thanks,
Daniel
