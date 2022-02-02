Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66FDE4A709A
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 13:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344080AbiBBMUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 07:20:35 -0500
Received: from www62.your-server.de ([213.133.104.62]:55950 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbiBBMUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 07:20:35 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nFEch-000GG3-PP; Wed, 02 Feb 2022 13:20:31 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nFEch-000WiW-Bx; Wed, 02 Feb 2022 13:20:31 +0100
Subject: Re: [syzbot] KASAN: vmalloc-out-of-bounds Write in ringbuf_map_alloc
To:     syzbot <syzbot+5ad567a418794b9b5983@syzkaller.appspotmail.com>,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        davem@davemloft.net, hotforest@gmail.com, houtao1@huawei.com,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
References: <000000000000b559f905d707ea15@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <8d1abb6f-17c3-4323-d56b-a910092e9989@iogearbox.net>
Date:   Wed, 2 Feb 2022 13:20:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <000000000000b559f905d707ea15@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26441/Wed Feb  2 10:43:13 2022)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/2/22 1:11 PM, syzbot wrote:
> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    6abab1b81b65 Add linux-next specific files for 20220202
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=13f4b900700000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=b8d8750556896349
> dashboard link: https://syzkaller.appspot.com/bug?extid=5ad567a418794b9b5983
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1450d9f0700000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=130ef35bb00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+5ad567a418794b9b5983@syzkaller.appspotmail.com

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/dborkman/bpf.git pr/rb-vmap
