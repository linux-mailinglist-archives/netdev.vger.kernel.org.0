Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB02B222BDF
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 21:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729428AbgGPT2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 15:28:02 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59466 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728788AbgGPT2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 15:28:01 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06GJN2vD040245;
        Thu, 16 Jul 2020 19:25:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=sAfj0r7P04opSCCkZfXIxVSYpBC0mws3QNMIYukELLo=;
 b=eOFRUw0y3vV1aSSKx61kLqFM4sxBDYcf1L0ME8BVfHR+aq+vtISQCgdOFl1tUG0w0BH7
 aKvq50sAuHhwrcGDcYF416FhN5Cmobl6wJqP1OQZrbAajS+qyz+nGZ+feFYpqLYx7ZJ1
 i7Bv9ShGJ5fZt9xyYoPtO30dgO8TKnt2gTkwsErfxQmb+kb2dwsYprUOePaLBAY4SWN0
 qvA94yekk55WDSU6FZN5fjiykJHx5VbBN8THNt6pc7HQe+zLYdB8mLhBm5gLOciEmPRU
 ei2PvLiil50By/KbIZLgtRM6vwCSBzezTbPGcMLC/D7BMivalnrrEccHTWOWHoef+JVr AQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 3275cmkc9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 16 Jul 2020 19:25:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06GJHhBa128551;
        Thu, 16 Jul 2020 19:25:47 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 327qbcaf87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jul 2020 19:25:47 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06GJPf8J025672;
        Thu, 16 Jul 2020 19:25:42 GMT
Received: from anon-dhcp-152.1015granger.net (/68.61.232.219)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 16 Jul 2020 12:25:41 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [Regression] "SUNRPC: Add "@len" parameter to gss_unwrap()"
 breaks NFS Kerberos on upstream stable 5.4.y
From:   Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <5619613.lOV4Wx5bFT@keks.as.studentenwerk.mhn.de>
Date:   Thu, 16 Jul 2020 15:25:40 -0400
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        matthew.ruffell@canonical.com,
        linux-stable <stable@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-kernel-owner@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <0885F62B-F9D2-4248-9313-70DAA1A1DE71@oracle.com>
References: <309E203B-8818-4E33-87F0-017E127788E2@canonical.com>
 <424D9E36-C51B-46E8-9A07-D329821F2647@oracle.com>
 <6E0D09F1-601B-432B-81EE-9858EC1AF1DE@canonical.com>
 <7042081C-27B3-4024-BA34-7146B459F8B4@oracle.com>
 <3884DFB0-D276-442D-8199-8FC77A40F1E5@oracle.com>
 <5619613.lOV4Wx5bFT@keks.as.studentenwerk.mhn.de>
To:     Pierre Sauter <pierre.sauter@stwm.de>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9684 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=2 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007160133
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9684 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1011 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007160133
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pierre-

> On Jul 16, 2020, at 2:40 PM, Pierre Sauter <pierre.sauter@stwm.de> =
wrote:
>=20
> Hi,
>=20
> Am 2020-07-15 20:54, schrieb Chuck Lever:
>> v5.4.40 does not have 31c9590ae468 and friends, but the claim is this
>> one crashes?
>=20
> To my knowledge 31c9590ae468 and friends are in v5.4.40.

Those upstream commits were merged in v5.4.42.

The last commit that is applied to net/sunrpc/auth_gss/gss_krb5_wrap.c
in v5.4.40 is 241b1f419f0e ("SUNRPC: Remove xdr_buf_trim()").


>> And v5.4.51 has those three and 89a3c9f5b9f0, which Pierre claims =
fixes
>> the problem for him; but another commenter says v5.4.51 still =
crashes.
>=20
> v5.4.51 still crashes for me (and afaik it does not have =
89a3c9f5b9f0).=20
> I applied 89a3c9f5b9f0 to the original v5.4.40 which helps mostly.

