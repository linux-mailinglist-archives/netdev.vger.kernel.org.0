Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E87D627951
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 10:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236163AbiKNJpx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 04:45:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235864AbiKNJpw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 04:45:52 -0500
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 727621DF08
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 01:45:49 -0800 (PST)
Received: by mail-io1-f69.google.com with SMTP id n23-20020a056602341700b00689fc6dbfd6so5481070ioz.8
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 01:45:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GUL3MobidaaGFE5xTUouvIf/4fdEFRDpBRQmnEe4eUQ=;
        b=BInPAUSVPfS+OL9uO4+IvEr5rpM6n+oP0V/8t4BZpqZMTeIiVWfNoADOtEIY7suy0U
         //oL9rdrPG1qJqg/jBZiSH25+HIkx+f8QsDcCxeRDJl/MGsb7eiioWIphtsf2ytDDSsQ
         RHt0PQXHDAi5ELwrvPH89kUJjWTiCbIH+zNio0piHO48620Ngr+/sLnZieq8qHs/Glqd
         jiCzw9m3ImJkA3lKKlcZir+dTAaIe/qCRHaU7nFommuHHFn8W5AZoXrIi4HXIq6qB1Ng
         rGLBxMamad7VrfPVdsb+Gaat8aQtLR/SM0WWN+fc5USbSEtGqlOL5/gLRy+8jvo3oJbU
         Fsag==
X-Gm-Message-State: ANoB5pmwHyxkAE/i/R9H1deeOJqtV69OxAG7poKwRe81eeaEjsyvWUG/
        Dd7zZ1zPA2PJKdkmNMWwgJv2cAkSOEjYZnfX2igcIKtyv8TC
X-Google-Smtp-Source: AA0mqf5G1Rh67bQf/38ogYalSTEMhlmBhJW4QCcvRBW/Eh00/SwrZ8g9QgL3Fh02gDow6oEeRq95N9IDaX2YynSu4fcm4D4M/JZ6
MIME-Version: 1.0
X-Received: by 2002:a02:9f05:0:b0:375:5e4b:4f97 with SMTP id
 z5-20020a029f05000000b003755e4b4f97mr5316223jal.199.1668419148783; Mon, 14
 Nov 2022 01:45:48 -0800 (PST)
Date:   Mon, 14 Nov 2022 01:45:48 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b325fb05ed6b1a69@google.com>
Subject: [syzbot] WARNING: ODEBUG bug in nci_free_device
From:   syzbot <syzbot+c8ba0eb624e8efbb37a1@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com,
        krzysztof.kozlowski@linaro.org, kuba@kernel.org, linma@zju.edu.cn,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    af7a05689189 Merge tag 'mips-fixes_6.1_1' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17f74649880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7abe2506fc0b8c90
dashboard link: https://syzkaller.appspot.com/bug?extid=c8ba0eb624e8efbb37a1
compiler:       arm-linux-gnueabi-gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: arm

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c8ba0eb624e8efbb37a1@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 10093 at lib/debugobjects.c:502 debug_print_object+0xb0/0xc4 lib/debugobjects.c:502
ODEBUG: free active (active state 0) object type: timer_list hint: nci_cmd_timer+0x0/0x2c net/nfc/nci/core.c:625
Modules linked in:
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 10093 Comm: syz-executor.1 Not tainted 6.1.0-rc4-syzkaller #0
Hardware name: ARM-Versatile Express
Backtrace: 
[<8173b47c>] (dump_backtrace) from [<8173b570>] (show_stack+0x18/0x1c arch/arm/kernel/traps.c:253)
 r7:81cfb8d0 r6:822228ec r5:600a0093 r4:81d09cb8
[<8173b558>] (show_stack) from [<81757650>] (__dump_stack lib/dump_stack.c:88 [inline])
[<8173b558>] (show_stack) from [<81757650>] (dump_stack_lvl+0x48/0x54 lib/dump_stack.c:106)
[<81757608>] (dump_stack_lvl) from [<81757674>] (dump_stack+0x18/0x1c lib/dump_stack.c:113)
 r5:00000000 r4:82448d14
