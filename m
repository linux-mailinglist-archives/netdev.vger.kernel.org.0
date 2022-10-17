Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B01260133E
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 18:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbiJQQQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 12:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbiJQQQi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 12:16:38 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF0C6D572
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 09:16:37 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id u2so6075643ilv.6
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 09:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WFrtH1nIceWDWjecFJq4RLnBMDwSO0i+CWv3MNMfQg4=;
        b=jEv4jAYG5jOPL6GizracGgpmxqZQyzsHZgcpzsug0NOrifCD7ynawGMq1j/8U+khSs
         IK6jqHG48I6xqj4p86ARYxnTkNWTeMD544onM0Tmh+B7yVzP6LqBvd+t8LWpVAz2u03h
         gwzqmfrQRgOYbcZ//HNPJ0SFSO0UloTO5p/ZgM13oPHxq/Ox9E1wvs93dwVnJYZMa0pK
         YyDLUWK6fjoMEYua124lgY+pDR/qn4tKgUomX2WOiYZG+sXkhcQsVfD+Eepqq+/MwBHE
         eKF4pgsWvIYQql6EgCgIJtbBadLWyZnUWPEiQGHvvRYL0FKJxLy3MQ4DJrMdqlb82DvR
         qFYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WFrtH1nIceWDWjecFJq4RLnBMDwSO0i+CWv3MNMfQg4=;
        b=TIBmHP3nRr0zt+Xul72PfKOU0ZFkWdmDzBwD/2N5VvYSZ2TdM2sORh3CcpmDQsDQsh
         7BayHNi7ot1sqwi7mVIzTmUdhrgkSRiC2IonOBEeZbMH03m4uGCtQe+mWLOpx5cU9fEF
         QYRzIiQ/8fpf995GKVhibF2POnuJaZCHu9mIl3eurpM2joOoUMGJBKMY6zyvE+nuxcL9
         uaHAV+gO/klRDOPtmya+XqlhmeFvMRbt+ZXX5rMxKt7jkVq17x8qimMLL+lickKwmWBp
         ol1WgaARe6GqwpkXhsZ3jbdDF+sFxwrKz6YGwzYK8YVjTbvbaZ7LgSxOBtMtlw71Hubq
         7YOQ==
X-Gm-Message-State: ACrzQf1zvKr/2S8fHpMbmFKVrQ6A8d3302kfTunmBC23sGX1Fo7bXX91
        jJ36cSqzYUISDmrKSteMUtRW3hX/2pYnet3IMnzfcg==
X-Google-Smtp-Source: AMsMyM6D6ZH23UH1DDhYJy7DKaiHnY8WMVH8bWKCG92JRizQyoSfHpBC/EBhk/nhFNQJo/Ae2+BoF7KVbaMOZd8wlgk=
X-Received: by 2002:a92:cc0b:0:b0:2f9:f3a9:c3e7 with SMTP id
 s11-20020a92cc0b000000b002f9f3a9c3e7mr4724220ilp.253.1666023395616; Mon, 17
 Oct 2022 09:16:35 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000068cb2905eb214e9a@google.com>
In-Reply-To: <00000000000068cb2905eb214e9a@google.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Mon, 17 Oct 2022 09:16:24 -0700
Message-ID: <CAKH8qBu+oT+BF6sA4PKxfUsj43O5BNSLzrdhirWOLJ0O8KbA3w@mail.gmail.com>
Subject: Re: [syzbot] WARNING in btf_type_id_size
To:     syzbot <syzbot+6280ebbcdba3e0c14fde@syzkaller.appspotmail.com>
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, haoluo@google.com, john.fastabend@gmail.com,
        jolsa@kernel.org, kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, martin.lau@linux.dev, nathan@kernel.org,
        ndesaulniers@google.com, netdev@vger.kernel.org, song@kernel.org,
        syzkaller-bugs@googlegroups.com, trix@redhat.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-15.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 15, 2022 at 11:52 PM syzbot
<syzbot+6280ebbcdba3e0c14fde@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    0326074ff465 Merge tag 'net-next-6.1' of git://git.kernel...
> git tree:       bpf
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=1376ba52880000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=796b7c2847a6866a
> dashboard link: https://syzkaller.appspot.com/bug?extid=6280ebbcdba3e0c14fde
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15e182aa880000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1677bfcc880000
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/7cc67ced256d/disk-0326074f.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/86a7be29267c/vmlinux-0326074f.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+6280ebbcdba3e0c14fde@syzkaller.appspotmail.com
>
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 3609 at kernel/bpf/btf.c:1946 btf_type_id_size+0x2d5/0x9d0 kernel/bpf/btf.c:1946
> Modules linked in:
> CPU: 0 PID: 3609 Comm: syz-executor361 Not tainted 6.0.0-syzkaller-02734-g0326074ff465 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/22/2022
> RIP: 0010:btf_type_id_size+0x2d5/0x9d0 kernel/bpf/btf.c:1946
> Code: ef e8 7f 8e e4 ff 41 83 ff 0b 77 28 f6 44 24 10 18 75 3f e8 6d 91 e4 ff 44 89 fe bf 0e 00 00 00 e8 20 8e e4 ff e8 5b 91 e4 ff <0f> 0b 45 31 f6 e9 98 02 00 00 41 83 ff 12 74 18 e8 46 91 e4 ff 44
> RSP: 0018:ffffc90003cefb40 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000000000
> RDX: ffff8880259c0000 RSI: ffffffff81968415 RDI: 0000000000000005
> RBP: ffff88801270ca00 R08: 0000000000000005 R09: 000000000000000e
> R10: 0000000000000011 R11: 0000000000000000 R12: 0000000000000000
> R13: 0000000000000011 R14: ffff888026ee6424 R15: 0000000000000011
> FS:  000055555641b300(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000f2e258 CR3: 000000007110e000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  btf_func_proto_check kernel/bpf/btf.c:4447 [inline]
>  btf_check_all_types kernel/bpf/btf.c:4723 [inline]
>  btf_parse_type_sec kernel/bpf/btf.c:4752 [inline]
>  btf_parse kernel/bpf/btf.c:5026 [inline]
>  btf_new_fd+0x1926/0x1e70 kernel/bpf/btf.c:6892
>  bpf_btf_load kernel/bpf/syscall.c:4324 [inline]
>  __sys_bpf+0xb7d/0x4cf0 kernel/bpf/syscall.c:5010
>  __do_sys_bpf kernel/bpf/syscall.c:5069 [inline]
>  __se_sys_bpf kernel/bpf/syscall.c:5067 [inline]
>  __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:5067
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7f0fbae41c69
> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffc8aeb6228 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f0fbae41c69
> RDX: 0000000000000020 RSI: 0000000020000140 RDI: 0000000000000012
> RBP: 00007f0fbae05e10 R08: 0000000000000000 R09: 0000000000000000
> R10: 00000000ffffffff R11: 0000000000000246 R12: 00007f0fbae05ea0
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>  </TASK>

Will be addressed by
https://lore.kernel.org/bpf/d1379e3f-a64d-8c27-9b77-f6de085ce498@meta.com/T/#u


> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