In the v5.4.51 upstream stable kernel, I see:

commit 7b99577ff376d58addf149eebe0ffff46351b3d7
Author:     Chuck Lever <chuck.lever@oracle.com>
AuthorDate: Thu Jun 25 11:32:34 2020 -0400
Commit:     Sasha Levin <sashal@kernel.org>
CommitDate: Tue Jun 30 15:37:12 2020 -0400

    SUNRPC: Properly set the @subbuf parameter of xdr_buf_subsegment()
   =20
    commit 89a3c9f5b9f0bcaa9aea3e8b2a616fcaea9aad78 upstream.

According to "git describe --contains", 7b99577ff376 was merged in =
v5.4.50.

So this makes me think there's a possibility you are not using upstream
stable kernels. I can't help if I don't know what source code and commit
stream you are using. It also makes me question the bisect result.


> My krb5 etype is aes256-cts-hmac-sha1-96.

Thanks! And what is your NFS server and filesystem? It's possible that =
the
client is not estimating the size of the reply correctly. Variables =
include
the size of file handles, MIC verifiers, and wrap tokens.


> Below is the bug in the original v5.4.40 with KASAN enabled. It =
happened=20
> immediately after mount of /home, no login neccessary:
>=20
> [   21.501730] =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [   21.501756] BUG: KASAN: slab-out-of-bounds in =
_copy_from_pages+0xe9/0x200 [sunrpc]
> [   21.501759] Write of size 64 at addr ffff8883bc9f3244 by task =
update-desktop-/1478
>=20
> [   21.501763] CPU: 0 PID: 1478 Comm: update-desktop- Tainted: G       =
    OE     5.4.0-40-generic #44

So, I don't know what 5.4.0-40-generic is, but it's not an upstream
stable kernel. If it's an Ubuntu kernel, you should work with them
directly to nail this issue down.


> [   21.501764] Hardware name: XXXXXXXXXXXXXXXXXXXXXX
> [   21.501765] Call Trace:
> [   21.501769]  dump_stack+0x96/0xca
> [   21.501772]  print_address_description.constprop.0+0x20/0x210
> [   21.501789]  ? _copy_from_pages+0xe9/0x200 [sunrpc]
> [   21.501790]  __kasan_report.cold+0x1b/0x41
> [   21.501806]  ? _copy_from_pages+0xe9/0x200 [sunrpc]
> [   21.501807]  kasan_report+0x12/0x20
> [   21.501809]  check_memory_region+0x129/0x1b0
> [   21.501811]  memcpy+0x38/0x50
> [   21.501825]  _copy_from_pages+0xe9/0x200 [sunrpc]
> [   21.501839]  ? call_decode+0x2fd/0x7e0 [sunrpc]
> [   21.501854]  ? __rpc_execute+0x204/0xbd0 [sunrpc]
> [   21.501869]  xdr_shrink_pagelen+0x198/0x3c0 [sunrpc]

You might try:

e8d70b321ecc ("SUNRPC: Fix another issue with MIC buffer space")


