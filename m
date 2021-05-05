Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C33373301
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 02:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbhEEARI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 20:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbhEEARI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 20:17:08 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98574C061574;
        Tue,  4 May 2021 17:16:12 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id s20so163948plr.13;
        Tue, 04 May 2021 17:16:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=Jn1nbpzzqL7HQEQVHOL9iyFV0ucov1Ws5Tt2GVyMqV8=;
        b=bZ6TL3d8pD15cLxcw6tLSJthNXy+uZqZ7y3ZMjs5WK4GHni4h1MfVHZmCD7FsMf60I
         lbqhdiypAHDaTdsFhfYptm7z0+SNEBcvMnEXEid4dcXN0KmAf6rcFWXTGxrcyd6V3C8K
         VPigPoYVa4p1rlGKLOEFPSurGRGqcB/i+xEM4OSKyChoyPp7IytV+VMkw2H0Ty71aRd/
         pVqv25DvHMdPPl0AKPGfxV3hZgVTApAUHi/LPiK9e9zzu9fytSPq+x3F1RuL8FlA+FL9
         2wezeo8mjyF4FFvdrC6gTeGsL7HOnwXtk1DqqLXhGklnLLLZXV/ei8+CeQt5mEvIavnR
         cpJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Jn1nbpzzqL7HQEQVHOL9iyFV0ucov1Ws5Tt2GVyMqV8=;
        b=Kr00DIDnksr21Edr8vacEiGtUuompR2Xna8YUEPjfPjiyJQnWVq1MNQyyos0rEQ/Tu
         7DLuPP56n7YHr66TYGNRIE43wsTesKkKIUjoIAvPz9Ni3gXQnBpGifQOCtQilsldyXA6
         bhbEYYB6QzcCXYNRJAHk4gacvRj8fxeBBQSKlhK7wTxddEqk3C3LEjACjAZhR64Nn78G
         9RHKjZ6KpJtJFuIfOtwsORVI31P2LvmJX9nRmCW+AJAvQToDJod9aJlJlT/PQ2PVet97
         SBv8rJL8LdOXPu2TVTs/3/ny8IvUGgeWuUkHEOPANJB3c1I1OEZsKxl1faj448rx//Ro
         zhSg==
X-Gm-Message-State: AOAM532XjKn/ABod5izxsb6YfpdA3EtL4MN/2FwcwEbZ6PHJrk2wCvlj
        bdudM6LnmNzOigTnmKP9BcM=
X-Google-Smtp-Source: ABdhPJxbOvElbjXxVijJ1f2EQ5hYTP6MEBhswnsnfHjyzrxQZt10tq5wIAbUIdJ7uGosy/bzHb36/A==
X-Received: by 2002:a17:902:f203:b029:ee:e32f:2a28 with SMTP id m3-20020a170902f203b02900eee32f2a28mr9209515plc.45.1620173772094;
        Tue, 04 May 2021 17:16:12 -0700 (PDT)
Received: from [192.168.1.41] (097-090-198-083.res.spectrum.com. [97.90.198.83])
        by smtp.gmail.com with ESMTPSA id j23sm14139867pfh.179.2021.05.04.17.16.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 May 2021 17:16:11 -0700 (PDT)
Subject: Re: WARNING: ODEBUG bug in bt_host_release
To:     syzbot <syzbot+0ce8a29c6c6469b16632@syzkaller.appspotmail.com>,
        davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <0000000000001d48cd05abebd088@google.com>
From:   SyzScope <syzscope@gmail.com>
Message-ID: <1346bb49-639f-21a9-f3c1-508d9ade87de@gmail.com>
Date:   Tue, 4 May 2021 17:16:09 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <0000000000001d48cd05abebd088@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This is SyzScope, a research project that aims to reveal high-risk 
primitives from a seemingly low-risk bug (UAF/OOB read, WARNING, BUG, etc.).

