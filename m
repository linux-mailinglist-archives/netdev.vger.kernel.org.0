Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82E796E69BB
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 18:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbjDRQlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 12:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbjDRQll (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 12:41:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF841FDE
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 09:41:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17C39636BF
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 16:41:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C11C433D2;
        Tue, 18 Apr 2023 16:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681836098;
        bh=W7Nb8nbgElJCPxZusyExXJG4CvrzFqUMACtP6sVZJtE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Tk8ojH4r26ZqlnUsKDn06jHjFxWtVv9a6dkYKfj5DsIL5WfLnWX2db1zHKKC7WePE
         0kEdsnRZQ4wBG4Lb+QWpGQyxlN109gl5d3PFyrMXD3OY7+1SpbA8p+FQqMbFtCI4Jd
         6KlulY8+ZOl/5xUVS4W0Djv0eWrZbTT5fGqjGtArafETjCC60c5p5c4TvWKGrzhsNP
         L1zDx4udIp8LHIrMk+jmwqM9YeDsPvyXuG0/vkEoaHRXLM0DybXWmMxvN23oehZrEU
         03vYl8M+oTc8cuASNd2ypWkjq33lSfk3vFivwPq7PLGjwn+1pu3MWbPoPbScaaB1cO
         5I0AYE5IJ4VXA==
Date:   Tue, 18 Apr 2023 19:41:33 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     kernel test robot <oliver.sang@intel.com>,
        Wangyang Guo <wangyang.guo@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Wangyang Guo <wangyang.guo@intel.com>, oe-lkp@lists.linux.dev,
        lkp@intel.com, Linux Memory Management List <linux-mm@kvack.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Subject: Re: [linux-next:master] [net]  d288a162dd:  canonical_address#:#[##]
Message-ID: <20230418164133.GA44666@unreal>
References: <202304162125.18b7bcdd-oliver.sang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <202304162125.18b7bcdd-oliver.sang@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 16, 2023 at 10:27:33PM +0800, kernel test robot wrote:
>=20
> Hello,
>=20
> kernel test robot noticed "canonical_address#:#[##]" on:
>=20
> commit: d288a162dd1c73507da582966f17dd226e34a0c0 ("net: dst: Prevent fals=
e sharing vs. dst_entry:: __refcnt")
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
>=20
> [test failed on linux-next/master d3f2cd24819158bb70701c3549e586f9df9cee6=
7]
>=20
> in testcase: kernel-selftests
> version: kernel-selftests-x86_64-60acb023-1_20230329
> with following parameters:
>=20
> 	group: net
>=20
> test-description: The kernel contains a set of "self tests" under the too=
ls/testing/selftests/ directory. These are intended to be small unit tests =
to exercise individual code paths in the kernel.
> test-url: https://www.kernel.org/doc/Documentation/kselftest.txt
>=20
>=20
> compiler: gcc-11
> test machine: 8 threads Intel(R) Core(TM) i7-6700 CPU @ 3.40GHz (Skylake)=
 with 28G memory
>=20
> (please refer to attached dmesg/kmsg for entire log/backtrace)
>=20
>=20
> If you fix the issue, kindly add following tag
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Link: https://lore.kernel.org/oe-lkp/202304162125.18b7bcdd-oliver.sang@=
intel.com
>=20
>=20
> [  447.531710][    C7] general protection fault, probably for non-canonic=
al address 0xed6d696d6d6d6d70: 0000 [#1] SMP KASAN PTI
> [  447.542997][    C7] KASAN: maybe wild-memory-access in range [0x6b6b6b=
6b6b6b6b80-0x6b6b6b6b6b6b6b87]
> [  447.552182][    C7] CPU: 7 PID: 0 Comm: swapper/7 Tainted: G S        =
         6.3.0-rc3-00830-gd288a162dd1c #1
> [  447.562327][    C7] Hardware name: Dell Inc. OptiPlex 7040/0Y7WYT, BIO=
S 1.2.8 01/26/2016
> [  447.570461][    C7] RIP: 0010:__lock_acquire+0xc30/0x2390
> [  447.575894][    C7] Code: 02 05 41 bc 01 00 00 00 0f 86 94 00 00 00 89=
 05 66 57 02 05 e9 89 00 00 00 48 b8 00 00 00 00 00 fc ff df 4c 89 f2 48 c1=
 ea
> 03 <80> 3c 02 00 0f 85 f5 12 00 00 45 31 e4 49 81 3e e0 6d 0c 86 45 0f
> [  447.595470][    C7] RSP: 0018:ffffc900004d0b18 EFLAGS: 00010002
> [  447.601426][    C7] RAX: dffffc0000000000 RBX: 1ffff9200009a190 RCX: 0=
000000000000000
> [  447.609300][    C7] RDX: 0d6d6d6d6d6d6d70 RSI: 0000000000000000 RDI: 6=
b6b6b6b6b6b6b83
> [  447.617174][    C7] RBP: ffff888100a8b440 R08: 0000000000000001 R09: 0=
000000000000000
> [  447.625049][    C7] R10: 0000000000000000 R11: 0000000000000001 R12: 0=
000000000000001
> [  447.632937][    C7] R13: 0000000000000000 R14: 6b6b6b6b6b6b6b83 R15: 0=
000000000000000
> [  447.640812][    C7] FS:  0000000000000000(0000) GS:ffff88862c780000(00=
00) knlGS:0000000000000000
> [  447.649648][    C7] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  447.656124][    C7] CR2: 000055dbc0fa1794 CR3: 000000075745e001 CR4: 0=
0000000003706e0
> [  447.664000][    C7] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0=
000000000000000
> [  447.671876][    C7] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0=
000000000000400
> [  447.679749][    C7] Call Trace:
> [  447.682910][    C7]  <IRQ>
> [  447.685632][    C7]  ? mark_lock_irq+0xe50/0xe50
> [  447.690277][    C7]  ? asm_sysvec_apic_timer_interrupt+0x1a/0x20
> [  447.696319][    C7]  ? cpuidle_enter_state+0xe4/0x520
> [  447.701404][    C7]  ? cpuidle_enter+0x4e/0xa0
> [  447.705883][    C7]  ? cpuidle_idle_call+0x1ab/0x270
> [  447.710884][    C7]  ? do_idle+0xf3/0x1a0
> [  447.714925][    C7]  ? mark_usage+0x2a0/0x2a0
> [  447.719315][    C7]  ? __lock_acquire+0xa7d/0x2390
> [  447.724145][    C7]  lock_acquire+0x19d/0x4c0
> [  447.728538][    C7]  ? rt_del_uncached_list+0x71/0x1c0
> [  447.733710][    C7]  ? lock_release+0x200/0x200
> [  447.738268][    C7]  ? lock_acquire+0x19d/0x4c0
> [  447.742828][    C7]  ? rcu_do_batch+0x30d/0xcd0
> [  447.747387][    C7]  _raw_spin_lock_bh+0x38/0x50
> [  447.752040][    C7]  ? rt_del_uncached_list+0x71/0x1c0
> [  447.757209][    C7]  rt_del_uncached_list+0x71/0x1c0
> [  447.762205][    C7]  xfrm4_dst_destroy+0x74/0x240
> [  447.766938][    C7]  dst_destroy+0xe7/0x3d0
> [  447.771146][    C7]  rcu_do_batch+0x35e/0xcd0
> [  447.775529][    C7]  ? rcu_check_gp_kthread_starvation+0x370/0x370
> [  447.781747][    C7]  ? lockdep_hardirqs_on_prepare+0x13e/0x350
> [  447.788225][    C7]  ? lockdep_hardirqs_on_prepare+0x13e/0x350
> [  447.794706][    C7]  rcu_core+0x51c/0x7c0
> [  447.798738][    C7]  __do_softirq+0x1c9/0x7b1
> [  447.803121][    C7]  __irq_exit_rcu+0x17d/0x1e0
> [  447.807677][    C7]  irq_exit_rcu+0xe/0x20
> [  447.811798][    C7]  sysvec_apic_timer_interrupt+0x73/0x90
> [  447.817317][    C7]  </IRQ>
> [  447.820124][    C7]  <TASK>
> [  447.822933][    C7]  asm_sysvec_apic_timer_interrupt+0x1a/0x20
> [  447.828798][    C7] RIP: 0010:cpuidle_enter_state+0xe4/0x520
> [  447.834491][    C7] Code: bf ff ff ff ff 49 89 c6 e8 f9 63 5d ff 31 ff=
 e8 12 84 a3 fd 45 84 ff 0f 85 49 02 00 00 e8 34 5d 5d ff 84 c0 0f 84 31 02=
 00 00 <45> 85 ed 0f 88 95 01 00 00 4d 63 fd 49 83 ff 09 0f 87 43 03 00 00
> [  447.854073][    C7] RSP: 0018:ffffc900001cfd90 EFLAGS: 00000202
> [  447.860040][    C7] RAX: 00000000005949ad RBX: ffffe8ffffd827a0 RCX: 1=
ffffffff0a9add1
> [  447.867915][    C7] RDX: 0000000000000000 RSI: 0000000000000000 RDI: f=
fffffff838b55ba
> [  447.875790][    C7] RBP: ffffffff84fd5660 R08: 0000000000000001 R09: f=
fffffff854dbda7
> [  447.883665][    C7] R10: fffffbfff0a9b7b4 R11: 0000000000000001 R12: 0=
000000000000004
> [  447.891539][    C7] R13: 0000000000000004 R14: 0000006832edd0d7 R15: 0=
000000000000000
> [  447.899416][    C7]  ? cpuidle_enter_state+0x31a/0x520
> [  447.904588][    C7]  cpuidle_enter+0x4e/0xa0
> [  447.908885][    C7]  cpuidle_idle_call+0x1ab/0x270
> [  447.913705][    C7]  ? arch_cpu_idle_exit+0x40/0x40
> [  447.918612][    C7]  ? lockdep_hardirqs_on_prepare+0x19a/0x350
> [  447.925094][    C7]  ? tsc_verify_tsc_adjust+0x5d/0x290
> [  447.930352][    C7]  do_idle+0xf3/0x1a0
> [  447.934213][    C7]  cpu_startup_entry+0x1d/0x20
> [  447.938856][    C7]  start_secondary+0x237/0x2d0
> [  447.943502][    C7]  ? set_cpu_sibling_map+0x2610/0x2610
> [  447.948856][    C7]  secondary_startup_64_no_verify+0xe0/0xeb
> [  447.954646][    C7]  </TASK>
> [  447.957549][    C7] Modules linked in: esp6 authenc echainiv xt_policy=
 nft_compat nf_tables veth nfnetlink esp4_offload psample esp4 bridge ip6_g=
re ip6_tunnel tunnel6 ip_gre gre cls_u32 sch_htb dummy tun nf_conntrack_bro=
adcast fou ip_tunnel ip6_udp_tunnel udp_tunnel rpcsec_gss_krb5 auth_rpcgss =
nfsv4 dns_resolver openvswitch nf_conncount nf_nat nf_conntrack nf_defrag_i=
pv6 nf_defrag_ipv4 intel_rapl_msr intel_rapl_common btrfs x86_pkg_temp_ther=
mal intel_powerclamp blake2b_generic xor coretemp kvm_intel raid6_pq zstd_c=
ompress libcrc32c kvm irqbypass crct10dif_pclmul crc32_pclmul crc32c_intel =
sd_mod ghash_clmulni_intel t10_pi sha512_ssse3 crc64_rocksoft_generic i915 =
crc64_rocksoft crc64 sg rapl mei_wdt drm_buddy intel_cstate intel_gtt ipmi_=
devintf ipmi_msghandler wmi_bmof mei_me ahci libahci drm_display_helper i2c=
_i801 intel_uncore mei i2c_smbus libata intel_pch_thermal drm_kms_helper vi=
deo syscopyarea sysfillrect sysimgblt ttm intel_pmc_core wmi acpi_pad binfm=
t_misc fuse drm ip_tables [last unloaded: netdevsim]
> [  448.047386][    C7] ---[ end trace 0000000000000000 ]---
> [  448.052730][    C7] RIP: 0010:__lock_acquire+0xc30/0x2390
> [  448.058173][    C7] Code: 02 05 41 bc 01 00 00 00 0f 86 94 00 00 00 89=
 05 66 57 02 05 e9 89 00 00 00 48 b8 00 00 00 00 00 fc ff df 4c 89 f2 48 c1=
 ea 03 <80> 3c 02 00 0f 85 f5 12 00 00 45 31 e4 49 81 3e e0 6d 0c 86 45 0f
> [  448.077750][    C7] RSP: 0018:ffffc900004d0b18 EFLAGS: 00010002
> [  448.083706][    C7] RAX: dffffc0000000000 RBX: 1ffff9200009a190 RCX: 0=
000000000000000
> [  448.091581][    C7] RDX: 0d6d6d6d6d6d6d70 RSI: 0000000000000000 RDI: 6=
b6b6b6b6b6b6b83
> [  448.099455][    C7] RBP: ffff888100a8b440 R08: 0000000000000001 R09: 0=
000000000000000
> [  448.107331][    C7] R10: 0000000000000000 R11: 0000000000000001 R12: 0=
000000000000001
> [  448.115205][    C7] R13: 0000000000000000 R14: 6b6b6b6b6b6b6b83 R15: 0=
000000000000000
> [  448.123101][    C7] FS:  0000000000000000(0000) GS:ffff88862c780000(00=
00) knlGS:0000000000000000
> [  448.131939][    C7] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  448.138419][    C7] CR2: 000055dbc0fa1794 CR3: 000000075745e001 CR4: 0=
0000000003706e0
> [  448.146296][    C7] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0=
000000000000000
> [  448.154173][    C7] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0=
000000000000400
> [  448.162055][    C7] Kernel panic - not syncing: Fatal exception in int=
errupt
> [  448.169198][    C7] Kernel Offset: disabled


Hi,

I came to the following diff which eliminates the kernel panics,
unfortunately I can explain only second hunk, but first is required
too.

diff --git a/net/core/dst.c b/net/core/dst.c
index 3247e84045ca..750c8edfe29a 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -72,6 +72,8 @@ void dst_init(struct dst_entry *dst, struct dst_ops *ops,
        dst->flags =3D flags;
        if (!(flags & DST_NOCOUNT))
                dst_entries_add(ops, 1);
+
+       INIT_LIST_HEAD(&dst->rt_uncached);
 }
 EXPORT_SYMBOL(dst_init);
=20
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 35085fc0cf15..4f31a880e213 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -154,6 +154,8 @@ void rt6_uncached_list_del(struct rt6_info *rt)
                spin_lock_bh(&ul->lock);
                list_del_init(&rt->dst.rt_uncached);
                spin_unlock_bh(&ul->lock);
+
+               rt->dst.rt_uncached_list =3D NULL;
        }
 }