> [   21.501871]  ? trailing_symlink+0x6fe/0x810
> [   21.501886]  xdr_align_pages+0x15f/0x580 [sunrpc]
> [   21.501904]  ? decode_setattr+0x120/0x120 [nfsv4]
> [   21.501920]  xdr_read_pages+0x44/0x290 [sunrpc]
> [   21.501935]  ? __decode_op_hdr+0x29/0x430 [nfsv4]
> [   21.501949]  nfs4_xdr_dec_readlink+0x238/0x390 [nfsv4]
> [   21.501963]  ? nfs4_xdr_dec_read+0x3c0/0x3c0 [nfsv4]
> [   21.501966]  ? __kasan_slab_free+0x14e/0x180
> [   21.501970]  ? gss_validate+0x37e/0x610 [auth_rpcgss]
> [   21.501972]  ? kasan_slab_free+0xe/0x10
> [   21.501985]  ? nfs4_xdr_dec_read+0x3c0/0x3c0 [nfsv4]
> [   21.502001]  rpcauth_unwrap_resp_decode+0xaa/0x100 [sunrpc]
> [   21.502005]  gss_unwrap_resp+0x99d/0x1570 [auth_rpcgss]
> [   21.502009]  ? gss_destroy_cred+0x460/0x460 [auth_rpcgss]
> [   21.502011]  ? finish_task_switch+0x163/0x670
> [   21.502014]  ? __switch_to_asm+0x34/0x70
> [   21.502017]  ? gss_wrap_req+0x830/0x830 [auth_rpcgss]
> [   21.502020]  ? prepare_to_wait+0xea/0x2b0
> [   21.502036]  rpcauth_unwrap_resp+0xac/0x100 [sunrpc]
> [   21.502049]  call_decode+0x454/0x7e0 [sunrpc]
> [   21.502063]  ? rpc_decode_header+0x10a0/0x10a0 [sunrpc]
> [   21.502065]  ? var_wake_function+0x140/0x140
> [   21.502078]  ? call_transmit_status+0x31e/0x5d0 [sunrpc]
> [   21.502091]  ? rpc_decode_header+0x10a0/0x10a0 [sunrpc]
> [   21.502106]  __rpc_execute+0x204/0xbd0 [sunrpc]
> [   21.502119]  ? xprt_wait_for_reply_request_def+0x170/0x170 [sunrpc]
> [   21.502134]  ? rpc_exit+0xc0/0xc0 [sunrpc]
> [   21.502135]  ? __kasan_check_read+0x11/0x20
> [   21.502137]  ? wake_up_bit+0x42/0x50
> [   21.502151]  rpc_execute+0x1a0/0x1f0 [sunrpc]
> [   21.502165]  rpc_run_task+0x454/0x5e0 [sunrpc]
> [   21.502179]  nfs4_call_sync_custom+0x12/0x70 [nfsv4]
> [   21.502192]  nfs4_call_sync_sequence+0x143/0x1f0 [nfsv4]
> [   21.502194]  ? __read_once_size_nocheck.constprop.0+0x10/0x10
> [   21.502207]  ? nfs4_call_sync_custom+0x70/0x70 [nfsv4]
> [   21.502209]  ? __kasan_check_read+0x11/0x20
> [   21.502211]  ? rmqueue+0x397/0x2410
> [   21.502225]  _nfs4_proc_readlink+0x1a6/0x250 [nfsv4]
> [   21.502238]  ? _nfs4_proc_getdeviceinfo+0x350/0x350 [nfsv4]
> [   21.502254]  nfs4_proc_readlink+0x101/0x2c0 [nfsv4]
> [   21.502268]  ? nfs4_proc_link+0x1c0/0x1c0 [nfsv4]
> [   21.502271]  ? add_to_page_cache_locked+0x20/0x20
> [   21.502285]  nfs_symlink_filler+0xdc/0x190 [nfs]
> [   21.502287]  do_read_cache_page+0x60e/0x1490
> [   21.502297]  ? nfs4_do_lookup_revalidate+0x1a1/0x2d0 [nfs]
> [   21.502308]  ? nfs_get_link+0x370/0x370 [nfs]
> [   21.502311]  ? xas_load+0x23/0x250
> [   21.502312]  ? pagecache_get_page+0x760/0x760
> [   21.502315]  ? lockref_get_not_dead+0xe3/0x1c0
> [   21.502317]  ? __kasan_check_write+0x14/0x20
> [   21.502318]  ? lockref_get_not_dead+0xe3/0x1c0
> [   21.502320]  ? __kasan_check_write+0x14/0x20
> [   21.502321]  ? _raw_spin_lock+0x7b/0xd0
> [   21.502323]  ? _raw_write_trylock+0x110/0x110
> [   21.502325]  read_cache_page+0x4c/0x80
> [   21.502335]  nfs_get_link+0x75/0x370 [nfs]
> [   21.502337]  trailing_symlink+0x6fe/0x810
> [   21.502347]  ? nfs_destroy_readpagecache+0x20/0x20 [nfs]
> [   21.502349]  path_lookupat.isra.0+0x188/0x7d0
> [   21.502351]  ? do_syscall_64+0x9f/0x3a0
> [   21.502353]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [   21.502355]  ? path_parentat.isra.0+0x110/0x110
> [   21.502357]  ? stack_trace_save+0x94/0xc0
> [   21.502359]  ? stack_trace_consume_entry+0x170/0x170
> [   21.502361]  filename_lookup+0x185/0x3b0
> [   21.502362]  ? nd_jump_link+0x1d0/0x1d0
> [   21.502364]  ? kasan_slab_free+0xe/0x10
> [   21.502366]  ? __kasan_check_read+0x11/0x20
> [   21.502367]  ? __check_object_size+0x249/0x316
> [   21.502369]  ? strncpy_from_user+0x80/0x290
> [   21.502370]  ? kmem_cache_alloc+0x180/0x250
> [   21.502372]  ? getname_flags+0x100/0x520
> [   21.502374]  user_path_at_empty+0x3a/0x50
> [   21.502375]  vfs_statx+0xca/0x150
> [   21.502377]  ? vfs_statx_fd+0x90/0x90
> [   21.502379]  ? __kasan_slab_free+0x14e/0x180
> [   21.502381]  __do_sys_newstat+0x9a/0x100
> [   21.502382]  ? cp_new_stat+0x5d0/0x5d0
> [   21.502384]  ? __kasan_check_write+0x14/0x20
> [   21.502385]  ? _raw_spin_lock_irq+0x82/0xe0
> [   21.502386]  ? _raw_read_lock_irq+0x50/0x50
> [   21.502388]  ? __blkcg_punt_bio_submit+0x1c0/0x1c0
> [   21.502390]  ? __kasan_check_write+0x14/0x20
> [   21.502392]  ? switch_fpu_return+0x13a/0x2d0
> [   21.502393]  ? fpregs_mark_activate+0x150/0x150
> [   21.502395]  __x64_sys_newstat+0x54/0x80
> [   21.502397]  do_syscall_64+0x9f/0x3a0
> [   21.502398]  ? prepare_exit_to_usermode+0xee/0x1a0
> [   21.502400]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [   21.502402] RIP: 0033:0x7f9afc30049a
> [   21.502404] Code: 00 00 75 05 48 83 c4 18 c3 e8 f2 24 02 00 66 90 =
f3 0f 1e fa 41 89 f8 48 89 f7 48 89 d6 41 83 f8 01 77 2d b8 04 00 00 00 =
0f 05 <48> 3d 00 f0 ff ff 77 06 c3 0f 1f 44 00 00 48 8b 15 c1 a9 0d 00 =
f7
> [   21.502405] RSP: 002b:00007ffe7cd464c8 EFLAGS: 00000246 ORIG_RAX: =
0000000000000004
> [   21.502407] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: =
00007f9afc30049a
> [   21.502408] RDX: 00007ffe7cd464d0 RSI: 00007ffe7cd464d0 RDI: =
000055c9330705f0
> [   21.502409] RBP: 000055c9330705f0 R08: 0000000000000001 R09: =
0000000000000001
> [   21.502410] R10: 0000000000000017 R11: 0000000000000246 R12: =
000055c933074de3
> [   21.502410] R13: 000055c93306e1a0 R14: 000055c93306c940 R15: =
000055c93306c990
>=20
> [   21.502414] Allocated by task 1478:
> [   21.502416]  save_stack+0x23/0x90
> [   21.502418]  __kasan_kmalloc.constprop.0+0xcf/0xe0
> [   21.502419]  kasan_slab_alloc+0xe/0x10
> [   21.502420]  kmem_cache_alloc+0xd7/0x250
> [   21.502422]  mempool_alloc_slab+0x17/0x20
> [   21.502424]  mempool_alloc+0x126/0x330
> [   21.502439]  rpc_malloc+0x1f2/0x270 [sunrpc]
> [   21.502452]  call_allocate+0x3b9/0x9d0 [sunrpc]
> [   21.502467]  __rpc_execute+0x204/0xbd0 [sunrpc]
> [   21.502480]  rpc_execute+0x1a0/0x1f0 [sunrpc]
> [   21.502493]  rpc_run_task+0x454/0x5e0 [sunrpc]
> [   21.502507]  nfs4_call_sync_custom+0x12/0x70 [nfsv4]
> [   21.502520]  nfs4_call_sync_sequence+0x143/0x1f0 [nfsv4]
> [   21.502533]  _nfs4_proc_readlink+0x1a6/0x250 [nfsv4]
> [   21.502546]  nfs4_proc_readlink+0x101/0x2c0 [nfsv4]
> [   21.502558]  nfs_symlink_filler+0xdc/0x190 [nfs]
> [   21.502560]  do_read_cache_page+0x60e/0x1490
> [   21.502561]  read_cache_page+0x4c/0x80
> [   21.502571]  nfs_get_link+0x75/0x370 [nfs]
> [   21.502572]  trailing_symlink+0x6fe/0x810
> [   21.502574]  path_lookupat.isra.0+0x188/0x7d0
> [   21.502575]  filename_lookup+0x185/0x3b0
> [   21.502576]  user_path_at_empty+0x3a/0x50
> [   21.502578]  vfs_statx+0xca/0x150
> [   21.502579]  __do_sys_newstat+0x9a/0x100
> [   21.502581]  __x64_sys_newstat+0x54/0x80
> [   21.502582]  do_syscall_64+0x9f/0x3a0
> [   21.502584]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>=20
> [   21.502585] Freed by task 0:
> [   21.502586] (stack is not available)
>=20
> [   21.502589] The buggy address belongs to the object at =
ffff8883bc9f2a80
>                which belongs to the cache rpc_buffers of size 2048
> [   21.502591] The buggy address is located 1988 bytes inside of
>                2048-byte region [ffff8883bc9f2a80, ffff8883bc9f3280)
> [   21.502592] The buggy address belongs to the page:
> [   21.502595] page:ffffea000ef27c00 refcount:1 mapcount:0 =
mapping:ffff8883bf61e600 index:0x0 compound_mapcount: 0
> [   21.502597] flags: 0x17ffffc0010200(slab|head)
> [   21.502600] raw: 0017ffffc0010200 dead000000000100 dead000000000122 =
ffff8883bf61e600
> [   21.502602] raw: 0000000000000000 00000000800f000f 00000001ffffffff =
0000000000000000
> [   21.502603] page dumped because: kasan: bad access detected
>=20
> [   21.502605] Memory state around the buggy address:
> [   21.502607]  ffff8883bc9f3180: 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00
> [   21.502608]  ffff8883bc9f3200: 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00
> [   21.502610] >ffff8883bc9f3280: fc fc fc fc fc fc fc fc fc fc fc fc =
fc fc fc fc
> [   21.502611]                    ^
> [   21.502612]  ffff8883bc9f3300: fb fb fb fb fb fb fb fb fb fb fb fb =
fb fb fb fb
> [   21.502614]  ffff8883bc9f3380: fb fb fb fb fb fb fb fb fb fb fb fb =
fb fb fb fb
> [   21.502615] =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [   21.502616] Disabling lock debugging due to kernel taint
>=20
> Best Regards
> --=20
> Pierre Sauter
> Studentenwerk M=C3=BCnchen
> -------

--
Chuck Lever



