Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A11A3F7C58
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 20:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237460AbhHYSmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 14:42:25 -0400
Received: from sonic314-27.consmr.mail.ne1.yahoo.com ([66.163.189.153]:35009
        "EHLO sonic314-27.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237527AbhHYSmY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 14:42:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1629916898; bh=OrPABbEHqm22Ib4gGSpBwO/c6GjLtPVN8KkZ0a8caKI=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=hEgQFvc3MU8fP8kJL2S342rL14LKK0yM7cpvnDxzwaFQFxq0EsY+AAgsf25xv+Lw7L74avQDLhKvbea2UOPGiK00Q83zqobub95sinl36tS30283OeOtCg39warB6r6QzG/ae+V7mEDkzwB366AVP3RTl7aNCFP33yAlZ0tUJvhPzKHukEKqOBBMHo1u2I2zn5ZKSfFlVfElSrN5xQpIOFURdncKBpCTPBw9lHhAq0hw/JCkitSHi/lM8oyKgrNE6EDgMMcBQ7jYj1pNn9CNI00bAS8pHWuOZprdtKYWSmry23XUCiAa8IJRn5ov8r5s7A2WzG+LHUVzbYn3blvFbw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1629916898; bh=ysPfpB3X7ven9u0DE5SNCYCB7uGa0wPs8ivijUwYL4e=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=IRGY5kdo30g6tuVXL69IvsZJ+99fDgYKdHL0WM0i6ZJwIlYcof8C8jVHIhZBkeG1tZLb7R1H+0JSGSSHfb06JgB9sYn4Ofy7NbvpiUPyLxuXFRKoCM0b+TAtflc4XoosdiiFpeaxYJAQmDKLzoQTZLwTHjt5Tarc16fnKbyGeG8MwXycVcoruDfRmLYTSMx0Yn7XjNhMXHR9NFIxGDbTTciBt8m/NP/QAlWo+rPJsH9/gGiFYS8DAM4Z1kuQpxblEJtfY1TyjyfHJYqk9eqUbDBUFMLwkaw8F7fLF7tZx42/kWVgiJwueHNShqASAYUuDNKobUXq24410p2+N9ksUg==
X-YMail-OSG: 29Y1ncMVM1lukwk_PgiL7PqsVa6b5gFFdu3O3Q2MOmOMDqUVI69B6DSQeFuRxqQ
 1VhgtcdclrT6Ikk9IMQzbcTStiWO47WL.zAEQ3ibsrl7wlHhTZyLekrChYbEDGHf7KYDDlRVaLuo
 6pgybzHOGnFViVvFcVJvy66j1SrclrWqFz2BpHjUvkoTFGH1RtGYOcTwimDg5eUUuzOv.2gZmmRH
 2M2IBKXKGINF75n47QAFLZBxBRqH3FWVjw7z6l0aOo34kl0IBWmfKAID5oBK2DVMXx.Ldh0ddK5Z
 ajPY5mkTPtsTqIhxJxx0b4a9YBPwXHaajX.v74mYcI.kaisjCRCJ2rqTbvSrVsG8unbX30ZSHYIf
 vgWFUUHZfkJ9QLYIHbsVYLtpYpY1GWvI4DvwOgwaGpt5HkUDmxBYZmcL.mZxeT4hapeXEHrrtTlx
 N0vKICOcFqF56EPwwOebgRWI.p_IwSBIVGWJQ1E.lh8C5lJggz1c_c2eVqhWOq34961vxhlB.fRU
 khSZtPJ6RUvezJdR_AwdadhcP1oDaKpHXfHfs_SsBaE8sM_sWZo7_xZk6QtlGydMWZjvY6r502Ph
 0JNbDQRiGTN9GJumZWg6XpdkF4UFdv_Dl4celJVKR_EadoUYD10bmaIc8.PiHwCnOKj41ZT8eVnI
 kK7hz9y3oIZzkm0zSybc8Y1IsujWcqTg0V6aBunVYTHvd6C.83zmve1JAqjG13cZ1g5oAaV6VsnW
 k7L36VMhPbBdhfT4lD9J_9ffRvRpTcZv6TeXjM6hSzrL6lzJiyV8W9nLoYFkBc94iW3f7MoatAnj
 k4vdSQ9BLcLIEJVTNru85PGOLbJbNkQv5NLguyTAjZZu_a2GUFGEkKfReOstuNKqJhGpBWlrknDL
 qj0imcovYD6OKgRTJPovYqF2Qn2NqcJJXWqzyt6EXreMDO1_73YwAKqJV2fiQQVZ42rIdu69.782
 H5JdEx1hcg4Hwfh_RSjuaJ06DiNpS_8Iqy1FcuyOtS.HN6z7PfpoYE1_h8klZc0DW_2EXJ4bWCrx
 MsoSW8CgBW78KatcgtY3lrYMq5XRl3u7Zgajf7csufDcEWnDgW3dL1LDA0yP89GOjwqjqi0Ffzko
 A7kJpSqrvO2k.P08j7ay7FMWhunwTD3YZvQ7u6HmN.FjYmUE_3_.6rkeng_8CtcjDH7dzn7Bz1Ah
 lALcCW2wvzyaUkYBB65cxhFfXSIVWsxQooGOoyo59JbhTPjD2J52zthxK9WqqvhuCGOfq1DIkVL6
 qV5JSwN_k3.KVm88E7pUT3Fk2J0aE0N8oZ2j4D4Mhj27uR66ut3PK4jLkvsR_90At8IRCmpm7ERO
 tHZ.oE5Qv7uOnBJKLZiKiiHRljO0fXXoyY9Q5KpX477Ze53B6S8GqzcSAuXHysLR0E_56.nocEs7
 _CiRJxN9nxXEXxqrsO9zs00q_sMzaWA7HUKumeK0e5IaWaVbr0J6_Sj6tnI61fM1se7cKrq_9bP4
 7hlngCNrNfNxhTLND1Rx2pInfyVIuedPKwgYQMeHaXaFTzfzEF0gzvZoVzKjojLbQ7BlPzBd9CgU
 s9IPuPF048dBB3kjXerHOyw.Uqv5b77SYHo83kHReDlO4lJ.9NLE.vjFJtYVq8cCQZzQpBZOBbh6
 aS1OIKmHXMvhnE9f6R3OfSnyEdSfN0gJml3Q8MMH8AqIsF3C0.t3ejspfoYerjseEhzcuc1E.9lU
 QEoCObDseAn5OchMJnzse0x8rXnrPekZVup4TqzW4X8f8KENVqHCaBGSZEc5qtVyoc78TxBY5YR7
 b7WQAS14bkI3ahce4i_Egxcb2K.EIm4kwkVSfBZBKVNyK_RZXutKJJ0N0MZ6QMnr1cZwsYDVioGJ
 D1dNyKygLr.znVfDZbA2K44rWH7yGmzVLeIpbyNqEYU9UD6_jSp5U80ogNAK3kxhtk6BhJYFnuoX
 cH2bVtBLWlbFyV5KeNQa6x4m21ADojx1txiTbN_zv6ujUWH8Cnne8r3ViCz0lP472qua1GlDWQ7A
 oJt1y2.IgGfGo28YVvY0OXw4mWktf26RpU4JWcdXjD_Vl8bTQEVenh7q4I0pHkXVBsVVAcFJi7rA
 GW8wrAYNi1jLF.ySHActWCsaob9gv4gSl9KVBpbK76Snnvn9DCMBmBzyw48l4jwlfFRiH9SpcwkL
 gV.FhoMEwSO4AJsI660g8N2rik7MfJg93VgM12NraFgjCTx0XX0VLFOu95jxkEofCduCkoK3YsVY
 W6cSaL8hpaWLyp4WICQ5wfqb0B1Iqp.yuaGRznLJazmJ6k0bGddqvcC093RTql7ddRUynweEU966
 2aFJ_vGmnmL6gQdxxql7jNafEL10iIGpScw1apafZrSc5cupJjmzZie9q2U_BxJG2
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic314.consmr.mail.ne1.yahoo.com with HTTP; Wed, 25 Aug 2021 18:41:38 +0000
Received: by kubenode507.mail-prod1.omega.bf1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 87ef9d7573f1dc3ef6128650a4dfdfec;
          Wed, 25 Aug 2021 18:41:33 +0000 (UTC)
Subject: Re: [syzbot] KASAN: use-after-free Read in netlbl_catmap_walk
To:     Paul Moore <paul@paul-moore.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+3f91de0b813cc3d19a80@syzkaller.appspotmail.com>,
        Casey Schaufler <casey@schaufler-ca.com>
References: <000000000000a814c505ca657a4e@google.com>
 <CAHC9VhSUnq-+bMYCBvc4yyw9bkMNTChdn1m2b4Vn2i0e54AxxQ@mail.gmail.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <610f2842-8f39-6da9-07a3-2132f64f33e6@schaufler-ca.com>
Date:   Wed, 25 Aug 2021 11:41:31 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAHC9VhSUnq-+bMYCBvc4yyw9bkMNTChdn1m2b4Vn2i0e54AxxQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Mailer: WebService/1.1.18906 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/25/2021 11:31 AM, Paul Moore wrote:
> On Wed, Aug 25, 2021 at 1:21 PM syzbot
> <syzbot+3f91de0b813cc3d19a80@syzkaller.appspotmail.com> wrote:
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    6e764bcd1cf7 Merge tag 'for-linus' of git://git.kernel.org..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=124e77c5300000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=2fd902af77ff1e56
>> dashboard link: https://syzkaller.appspot.com/bug?extid=3f91de0b813cc3d19a80
>> compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.1
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13f72f16300000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=133e338d300000
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+3f91de0b813cc3d19a80@syzkaller.appspotmail.com
>>
>> ==================================================================
>> BUG: KASAN: use-after-free in _netlbl_catmap_getnode net/netlabel/netlabel_kapi.c:564 [inline]
>> BUG: KASAN: use-after-free in netlbl_catmap_walk+0x28b/0x2e0 net/netlabel/netlabel_kapi.c:615
>> Read of size 4 at addr ffff8880161c9800 by task syz-executor742/8768
>>
>> CPU: 0 PID: 8768 Comm: syz-executor742 Not tainted 5.14.0-rc7-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> Call Trace:
>>  __dump_stack lib/dump_stack.c:88 [inline]
>>  dump_stack_lvl+0x1ae/0x29f lib/dump_stack.c:105
>>  print_address_description+0x66/0x3b0 mm/kasan/report.c:233
>>  __kasan_report mm/kasan/report.c:419 [inline]
>>  kasan_report+0x163/0x210 mm/kasan/report.c:436
>>  _netlbl_catmap_getnode net/netlabel/netlabel_kapi.c:564 [inline]
>>  netlbl_catmap_walk+0x28b/0x2e0 net/netlabel/netlabel_kapi.c:615
>>  cipso_seq_show+0x15f/0x280 security/smack/smackfs.c:789
>>  traverse+0x1dc/0x530 fs/seq_file.c:111
>>  seq_lseek+0x12b/0x240 fs/seq_file.c:323
>>  vfs_llseek fs/read_write.c:300 [inline]
>>  ksys_lseek fs/read_write.c:313 [inline]
>>  __do_sys_lseek fs/read_write.c:324 [inline]
>>  __se_sys_lseek fs/read_write.c:322 [inline]
>>  __x64_sys_lseek+0x15b/0x1e0 fs/read_write.c:322
>>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>  do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
>>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>> RIP: 0033:0x445889
>> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 11 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
>> RSP: 002b:00007f9a9cff0318 EFLAGS: 00000246 ORIG_RAX: 0000000000000008
>> RAX: ffffffffffffffda RBX: 00000000004ca408 RCX: 0000000000445889
>> RDX: 0000000000000000 RSI: 0000000100000001 RDI: 0000000000000003
>> RBP: 00000000004ca400 R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004ca40c
>> R13: 00007ffead4e31bf R14: 00007f9a9cff0400 R15: 0000000000022000
>>
>> Allocated by task 8768:
>>  kasan_save_stack mm/kasan/common.c:38 [inline]
>>  kasan_set_track mm/kasan/common.c:46 [inline]
>>  set_alloc_info mm/kasan/common.c:434 [inline]
>>  ____kasan_kmalloc+0xcd/0x100 mm/kasan/common.c:513
>>  kasan_kmalloc include/linux/kasan.h:264 [inline]
>>  kmem_cache_alloc_trace+0x96/0x340 mm/slub.c:2986
>>  kmalloc include/linux/slab.h:591 [inline]
>>  kzalloc include/linux/slab.h:721 [inline]
>>  netlbl_catmap_alloc include/net/netlabel.h:317 [inline]
>>  _netlbl_catmap_getnode net/netlabel/netlabel_kapi.c:582 [inline]
>>  netlbl_catmap_setbit+0x1cb/0x3f0 net/netlabel/netlabel_kapi.c:782
>>  smk_netlbl_mls+0x103/0x5e0 security/smack/smack_access.c:505
>>  smk_set_cipso+0x621/0x810 security/smack/smackfs.c:921
>>  vfs_write+0x289/0xc90 fs/read_write.c:603
>>  ksys_write+0x171/0x2a0 fs/read_write.c:658
>>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>  do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
>>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>>
>> Freed by task 8769:
>>  kasan_save_stack mm/kasan/common.c:38 [inline]
>>  kasan_set_track+0x3d/0x70 mm/kasan/common.c:46
>>  kasan_set_free_info+0x1f/0x40 mm/kasan/generic.c:360
>>  ____kasan_slab_free+0x10d/0x150 mm/kasan/common.c:366
>>  kasan_slab_free include/linux/kasan.h:230 [inline]
>>  slab_free_hook mm/slub.c:1628 [inline]
>>  slab_free_freelist_hook+0x1e8/0x2a0 mm/slub.c:1653
>>  slab_free mm/slub.c:3213 [inline]
>>  kfree+0xcf/0x2e0 mm/slub.c:4267
>>  netlbl_catmap_free include/net/netlabel.h:335 [inline]
>>  smk_set_cipso+0x682/0x810 security/smack/smackfs.c:923
>>  vfs_write+0x289/0xc90 fs/read_write.c:603
>>  ksys_write+0x171/0x2a0 fs/read_write.c:658
>>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>  do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
>>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>>
>> The buggy address belongs to the object at ffff8880161c9800
>>  which belongs to the cache kmalloc-64 of size 64
>> The buggy address is located 0 bytes inside of
>>  64-byte region [ffff8880161c9800, ffff8880161c9840)
>> The buggy address belongs to the page:
>> page:ffffea0000587240 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x161c9
>> flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
>> raw: 00fff00000000200 0000000000000000 0000000b00000001 ffff888011041640
>> raw: 0000000000000000 0000000080200020 00000001ffffffff 0000000000000000
>> page dumped because: kasan: bad access detected
>> page_owner tracks the page as allocated
>> page last allocated via order 0, migratetype Unmovable, gfp_mask 0x12cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY), pid 6484, ts 27339779214, free_ts 27310944203
>>  prep_new_page mm/page_alloc.c:2436 [inline]
>>  get_page_from_freelist+0x779/0xa30 mm/page_alloc.c:4168
>>  __alloc_pages+0x26c/0x5f0 mm/page_alloc.c:5390
>>  alloc_slab_page mm/slub.c:1691 [inline]
>>  allocate_slab+0xf1/0x540 mm/slub.c:1831
>>  new_slab mm/slub.c:1894 [inline]
>>  new_slab_objects mm/slub.c:2640 [inline]
>>  ___slab_alloc+0x1cf/0x350 mm/slub.c:2803
>>  __slab_alloc mm/slub.c:2843 [inline]
>>  slab_alloc_node mm/slub.c:2925 [inline]
>>  __kmalloc_node+0x310/0x430 mm/slub.c:4159
>>  kmalloc_node include/linux/slab.h:614 [inline]
>>  kvmalloc_node+0x81/0xf0 mm/util.c:587
>>  kvmalloc include/linux/mm.h:806 [inline]
>>  simple_xattr_alloc+0x3f/0xa0 fs/xattr.c:951
>>  shmem_initxattrs+0x91/0x1e0 mm/shmem.c:3142
>>  security_inode_init_security+0x37a/0x3c0 security/security.c:1099
>>  shmem_mknod+0xb0/0x1b0 mm/shmem.c:2822
>>  lookup_open fs/namei.c:3228 [inline]
>>  open_last_lookups fs/namei.c:3298 [inline]
>>  path_openat+0x13b7/0x36b0 fs/namei.c:3504
>>  do_filp_open+0x253/0x4d0 fs/namei.c:3534
>>  do_sys_openat2+0x124/0x460 fs/open.c:1204
>>  do_sys_open fs/open.c:1220 [inline]
>>  __do_sys_open fs/open.c:1228 [inline]
>>  __se_sys_open fs/open.c:1224 [inline]
>>  __x64_sys_open+0x221/0x270 fs/open.c:1224
>>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>  do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
>>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>> page last free stack trace:
>>  reset_page_owner include/linux/page_owner.h:24 [inline]
>>  free_pages_prepare mm/page_alloc.c:1346 [inline]
>>  free_pcp_prepare+0xc29/0xd20 mm/page_alloc.c:1397
>>  free_unref_page_prepare mm/page_alloc.c:3332 [inline]
>>  free_unref_page+0x7e/0x550 mm/page_alloc.c:3411
>>  __vunmap+0x926/0xa70 mm/vmalloc.c:2587
>>  free_work+0x66/0x90 mm/vmalloc.c:82
>>  process_one_work+0x833/0x10c0 kernel/workqueue.c:2276
>>  worker_thread+0xac1/0x1320 kernel/workqueue.c:2422
>>  kthread+0x453/0x480 kernel/kthread.c:319
>>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
>>
>> Memory state around the buggy address:
>>  ffff8880161c9700: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
>>  ffff8880161c9780: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>>> ffff8880161c9800: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>>                    ^
>>  ffff8880161c9880: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>>  ffff8880161c9900: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>> ==================================================================
>>
>>
>> ---
>> This report is generated by a bot. It may contain errors.
>> See https://goo.gl/tpsmEJ for more information about syzbot.
>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>>
>> syzbot will keep track of this issue. See:
>> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>> syzbot can test patches for this issue, for details see:
>> https://goo.gl/tpsmEJ#testing-patches
> Adding Casey to the To/CC line as I think this issue lies with Smack
> and not NetLabel, although if someone believes otherwise please let me
> know.

This does appear to be a Smack issue. Smack issues should come to me.

> It looks like the problem is near the bottom of smk_set_cipso(), right
> after smk_netlbl_mls() successfully creates the netlabel category
> bitmap and attempts to free any old existing category bitmaps before
> assigning the new value.  As I see it the problem is that the
> smack_known pointer, @skp, which is host to the bitmap is located from
> a RCU protected list meaning that it is possible for other tasks to be
> accessing the category bitmap while it is being freed, or directly
> afterwards given they may still be pointing at the old/freed data.
>
> Casey obviously knows Smack much better than I do so I'll refrain from
> going to far with a solution here in the likelihood that I'm off the
> mark, but I suspect the right solution here would be to either
> duplicate and replace the entry in the smack_known list using the
> normal RCU list manipulation approach (easiest?), manage the
> smack_known->smk_netlabel field as it's own RCU protected pointer
> (less easy?), or something else entirely (wildcard!).  I'm not sure
> this is a problem we can, or want to, solve at the NetLabel layer.

Agreed. Not a problem for netlabel. 

