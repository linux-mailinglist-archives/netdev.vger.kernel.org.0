Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C779B578CC0
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 23:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234007AbiGRVbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 17:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235082AbiGRVbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 17:31:23 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B433431DF8;
        Mon, 18 Jul 2022 14:31:21 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id bp15so23719303ejb.6;
        Mon, 18 Jul 2022 14:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bSM5ivYjQeEP8TfF7U5MwOVE0teXxd2IvF5WPp8/KBc=;
        b=gBKdHn8otcrOaqcMOQNE0eKSTu5eRkOi4I8ZMtloFBpcwoqx+4W0YgLGu+jZF/EgVM
         lVrTmFqm3C2Fuclno1XZZQ9R43fnk5oR7Rig+FeJQB5Yw8lc/J5SY5YZnv3KGaY4qvDT
         ow4JjFvaPzk4MmoofaX7/8n8+SQnT4/7mc6ABLCgh6Y8xsj3yBeKe/woF/sVrXAx2hJ6
         GTto1VFja7nl+CdGM967AUn9zTwM7hCtOFADL7h4wyqLIeoYkskt+SKVNJQ21UPIHLOY
         jS5QxXIH4+vDuRX17T8StJjsZhd7vir7tgKI/lItwI/wASh9SgZZJqTdhdwE5+z/1XDB
         eUzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bSM5ivYjQeEP8TfF7U5MwOVE0teXxd2IvF5WPp8/KBc=;
        b=sdwG02oXrwhMBK3AHKKlLqpjnyplEso+IVWWzCg59KkDZRAFB7fCXrlfw3SruN0VZX
         FPCpFZHyDNEmzT2xnxmHIlkvlTKiR0FKWau3v3skv6PORpkx6phNWPUsQfOH+zhelg9f
         4bpXSgoPxOkqqhs/jfzhyWplcTMFKA58evgZYgfyoBpD6DaMgm+tikO9ucUcuV3Ddx31
         +5qTLVQdqQiw2m568Oz0jNZL4bpntMlfckT7YDNAodZAalNtIHeuANp/xlCc9KCppkm9
         E0olEYCLQwyhhidHuFePyrifHWz79DPSIe3J43LfZJlnJl2lzoaftmOeXulnMjmLegg6
         XxBQ==
X-Gm-Message-State: AJIora+/mGp57Tbwd3LGn7KiUzf2R7MdvmlNeBvbeDccx9ixm+e9irWX
        ufdu/c4jFFMhVo4w0fE1Lbj2venCvOVnhhPGNBs=
X-Google-Smtp-Source: AGRyM1v95rKJTJeASt2uwuv/96bNjRzHCdLQO61Ht3D1x7i6W4zfHdp728CQ7ePIw5Cde8mm1A90Q/MHpM4dKb0sQKM=
X-Received: by 2002:a17:907:608f:b0:72b:7db9:4dc6 with SMTP id
 ht15-20020a170907608f00b0072b7db94dc6mr26848162ejc.463.1658179880155; Mon, 18
 Jul 2022 14:31:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220712235310.1935121-2-joannelkoong@gmail.com> <YtLJMxChUupbAa+U@xsang-OptiPlex-9020>
In-Reply-To: <YtLJMxChUupbAa+U@xsang-OptiPlex-9020>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Mon, 18 Jul 2022 14:31:09 -0700
Message-ID: <CAJnrk1Z0f1z-Mk10othmauAyaF_LD+MxcwVrtD_2=Z_bOHgecQ@mail.gmail.com>
Subject: Re: [net] 2e20fc25bc: BUG:kernel_NULL_pointer_dereference,address
To:     kernel test robot <oliver.sang@intel.com>
Cc:     0day robot <lkp@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, dccp@vger.kernel.org,
        lkp@lists.01.org, Eric Dumazet <edumazet@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 16, 2022 at 7:20 AM kernel test robot <oliver.sang@intel.com> wrote:
