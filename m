Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBE1772E6
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 22:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbfGZUic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 16:38:32 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46854 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727512AbfGZUib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 16:38:31 -0400
Received: by mail-wr1-f65.google.com with SMTP id z1so55636954wru.13;
        Fri, 26 Jul 2019 13:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=yjm9C+iCFzUgwfxxisADStycLzUMqh94ZfjnwoRc6og=;
        b=o4F12wjKoKJ4ZHrwF8YfYFFa0Qn2IBq3qaQDupPAj/iPxKuEBIylRiZXNsqCSBaM0P
         BOrLo8CJ8mYWyetElTTCosEU9cBc9zqnxhc9l4yrs025HBU4k6jii1SXMIVvcYEvqjm/
         JNAxw9R8SF3zL/ej2/ZvdcWKpkLnrfeOdkBTvEy5wn/s8MUemyr5g1GCdEb0VL4DsvNT
         r214fydhEHK84/WrZT0T7FmUcgg61P1IlAZk+Yr5PHUFxCWFH6zFdOXl7vnCb74DwSDu
         6B5vQWLIjIh/v+/3jFJ5zAmArIzNUxhkLwcA0QScBV7H9qxLiURaymJVgop3HfYsmkQN
         tJXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=yjm9C+iCFzUgwfxxisADStycLzUMqh94ZfjnwoRc6og=;
        b=ZxmQs6fIEj/vy8oZtFYpkKKjzE7y898zDNGscpOfS3lzijduUuC0n57zwr0/4ozcTu
         J3vM4wvuWLjD335EmOdiZlA6wGFfC9YUTST6rKjAegZZlVjENteFGhUWiDJ2mBKk21JO
         Dw5dzbWuyxPpYF2VoS6kNrjc9V/M6/bENEgPEAF0+syXHmPcwqKWRy9pq4CuRylKP+1s
         xIlJsU78FYFwftsAR8G90K9OfUHBuGLVSQfoP/EvGPiqj+w6v+08kW/lBK1ObntStbN8
         63l+g3J9J6PHStVsXa7kckBi2QJV+icNm6ftkmTshSDgLv1fxOU8cQLwPwxm4ZcKG9wm
         2qBg==
X-Gm-Message-State: APjAAAXjkbSDLyx9uU/b0LDdqWd2iHLZEU06h5ca6PiGdqqMsCgZXe/z
        qg72JfTm2qC1/tz2UDi0r1hbt4I9uSnLLan17/Q=
X-Google-Smtp-Source: APXvYqyKp2x20XYWI8SJf8J8POKcs0ndLwh4brrBeQVc7Zk81M8RxAUCUCat3tlpPV+8rOiP6QHk/SdMBSKbNZGqq6k=
X-Received: by 2002:a5d:498f:: with SMTP id r15mr97329873wrq.353.1564173508439;
 Fri, 26 Jul 2019 13:38:28 -0700 (PDT)
MIME-Version: 1.0
References: <CA+icZUWF=B_phP8eGD3v2d9jSSK6Y-N65y-T6xewZnY91vc2_Q@mail.gmail.com>
 <c2524c96-d71c-d7db-22ec-12da905dc180@fb.com>
In-Reply-To: <c2524c96-d71c-d7db-22ec-12da905dc180@fb.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Fri, 26 Jul 2019 22:38:16 +0200
Message-ID: <CA+icZUXYp=Jx+8aGrZmkCbSFp-cSPcoRzRdRJsPj4yYNs_mJQw@mail.gmail.com>
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

Hi Yonghong Song,

On Fri, Jul 26, 2019 at 5:45 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 7/26/19 1:26 AM, Sedat Dilek wrote:
> > Hi,
> >
> > I have opened a new issue in the ClangBuiltLinux issue tracker.
>
> Glad to know clang 9 has asm goto support and now It can compile
> kernel again.
>

Yupp.

> >
> > I am seeing a problem in the area bpf/seccomp causing
> > systemd/journald/udevd services to fail.
> >
> > [Fri Jul 26 08:08:43 2019] systemd[453]: systemd-udevd.service: Failed
> > to connect stdout to the journal socket, ignoring: Connection refused
> >
> > This happens when I use the (LLVM) LLD ld.lld-9 linker but not with
> > BFD linker ld.bfd on Debian/buster AMD64.
> > In both cases I use clang-9 (prerelease).
>
> Looks like it is a lld bug.
>
> I see the stack trace has __bpf_prog_run32() which is used by
> kernel bpf interpreter. Could you try to enable bpf jit
>    sysctl net.core.bpf_jit_enable = 1
> If this passed, it will prove it is interpreter related.
>

After...