[<8175765c>] (dump_stack) from [<8173c118>] (panic+0x11c/0x360 kernel/panic.c:274)
[<8173bffc>] (panic) from [<80241604>] (__warn+0x98/0x1a4 kernel/panic.c:621)
 r3:00000001 r2:00000000 r1:00000000 r0:81cfb8d0
 r7:807a8834
[<8024156c>] (__warn) from [<8173c3f8>] (warn_slowpath_fmt+0x9c/0xd4 kernel/panic.c:651)
 r8:00000009 r7:807a8834 r6:000001f6 r5:81d53dac r4:81d53d6c
[<8173c360>] (warn_slowpath_fmt) from [<807a8834>] (debug_print_object+0xb0/0xc4 lib/debugobjects.c:502)
 r8:81804850 r7:81d20a24 r6:841589a8 r5:824cc2cc r4:8220cd94
[<807a8784>] (debug_print_object) from [<807a9f9c>] (__debug_check_no_obj_freed lib/debugobjects.c:989 [inline])
[<807a8784>] (debug_print_object) from [<807a9f9c>] (debug_check_no_obj_freed+0x1e8/0x230 lib/debugobjects.c:1020)
 r8:81804850 r7:00000122 r6:84f3e000 r5:84f3e030 r4:841589a8
[<807a9db4>] (debug_check_no_obj_freed) from [<80481b64>] (slab_free_hook mm/slub.c:1699 [inline])
[<807a9db4>] (debug_check_no_obj_freed) from [<80481b64>] (slab_free_freelist_hook mm/slub.c:1750 [inline])
[<807a9db4>] (debug_check_no_obj_freed) from [<80481b64>] (slab_free mm/slub.c:3661 [inline])
[<807a9db4>] (debug_check_no_obj_freed) from [<80481b64>] (__kmem_cache_free+0x16c/0x340 mm/slub.c:3674)
 r10:5ac3c35a r9:00000000 r8:84ef8490 r7:816ca63c r6:ddeab3e0 r5:84f3e000
 r4:82801600
[<804819f8>] (__kmem_cache_free) from [<80425fa8>] (kfree+0x6c/0x158 mm/slab_common.c:1007)
 r10:5ac3c35a r9:7efffd08 r8:84ef8490 r7:833d4450 r6:816ca63c r5:ddeab3e0
 r4:84f3e000
[<80425f3c>] (kfree) from [<816ca63c>] (nci_free_device+0x2c/0x30 net/nfc/nci/core.c:1205)
 r7:833d4450 r6:834eaf68 r5:000e001b r4:84f3e000
[<816ca610>] (nci_free_device) from [<809f1974>] (virtual_ncidev_close+0x6c/0x7c drivers/nfc/virtual_ncidev.c:167)
 r5:000e001b r4:824fd054
[<809f1908>] (virtual_ncidev_close) from [<804a9600>] (__fput+0x84/0x264 fs/file_table.c:320)
 r5:000e001b r4:84303900
[<804a957c>] (__fput) from [<804a985c>] (____fput+0x10/0x14 fs/file_table.c:348)
 r9:7efffd08 r8:83e56fc4 r7:824495dc r6:83e56780 r5:83e56f94 r4:00000000
[<804a984c>] (____fput) from [<8026618c>] (task_work_run+0x8c/0xb4 kernel/task_work.c:179)
[<80266100>] (task_work_run) from [<8020c070>] (resume_user_mode_work include/linux/resume_user_mode.h:49 [inline])
[<80266100>] (task_work_run) from [<8020c070>] (do_work_pending+0x420/0x524 arch/arm/kernel/signal.c:630)
 r9:7efffd08 r8:80200288 r7:fffffe30 r6:80200288 r5:e031dfb0 r4:83e56780
[<8020bc50>] (do_work_pending) from [<80200088>] (slow_work_pending+0xc/0x20)
Exception stack(0xe031dfb0 to 0xe031dff8)
dfa0:                                     00000000 00000002 00000000 00000003
dfc0: 00000004 015c14c0 00000000 00000006 00140000 000003e8 0014c048 00000000
dfe0: 2ec60000 7ec52408 0002993c 00029df8 80000010 00000003
 r10:00000006 r9:83e56780 r8:80200288 r7:00000006 r6:00000000 r5:015c14c0
 r4:00000004
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
