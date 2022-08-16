Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFE37595990
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 13:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234085AbiHPLLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 07:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235279AbiHPLK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 07:10:57 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA1AF5F23C
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 01:40:24 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id y4-20020a056e021be400b002e5a1e77e04so4009569ilv.22
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 01:40:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc;
        bh=S7sXChFfUUDqSARJ95OntzRb6yK9dHFthrmWhZP2eZY=;
        b=ujRXVwooXifuoUTYKJKaRebYrCKwqdwqMrvKGyUdguPqHAevJtRF12UoDKovOuw2TX
         5ZayRNsB0q3dfPETg+YmVX6BwBkLnTCyWmQXY5IoMSaJrz4qVpLPd+oeYUtEe2Slnb1T
         lxZi6Qzzg8vZoapT7GE/cX9jaSZGLJdmfXZeAWx/Y3uhNu8iEgsCk5nG58X5D0UIg+tB
         9HC7rj98ZJsYb1YO4U91OchybXuzQzoNELC2d4itnlwqClYFfgn0MMNbivAWXgTlZ9Wp
         vqqgYPaNecltdK4d4ct5MUQqb1cD/GWCKep+Fqn7wZQi4VHqVGjvqIIKvCdGCMctbs8n
         SePw==
X-Gm-Message-State: ACgBeo28owKXYvq9rOC4rh3uh9IZI8M6ZA3c4T+EfPs6RcFt4R/LTKXD
        T+iBtSQhir4SKB4dSFsFkoDDHChIbRdXljo6XehaI2PCxXYf
X-Google-Smtp-Source: AA6agR4KYBTAkbzdDt+iqgXQAeuVNL/5PRmdr0Xm9+Ri8L+Gjxo676Q2XGjawBiHrpsy7415qhjZqC44zZ3h8xHwHQnxzqB+JzgH
MIME-Version: 1.0
X-Received: by 2002:a6b:b802:0:b0:67b:de15:c1fb with SMTP id
 i2-20020a6bb802000000b0067bde15c1fbmr8215634iof.215.1660639223858; Tue, 16
 Aug 2022 01:40:23 -0700 (PDT)
Date:   Tue, 16 Aug 2022 01:40:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000009cd7a05e657b38e@google.com>
Subject: [syzbot] upstream boot error: BUG: unable to handle kernel paging
 request in ieee80211_register_hw
From:   syzbot <syzbot+655209e079e67502f2da@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com,
        johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    4a9350597aff Merge tag 'sound-fix-6.0-rc1' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11515705080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bc6716795f118372
dashboard link: https://syzkaller.appspot.com/bug?extid=655209e079e67502f2da
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: i386

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+655209e079e67502f2da@syzkaller.appspotmail.com

