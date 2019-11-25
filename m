Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA0810955F
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 23:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbfKYWFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 17:05:00 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:52627 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbfKYWFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 17:05:00 -0500
Received: from fsav401.sakura.ne.jp (fsav401.sakura.ne.jp [133.242.250.100])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id xAPM40dL086354;
        Tue, 26 Nov 2019 07:04:01 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav401.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav401.sakura.ne.jp);
 Tue, 26 Nov 2019 07:04:00 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav401.sakura.ne.jp)
Received: from [192.168.1.9] (softbank126040052248.bbtec.net [126.40.52.248])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id xAPM3qjm086324
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NO);
        Tue, 26 Nov 2019 07:04:00 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Subject: Re: general protection fault in selinux_socket_sendmsg (2)
To:     syzbot <syzbot+314db21f0d5c1f53856c@syzkaller.appspotmail.com>,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <0000000000006c9f4e059830c33c@google.com>
Cc:     andriin@fb.com, anton@enomsg.org, ast@kernel.org,
        bpf@vger.kernel.org, ccross@android.com, daniel@iogearbox.net,
        eparis@parisplace.org, kafai@fb.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, paul@paul-moore.com,
        sds@tycho.nsa.gov, selinux@vger.kernel.org, songliubraving@fb.com,
        tony.luck@intel.com, yhs@fb.com
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-ID: <2340a1a3-37cf-5f55-1f9a-9052a557f579@I-love.SAKURA.ne.jp>
Date:   Tue, 26 Nov 2019 07:03:51 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <0000000000006c9f4e059830c33c@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/11/26 4:28, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    6b8a7946 Merge tag 'for_linus' of git://git.kernel.org/pub..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1680ab8ce00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=4737c15fc47048f2
> dashboard link: https://syzkaller.appspot.com/bug?extid=314db21f0d5c1f53856c
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> 
> Unfortunately, I don't have any reproducer for this crash yet.

Original bug has syz reproducer.

> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+314db21f0d5c1f53856c@syzkaller.appspotmail.com
> 

net/rxrpc/output.c:655

#syz dup: KMSAN: use-after-free in rxrpc_send_keepalive