My crashes with enabled KASAN are:

 [  246.087211] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
 [  246.087910] BUG: KASAN: wild-memory-access in _raw_spin_lock_bh+0x76/0x=
e0
 [  246.088488] Write of size 4 at addr 636275735f5f100e by task swapper/10=
/0
 [  246.089061]
 [  246.089271] CPU: 10 PID: 0 Comm: swapper/10 Not tainted 6.3.0-rc6+ #10
 [  246.089829] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS re=
l-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
 [  246.090750] Call Trace:
 [  246.091023]  <IRQ>
 [  246.091267]  dump_stack_lvl+0x33/0x50
 [  246.091628]  ? _raw_spin_lock_bh+0x76/0xe0
 [  246.092012]  kasan_report+0xae/0xe0
 [  246.092354]  ? _raw_spin_lock_bh+0x76/0xe0
 [  246.092739]  kasan_check_range+0x140/0x190
 [  246.093124]  _raw_spin_lock_bh+0x76/0xe0
 [  246.093495]  ? _raw_spin_lock+0xd0/0xd0
 [  246.093863]  ? run_posix_cpu_timers+0x2d4/0x340
 [  246.100676]  ? clear_posix_cputimers_work+0x50/0x50
 [  246.101118]  rt6_uncached_list_del+0x3a/0x90
 [  246.101522]  xfrm6_dst_destroy+0x90/0x1e0
 [  246.101906]  dst_destroy+0x76/0x1f0
 [  246.102255]  rcu_core+0x4a3/0x7c0
 [  246.102593]  ? rcu_exp_handler+0xe0/0xe0
 [  246.102972]  ? kvm_clock_read+0xd/0x10
 [  246.103341]  ? ktime_get+0x45/0xb0
 [  246.103677]  ? lapic_next_deadline+0x37/0x60
 [  246.104078]  ? clockevents_program_event+0xd3/0x130
 [  246.104519]  __do_softirq+0xf1/0x355
 [  246.104876]  irq_exit_rcu+0xa3/0xe0
 [  246.105218]  sysvec_apic_timer_interrupt+0x6f/0x90
 [  246.105654]  </IRQ>
 [  246.105902]  <TASK>
 [  246.106147]  asm_sysvec_apic_timer_interrupt+0x16/0x20
 [  246.106614] RIP: 0010:default_idle+0x13/0x20
 [  246.107018] Code: c0 08 00 00 00 4d 29 c8 4c 01 c7 4c 29 c2 e9 72 ff ff=
 ff cc cc cc cc 8b 05 1a 1f e5 01 85 c0 7e 07 0f 00 2d 8f 52 3f 00 fb f4 <f=