sysctl -w net.core.bpf_jit_enable=1

I can start all failed systemd services.

systemd-journald.service
systemd-udevd.service
haveged.service

This is in maintenance mode.

What is next: Do set a permanent sysctl setting for net.core.bpf_jit_enable?

Regards,
- Sedat -

> >
> > Base for testing: next-20190723.
> >
> > The call-trace looks like this:
> >
> > [Fri Jul 26 08:08:42 2019] BUG: unable to handle page fault for
> > address: ffffffff85403370
> > [Fri Jul 26 08:08:42 2019] #PF: supervisor read access in kernel mode
> > [Fri Jul 26 08:08:42 2019] #PF: error_code(0x0000) - not-present page
> > [Fri Jul 26 08:08:42 2019] PGD 7620e067 P4D 7620e067 PUD 7620f063 PMD
> > 44fe85063 PTE 800fffff8a3fc062
> > [Fri Jul 26 08:08:42 2019] Oops: 0000 [#1] SMP PTI
> > [Fri Jul 26 08:08:42 2019] CPU: 2 PID: 417 Comm: (journald) Not
> > tainted 5.3.0-rc1-5-amd64-cbl-asmgoto #5~buster+dileks1
> > [Fri Jul 26 08:08:42 2019] Hardware name: LENOVO
> > 20HDCTO1WW/20HDCTO1WW, BIOS N1QET83W (1.58 ) 04/18/2019
> > [Fri Jul 26 08:08:42 2019] RIP: 0010:___bpf_prog_run+0x40/0x14f0
> > [Fri Jul 26 08:08:42 2019] Code: f3 eb 24 48 83 f8 38 0f 84 a9 0c 00
> > 00 48 83 f8 39 0f 85 8a 14 00 00 0f 1f 00 48 0f bf 43 02 48 8d 1c c3
> > 48 83 c3 08 0f b6 33 <48> 8b 04 f5 10 2e 40 85 48 83 f8 3b 7f 62 48 83
> > f8 1e 0f 8f c8 00
> > [Fri Jul 26 08:08:42 2019] RSP: 0018:ffff992ec028fcb8 EFLAGS: 00010246
> > [Fri Jul 26 08:08:42 2019] RAX: ffff992ec028fd60 RBX: ffff992ec00e9038
> > RCX: 0000000000000002
> > [Fri Jul 26 08:08:42 2019] RDX: ffff992ec028fd40 RSI: 00000000000000ac
> > RDI: ffff992ec028fce0
> > [Fri Jul 26 08:08:42 2019] RBP: ffff992ec028fcd0 R08: 0000000000000000
> > R09: ffff992ec028ff58
> > [Fri Jul 26 08:08:42 2019] R10: 0000000000000000 R11: ffffffff849b8210
> > R12: 000000007fff0000
> > [Fri Jul 26 08:08:42 2019] R13: ffff992ec028feb8 R14: 0000000000000000
> > R15: ffff992ec028fce0
> > [Fri Jul 26 08:08:42 2019] FS:  00007f5d20f1d940(0000)
> > GS:ffff8ba3d2500000(0000) knlGS:0000000000000000
> > [Fri Jul 26 08:08:42 2019] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [Fri Jul 26 08:08:42 2019] CR2: ffffffff85403370 CR3: 0000000445b3e001
> > CR4: 00000000003606e0
> > [Fri Jul 26 08:08:42 2019] Call Trace:
> > [Fri Jul 26 08:08:42 2019]  __bpf_prog_run32+0x44/0x70
> > [Fri Jul 26 08:08:42 2019]  ? flush_tlb_func_common+0xd8/0x230
> > [Fri Jul 26 08:08:42 2019]  ? mem_cgroup_commit_charge+0x8c/0x120
> > [Fri Jul 26 08:08:42 2019]  ? wp_page_copy+0x464/0x7a0
> > [Fri Jul 26 08:08:42 2019]  seccomp_run_filters+0x54/0x110
> > [Fri Jul 26 08:08:42 2019]  __seccomp_filter+0xf7/0x6e0
> > [Fri Jul 26 08:08:42 2019]  ? do_wp_page+0x32b/0x5d0
> > [Fri Jul 26 08:08:42 2019]  ? handle_mm_fault+0x90d/0xbf0
> > [Fri Jul 26 08:08:42 2019]  syscall_trace_enter+0x182/0x290
> > [Fri Jul 26 08:08:42 2019]  do_syscall_64+0x30/0x90
> > [Fri Jul 26 08:08:42 2019]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > [Fri Jul 26 08:08:42 2019] RIP: 0033:0x7f5d220d7f59
> > [Fri Jul 26 08:08:42 2019] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00
> > 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8
> > 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 07 6f 0c 00
> > f7 d8 64 89 01 48
> > [Fri Jul 26 08:08:42 2019] RSP: 002b:00007ffd11332b48 EFLAGS: 00000246
> > ORIG_RAX: 000000000000013d
> > [Fri Jul 26 08:08:42 2019] RAX: ffffffffffffffda RBX: 000055bf8ab34010
> > RCX: 00007f5d220d7f59
> > [Fri Jul 26 08:08:42 2019] RDX: 000055bf8ab34010 RSI: 0000000000000000
> > RDI: 0000000000000001
> > [Fri Jul 26 08:08:42 2019] RBP: 000055bf8ab97fb0 R08: 000055bf8abbe180
> > R09: 00000000c000003e
> > [Fri Jul 26 08:08:42 2019] R10: 000055bf8abbe1e0 R11: 0000000000000246
> > R12: 00007ffd11332ba0
> > [Fri Jul 26 08:08:42 2019] R13: 00007ffd11332b98 R14: 00007f5d21f087f8
> > R15: 000000000000002c
> > [Fri Jul 26 08:08:42 2019] Modules linked in: i2c_dev parport_pc
> > sunrpc ppdev lp parport efivarfs ip_tables x_tables autofs4 ext4
> > crc32c_generic mbcache crc16 jbd2 btrfs zstd_decompress zstd_compress
> > algif_skcipher af_alg sd_mod dm_crypt dm_mod raid10 raid456
> > async_raid6_recov async_memcpy async_pq async_xor async_tx xor
> > raid6_pq libcrc32c raid1 uas raid0 usb_storage multipath linear
> > scsi_mod md_mod hid_cherry hid_generic usbhid hid crct10dif_pclmul
> > crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64
> > i915 glue_helper crypto_simd nvme i2c_algo_bit cryptd psmouse xhci_pci
> > drm_kms_helper e1000e i2c_i801 xhci_hcd intel_lpss_pci nvme_core
> > intel_lpss drm usbcore thermal wmi video button
> > [Fri Jul 26 08:08:42 2019] CR2: ffffffff85403370
> > [Fri Jul 26 08:08:42 2019] ---[ end trace 867b35c7d6c6705a ]---
> > [Fri Jul 26 08:08:42 2019] RIP: 0010:___bpf_prog_run+0x40/0x14f0
> > [Fri Jul 26 08:08:42 2019] Code: f3 eb 24 48 83 f8 38 0f 84 a9 0c 00
> > 00 48 83 f8 39 0f 85 8a 14 00 00 0f 1f 00 48 0f bf 43 02 48 8d 1c c3
> > 48 83 c3 08 0f b6 33 <48> 8b 04 f5 10 2e 40 85 48 83 f8 3b 7f 62 48 83
> > f8 1e 0f 8f c8 00
> > [Fri Jul 26 08:08:42 2019] RSP: 0018:ffff992ec028fcb8 EFLAGS: 00010246
> > [Fri Jul 26 08:08:42 2019] RAX: ffff992ec028fd60 RBX: ffff992ec00e9038
> > RCX: 0000000000000002
> > [Fri Jul 26 08:08:42 2019] RDX: ffff992ec028fd40 RSI: 00000000000000ac
> > RDI: ffff992ec028fce0
> > [Fri Jul 26 08:08:42 2019] RBP: ffff992ec028fcd0 R08: 0000000000000000
> > R09: ffff992ec028ff58
> > [Fri Jul 26 08:08:42 2019] R10: 0000000000000000 R11: ffffffff849b8210
> > R12: 000000007fff0000
> > [Fri Jul 26 08:08:42 2019] R13: ffff992ec028feb8 R14: 0000000000000000
> > R15: ffff992ec028fce0
> > [Fri Jul 26 08:08:42 2019] FS:  00007f5d20f1d940(0000)
> > GS:ffff8ba3d2500000(0000) knlGS:0000000000000000
> > [Fri Jul 26 08:08:42 2019] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [Fri Jul 26 08:08:42 2019] CR2: ffffffff85403370 CR3: 0000000445b3e001
> > CR4: 00000000003606e0
> >
> > More details in [1] and what I tried (for example CONFIG_SECCOMP=n)
> >
> > I have no clue about BPF or SECCOMP.
> >
> > Can you comment on this?
> >
> > If this touches BPF: Can you give me some hints and instructions in debugging?
> >
> > My kernel-config and dmesg-log are attached.
> >
> > Thanks.
> >
> > Regards,
> > - Sedat -
> >
> > [1] https://github.com/ClangBuiltLinux/linux/issues/619
> >
