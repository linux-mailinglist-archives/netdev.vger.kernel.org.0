Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E202877350
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 23:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728292AbfGZVT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 17:19:59 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33062 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbfGZVT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 17:19:59 -0400
Received: by mail-wr1-f68.google.com with SMTP id n9so55841726wru.0;
        Fri, 26 Jul 2019 14:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=EJ4jcCbbCaX8bSsgyjyBTjyhupWPsOIBLRvIrJhGCzc=;
        b=CfjUjEIXpFwJ4gM7VImYU8pKwZB0mJkD1frrh9VAFpF0Y8rUzTK8ngM01LL/mnLVDE
         ze8ispkD9D2wgjn0/McptVOiKdf+vwTO95+TGDR/C3QAtzdg950ZlwRUJUtM2hc/DxzU
         7DYnLPLMSL3bGZbdj2SP3hpuUQ+Am6+gIFuhY8R2DM7e2TpkqdWkb6ODRRrYlqnQqkmV
         XTmSgTGSnSRSX1PxciqiZ+EdXYI9sPQUD9XafZJvoJppBnMnY+ghkj2/FzX+Grt70xDR
         ronO935G1Nk+WUI7fg218IgXlhLgoSUbbr6rGzc0ZL504CGTDBHVk4qAjSZHcuECqZWE
         kObg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=EJ4jcCbbCaX8bSsgyjyBTjyhupWPsOIBLRvIrJhGCzc=;
        b=dBs98+gHUhZiWSQXaGqbLd3G1MAtX00gGYB2xRQ7mAYnVazZBc7D/kYYnhGflh074o
         7O0QkbbTyV2uPK7TFuyKLD/ITlgX1MPBYwyz4HBOnCMttV6B0wSRpb9CGAQcl0jVdQFr
         v0rc/vPsKHgcW1w7lms46RaRdeDSN+2tKmZkdQIwbHJfwxea0JpwhHANJV/hBxUYuQlG
         4M8IBmQ7+c9NgbU5yxYTZbvQG/aGZGLRxDqtNjdEjXi319yTDhsLXPEm7vWZ2HBbv55r
         aws1LyH0EoKlhkdkR7/NGxVSS6OEN4pMxXRdSvVbsYbV3FS1FcpJVGLy0F29e8rnR4PX
         eeQQ==
X-Gm-Message-State: APjAAAUIZofFRp0jbYFihzljiR2dSIO2roYVaJnDtZEqJLFFypeIw0Fy
        VrLI33IOC3fsCuC6/wnz3wVWQatOKAs3iZl5cPE=
X-Google-Smtp-Source: APXvYqxSj9CahzIg0mF6wBo6On47PcZ0jUg4kqF4jtirnik0vtIp2Z+2M+a6HT5+YowzSupGwj6k8jkZ3WEfu5iPBpg=
X-Received: by 2002:a5d:4212:: with SMTP id n18mr100661786wrq.261.1564175995131;
 Fri, 26 Jul 2019 14:19:55 -0700 (PDT)
MIME-Version: 1.0
References: <CA+icZUWF=B_phP8eGD3v2d9jSSK6Y-N65y-T6xewZnY91vc2_Q@mail.gmail.com>
 <c2524c96-d71c-d7db-22ec-12da905dc180@fb.com> <CA+icZUXYp=Jx+8aGrZmkCbSFp-cSPcoRzRdRJsPj4yYNs_mJQw@mail.gmail.com>
 <CA+icZUXsPRWmH3i-9=TK-=2HviubRqpAeDJGriWHgK1fkFhgUg@mail.gmail.com> <295d2acd-0844-9a40-3f94-5bcbb13871d2@fb.com>
In-Reply-To: <295d2acd-0844-9a40-3f94-5bcbb13871d2@fb.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Fri, 26 Jul 2019 23:19:44 +0200
Message-ID: <CA+icZUUe0QE9QGMom1iQwuG8nM7Oi4Mq0GKqrLvebyxfUmj6RQ@mail.gmail.com>
Subject: Re: next-20190723: bpf/seccomp - systemd/journald issue?
To:     Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>,
        Kees Cook <keescook@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 26, 2019 at 11:10 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 7/26/19 2:02 PM, Sedat Dilek wrote:
> > On Fri, Jul 26, 2019 at 10:38 PM Sedat Dilek <sedat.dilek@gmail.com> wrote:
> >>
> >> Hi Yonghong Song,
> >>
> >> On Fri, Jul 26, 2019 at 5:45 PM Yonghong Song <yhs@fb.com> wrote:
> >>>
> >>>
> >>>
> >>> On 7/26/19 1:26 AM, Sedat Dilek wrote:
> >>>> Hi,
> >>>>
> >>>> I have opened a new issue in the ClangBuiltLinux issue tracker.
> >>>
> >>> Glad to know clang 9 has asm goto support and now It can compile
> >>> kernel again.
> >>>
> >>
> >> Yupp.
> >>
> >>>>
> >>>> I am seeing a problem in the area bpf/seccomp causing
> >>>> systemd/journald/udevd services to fail.
> >>>>
> >>>> [Fri Jul 26 08:08:43 2019] systemd[453]: systemd-udevd.service: Failed
> >>>> to connect stdout to the journal socket, ignoring: Connection refused
> >>>>
> >>>> This happens when I use the (LLVM) LLD ld.lld-9 linker but not with
> >>>> BFD linker ld.bfd on Debian/buster AMD64.
> >>>> In both cases I use clang-9 (prerelease).
> >>>
> >>> Looks like it is a lld bug.
> >>>
> >>> I see the stack trace has __bpf_prog_run32() which is used by
> >>> kernel bpf interpreter. Could you try to enable bpf jit
> >>>     sysctl net.core.bpf_jit_enable = 1
> >>> If this passed, it will prove it is interpreter related.
> >>>
> >>
> >> After...
> >>
> >> sysctl -w net.core.bpf_jit_enable=1
> >>
> >> I can start all failed systemd services.
> >>
> >> systemd-journald.service
> >> systemd-udevd.service
> >> haveged.service
> >>
> >> This is in maintenance mode.
> >>
> >> What is next: Do set a permanent sysctl setting for net.core.bpf_jit_enable?
> >>
> >
> > This is what I did:
>
> I probably won't have cycles to debug this potential lld issue.
> Maybe you already did, I suggest you put enough reproducible
> details in the bug you filed against lld so they can take a look.
>

I understand and will put the journalctl-log into the CBL issue
tracker and update informations.

Thanks for your help understanding the BPF correlations.

Is setting 'net.core.bpf_jit_enable = 2' helpful here?

Values :
0 - disable the JIT (default value)
1 - enable the JIT
2 - enable the JIT and ask the compiler to emit traces on kernel log.

Which files should LLD folks look at?

cd linux
 find ./ -name '*bpf*.o' | grep jit
./arch/x86/net/bpf_jit_comp.o

Compare the objdumps?

I have archived the full build-dirs of clang9+ld.bfd and clang9+ld.lld-9.

Thanks for your help!

- sed@ -

[1] https://sysctl-explorer.net/net/core/bpf_jit_enable/