a> c3 66 66 2e 0f 1f 84 00 00 00 00 00 65 48 8b 04 25 40 74 03 00
 [  246.108506] RSP: 0018:ffff88810095fe20 EFLAGS: 00000242
 [  246.108965] RAX: 0000000000000001 RBX: ffff888100950000 RCX: ffffffff82=
25956f
 [  246.109558] RDX: ffffed1103e2698d RSI: 0000000000000004 RDI: 0000000000=
096c14
 [  246.110152] RBP: 000000000000000a R08: 0000000000000001 R09: ffff88881f=
134c63
 [  246.110748] R10: ffffed1103e2698c R11: 00000000fa83b2da R12: ffffffff83=
894ce0
 [  246.111345] R13: 0000000000000000 R14: 0000000000000000 R15: 1ffff11020=
12bfc7
 [  246.111939]  ? ct_kernel_exit.constprop.0+0x7f/0xa0
 [  246.112385]  default_idle_call+0x30/0x50
 [  246.112758]  do_idle+0x255/0x260
 [  246.113083]  ? arch_cpu_idle_exit+0x30/0x30
 [  246.113476]  ? finish_task_switch.isra.0+0xbd/0x3e0
 [  246.113921]  ? schedule_idle+0x37/0x50
 [  246.114280]  cpu_startup_entry+0x19/0x20
 [  246.114658]  start_secondary+0x1a5/0x1d0
 [  246.115036]  ? set_cpu_sibling_map+0xb60/0xb60
 [  246.115448]  secondary_startup_64_no_verify+0xcd/0xdb
 [  246.115901]  </TASK>
 [  246.116156] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
 [  246.116810] Disabling lock debugging due to kernel taint
 [  246.117286] stack segment: 0000 [#1] SMP KASAN
 [  246.117704] CPU: 10 PID: 0 Comm: swapper/10 Tainted: G    B            =
  6.3.0-rc6+ #10
 [  246.118436] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS re=
l-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
 [  246.119362] RIP: 0010:_raw_spin_lock_bh+0x8e/0xe0
 [  246.119792] Code: be 04 00 00 00 c7 44 24 20 00 00 00 00 e8 7a 35 2b ff=
 be 04 00 00 00 48 8d 7c 24 20 e8 6b 35 2b ff ba 01 00 00 00 8b 44 24 20 <f=
0> 0f b1 55 00 75 29 48 b8 00 00 00 00 00 fc ff df 48 c7 04 03 00
 [  246.121261] RSP: 0018:ffff88881f109d78 EFLAGS: 00010297
 [  246.121721] RAX: 0000000000000000 RBX: 1ffff11103e213af RCX: ffffffff82=
269255
 [  246.122314] RDX: 0000000000000001 RSI: 0000000000000004 RDI: ffff88881f=
109d98
 [  246.122941] RBP: 636275735f5f100e R08: 0000000000000001 R09: 0000000000=
000003
 [  246.123541] R10: ffffed1103e213b3 R11: 6e696c6261736944 R12: ffff88810f=
0a8000
 [  246.124134] R13: 0000000000000000 R14: 636275735f5f100e R15: ffff88810f=
0a8008
 [  246.124730] FS:  0000000000000000(0000) GS:ffff88881f100000(0000) knlGS=
:0000000000000000
 [  246.125435] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 [  246.125935] CR2: 0000564fdebef048 CR3: 000000014104a005 CR4: 0000000000=
370ea0
 [  246.126536] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000=
000000
 [  246.127134] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000=
000400
 [  246.127734] Call Trace:
 [  246.128025]  <IRQ>
 [  246.128265]  ? _raw_spin_lock+0xd0/0xd0
 [  246.128637]  ? run_posix_cpu_timers+0x2d4/0x340
 [  246.129060]  ? clear_posix_cputimers_work+0x50/0x50
 [  246.129504]  rt6_uncached_list_del+0x3a/0x90
 [  246.129905]  xfrm6_dst_destroy+0x90/0x1e0
 [  246.130282]  dst_destroy+0x76/0x1f0
 [  246.130631]  rcu_core+0x4a3/0x7c0
 [  246.130962]  ? rcu_exp_handler+0xe0/0xe0
 [  246.131333]  ? kvm_clock_read+0xd/0x10
 [  246.131696]  ? ktime_get+0x45/0xb0
 [  246.132036]  ? lapic_next_deadline+0x37/0x60
 [  246.132430]  ? clockevents_program_event+0xd3/0x130
 [  246.132878]  __do_softirq+0xf1/0x355
 [  246.133237]  irq_exit_rcu+0xa3/0xe0
 [  246.133586]  sysvec_apic_timer_interrupt+0x6f/0x90
 [  246.134021]  </IRQ>
 [  246.134270]  <TASK>
 [  246.134521]  asm_sysvec_apic_timer_interrupt+0x16/0x20
 [  246.134975] RIP: 0010:default_idle+0x13/0x20
 [  246.135377] Code: c0 08 00 00 00 4d 29 c8 4c 01 c7 4c 29 c2 e9 72 ff ff=
 ff cc cc cc cc 8b 05 1a 1f e5 01 85 c0 7e 07 0f 00 2d 8f 52 3f 00 fb f4 <f=
a> c3 66 66 2e 0f 1f 84 00 00 00 00 00 65 48 8b 04 25 40 74 03 00
 [  246.136874] RSP: 0018:ffff88810095fe20 EFLAGS: 00000242
 [  246.137334] RAX: 0000000000000001 RBX: ffff888100950000 RCX: ffffffff82=
25956f
 [  246.137957] RDX: ffffed1103e2698d RSI: 0000000000000004 RDI: 0000000000=
096c14
 [  246.138558] RBP: 000000000000000a R08: 0000000000000001 R09: ffff88881f=
134c63
 [  246.139149] R10: ffffed1103e2698c R11: 00000000fa83b2da R12: ffffffff83=
894ce0
 [  246.139744] R13: 0000000000000000 R14: 0000000000000000 R15: 1ffff11020=
12bfc7
 [  246.140343]  ? ct_kernel_exit.constprop.0+0x7f/0xa0
 [  246.140791]  default_idle_call+0x30/0x50
 [  246.141170]  do_idle+0x255/0x260
 [  246.141495]  ? arch_cpu_idle_exit+0x30/0x30
 [  246.141888]  ? finish_task_switch.isra.0+0xbd/0x3e0
 [  246.142331]  ? schedule_idle+0x37/0x50
 [  246.142712]  cpu_startup_entry+0x19/0x20
 [  246.143088]  start_secondary+0x1a5/0x1d0
 [  246.143464]  ? set_cpu_sibling_map+0xb60/0xb60
 [  246.143875]  secondary_startup_64_no_verify+0xcd/0xdb
 [  246.144327]  </TASK>
 [  246.144583] Modules linked in: mlx5_vdpa vringh vhost_iotlb vdpa iptabl=
e_raw bonding ib_ipoib ib_umad geneve rdma_ucm mlx5_vfio_pci ip6_gre ip6_tu=
nnel tunnel6 mlx5_ib ib_uverbs mlx5_core nf_tables ip_gre gre vfio_pci vfio=
_pci_core vfio_iommu_type1 vfio ipip tunnel4 openvswitch nsh xt_conntrack x=
t_MASQUERADE nf_conntrack_netlink nfnetlink xt_addrtype iptable_nat nf_nat =
br_netfilter rpcrdma ib_iser libiscsi scsi_transport_iscsi rdma_cm iw_cm ib=
_cm ib_core overlay zram zsmalloc fuse [last unloaded: ib_uverbs]
 [  246.148167] ---[ end trace 0000000000000000 ]---
 [  246.148605] RIP: 0010:_raw_spin_lock_bh+0x8e/0xe0
 [  246.149047] Code: be 04 00 00 00 c7 44 24 20 00 00 00 00 e8 7a 35 2b ff=
 be 04 00 00 00 48 8d 7c 24 20 e8 6b 35 2b ff ba 01 00 00 00 8b 44 24 20 <f=
0> 0f b1 55 00 75 29 48 b8 00 00 00 00 00 fc ff df 48 c7 04 03 00
 [  246.150568] RSP: 0018:ffff88881f109d78 EFLAGS: 00010297
 [  246.151039] RAX: 0000000000000000 RBX: 1ffff11103e213af RCX: ffffffff82=
269255
 [  246.151655] RDX: 0000000000000001 RSI: 0000000000000004 RDI: ffff88881f=
109d98
 [  246.152256] RBP: 636275735f5f100e R08: 0000000000000001 R09: 0000000000=
000003
 [  246.152857] R10: ffffed1103e213b3 R11: 6e696c6261736944 R12: ffff88810f=
0a8000
 [  246.153461] R13: 0000000000000000 R14: 636275735f5f100e R15: ffff88810f=
0a8008
 [  246.154064] FS:  0000000000000000(0000) GS:ffff88881f100000(0000) knlGS=
:0000000000000000
 [  246.154781] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 [  246.155300] CR2: 0000564fdebef048 CR3: 000000014104a005 CR4: 0000000000=
370ea0
 [  246.155907] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000=
000000
 [  246.156507] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000=
000400
 [  246.157111] Kernel panic - not syncing: Fatal exception in interrupt
 [  246.157928] Kernel Offset: disabled
 [  246.158281] ---[ end Kernel panic - not syncing: Fatal exception in int=
errupt ]---

Thanks
