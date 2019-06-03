Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA25C33236
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 16:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729124AbfFCOcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 10:32:04 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35249 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729112AbfFCOcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 10:32:02 -0400
Received: by mail-pg1-f195.google.com with SMTP id s27so2783138pgl.2
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 07:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hzUTYLyJIfqWCjhTtjBG0SwXN5C9pieJX1yZ/fNJlfM=;
        b=eaLPFr+Eaf59bCyCzpVAHIPnC8xqLgpWXZaR4rZz8ItD+0nBJJeq69I92bv3/zpy2O
         41hZVzQIDPfP+wD63PGly4n4s0gTBx70DvVQMCVrx/HhSth24Q5Wi4TakwbZhuJS6rip
         cz3RHY+nauj3rE0y4a8pBcSQOdRwozKlJSWLGK9DK4i3eTakYP7btsk4XWihEYedjE2n
         3pChjIa2/IfYRg/2RQcCBUhi1yUFmNqcbvSA0QzljaudvdI/ZVQnpRQFz/hiiCleLfkq
         iI4SLIlK93MtjqC67lx6+neBootb9ne1ziuUOW7s51yCKC4B2MK723+klvt9EfbBrR93
         fJLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hzUTYLyJIfqWCjhTtjBG0SwXN5C9pieJX1yZ/fNJlfM=;
        b=QnQHnRN9z/HDaMqi33sS2Qyoof8g7fCcrVsh40XWAR6BXpL7pPyt0FgtiQkdkQiKFs
         V6Rl89P07XX1ffqw30EvjiPxdvIMQ+Kr/gZxO9g6R132zF48R4xsEc/HJw6zXsSgP4PZ
         YQhf2RHgrPcWaH1Dv2IH23FwcO67Kbq3FfVsTBbU8vpP22vsaqEtm0dXGr9uozFjVfVy
         wm7YlpzlWULCq6vj7EEC/iDsAmZ0xoQPqWA3Ff404OIcorJ6xGhpLM7Y3vqgbQBBH5Sy
         x0HWaxEGZF7zqNQCPuKdhmD0uGdv5OxUqCdRMYAAqzhH3am18FY9WQtK3jNX4eyLQR9n
         +QmA==
X-Gm-Message-State: APjAAAUh+nrxKt649myX84toqtAmXhzkolTetPDA+SVkSiETkeAi+If9
        ADwhInuSvQBbGiQrGCI+S9LlOOChQlRfWynRrLkezg==
X-Google-Smtp-Source: APXvYqz62JARGj8JxGWFy+5viuvU32dXkhQ5iv+X79Ts4VPYi9LH21dOu2hiS+UtzZDuokRswnFwn9epckI55I9JNQY=
X-Received: by 2002:a65:64d9:: with SMTP id t25mr28553940pgv.130.1559572321848;
 Mon, 03 Jun 2019 07:32:01 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000044cec9058a6b6003@google.com>
In-Reply-To: <00000000000044cec9058a6b6003@google.com>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Mon, 3 Jun 2019 16:31:50 +0200
Message-ID: <CAAeHK+z6wQA_ZMG0bC7M9792JXDY=-y4qG=_qypVjwuNbFnFpw@mail.gmail.com>
Subject: Re: INFO: trying to register non-static key in mwifiex_unregister_dev
To:     syzbot <syzbot+373e6719b49912399d21@syzkaller.appspotmail.com>
Cc:     amitkarwar@gmail.com, "David S. Miller" <davem@davemloft.net>,
        gbhat@marvell.com, huxinming820@gmail.com,
        Kalle Valo <kvalo@codeaurora.org>,
        LKML <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        nishants@marvell.com,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 3, 2019 at 3:31 PM syzbot
<syzbot+373e6719b49912399d21@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    69bbe8c7 usb-fuzzer: main usb gadget fuzzer driver
> git tree:       https://github.com/google/kasan.git usb-fuzzer
> console output: https://syzkaller.appspot.com/x/log.txt?x=1448d0f2a00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=193d8457178b3229
> dashboard link: https://syzkaller.appspot.com/bug?extid=373e6719b49912399d21
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16e57ca6a00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1106eda2a00000
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+373e6719b49912399d21@syzkaller.appspotmail.com
>
> usb 1-1: Using ep0 maxpacket: 8
> usb 1-1: config 0 has an invalid interface number: 182 but max is 0
> usb 1-1: config 0 has no interface number 0
> usb 1-1: New USB device found, idVendor=1286, idProduct=2052,
> bcdDevice=61.43
> usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> usb 1-1: config 0 descriptor??
> usb 1-1: Direct firmware load for mrvl/usbusb8997_combo_v4.bin failed with
> error -2
> usb 1-1: Failed to get firmware mrvl/usbusb8997_combo_v4.bin
> usb 1-1: info: _mwifiex_fw_dpc: unregister device
> INFO: trying to register non-static key.
> the code is fine but needs lockdep annotation.
> turning off the locking correctness validator.
> CPU: 1 PID: 21 Comm: kworker/1:1 Not tainted 5.2.0-rc1+ #10
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Workqueue: events request_firmware_work_func
> Call Trace:
>   __dump_stack lib/dump_stack.c:77 [inline]
>   dump_stack+0xca/0x13e lib/dump_stack.c:113
>   assign_lock_key kernel/locking/lockdep.c:774 [inline]
>   register_lock_class+0x11ae/0x1240 kernel/locking/lockdep.c:1083
>   __lock_acquire+0x11d/0x5340 kernel/locking/lockdep.c:3673
>   lock_acquire+0x100/0x2b0 kernel/locking/lockdep.c:4302
>   del_timer_sync+0x3a/0x130 kernel/time/timer.c:1277
>   mwifiex_usb_cleanup_tx_aggr
> drivers/net/wireless/marvell/mwifiex/usb.c:1358 [inline]
>   mwifiex_unregister_dev+0x416/0x690
> drivers/net/wireless/marvell/mwifiex/usb.c:1370
>   _mwifiex_fw_dpc+0x577/0xda0 drivers/net/wireless/marvell/mwifiex/main.c:651
>   request_firmware_work_func+0x126/0x242
> drivers/base/firmware_loader/main.c:785
>   process_one_work+0x905/0x1570 kernel/workqueue.c:2268
>   worker_thread+0x96/0xe20 kernel/workqueue.c:2414
>   kthread+0x30b/0x410 kernel/kthread.c:254
>   ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
> ------------[ cut here ]------------
> ODEBUG: assert_init not available (active state 0) object type: timer_list
> hint: 0x0
> WARNING: CPU: 1 PID: 21 at lib/debugobjects.c:325
> debug_print_object+0x160/0x250 lib/debugobjects.c:325
>
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches

#syz dup: INFO: trying to register non-static key in del_timer_sync (2)