> >
> > Jul 26 22:43:06 iniza kernel: BUG: unable to handle page fault for
> > address: ffffffffa8203370
> > Jul 26 22:43:06 iniza kernel: #PF: supervisor read access in kernel mode
> > Jul 26 22:43:06 iniza kernel: #PF: error_code(0x0000) - not-present page
> > Jul 26 22:43:06 iniza kernel: PGD 2cfa0e067 P4D 2cfa0e067 PUD
> > 2cfa0f063 PMD 450829063 PTE 800ffffd30bfc062
> > Jul 26 22:43:06 iniza kernel: Oops: 0000 [#3] SMP PTI
> > Jul 26 22:43:06 iniza kernel: CPU: 3 PID: 436 Comm: systemd-udevd
> > Tainted: G      D           5.3.0-rc1-7-amd64-cbl-asmgoto
> > #7~buster+dileks1
> > Jul 26 22:43:06 iniza kernel: Hardware name: LENOVO
> > 20HDCTO1WW/20HDCTO1WW, BIOS N1QET83W (1.58 ) 04/18/2019
> > Jul 26 22:43:06 iniza kernel: RIP: 0010:___bpf_prog_run+0x40/0x14f0
> > Jul 26 22:43:06 iniza kernel: Code: f3 eb 24 48 83 f8 38 0f 84 a9 0c
> > 00 00 48 83 f8 39 0f 85 8a 14 00 00 0f 1f 00 48 0f bf 43 02 48 8d 1c
> > c3 48 83 c3 08 0f b6
> >   33 <48> 8b 04 f5 10 2e 20 a8 48 83 f8 3b 7f 62 48 83 f8 1e 0f 8f c8 00
> > Jul 26 22:43:06 iniza kernel: RSP: 0018:ffffb3cec0327a88 EFLAGS: 00010246
> > Jul 26 22:43:06 iniza kernel: RAX: ffffb3cec0327b30 RBX:
> > ffffb3cec00d1038 RCX: 0000000000000000
> > Jul 26 22:43:06 iniza kernel: RDX: ffffb3cec0327b10 RSI:
> > 00000000000000ac RDI: ffffb3cec0327ab0
> > Jul 26 22:43:06 iniza kernel: RBP: ffffb3cec0327aa0 R08:
> > ffff9b33c94c0a00 R09: 0000000000000000
> > Jul 26 22:43:06 iniza kernel: R10: ffff9b33cfe14e00 R11:
> > ffffffffa77b8210 R12: 0000000000000000
> > Jul 26 22:43:06 iniza kernel: R13: ffffb3cec00d1000 R14:
> > 0000000000000000 R15: ffffb3cec0327ab0
> > Jul 26 22:43:06 iniza kernel: FS:  00007f7ac2d28d40(0000)
> > GS:ffff9b33d2580000(0000) knlGS:0000000000000000
> > Jul 26 22:43:06 iniza kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > Jul 26 22:43:06 iniza kernel: CR2: ffffffffa8203370 CR3:
> > 000000044f3ea006 CR4: 00000000003606e0
> > Jul 26 22:43:06 iniza kernel: Call Trace:
> > Jul 26 22:43:06 iniza kernel:  __bpf_prog_run32+0x44/0x70
> > Jul 26 22:43:06 iniza kernel:  ? security_sock_rcv_skb+0x3f/0x60
> > Jul 26 22:43:06 iniza kernel:  sk_filter_trim_cap+0xe4/0x220
> > Jul 26 22:43:06 iniza kernel:  ? __skb_clone+0x2e/0x100
> > Jul 26 22:43:06 iniza kernel:  netlink_broadcast_filtered+0x2df/0x4f0
> > Jul 26 22:43:06 iniza kernel:  netlink_sendmsg+0x34f/0x3c0
> > Jul 26 22:43:06 iniza kernel:  ___sys_sendmsg+0x315/0x330
> > Jul 26 22:43:06 iniza kernel:  ? seccomp_run_filters+0x54/0x110
> > Jul 26 22:43:06 iniza kernel:  ? filename_parentat+0x210/0x490
> > Jul 26 22:43:06 iniza kernel:  ? __seccomp_filter+0xf7/0x6e0
> > Jul 26 22:43:06 iniza kernel:  ? __d_alloc+0x159/0x1c0
> > Jul 26 22:43:06 iniza kernel:  ? kmem_cache_free+0x1e/0x5c0
> > Jul 26 22:43:06 iniza kernel:  ? fast_dput+0x73/0xb0
> > Jul 26 22:43:06 iniza kernel:  __x64_sys_sendmsg+0x97/0xe0
> > Jul 26 22:43:06 iniza kernel:  do_syscall_64+0x59/0x90
> > Jul 26 22:43:06 iniza kernel:  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > Jul 26 22:43:06 iniza kernel: RIP: 0033:0x7f7ac3519914
> > Jul 26 22:43:06 iniza kernel: Code: 00 f7 d8 64 89 02 48 c7 c0 ff ff
> > ff ff eb b5 0f 1f 80 00 00 00 00 48 8d 05 e9 5d 0c 00 8b 00 85 c0 75
> > 13 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 54 c3 0f 1f 00 41 54 41
> > 89 d4 55 48 89 f5 53
> > Jul 26 22:43:06 iniza kernel: RSP: 002b:00007ffcfb66a478 EFLAGS:
> > 00000246 ORIG_RAX: 000000000000002e
> > Jul 26 22:43:06 iniza kernel: RAX: ffffffffffffffda RBX:
> > 0000561e28ac9390 RCX: 00007f7ac3519914
> > Jul 26 22:43:06 iniza kernel: RDX: 0000000000000000 RSI:
> > 00007ffcfb66a4a0 RDI: 000000000000000d
> > Jul 26 22:43:06 iniza kernel: RBP: 0000561e28acd210 R08:
> > 0000561e28990140 R09: 0000000000000002
> > Jul 26 22:43:06 iniza kernel: R10: 0000000000000000 R11:
> > 0000000000000246 R12: 0000000000000000
> > Jul 26 22:43:06 iniza kernel: R13: 0000000000000000 R14:
> > 000000000000005e R15: 00007ffcfb66a490
> > Jul 26 22:43:06 iniza kernel: Modules linked in: nfsd auth_rpcgss
> > nfs_acl lockd grace i2c_dev parport_pc ppdev lp parport sunrpc
> > efivarfs ip_tables x_tables autofs4 ext4 crc32c_generic mbcache crc16
> > jbd2 btrfs zstd_decompress zstd_compress algif_skcipher af_alg sd_mod
> > uas usb_storage scsi_mod hid_generic usbhid hid dm_crypt dm_mod raid10
> > raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor
> > raid6_pq libcrc32c raid1 raid0 multipath linear md_mod
> > crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel
> > aesni_intel i915 intel_lpss_pci nvme aes_x86_64 glue_helper
> > i2c_algo_bit crypto_simd cryptd xhci_pci psmouse e1000e drm_kms_helper
> > xhci_hcd i2c_i801 nvme_core intel_lpss drm usbcore thermal wmi video
> > button
> > Jul 26 22:43:06 iniza kernel: CR2: ffffffffa8203370
> > Jul 26 22:43:06 iniza kernel: ---[ end trace 312670b063bd0391 ]---
> > Jul 26 22:43:06 iniza kernel: RIP: 0010:___bpf_prog_run+0x40/0x14f0
> > Jul 26 22:43:06 iniza kernel: Code: f3 eb 24 48 83 f8 38 0f 84 a9 0c
> > 00 00 48 83 f8 39 0f 85 8a 14 00 00 0f 1f 00 48 0f bf 43 02 48 8d 1c
> > c3 48 83 c3 08 0f b6 33 <48> 8b 04 f5 10 2e 20 a8 48 83 f8 3b 7f 62 48
> > 83 f8 1e 0f 8f c8 00
> > Jul 26 22:43:06 iniza kernel: RSP: 0018:ffffb3cec0253cb8 EFLAGS: 00010246
> > Jul 26 22:43:06 iniza kernel: RAX: ffffb3cec0253d60 RBX:
> > ffffb3cec00e9038 RCX: 0000000000000002
> > Jul 26 22:43:06 iniza kernel: RDX: ffffb3cec0253d40 RSI:
> > 00000000000000ac RDI: ffffb3cec0253ce0
> > Jul 26 22:43:06 iniza kernel: RBP: ffffb3cec0253cd0 R08:
> > 0000000000000000 R09: ffffb3cec0253f58
> > Jul 26 22:43:06 iniza kernel: R10: 0000000000000000 R11:
> > ffffffffa77b8210 R12: 000000007fff0000
> > Jul 26 22:43:06 iniza kernel: R13: ffffb3cec0253eb8 R14:
> > 0000000000000000 R15: ffffb3cec0253ce0
> > Jul 26 22:43:06 iniza kernel: FS:  00007f7ac2d28d40(0000)
> > GS:ffff9b33d2580000(0000) knlGS:0000000000000000
> > Jul 26 22:43:06 iniza kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > Jul 26 22:43:06 iniza kernel: CR2: ffffffffa8203370 CR3:
> > 000000044f3ea006 CR4: 00000000003606e0
> > Jul 26 22:43:06 iniza kernel: BUG: unable to handle page fault for
> > address: ffffffffa8203370
> > Jul 26 22:43:06 iniza kernel: #PF: supervisor read access in kernel mode
> > Jul 26 22:43:06 iniza kernel: #PF: error_code(0x0000) - not-present page
> > Jul 26 22:43:06 iniza kernel: PGD 2cfa0e067 P4D 2cfa0e067 PUD
> > 2cfa0f063 PMD 450829063 PTE 800ffffd30bfc062
> > Jul 26 22:43:06 iniza kernel: Oops: 0000 [#4] SMP PTI
> > Jul 26 22:43:06 iniza kernel: CPU: 0 PID: 437 Comm: systemd-udevd
> > Tainted: G      D           5.3.0-rc1-7-amd64-cbl-asmgoto
> > #7~buster+dileks1
> > Jul 26 22:43:06 iniza kernel: Hardware name: LENOVO
> > 20HDCTO1WW/20HDCTO1WW, BIOS N1QET83W (1.58 ) 04/18/2019
> > Jul 26 22:43:06 iniza kernel: RIP: 0010:___bpf_prog_run+0x40/0x14f0
> > Jul 26 22:43:06 iniza kernel: Code: f3 eb 24 48 83 f8 38 0f 84 a9 0c
> > 00 00 48 83 f8 39 0f 85 8a 14 00 00 0f 1f 00 48 0f bf 43 02 48 8d 1c
> > c3 48 83 c3 08 0f b6 33 <48> 8b 04 f5 10 2e 20 a8 48 83 f8 3b 7f 62 48
> > 83 f8 1e 0f 8f c8 00
> > Jul 26 22:43:06 iniza kernel: RSP: 0018:ffffb3cec032fa88 EFLAGS: 00010246
> > Jul 26 22:43:06 iniza kernel: RAX: ffffb3cec032fb30 RBX:
> > ffffb3cec00d1038 RCX: 0000000000000000
> > Jul 26 22:43:06 iniza kernel: RDX: ffffb3cec032fb10 RSI:
> > 00000000000000ac RDI: ffffb3cec032fab0
> > Jul 26 22:43:06 iniza kernel: RBP: ffffb3cec032faa0 R08:
> > ffff9b33cf34b000 R09: 0000000000000000
> > Jul 26 22:43:06 iniza kernel: R10: ffff9b33cf3a3400 R11:
> > ffffffffa77b8210 R12: 0000000000000000
> > Jul 26 22:43:06 iniza kernel: R13: ffffb3cec00d1000 R14:
> > 0000000000000000 R15: ffffb3cec032fab0
> > Jul 26 22:43:06 iniza kernel: FS:  00007f7ac2d28d40(0000)
> > GS:ffff9b33d2400000(0000) knlGS:0000000000000000
> > Jul 26 22:43:06 iniza kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > Jul 26 22:43:06 iniza kernel: CR2: ffffffffa8203370 CR3:
> > 000000044724a001 CR4: 00000000003606f0
> > Jul 26 22:43:06 iniza kernel: Call Trace:
> > Jul 26 22:43:06 iniza kernel:  __bpf_prog_run32+0x44/0x70
> > Jul 26 22:43:06 iniza kernel:  ? prep_new_page+0x47/0x1a0
> > Jul 26 22:43:06 iniza kernel:  ? security_sock_rcv_skb+0x3f/0x60
> > Jul 26 22:43:06 iniza kernel:  sk_filter_trim_cap+0xe4/0x220
> > Jul 26 22:43:06 iniza kernel:  ? __skb_clone+0x2e/0x100
> > Jul 26 22:43:06 iniza kernel:  netlink_broadcast_filtered+0x2df/0x4f0
> > Jul 26 22:43:06 iniza kernel:  netlink_sendmsg+0x34f/0x3c0
> > Jul 26 22:43:06 iniza kernel:  ___sys_sendmsg+0x315/0x330
> > Jul 26 22:43:06 iniza kernel:  ? seccomp_run_filters+0x54/0x110
> > Jul 26 22:43:06 iniza kernel:  ? filename_parentat+0x210/0x490
> > Jul 26 22:43:06 iniza kernel:  ? __seccomp_filter+0xf7/0x6e0
> > Jul 26 22:43:06 iniza kernel:  ? __d_alloc+0x159/0x1c0
> > Jul 26 22:43:06 iniza kernel:  ? kmem_cache_free+0x1e/0x5c0
> > Jul 26 22:43:06 iniza kernel:  ? fast_dput+0x73/0xb0
> > Jul 26 22:43:06 iniza kernel:  __x64_sys_sendmsg+0x97/0xe0
> > Jul 26 22:43:06 iniza kernel:  do_syscall_64+0x59/0x90
> > Jul 26 22:43:06 iniza kernel:  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > Jul 26 22:43:06 iniza kernel: RIP: 0033:0x7f7ac3519914
> > Jul 26 22:43:06 iniza kernel: Code: 00 f7 d8 64 89 02 48 c7 c0 ff ff
> > ff ff eb b5 0f 1f 80 00 00 00 00 48 8d 05 e9 5d 0c 00 8b 00 85 c0 75
> > 13 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 54 c3 0f 1f 00 41 54 41
> > 89 d4 55 48 89 f5 53
> > Jul 26 22:43:06 iniza kernel: RSP: 002b:00007ffcfb66a478 EFLAGS:
> > 00000246 ORIG_RAX: 000000000000002e
> > Jul 26 22:43:06 iniza kernel: RAX: ffffffffffffffda RBX:
> > 0000561e28aaa600 RCX: 00007f7ac3519914
> > Jul 26 22:43:06 iniza kernel: RDX: 0000000000000000 RSI:
> > 00007ffcfb66a4a0 RDI: 000000000000000e
> > Jul 26 22:43:06 iniza kernel: RBP: 0000561e28aaaac0 R08:
> > 0000561e28990140 R09: 0000000000000002
> > Jul 26 22:43:06 iniza kernel: R10: 0000000000000000 R11:
> > 0000000000000246 R12: 0000000000000000
> > Jul 26 22:43:06 iniza kernel: R13: 0000000000000000 R14:
> > 000000000000005d R15: 00007ffcfb66a490
> > Jul 26 22:43:06 iniza kernel: Modules linked in: nfsd auth_rpcgss
> > nfs_acl lockd grace i2c_dev parport_pc ppdev lp parport sunrpc
> > efivarfs ip_tables x_tables autofs4 ext4 crc32c_generic mbcache crc16
> > jbd2 btrfs zstd_decompress zstd_compress algif_skcipher af_alg sd_mod
> > uas usb_storage scsi_mod hid_generic usbhid hid dm_crypt dm_mod raid10
> > raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor
> > raid6_pq libcrc32c raid1 raid0 multipath linear md_mod
> > crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel
> > aesni_intel i915 intel_lpss_pci nvme aes_x86_64 glue_helper
> > i2c_algo_bit crypto_simd cryptd xhci_pci psmouse e1000e drm_kms_helper
> > xhci_hcd i2c_i801 nvme_core intel_lpss drm usbcore thermal wmi video
> > button
> > Jul 26 22:43:06 iniza kernel: CR2: ffffffffa8203370
> > Jul 26 22:43:06 iniza kernel: ---[ end trace 312670b063bd0392 ]---
> >
> > Full `journalctl -xb` attached.
> >
> > - Sedat -
> >