usbcore: registered new interface driver nfcmrvl
Loading iSCSI transport class v2.0-870.
scsi host0: Virtio SCSI HBA
st: Version 20160209, fixed bufsize 32768, s/g segs 256
Rounding down aligned max_sectors from 4294967295 to 4294967288
db_root: cannot open: /etc/target
slram: not enough parameters.
ftl_cs: FTL header not found.
wireguard: WireGuard 1.0.0 loaded. See www.wireguard.com for information.
wireguard: Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
eql: Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller (davem@redhat.com)
MACsec IEEE 802.1AE
tun: Universal TUN/TAP device driver, 1.6
vcan: Virtual CAN interface driver
vxcan: Virtual CAN Tunnel driver
slcan: serial line CAN interface driver
CAN device driver interface
usbcore: registered new interface driver usb_8dev
usbcore: registered new interface driver ems_usb
usbcore: registered new interface driver gs_usb
usbcore: registered new interface driver kvaser_usb
usbcore: registered new interface driver mcba_usb
usbcore: registered new interface driver peak_usb
e100: Intel(R) PRO/100 Network Driver
e100: Copyright(c) 1999-2006 Intel Corporation
e1000: Intel(R) PRO/1000 Network Driver
e1000: Copyright (c) 1999-2006 Intel Corporation.
e1000e: Intel(R) PRO/1000 Network Driver
e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
mkiss: AX.25 Multikiss, Hans Albas PE1AYX
AX.25: 6pack driver, Revision: 0.3.0
AX.25: bpqether driver version 004
PPP generic driver version 2.4.2
PPP BSD Compression module registered
PPP Deflate Compression module registered
PPP MPPE Compression module registered
NET: Registered PF_PPPOX protocol family
PPTP driver version 0.8.5
SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256) (6 bit encapsulation enabled).
CSLIP: code copyright 1989 Regents of the University of California.
SLIP linefill/keepalive option.
hdlc: HDLC support module revision 1.22
LAPB Ethernet driver version 0.02
usbcore: registered new interface driver ath9k_htc
usbcore: registered new interface driver carl9170
usbcore: registered new interface driver ath6kl_usb
usbcore: registered new interface driver ar5523
usbcore: registered new interface driver ath10k_usb
usbcore: registered new interface driver rndis_wlan
mac80211_hwsim: initializing netlink
BUG: unable to handle page fault for address: ffffddffe0000001
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 11829067 P4D 11829067 PUD 0 
Oops: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.19.0-syzkaller-14090-g4a9350597aff #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/22/2022
RIP: 0010:ieee80211_register_hw+0x2872/0x3eb0 net/mac80211/main.c:1069
Code: 89 e7 e8 31 3b b8 f8 45 39 ec 0f 84 0b 03 00 00 e8 e3 3e b8 f8 4c 8d 75 f4 48 89 e8 48 b9 00 00 00 00 00 fc ff df 48 c1 e8 03 <0f> b6 14 08 48 89 e8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 d6
RSP: 0000:ffffc90000067a40 EFLAGS: 00010a03
RAX: 1fffe1ffe0000001 RBX: 0000000000000000 RCX: dffffc0000000000
RDX: ffff8881401b8000 RSI: ffffffff88c3c82d RDI: 0000000000000005
RBP: ffff0fff0000000c R08: 0000000000000005 R09: 0000000000000000
R10: 000000000000076d R11: 0000000000000000 R12: 0000000000000000
R13: 000000000000076d R14: ffff0fff00000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffddffe0000001 CR3: 000000000bc8e000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 mac80211_hwsim_new_radio+0x255f/0x4dd0 drivers/net/wireless/mac80211_hwsim.c:4129
 init_mac80211_hwsim+0x5aa/0x73b drivers/net/wireless/mac80211_hwsim.c:5379
 do_one_initcall+0xfe/0x650 init/main.c:1296
 do_initcall_level init/main.c:1369 [inline]
 do_initcalls init/main.c:1385 [inline]
 do_basic_setup init/main.c:1404 [inline]
 kernel_init_freeable+0x6b1/0x73a init/main.c:1611
 kernel_init+0x1a/0x1d0 init/main.c:1500
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>
Modules linked in:
CR2: ffffddffe0000001
---[ end trace 0000000000000000 ]---
RIP: 0010:ieee80211_register_hw+0x2872/0x3eb0 net/mac80211/main.c:1069
Code: 89 e7 e8 31 3b b8 f8 45 39 ec 0f 84 0b 03 00 00 e8 e3 3e b8 f8 4c 8d 75 f4 48 89 e8 48 b9 00 00 00 00 00 fc ff df 48 c1 e8 03 <0f> b6 14 08 48 89 e8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 d6
RSP: 0000:ffffc90000067a40 EFLAGS: 00010a03
RAX: 1fffe1ffe0000001 RBX: 0000000000000000 RCX: dffffc0000000000
RDX: ffff8881401b8000 RSI: ffffffff88c3c82d RDI: 0000000000000005
RBP: ffff0fff0000000c R08: 0000000000000005 R09: 0000000000000000
R10: 000000000000076d R11: 0000000000000000 R12: 0000000000000000
R13: 000000000000076d R14: ffff0fff00000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffddffe0000001 CR3: 000000000bc8e000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	89 e7                	mov    %esp,%edi
   2:	e8 31 3b b8 f8       	callq  0xf8b83b38
   7:	45 39 ec             	cmp    %r13d,%r12d
   a:	0f 84 0b 03 00 00    	je     0x31b
  10:	e8 e3 3e b8 f8       	callq  0xf8b83ef8
  15:	4c 8d 75 f4          	lea    -0xc(%rbp),%r14
  19:	48 89 e8             	mov    %rbp,%rax
  1c:	48 b9 00 00 00 00 00 	movabs $0xdffffc0000000000,%rcx
  23:	fc ff df
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	0f b6 14 08          	movzbl (%rax,%rcx,1),%edx <-- trapping instruction
  2e:	48 89 e8             	mov    %rbp,%rax
  31:	83 e0 07             	and    $0x7,%eax
  34:	83 c0 03             	add    $0x3,%eax
  37:	38 d0                	cmp    %dl,%al
  39:	7c 08                	jl     0x43
  3b:	84 d2                	test   %dl,%dl
  3d:	0f                   	.byte 0xf
  3e:	85 d6                	test   %edx,%esi


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
