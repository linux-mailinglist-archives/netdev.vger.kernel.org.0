Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B72622704C
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 23:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgGTVZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 17:25:13 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52300 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbgGTVZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 17:25:13 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06KLCPLZ024234;
        Mon, 20 Jul 2020 21:22:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=YF1O2bzyt5JsxVAWJIZ9x4b/c9upyzhSLMaVfh6sbTk=;
 b=Rha4DVjqmyBkZASkBbobcjjiNpKHEy1wVFamjMx3lVsgnA7hhOfhmLWEdxz1wQyceX3a
 vFdlOB0r65eM8eWot3N5j516Dog664wq30Czx02J6ClnYFeV+DPTmG+ZFT0+ZhekWvZ9
 x35ISZrXg/iFqTJgqiwIk3JhGlYicyWkOEkNpAhkaftGp2D+Nxr4C0k9aj/Z0ap5nzjy
 XxKiJe52+tSvFEoe7bdSh8guGrs3Qlkln+nWdqG9vpGSRUFhE5xRlgDNaqqjzl44SOqZ
 liNW4/zOnGayeKfEmi7lD776Ui9IEPta/FaY6k1YUn73me8s4P4Rp12QdVvG613H357l 0A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 32brgr9e27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 20 Jul 2020 21:22:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06KLDvnS072727;
        Mon, 20 Jul 2020 21:22:57 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 32djp394q9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jul 2020 21:22:57 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06KLMnOJ002885;
        Mon, 20 Jul 2020 21:22:49 GMT
Received: from anon-dhcp-152.1015granger.net (/68.61.232.219)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Jul 2020 21:22:49 +0000
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [Regression] "SUNRPC: Add "@len" parameter to gss_unwrap()"
 breaks NFS Kerberos on upstream stable 5.4.y
From:   Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <9AA41536-4CD0-46E0-BE5E-850A420EF7FE@oracle.com>
Date:   Mon, 20 Jul 2020 17:22:48 -0400
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        matthew.ruffell@canonical.com,
        linux-stable <stable@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-kernel-owner@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <144859B6-6050-4209-A540-4EF0760FAAE8@oracle.com>
References: <309E203B-8818-4E33-87F0-017E127788E2@canonical.com>
 <650B6279-9550-4844-9375-280F11C3DC4B@oracle.com>
 <CCF13E29-7B8B-47B3-A8D0-1A6E0E626BA6@canonical.com>
 <4572147.31r3eYUQgx@keks.as.studentenwerk.mhn.de>
 <9AA41536-4CD0-46E0-BE5E-850A420EF7FE@oracle.com>
To:     Pierre Sauter <pierre.sauter@stwm.de>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=999 phishscore=0 suspectscore=2 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007200137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 impostorscore=0 suspectscore=2 adultscore=0 clxscore=1015 mlxlogscore=999
 priorityscore=1501 phishscore=0 lowpriorityscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007200137
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 18, 2020, at 11:55 AM, Chuck Lever <chuck.lever@oracle.com> =
wrote:
>=20
>=20
>=20
>> On Jul 17, 2020, at 3:46 PM, Pierre Sauter <pierre.sauter@stwm.de> =
wrote:
>>=20
>> Am Freitag, 17. Juli 2020, 19:56:09 CEST schrieb Kai-Heng Feng:
>>>> Pierre, thanks for confirming!
>>>>=20
>>>> Kai-Heng suspected an upstream stable commit that is missing in =
5.4.0-40,
>>>> but I don't have any good suggestions.
>>>=20
>>> Well, Ubuntu's 5.4 kernel is based on upstream stable v5.4, so I =
asked users to test stable v5.4.51, however the feedback was negative, =
and that's the reason why I raised the issue here.
>>>=20
>>> Anyway, good to know that it's fixed in upstream stable, =
everything's good now!
>>> Thanks for your effort Chuck.
>>>=20
>>> Kai-Heng
>>=20
>> Sorry to have caused premature happiness. Kai-Hengs last message =
reminded me
>> that I had seen the bug earlier in the week on Ubuntu Mainline =
v.5.4.51.
>> So I decided to rebuild vanilla v5.4.51 with Ubuntus config + KASAN, =
and voila.
>> It seems that their config is just really good in exposing the bug on =
mount. I
>> am off for the weekend, can do more testing next week.
>>=20
>> [   21.664580] =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> [   21.664657] BUG: KASAN: slab-out-of-bounds in =
_copy_from_pages+0xed/0x210 [sunrpc]
>> [   21.664705] Write of size 64 at addr ffff8883b6b7d444 by task =
update-desktop-/1345
>>=20
>> [   21.664764] CPU: 0 PID: 1345 Comm: update-desktop- Not tainted =
5.4.51 #1
>> [   21.664765] Hardware name: XXXXXX
>> [   21.664766] Call Trace:
>> [   21.664771]  dump_stack+0x96/0xca
>> [   21.664775]  print_address_description.constprop.0+0x20/0x210
>> [   21.664795]  ? _copy_from_pages+0xed/0x210 [sunrpc]
>> [   21.664797]  __kasan_report.cold+0x1b/0x41
>> [   21.664816]  ? _copy_from_pages+0xed/0x210 [sunrpc]
>> [   21.664819]  kasan_report+0x14/0x20
>> [   21.664820]  check_memory_region+0x129/0x1b0
>> [   21.664822]  memcpy+0x38/0x50
>> [   21.664840]  _copy_from_pages+0xed/0x210 [sunrpc]
>> [   21.664859]  xdr_shrink_pagelen+0x1d6/0x440 [sunrpc]
>> [   21.664877]  xdr_align_pages+0x15f/0x580 [sunrpc]
>> [   21.664897]  ? decode_setattr+0x120/0x120 [nfsv4]
>> [   21.664916]  xdr_read_pages+0x44/0x290 [sunrpc]
>> [   21.664933]  ? __decode_op_hdr+0x29/0x430 [nfsv4]
>> [   21.664950]  nfs4_xdr_dec_readlink+0x238/0x390 [nfsv4]
>=20
> READLINK appears to be a common element in these splats. Is there
> an especially large symbolic link in your home directory? Knowing
> that might help me reproduce the problem here.
>=20
> You confirmed the crash does not occur in v5.5.19, but the 5.8-ish
> kernel you tested was Ubuntu's. Do you have test results for a
> stock upstream v5.8-rc5 kernel?
>=20
> Do you know if v5.6.19 has this issue?

