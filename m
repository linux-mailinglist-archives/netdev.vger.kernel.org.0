Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A12AC759CA
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 23:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbfGYVjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 17:39:42 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:33781 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726821AbfGYVji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 17:39:38 -0400
Received: by mail-qt1-f194.google.com with SMTP id r6so46372025qtt.0
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 14:39:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=CSygOM7YhBnAy6MsNYv6TaOG2ZVJz0P5wm8bU+ygO/4=;
        b=he8sVU6r0LuORP3V5bECPCNh4zTrWW+c+9YByWiA/m4wVPzKwS4rxcjYhtNb8XAtCr
         vPhn6X9s1m9Ea721keeZtJtM6n6D0w70kDoKdR2eXi7pykvlO3oDfajbvt21kgOXIyGm
         A6wer3iU+3tejiUzRkwfva1C7JpiU9qVgnqDbvw67NKyV8AlfL00gNGijmy61Q6m+CDe
         +J86Y/mXfWPrI/ewTSTpr6yeebWZTELAR6B8EWA6I1CyIafedvBEDfCDTVJyy/aiP3hW
         pGbDNqi5ZJe8rms1lBSBS8vg1Lt8dAaSeB8qhTDq+z4AWvhEKkggpKF3dSELmZ2IW5g8
         WkSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=CSygOM7YhBnAy6MsNYv6TaOG2ZVJz0P5wm8bU+ygO/4=;
        b=psj0btWI+FlT3FXrVfd5wsZRyEdCwA5r3m0BDwIirQr+0SO+lnJqVKGFsqBFeOTjOd
         IG9NFI2Nx7Mw9Q33NbR+3hQTWGZCfDnIF3CDO0vAiQ/2+cnDK/QvvgmVTWoA+6fw9iLo
         3tHtZj6lYnNB6uEZh/Ct8vzbD5wBOqFUSD7756sBMUOBHnPhbw8PyzBxMb1yy2ehINru
         FNbjJEnMsUWkV2MDyJwSbhtNLsT3JspQJ1qZCUaPcp7XnxJC2upHk5TisPyYlOiL0qjQ
         mhBm/7ybxw1Ib2SUPH0TW1xe7hoF9CtUejRO6GVjw4B15T3HjKby9JRp+iy/kVtwPQaV
         g0Ng==
X-Gm-Message-State: APjAAAVcNH8CZQOo8DsXCQ/3sG54T7DhBH4+j/oYzTo7ZC3O3dNZfPTG
        wvVqdezT3PLsOP48u0McdWHx0Q==
X-Google-Smtp-Source: APXvYqyYasGQHoqJBwR2mvO8Ts9j5uUl2Sqix4ffDGoTkQFRVGfQzVPXJ95YOGNCYmaWD71TU8x+Dg==
X-Received: by 2002:a0c:c93c:: with SMTP id r57mr49389143qvj.226.1564090776809;
        Thu, 25 Jul 2019 14:39:36 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z33sm23385643qtc.56.2019.07.25.14.39.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 25 Jul 2019 14:39:36 -0700 (PDT)
Date:   Thu, 25 Jul 2019 14:39:32 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     syzbot <syzbot+0e0fedcad708d12d3032@syzkaller.appspotmail.com>
Cc:     ast@kernel.org, aviadye@mellanox.com, borisp@mellanox.com,
        bpf@vger.kernel.org, daniel@iogearbox.net, davejwatson@fb.com,
        davem@davemloft.net, john.fastabend@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Subject: Re: general protection fault in tls_trim_both_msgs
Message-ID: <20190725143932.78705103@cakuba.netronome.com>
In-Reply-To: <0000000000002b4896058e7abf78@google.com>
References: <0000000000002b4896058e7abf78@google.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Jul 2019 22:32:07 -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    9e6dfe80 Add linux-next specific files for 20190724
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=1046971fa00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=6cbb8fc2cf2842d7
> dashboard link: https://syzkaller.appspot.com/bug?extid=0e0fedcad708d12d3032
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> 
> Unfortunately, I don't have any reproducer for this crash yet.

