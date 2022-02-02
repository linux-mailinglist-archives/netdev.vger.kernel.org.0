Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2DF14A6D65
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 10:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240646AbiBBJBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 04:01:08 -0500
Received: from www62.your-server.de ([213.133.104.62]:37648 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237098AbiBBJBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 04:01:08 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nFBVe-0006LF-Bm; Wed, 02 Feb 2022 10:01:02 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nFBVe-000Txw-1l; Wed, 02 Feb 2022 10:01:02 +0100
Subject: Re: [syzbot] possible deadlock in ___neigh_create
To:     syzbot <syzbot+5239d0e1778a500d477a@syzkaller.appspotmail.com>,
        davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
        john.fastabend@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        roopa@nvidia.com, syzkaller-bugs@googlegroups.com
References: <00000000000034665005d7035599@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <eb631eb1-b7e1-bfb5-0027-1577445ce39a@iogearbox.net>
Date:   Wed, 2 Feb 2022 10:01:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <00000000000034665005d7035599@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26440/Tue Feb  1 10:29:16 2022)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/2/22 7:43 AM, syzbot wrote:
> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    e4d2763f9aaf Merge branch 'lan966x-ptp'
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=15b941f0700000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=e029d3b2ccd4c91a
> dashboard link: https://syzkaller.appspot.com/bug?extid=5239d0e1778a500d477a
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16f9a76c700000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+5239d0e1778a500d477a@syzkaller.appspotmail.com

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/dborkman/bpf.git pr/neigh-probe