I have a workload that can reproduce this exact KASAN splat on
v5.4.51. Looking into it now.


>> [   21.664966]  ? nfs4_xdr_dec_read+0x3c0/0x3c0 [nfsv4]
>> [   21.664969]  ? __kasan_slab_free+0x14e/0x180
>> [   21.664985]  ? nfs4_xdr_dec_read+0x3c0/0x3c0 [nfsv4]
>> [   21.665003]  rpcauth_unwrap_resp_decode+0xaa/0x100 [sunrpc]
>> [   21.665009]  gss_unwrap_resp+0x99d/0x1570 [auth_rpcgss]
>> [   21.665014]  ? gss_destroy_cred+0x460/0x460 [auth_rpcgss]
>> [   21.665016]  ? finish_task_switch+0x163/0x670
>> [   21.665019]  ? __switch_to_asm+0x34/0x70
>> [   21.665023]  ? gss_wrap_req+0x1700/0x1700 [auth_rpcgss]
>> [   21.665026]  ? prepare_to_wait+0xea/0x2b0
>> [   21.665045]  rpcauth_unwrap_resp+0xac/0x100 [sunrpc]
>> [   21.665061]  call_decode+0x454/0x7e0 [sunrpc]
>> [   21.665077]  ? rpc_decode_header+0x10a0/0x10a0 [sunrpc]
>> [   21.665079]  ? var_wake_function+0x140/0x140
>> [   21.665095]  ? call_transmit_status+0x31e/0x5d0 [sunrpc]
>> [   21.665110]  ? rpc_decode_header+0x10a0/0x10a0 [sunrpc]
>> [   21.665127]  __rpc_execute+0x204/0xbd0 [sunrpc]
>> [   21.665143]  ? xprt_wait_for_reply_request_def+0x170/0x170 =
[sunrpc]
>> [   21.665160]  ? rpc_exit+0xc0/0xc0 [sunrpc]
>> [   21.665162]  ? __kasan_check_read+0x11/0x20
>> [   21.665164]  ? wake_up_bit+0x42/0x50
>> [   21.665181]  rpc_execute+0x1a0/0x1f0 [sunrpc]
>> [   21.665197]  rpc_run_task+0x454/0x5e0 [sunrpc]
>> [   21.665213]  nfs4_call_sync_custom+0x12/0x70 [nfsv4]
>> [   21.665229]  nfs4_call_sync_sequence+0x143/0x1f0 [nfsv4]
>> [   21.665244]  ? nfs4_call_sync_custom+0x70/0x70 [nfsv4]
>> [   21.665247]  ? get_page_from_freelist+0x24d0/0x45f0
>> [   21.665263]  _nfs4_proc_readlink+0x1a6/0x250 [nfsv4]
>> [   21.665280]  ? _nfs4_proc_getdeviceinfo+0x350/0x350 [nfsv4]
>> [   21.665282]  ? release_pages+0x44b/0xca0
>> [   21.665284]  ? __mod_lruvec_state+0x8f/0x320
>> [   21.665286]  ? pagevec_lru_move_fn+0x18d/0x230
>> [   21.665303]  nfs4_proc_readlink+0x101/0x2c0 [nfsv4]
>> [   21.665320]  ? nfs4_proc_link+0x1c0/0x1c0 [nfsv4]
>> [   21.665322]  ? add_to_page_cache_locked+0x20/0x20
>> [   21.665339]  nfs_symlink_filler+0xdc/0x190 [nfs]
>> [   21.665341]  do_read_cache_page+0x60e/0x1490
>> [   21.665353]  ? nfs4_do_lookup_revalidate+0x1a1/0x2d0 [nfs]
>> [   21.665365]  ? nfs_get_link+0x370/0x370 [nfs]
>> [   21.665367]  ? xas_load+0x23/0x250
>> [   21.665369]  ? pagecache_get_page+0x760/0x760
>> [   21.665372]  ? lockref_get_not_dead+0xe3/0x1c0
>> [   21.665374]  ? __kasan_check_write+0x14/0x20
>> [   21.665376]  ? lockref_get_not_dead+0xe3/0x1c0
>> [   21.665378]  ? __kasan_check_write+0x14/0x20
>> [   21.665380]  ? _raw_spin_lock+0x7b/0xd0
>> [   21.665382]  ? _raw_write_trylock+0x110/0x110
>> [   21.665384]  read_cache_page+0x4c/0x80
>> [   21.665396]  nfs_get_link+0x75/0x370 [nfs]
>> [   21.665399]  trailing_symlink+0x6fe/0x810
>> [   21.665411]  ? nfs_destroy_readpagecache+0x20/0x20 [nfs]
>> [   21.665413]  path_lookupat.isra.0+0x188/0x7d0
>> [   21.665416]  ? do_syscall_64+0x9f/0x3a0
>> [   21.665418]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
>> [   21.665420]  ? path_parentat.isra.0+0x110/0x110
>> [   21.665423]  ? stack_trace_save+0x94/0xc0
>> [   21.665424]  ? stack_trace_consume_entry+0x170/0x170
>> [   21.665427]  filename_lookup+0x185/0x3b0
>> [   21.665429]  ? nd_jump_link+0x1d0/0x1d0
>> [   21.665431]  ? kasan_slab_free+0xe/0x10
>> [   21.665434]  ? __kasan_check_read+0x11/0x20
>> [   21.665436]  ? __check_object_size+0x249/0x316
>> [   21.665438]  ? strncpy_from_user+0x80/0x290
>> [   21.665440]  ? kmem_cache_alloc+0x180/0x250
>> [   21.665442]  ? getname_flags+0x100/0x520
>> [   21.665444]  user_path_at_empty+0x3a/0x50
>> [   21.665447]  vfs_statx+0xca/0x150
>> [   21.665449]  ? vfs_statx_fd+0x90/0x90
>> [   21.665451]  ? __kasan_slab_free+0x14e/0x180
>> [   21.665453]  __do_sys_newstat+0x9a/0x100
>> [   21.665455]  ? cp_new_stat+0x5d0/0x5d0
>> [   21.665457]  ? __kasan_check_write+0x14/0x20
>> [   21.665459]  ? _raw_spin_lock_irq+0x82/0xe0
>> [   21.665461]  ? _raw_read_lock_irq+0x50/0x50
>> [   21.665464]  ? __blkcg_punt_bio_submit+0x1c0/0x1c0
>> [   21.665466]  ? __kasan_check_write+0x14/0x20
>> [   21.665469]  ? switch_fpu_return+0x13a/0x2d0
>> [   21.665471]  ? fpregs_mark_activate+0x150/0x150
>> [   21.665474]  __x64_sys_newstat+0x54/0x80
>> [   21.665476]  do_syscall_64+0x9f/0x3a0
>> [   21.665478]  ? prepare_exit_to_usermode+0xee/0x1a0
>> [   21.665480]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>> [   21.665482] RIP: 0033:0x7f6e05f5c49a
>> [   21.665485] Code: 00 00 75 05 48 83 c4 18 c3 e8 f2 24 02 00 66 90 =
f3 0f 1e fa 41 89 f8 48 89 f7 48 89 d6 41 83 f8 01 77 2d b8 04 00 00 00 =
0f 05 <48> 3d 00 f0 ff ff 77 06 c3 0f 1f 44 00 00 48 8b 15 c1 a9 0d 00 =
f7
>> [   21.665486] RSP: 002b:00007fff043e5f18 EFLAGS: 00000246 ORIG_RAX: =
0000000000000004
>> [   21.665488] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: =
00007f6e05f5c49a
>> [   21.665489] RDX: 00007fff043e5f20 RSI: 00007fff043e5f20 RDI: =
000055af4c4ea5f0
>> [   21.665490] RBP: 000055af4c4ea5f0 R08: 0000000000000001 R09: =
0000000000000001
>> [   21.665491] R10: 0000000000000017 R11: 0000000000000246 R12: =
000055af4c4eede3
>> [   21.665492] R13: 000055af4c4e81a0 R14: 000055af4c4e6940 R15: =
000055af4c4e6990
>>=20
>> [   21.665508] Allocated by task 1345:
>> [   21.665532]  save_stack+0x23/0x90
>> [   21.665534]  __kasan_kmalloc.constprop.0+0xcf/0xe0
>> [   21.665536]  kasan_slab_alloc+0xe/0x10
>> [   21.665538]  kmem_cache_alloc+0xd7/0x250
>> [   21.665539]  mempool_alloc_slab+0x17/0x20
>> [   21.665541]  mempool_alloc+0x126/0x330
>> [   21.665558]  rpc_malloc+0x1f2/0x270 [sunrpc]
>> [   21.665574]  call_allocate+0x3b9/0x9d0 [sunrpc]
>> [   21.665591]  __rpc_execute+0x204/0xbd0 [sunrpc]
>> [   21.665607]  rpc_execute+0x1a0/0x1f0 [sunrpc]
>> [   21.665623]  rpc_run_task+0x454/0x5e0 [sunrpc]
>> [   21.665638]  nfs4_call_sync_custom+0x12/0x70 [nfsv4]
>> [   21.665653]  nfs4_call_sync_sequence+0x143/0x1f0 [nfsv4]
>> [   21.665668]  _nfs4_proc_readlink+0x1a6/0x250 [nfsv4]
>> [   21.665684]  nfs4_proc_readlink+0x101/0x2c0 [nfsv4]
>> [   21.665698]  nfs_symlink_filler+0xdc/0x190 [nfs]
>> [   21.665699]  do_read_cache_page+0x60e/0x1490
>> [   21.665701]  read_cache_page+0x4c/0x80
>> [   21.665713]  nfs_get_link+0x75/0x370 [nfs]
>> [   21.665714]  trailing_symlink+0x6fe/0x810
>> [   21.665716]  path_lookupat.isra.0+0x188/0x7d0
>> [   21.665718]  filename_lookup+0x185/0x3b0
>> [   21.665719]  user_path_at_empty+0x3a/0x50
>> [   21.665721]  vfs_statx+0xca/0x150
>> [   21.665723]  __do_sys_newstat+0x9a/0x100
>> [   21.665725]  __x64_sys_newstat+0x54/0x80
>> [   21.665727]  do_syscall_64+0x9f/0x3a0
>> [   21.665729]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>=20
>> [   21.665743] Freed by task 0:
>> [   21.665762] (stack is not available)
>>=20
>> [   21.665798] The buggy address belongs to the object at =
ffff8883b6b7cc80
>>               which belongs to the cache rpc_buffers of size 2048
>> [   21.665871] The buggy address is located 1988 bytes inside of
>>               2048-byte region [ffff8883b6b7cc80, ffff8883b6b7d480)
>> [   21.665939] The buggy address belongs to the page:
>> [   21.665970] page:ffffea000edade00 refcount:1 mapcount:0 =
mapping:ffff88840afecc00 index:0x0 compound_mapcount: 0
>> [   21.666029] flags: 0x17ffffc0010200(slab|head)
>> [   21.666059] raw: 0017ffffc0010200 dead000000000100 =
dead000000000122 ffff88840afecc00
>> [   21.666107] raw: 0000000000000000 00000000800f000f =
00000001ffffffff 0000000000000000
>> [   21.666152] page dumped because: kasan: bad access detected
>>=20
>> [   21.666197] Memory state around the buggy address:
>> [   21.666228]  ffff8883b6b7d380: 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00
>> [   21.666272]  ffff8883b6b7d400: 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00
>> [   21.666315] >ffff8883b6b7d480: fc fc fc fc fc fc fc fc fc fc fc fc =
fc fc fc fc
>> [   21.666358]                    ^
>> [   21.666379]  ffff8883b6b7d500: fc fc fc fc fc fc fc fc fc fc fc fc =
fc fc fc fc
>> [   21.666423]  ffff8883b6b7d580: fc fc fc fc fc fc fc fc fc fc fc fc =
fc fc fc fc
>> [   21.666465] =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> [   21.666509] Disabling lock debugging due to kernel taint
>>=20
>>=20
>>=20
>=20
> --
> Chuck Lever

--
Chuck Lever