>
>
>
> Greeting,
>
> FYI, we noticed the following commit (built with gcc-11):
>
> commit: 2e20fc25bca52fbc786bbae312df56514c10798d ("[PATCH net-next v2 1/3] net: Add a bhash2 table hashed by port + address")
> url: https://github.com/intel-lab-lkp/linux/commits/Joanne-Koong/Add-a-second-bind-table-hashed-by-port-address/20220713-075808
> base: https://git.kernel.org/cgit/linux/kernel/git/davem/net-next.git 5022e221c98a609e0e5b0a73852c7e3d32f1c545
> patch link: https://lore.kernel.org/netdev/20220712235310.1935121-2-joannelkoong@gmail.com
>
> in testcase: boot
>
> on test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G
>
> caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):
>
>
> +-------------------------------------------------------+------------+------------+
> |                                                       | 5022e221c9 | 2e20fc25bc |
> +-------------------------------------------------------+------------+------------+
> | boot_successes                                        | 8          | 0          |
> | boot_failures                                         | 0          | 12         |
> | BUG:kernel_NULL_pointer_dereference,address           | 0          | 12         |
> | Oops:#[##]                                            | 0          | 12         |
> | RIP:inet_bhash2_update_saddr                          | 0          | 12         |
> | Kernel_panic-not_syncing:Fatal_exception_in_interrupt | 0          | 12         |
> +-------------------------------------------------------+------------+------------+
>
>
> If you fix the issue, kindly add following tag
> Reported-by: kernel test robot <oliver.sang@intel.com>
>
I will fix this issue in the next iteration of the patch (if the
previous address was never added to the bhash2 table, then we don't
need to compute the hash for it and remove it from the table). Thanks
for reporting.
>
> [  247.022450][  T328] BUG: kernel NULL pointer dereference, address: 0000000000000000
> [  247.024448][  T328] #PF: supervisor write access in kernel mode
> [  247.026159][  T328] #PF: error_code(0x0002) - not-present page
> [  247.027743][  T328] PGD 800000014b28a067 P4D 800000014b28a067 PUD 14b289067 PMD 0
> [  247.029705][  T328] Oops: 0002 [#1] SMP PTI
> [  247.030900][  T328] CPU: 1 PID: 328 Comm: wget Not tainted 5.19.0-rc5-01130-g2e20fc25bca5 #1
> [  247.033223][  T328] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.0-debian-1.16.0-4 04/01/2014
> [ 247.035984][ T328] RIP: 0010:inet_bhash2_update_saddr (include/linux/list.h:884 include/net/sock.h:824 net/ipv4/inet_hashtables.c:872)
> [ 247.037623][ T328] Code: 48 8d 83 00 03 00 00 4c 8b a3 f8 02 00 00 48 89 c7 48 89 44 24 28 e8 10 79 01 ff 4c 8b ab 00 03 00 00 4c 89 ef e8 f1 87 01 ff <4d> 89 65 00 4d 85 e4 74 14 e8 93 2b ed fe 49 8d 7c 24 08 e8 d9 87
> All code
> ========
>    0:   48 8d 83 00 03 00 00    lea    0x300(%rbx),%rax
>    7:   4c 8b a3 f8 02 00 00    mov    0x2f8(%rbx),%r12
>    e:   48 89 c7                mov    %rax,%rdi
>   11:   48 89 44 24 28          mov    %rax,0x28(%rsp)
>   16:   e8 10 79 01 ff          callq  0xffffffffff01792b
>   1b:   4c 8b ab 00 03 00 00    mov    0x300(%rbx),%r13
>   22:   4c 89 ef                mov    %r13,%rdi
>   25:   e8 f1 87 01 ff          callq  0xffffffffff01881b
>   2a:*  4d 89 65 00             mov    %r12,0x0(%r13)           <-- trapping instruction
>   2e:   4d 85 e4                test   %r12,%r12
>   31:   74 14                   je     0x47
>   33:   e8 93 2b ed fe          callq  0xfffffffffeed2bcb
>   38:   49 8d 7c 24 08          lea    0x8(%r12),%rdi
>   3d:   e8                      .byte 0xe8
>   3e:   d9                      .byte 0xd9
>   3f:   87                      .byte 0x87
>
> Code starting with the faulting instruction
> ===========================================
>    0:   4d 89 65 00             mov    %r12,0x0(%r13)
>    4:   4d 85 e4                test   %r12,%r12
>    7:   74 14                   je     0x1d
>    9:   e8 93 2b ed fe          callq  0xfffffffffeed2ba1
>    e:   49 8d 7c 24 08          lea    0x8(%r12),%rdi
>   13:   e8                      .byte 0xe8
>   14:   d9                      .byte 0xd9
>   15:   87                      .byte 0x87
> [  247.062693][  T328] RSP: 0018:ffffc90000ae7bd8 EFLAGS: 00010246
> [  247.064435][  T328] RAX: ffff88811673c3e0 RBX: ffff8881168e4600 RCX: ffffffff823fb28f
> [  247.066525][  T328] RDX: 0000000000000a28 RSI: 0001ffffffffffff RDI: 0000000000000000
> [  247.068479][  T328] RBP: ffffc90000ae7c60 R08: ffffffff8477ff18 R09: 0000000000000000
> [  247.070484][  T328] R10: 0000000000000005 R11: 0000000000000000 R12: 0000000000000000
> [  247.072457][  T328] R13: 0000000000000000 R14: ffffffff84cefd40 R15: ffffffff84cf29c0
> [  247.074463][  T328] FS:  00007f38cc1a6700(0000) GS:ffff88842fd00000(0000) knlGS:0000000000000000
> [  247.076798][  T328] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  247.080161][  T328] CR2: 0000000000000000 CR3: 0000000116a32000 CR4: 00000000000006e0
> [  247.082224][  T328] Call Trace:
> [  247.083152][  T328]  <TASK>
> [ 247.083906][ T328] ? write_comp_data (kernel/kcov.c:229)
> [ 247.085183][ T328] tcp_v4_connect (net/ipv4/tcp_ipv4.c:261)
> [ 247.086542][ T328] __inet_stream_connect (net/ipv4/af_inet.c:661)
> [ 247.088103][ T328] ? write_comp_data (kernel/kcov.c:229)
> [ 247.089429][ T328] inet_stream_connect (net/ipv4/af_inet.c:725)
> [ 247.090707][ T328] ? __inet_stream_connect (net/ipv4/af_inet.c:720)
> [ 247.092104][ T328] __sys_connect_file (net/socket.c:1976)
> [ 247.093453][ T328] __sys_connect (net/socket.c:1993)
> [ 247.094902][ T328] ? write_comp_data (kernel/kcov.c:229)
> [ 247.096382][ T328] ? __x64_sys_alarm (kernel/time/itimer.c:306)
> [ 247.097825][ T328] __x64_sys_connect (net/socket.c:2000)
> [ 247.115487][ T328] do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
> [ 247.116792][ T328] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:115)
> [  247.118477][  T328] RIP: 0033:0x7f38cb2662e0
> [ 247.119521][ T328] Code: 00 31 d2 48 29 c2 64 89 11 48 83 c8 ff eb ea 90 90 90 90 90 90 90 90 90 90 90 83 3d fd 8e 2c 00 00 75 10 b8 2a 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 fe ce 00 00 48 89 04 24
> All code
> ========
>    0:   00 31                   add    %dh,(%rcx)
>    2:   d2 48 29                rorb   %cl,0x29(%rax)
>    5:   c2 64 89                retq   $0x8964
>    8:   11 48 83                adc    %ecx,-0x7d(%rax)
>    b:   c8 ff eb ea             enterq $0xebff,$0xea
>    f:   90                      nop
>   10:   90                      nop
>   11:   90                      nop
>   12:   90                      nop
>   13:   90                      nop
>   14:   90                      nop
>   15:   90                      nop
>   16:   90                      nop
>   17:   90                      nop
>   18:   90                      nop
>   19:   90                      nop
>   1a:   83 3d fd 8e 2c 00 00    cmpl   $0x0,0x2c8efd(%rip)        # 0x2c8f1e
>   21:   75 10                   jne    0x33
>   23:   b8 2a 00 00 00          mov    $0x2a,%eax
>   28:   0f 05                   syscall
>   2a:*  48 3d 01 f0 ff ff       cmp    $0xfffffffffffff001,%rax         <-- trapping instruction
>   30:   73 31                   jae    0x63
>   32:   c3                      retq
>   33:   48 83 ec 08             sub    $0x8,%rsp
>   37:   e8 fe ce 00 00          callq  0xcf3a
>   3c:   48 89 04 24             mov    %rax,(%rsp)
>
> Code starting with the faulting instruction
> ===========================================
>    0:   48 3d 01 f0 ff ff       cmp    $0xfffffffffffff001,%rax
>    6:   73 31                   jae    0x39
>    8:   c3                      retq
>    9:   48 83 ec 08             sub    $0x8,%rsp
>    d:   e8 fe ce 00 00          callq  0xcf10
>   12:   48 89 04 24             mov    %rax,(%rsp)
> [  247.124379][  T328] RSP: 002b:00007fffffe84038 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
> [  247.126935][  T328] RAX: ffffffffffffffda RBX: 00007fffffe840d0 RCX: 00007f38cb2662e0
> [  247.128978][  T328] RDX: 0000000000000010 RSI: 00007fffffe840f0 RDI: 0000000000000004
> [  247.131142][  T328] RBP: 0000000000000004 R08: 00007fffffe83fa0 R09: 0000000000000001
> [  247.133075][  T328] R10: 00007fffffe83dd0 R11: 0000000000000246 R12: 0000000000000050
> [  247.135155][  T328] R13: 000000000065ade0 R14: 0000000001549a70 R15: 000000000000002a
> [  247.137196][  T328]  </TASK>
> [  247.142192][  T328] Modules linked in: bochs drm_vram_helper drm_ttm_helper ttm drm_kms_helper syscopyarea sysfillrect sysimgblt ppdev fb_sys_fops sr_mod drm joydev i2c_piix4 cdrom parport_pc parport
> [  247.147469][  T328] CR2: 0000000000000000
> [  247.148548][  T328] ---[ end trace 0000000000000000 ]---
> [ 247.186378][ T328] RIP: 0010:inet_bhash2_update_saddr (include/linux/list.h:884 include/net/sock.h:824 net/ipv4/inet_hashtables.c:872)
> [ 247.218516][ T328] Code: 48 8d 83 00 03 00 00 4c 8b a3 f8 02 00 00 48 89 c7 48 89 44 24 28 e8 10 79 01 ff 4c 8b ab 00 03 00 00 4c 89 ef e8 f1 87 01 ff <4d> 89 65 00 4d 85 e4 74 14 e8 93 2b ed fe 49 8d 7c 24 08 e8 d9 87
> All code
> ========
>    0:   48 8d 83 00 03 00 00    lea    0x300(%rbx),%rax
>    7:   4c 8b a3 f8 02 00 00    mov    0x2f8(%rbx),%r12
>    e:   48 89 c7                mov    %rax,%rdi
>   11:   48 89 44 24 28          mov    %rax,0x28(%rsp)
>   16:   e8 10 79 01 ff          callq  0xffffffffff01792b
>   1b:   4c 8b ab 00 03 00 00    mov    0x300(%rbx),%r13
>   22:   4c 89 ef                mov    %r13,%rdi
>   25:   e8 f1 87 01 ff          callq  0xffffffffff01881b
>   2a:*  4d 89 65 00             mov    %r12,0x0(%r13)           <-- trapping instruction
>   2e:   4d 85 e4                test   %r12,%r12
>   31:   74 14                   je     0x47
>   33:   e8 93 2b ed fe          callq  0xfffffffffeed2bcb
>   38:   49 8d 7c 24 08          lea    0x8(%r12),%rdi
>   3d:   e8                      .byte 0xe8
>   3e:   d9                      .byte 0xd9
>   3f:   87                      .byte 0x87
>
> Code starting with the faulting instruction
> ===========================================
>    0:   4d 89 65 00             mov    %r12,0x0(%r13)
>    4:   4d 85 e4                test   %r12,%r12
>    7:   74 14                   je     0x1d
>    9:   e8 93 2b ed fe          callq  0xfffffffffeed2ba1
>    e:   49 8d 7c 24 08          lea    0x8(%r12),%rdi
>   13:   e8                      .byte 0xe8
>   14:   d9                      .byte 0xd9
>   15:   87                      .byte 0x87
>
>
> To reproduce:
>
>         # build kernel
>         cd linux
>         cp config-5.19.0-rc5-01130-g2e20fc25bca5 .config
>         make HOSTCC=gcc-11 CC=gcc-11 ARCH=x86_64 olddefconfig prepare modules_prepare bzImage modules
>         make HOSTCC=gcc-11 CC=gcc-11 ARCH=x86_64 INSTALL_MOD_PATH=<mod-install-dir> modules_install
>         cd <mod-install-dir>
>         find lib/ | cpio -o -H newc --quiet | gzip > modules.cgz
>
>
>         git clone https://github.com/intel/lkp-tests.git
>         cd lkp-tests
>         bin/lkp qemu -k <bzImage> -m modules.cgz job-script # job-script is attached in this email
>
>         # if come across any failure that blocks the test,
>         # please remove ~/.lkp and /lkp dir to run from a clean state.
>
>
>
> --
> 0-DAY CI Kernel Test Service
> https://01.org/lkp
>
>