We are currently testing seemingly low-risk bugs on syzbot's open 
section(https://syzkaller.appspot.com/upstream), and try to reach out to 
kernel developers as long as SyzScope discovers any high-risk primitives.

Regrading the bug "WARNING: ODEBUG bug in bt_host_release", SyzScope 
reports 146 memory write primitives, and 7 control flow hijacking 
primitives.

The detailed comments can be found at 
https://sites.google.com/view/syzscope/warning-odebug-bug-in-bt_host_release

Please let us know if SyzScope indeed helps, and any suggestions/feedback.

On 8/2/2020 2:36 PM, syzbot wrote:
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    ac3a0c84 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=11e1da92900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=e59ee776d5aa8d55
> dashboard link: https://syzkaller.appspot.com/bug?extid=0ce8a29c6c6469b16632
> compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14f653ca900000
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+0ce8a29c6c6469b16632@syzkaller.appspotmail.com
>
> ------------[ cut here ]------------
> ODEBUG: free active (active state 0) object type: timer_list hint: delayed_work_timer_fn+0x0/0x80 arch/x86/include/asm/paravirt.h:770
> WARNING: CPU: 1 PID: 20314 at lib/debugobjects.c:488 debug_print_object lib/debugobjects.c:485 [inline]
> WARNING: CPU: 1 PID: 20314 at lib/debugobjects.c:488 __debug_check_no_obj_freed lib/debugobjects.c:967 [inline]
> WARNING: CPU: 1 PID: 20314 at lib/debugobjects.c:488 debug_check_no_obj_freed+0x45c/0x640 lib/debugobjects.c:998
> Kernel panic - not syncing: panic_on_warn set ...
> CPU: 1 PID: 20314 Comm: syz-executor.5 Not tainted 5.8.0-rc7-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>   __dump_stack lib/dump_stack.c:77 [inline]
>   dump_stack+0x1f0/0x31e lib/dump_stack.c:118
>   panic+0x264/0x7a0 kernel/panic.c:231
>   __warn+0x227/0x250 kernel/panic.c:600
>   report_bug+0x1b1/0x2e0 lib/bug.c:198
>   handle_bug+0x42/0x80 arch/x86/kernel/traps.c:235
>   exc_invalid_op+0x16/0x40 arch/x86/kernel/traps.c:255
>   asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:540
> RIP: 0010:debug_print_object lib/debugobjects.c:485 [inline]
> RIP: 0010:__debug_check_no_obj_freed lib/debugobjects.c:967 [inline]
> RIP: 0010:debug_check_no_obj_freed+0x45c/0x640 lib/debugobjects.c:998
> Code: 74 08 4c 89 f7 e8 04 e4 11 fe 4d 8b 06 48 c7 c7 ef b7 14 89 48 c7 c6 fd 95 12 89 48 89 da 89 e9 4d 89 f9 31 c0 e8 64 95 a4 fd <0f> 0b 48 ba 00 00 00 00 00 fc ff df ff 05 86 c1 eb 05 48 8b 5c 24
> RSP: 0018:ffffc90003777b90 EFLAGS: 00010046
> RAX: ffd2d42dae8b6000 RBX: ffffffff8918b660 RCX: ffff888087ef6000
> RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
> RBP: 0000000000000000 R08: ffffffff815dd389 R09: ffffed1015d241c3
> R10: ffffed1015d241c3 R11: 0000000000000000 R12: ffff8880a131c9ec
> R13: ffffffff8ba5dfb8 R14: ffffffff894edb20 R15: ffffffff814c4b60
>   kfree+0xfc/0x220 mm/slab.c:3756
>   bt_host_release+0x18/0x20 net/bluetooth/hci_sysfs.c:86
>   device_release+0x70/0x1a0 drivers/base/core.c:1575
>   kobject_cleanup lib/kobject.c:693 [inline]
>   kobject_release lib/kobject.c:722 [inline]
>   kref_put include/linux/kref.h:65 [inline]
>   kobject_put+0x15b/0x220 lib/kobject.c:739
>   vhci_release+0x7b/0xc0 drivers/bluetooth/hci_vhci.c:341
>   __fput+0x2f0/0x750 fs/file_table.c:281
>   task_work_run+0x137/0x1c0 kernel/task_work.c:135
>   exit_task_work include/linux/task_work.h:25 [inline]
>   do_exit+0x601/0x1f80 kernel/exit.c:805
>   do_group_exit+0x161/0x2d0 kernel/exit.c:903
>   __do_sys_exit_group+0x13/0x20 kernel/exit.c:914
>   __se_sys_exit_group+0x10/0x10 kernel/exit.c:912
>   __x64_sys_exit_group+0x37/0x40 kernel/exit.c:912
>   do_syscall_64+0x73/0xe0 arch/x86/entry/common.c:384
>   entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x45cc79
> Code: Bad RIP value.
> RSP: 002b:00007ffe023458d8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 000000000045cc79
> RDX: 00000000004166d1 RSI: 0000000000ca85f0 RDI: 0000000000000043
> RBP: 00000000004c2903 R08: 000000000000000b R09: 0000000000000000
> R10: 000000000246f940 R11: 0000000000000246 R12: 0000000000000004
> R13: 00007ffe02345a20 R14: 00000000000b206f R15: 00007ffe02345a30
> Kernel Offset: disabled
> Rebooting in 86400 seconds..
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
>