Looks very like the issue we mentioned in the cover letter for unhash
fixes. TX is waiting for mem, the connection dies, we free ctx, TX
wakes up with a now stale ctx pointer. I'm testing a fix for this,
Netronome team was actually able to trigger a NULL-deref on the RX
side, because there ctx is reloaded but not NULL-checked.

> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+0e0fedcad708d12d3032@syzkaller.appspotmail.com
> 
> kasan: CONFIG_KASAN_INLINE enabled
> kasan: GPF could be caused by NULL-ptr deref or user memory access
> general protection fault: 0000 [#1] PREEMPT SMP KASAN
> CPU: 1 PID: 15517 Comm: syz-executor.4 Not tainted 5.3.0-rc1-next-20190724  
> #50
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
> Google 01/01/2011
> RIP: 0010:tls_trim_both_msgs+0x54/0x130 net/tls/tls_sw.c:268
> Code: 48 c1 ea 03 80 3c 02 00 0f 85 e3 00 00 00 4d 8b b5 b0 06 00 00 48 b8  
> 00 00 00 00 00 fc ff df 49 8d 7e 28 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f  
> 85 b3 00 00 00 48 b8 00 00 00 00 00 fc ff df 49 8b
> RSP: 0018:ffff8880612cfac0 EFLAGS: 00010206
> RAX: dffffc0000000000 RBX: ffff8880a8794340 RCX: ffffc9000e7b9000
> RDX: 0000000000000005 RSI: ffffffff86298656 RDI: 0000000000000028
> RBP: ffff8880612cfae0 R08: ffff88805ae4c580 R09: fffffbfff14a8155
> R10: fffffbfff14a8154 R11: ffffffff8a540aa7 R12: 0000000000000000
> R13: ffff888061d82e00 R14: 0000000000000000 R15: 00000000ffffffe0
> FS:  00007f7d33516700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b2fa2f000 CR3: 000000009fcf1000 CR4: 00000000001406e0
> Call Trace:
>   tls_sw_sendmsg+0xe38/0x17b0 net/tls/tls_sw.c:1057
>   inet6_sendmsg+0x9e/0xe0 net/ipv6/af_inet6.c:576
>   sock_sendmsg_nosec net/socket.c:637 [inline]
>   sock_sendmsg+0xd7/0x130 net/socket.c:657
>   __sys_sendto+0x262/0x380 net/socket.c:1952
>   __do_sys_sendto net/socket.c:1964 [inline]
>   __se_sys_sendto net/socket.c:1960 [inline]
>   __x64_sys_sendto+0xe1/0x1a0 net/socket.c:1960
>   do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x459829
> Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
> 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
> ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007f7d33515c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
> RAX: ffffffffffffffda RBX: 0000000000000006 RCX: 0000000000459829
> RDX: ffffffffffffffc1 RSI: 00000000200005c0 RDI: 0000000000000003
> RBP: 000000000075bf20 R08: 0000000000000000 R09: 1201000000003618
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007f7d335166d4
> R13: 00000000004c7669 R14: 00000000004dcc70 R15: 00000000ffffffff
> Modules linked in:
> ---[ end trace 2dd728cceb39a185 ]---
> RIP: 0010:tls_trim_both_msgs+0x54/0x130 net/tls/tls_sw.c:268
> Code: 48 c1 ea 03 80 3c 02 00 0f 85 e3 00 00 00 4d 8b b5 b0 06 00 00 48 b8  
> 00 00 00 00 00 fc ff df 49 8d 7e 28 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f  
> 85 b3 00 00 00 48 b8 00 00 00 00 00 fc ff df 49 8b
> RSP: 0018:ffff8880612cfac0 EFLAGS: 00010206
> RAX: dffffc0000000000 RBX: ffff8880a8794340 RCX: ffffc9000e7b9000
> RDX: 0000000000000005 RSI: ffffffff86298656 RDI: 0000000000000028
> RBP: ffff8880612cfae0 R08: ffff88805ae4c580 R09: fffffbfff14a8155
> R10: fffffbfff14a8154 R11: ffffffff8a540aa7 R12: 0000000000000000
> R13: ffff888061d82e00 R14: 0000000000000000 R15: 00000000ffffffe0
> FS:  00007f7d33516700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000019dbe80 CR3: 000000009fcf1000 CR4: 00000000001406e0
> 
> 
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

