Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51C6629722E
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 17:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S465738AbgJWPYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 11:24:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S465734AbgJWPYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 11:24:22 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA90C0613CE
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 08:24:21 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id a200so1576586pfa.10
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 08:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=xR0U9Sb1czRjDknD6M0cepmBAfEedaV2pbctWm+HP6E=;
        b=HNM/DuntWecrcBaflrfl5ZcvNSSdEo1pRgjYOHitMILc2ZUyUZbJYn/rlVS+i95dWV
         2v4YZnhdkkCFKnSZxhe/8HEqN4Ct93/c1hO1iRI61+p286hyv5KYWh9kxxm3pF3zIhyl
         f2nRhj7paX7gIDD/rkX59BQ4aaLciwhnaXzOy64PkP1xHtOXTjh54OkHuV5EUUtxrYSS
         kzEWnn3Fb4RJwom0BgTxibPIp/zbfsI//R/PFpT+EnDiQylWbHh1LWNjaqEhkcOKpzCp
         lucnt2T6NF+DA7mwzuPJzFjUB6/aSzQx6twOU2Ua0gDTPvVeaKUdPCkFOzi8IKV6FPU5
         n0bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=xR0U9Sb1czRjDknD6M0cepmBAfEedaV2pbctWm+HP6E=;
        b=PUInJKxrvVZAjactIvWTrZccdxbju6cIwkiP7+YCKVbM+E7lqTZJDvjR0E3d7Hj61t
         Jmz0STSBfizDCAgeCQU2VemxQh9zfkA0Fhxg7a9l53cHjyXVGkAx0unghYFAgeE3a7f/
         ZZtckmTT9b165QYLKbJGKcyvBqx6R1DMZDBVdaorllEub7dLGjb455zSYAZktvez6FZ/
         Bi6nad7+5AK5H6GHhcJWVxofHF4KTEY53wcuG4xX2A+Ev56qVBK5rqA+tzGSAdA0zn+n
         rmN4JYcCVYfI93YIsDF4+/eVQSyLUdVNCXUXk62cVk3JkYccIk4Ut8VqcCGx8FkR0DWw
         AKvQ==
X-Gm-Message-State: AOAM533zN8JzYQ2/gLEqECGIxVApwE5wJnopHY8tcVZpx3CE2F9PoLVs
        6JsaXHRXWWXYQEsbFRlRBdi6OvPKRMeoPy5j
X-Google-Smtp-Source: ABdhPJxzjmRZPby+Hj2L+dA8Os/QY0QW8zIZsCEjWOtuhUjusXXgfkLKSOnyMXBVqH7nY3Z/Peb0HQ==
X-Received: by 2002:aa7:8b0b:0:b029:152:900d:2288 with SMTP id f11-20020aa78b0b0000b0290152900d2288mr2668877pfd.53.1603466659766;
        Fri, 23 Oct 2020 08:24:19 -0700 (PDT)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id l13sm2242829pgp.25.2020.10.23.08.24.18
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2020 08:24:19 -0700 (PDT)
Date:   Fri, 23 Oct 2020 08:24:11 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 209823] New: system panic since commit 
 d18d22ce8f62839365c984b1df474d3975ed4eb2
Message-ID: <20201023082411.27a8a3a7@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Fri, 23 Oct 2020 03:38:54 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 209823] New: system panic since commit  d18d22ce8f62839365c984b1df474d3975ed4eb2


https://bugzilla.kernel.org/show_bug.cgi?id=209823

            Bug ID: 209823
           Summary: system panic since commit
                    d18d22ce8f62839365c984b1df474d3975ed4eb2
           Product: Networking
           Version: 2.5
    Kernel Version: 5.4.15
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: liuzx@knownsec.com
        Regression: No

Created attachment 293133
  --> https://bugzilla.kernel.org/attachment.cgi?id=293133&action=edit  
kernel config 5.4.15-ks-00023-gd18d22ce8f62

On a server running as a NAT gateway, after upgrade the kernel to 5.4 series,
the system panic immediately after keepalived transfer it to master state.
I did a git bisect on 5.4 release, and the result is:

# first bad commit: [d18d22ce8f62839365c984b1df474d3975ed4eb2] net: Fix packet
reordering caused by GRO and listified RX cooperation

kernel 5.5.0 has no such problem.

See attachment for the kernel config. Following is the message captured from
serial console:

[   75.333333][    C1] stack segment: 0000 [#1] SMP PTI
[   75.338338][    C1] CPU: 1 PID: 4486 Comm: realpath Tainted: G              
 T 5.4.15-ks-00023-gd18d22ce8f62 #4
[   75.348586][    C1] Hardware name: Dell Inc. PowerEdge R210 II/0CP8FC, BIOS
2.10.0 05/24/2018
[   75.357167][    C1] RIP: 0010:skb_seq_read+0x2c/0x200
[   75.362243][    C1] Code: 44 00 00 4c 8b 4a 20 03 3a 39 7a 04 0f 86 a0 01 00
00 55 41 89 fa 53 48 8b 6a 18 65 48 8b 1c 25 c0 6b 01 00 49 89 db 8b 7a 0c <44>
8b 45 70 41 01 f8 44 2b 45 74 45 39 c2 0f 83 a1 00 00 00 4d 85
[   75.381778][    C1] RSP: 0000:ffffb497c0114a98 EFLAGS: 00010286
[   75.387727][    C1] RAX: 00000000000006c0 RBX: ffff9bcf38e29fc0 RCX:
ffff9bcf35dfd800
[   75.397580][    C1] RDX: ffffb497c0114b00 RSI: ffffb497c0114ab0 RDI:
0000000000000114
[   75.407416][    C1] RBP: dead000000000100 R08: ffff9bcf35559700 R09:
0000000000000000
[   75.417241][    C1] R10: 0000000000000114 R11: ffff9bcf38e29fc0 R12:
ffffb497c0114afc
[   75.427069][    C1] R13: 0000000000000114 R14: 0000000000000114 R15:
0000000000000116
[   75.436882][    C1] FS:  0000000000000000(0000) GS:ffff9bcf3ba40000(0000)
knlGS:0000000000000000
[   75.447650][    C1] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   75.456093][    C1] CR2: 00007f5182e735c0 CR3: 000000008f4f6002 CR4:
00000000001606e0
[   75.465934][    C1] Call Trace:
[   75.471089][    C1]  <IRQ>
[   75.475801][    C1]  bm_find+0x52/0x120 [ts_bm]
[   75.482325][    C1]  skb_find_text+0x77/0xd0
[   75.488570][    C1]  string_mt+0x28/0x35 [xt_string]
[   75.495496][    C1]  ipt_do_table+0x29e/0x680 [ip_tables]
[   75.502843][    C1]  ? update_group_capacity+0x25/0x1e0
[   75.510002][    C1]  nf_hook_slow+0x40/0xb0
[   75.516095][    C1]  ip_sublist_rcv+0x253/0x280
[   75.522517][    C1]  ? ip_rcv_finish_core.isra.0+0x390/0x390
[   75.530054][    C1]  ip_list_rcv+0x119/0x13d
[   75.536191][    C1]  __netif_receive_skb_list_core+0x246/0x270
[   75.543889][    C1]  netif_receive_skb_list_internal+0x1c3/0x2f0
[   75.551753][    C1]  gro_normal_list.part.0+0x19/0x40
[   75.558641][    C1]  napi_complete_done+0x86/0x120
[   75.565264][    C1]  bnx2_poll_msix+0x9f/0xd0 [bnx2]
[   75.572065][    C1]  net_rx_action+0x161/0x3b0
[   75.578342][    C1]  __do_softirq+0xee/0x2ff
[   75.584436][    C1]  irq_exit+0xe6/0xf0
[   75.590078][    C1]  do_IRQ+0x58/0xe0
[   75.595523][    C1]  common_interrupt+0xf/0xf
[   75.601640][    C1]  </IRQ>
[   75.606201][    C1] RIP: 0010:kthread_blkcg+0x14/0x30
[   75.613016][    C1] Code: 8b 44 24 20 eb 83 41 b8 ea ff ff ff e9 94 fc ff ff
90 90 90 90 90 0f 1f 44 00 00 31 c0 65 48 8b 14 25 c0 6b 01 00 f6 42 72 20 <74>
10 48 8b 82 70 09 00 00 48 85 c0 74 04 48 8b 40 58 c3 66 0f 1f
[   75.636128][    C1] RSP: 0000:ffffb497c07d7d78 EFLAGS: 00000246 ORIG_RAX:
ffffffffffffffda
[   75.646247][    C1] RAX: 0000000000000000 RBX: ffffb497c07d7e00 RCX:
0000000000000000
[   75.655930][    C1] RDX: ffff9bcf38e29fc0 RSI: 0000000000000000 RDI:
ffff9bcf07d0d000
[   75.665613][    C1] RBP: 0000000000000000 R08: ffff9bcf07d0d000 R09:
0000000000000001
[   75.675305][    C1] R10: 0000000000000002 R11: ffffed4982399b80 R12:
0000000000000cc0
[   75.685002][    C1] R13: 0000000000000000 R14: ffff9bcf3a897080 R15:
0000000000000055
[   75.694687][    C1]  mem_cgroup_throttle_swaprate+0x25/0x11f
[   75.702197][    C1]  mem_cgroup_try_charge_delay+0x33/0x40
[   75.709515][    C1]  do_fault+0x8d/0x630
[   75.715254][    C1]  __handle_mm_fault+0x451/0x700
[   75.721843][    C1]  handle_mm_fault+0xc4/0x200
[   75.728158][    C1]  do_user_addr_fault+0x202/0x460
[   75.734793][    C1]  do_page_fault+0x31/0x110
[   75.740871][    C1]  page_fault+0x3e/0x50
[   75.746586][    C1] RIP: 0033:0x7f5182e4cef4
[   75.752552][    C1] Code: 00 00 00 00 66 90 55 48 89 e5 41 57 49 89 ff 41 56
41 55 41 54 53 48 83 ec 38 0f 31 48 c1 e2 20 48 09 d0 48 8d 15 14 6f 02 00 <48>
89 05 c5 66 02 00 48 8b 05 06 6f 02 00 48 89 d1 48 2b 0d 7c 70
[   75.775424][    C1] RSP: 002b:00007ffc55eacf00 EFLAGS: 00010202
[   75.783004][    C1] RAX: 0000005c80a2b080 RBX: 0000000000000000 RCX:
0000000000000000
[   75.792484][    C1] RDX: 00007f5182e73e08 RSI: 0000000000000000 RDI:
00007ffc55eacf70
[   75.801944][    C1] RBP: 00007ffc55eacf60 R08: 0000000000000000 R09:
0000000000000000
[   75.811422][    C1] R10: 0000000000000000 R11: 0000000000000000 R12:
0000000000000000
[   75.820875][    C1] R13: 0000000000000000 R14: 0000000000000000 R15:
00007ffc55eacf70
[   75.830294][    C1] Modules linked in: tcp_diag inet_diag bridge stp llc
nf_conntrack_netlink xfrm_user xfrm_algo overlay af_packet cn xt_AUDIT
xt_recent xt_connlimit nf_conncount xt_conntrack iptable_filter iptable_mangle
xt_REDIREC
T xt_nat iptable_nat nf_nat xt_comment ts_bm xt_multiport xt_addrtype xt_CT
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 libcrc32c crc32c_generic xt_string
xt_set iptable_raw ip_tables x_tables bpfilter ip_set_hash_netportnet ip_set
nfnet
link msr binfmt_misc coretemp intel_rapl_msr intel_rapl_common
x86_pkg_temp_thermal intel_powerclamp kvm_intel kvm mgag200 drm_vram_helper ttm
drm_kms_helper irqbypass dm_mod crct10dif_pclmul crc32_pclmul
ghash_clmulni_intel drm aesni_i
ntel crypto_simd cryptd input_leds igb led_class glue_helper joydev usbkbd
intel_cstate intel_uncore dcdbas agpgart iTCO_wdt iTCO_vendor_support evdev
mac_hid ipmi_ssif sr_mod watchdog fb_sys_fops syscopyarea sysfillrect cdrom
sysimgblt
 intel_rapl_perf bnx2 ipmi_si i2c_i801 pcspkr
[   75.830342][    C1]  ie31200_edac hwmon ipmi_devintf dca edac_core thermal
i2c_algo_bit ipmi_msghandler lpc_ich wmi rtc_cmos i2c_core ata_generic
pata_acpi button fan ext4 crc16 jbd2 mbcache sd_mod hid_generic usbhid hid
ata_piix ehc
i_pci libata crc32c_intel ehci_hcd scsi_mod usbcore usb_common
[   75.958030][    C2] stack segment: 0000 [#2] SMP PTI
[   75.958059][    C1] ---[ end trace fa1655e994cf04d6 ]---
[   75.963908][    C2] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G      D        
T 5.4.15-ks-00023-gd18d22ce8f62 #4
[   75.963910][    C2] Hardware name: Dell Inc. PowerEdge R210 II/0CP8FC, BIOS
2.10.0 05/24/2018
[   76.027718][    C1] RIP: 0010:skb_seq_read+0x2c/0x200
[   76.037146][    C2] RIP: 0010:skb_seq_read+0x2c/0x200
[   76.037148][    C2] Code: 44 00 00 4c 8b 4a 20 03 3a 39 7a 04 0f 86 a0 01 00
00 55 41 89 fa 53 48 8b 6a 18 65 48 8b 1c 25 c0 6b 01 00 49 89 db 8b 7a 0c <44>
8b 45 70 41 01 f8 44 2b 45 74 45 39 c2 0f 83 a1 00 00 00 4d 85
[   76.046597][    C1] Code: 44 00 00 4c 8b 4a 20 03 3a 39 7a 04 0f 86 a0 01 00
00 55 41 89 fa 53 48 8b 6a 18 65 48 8b 1c 25 c0 6b 01 00 49 89 db 8b 7a 0c <44>
8b 45 70 41 01 f8 44 2b 45 74 45 39 c2 0f 83 a1 00 00 00 4d 85
[   76.052566][    C2] RSP: 0018:ffffb497c0148a98 EFLAGS: 00010286
[   76.052568][    C2] RAX: 00000000000006c0 RBX: ffff9bcf07f85f40 RCX:
ffff9bcf35e9a000
[   76.058528][    C1] RSP: 0000:ffffb497c0114a98 EFLAGS: 00010286
[   76.079855][    C2] RDX: ffffb497c0148b00 RSI: ffffb497c0148ab0 RDI:
00000000000005c8
[   76.079855][    C2] RBP: dead000000000100 R08: ffff9bcf36885100 R09:
0000000000000000
[   76.079857][    C2] R10: 00000000000005c8 R11: ffff9bcf07f85f40 R12:
ffffb497c0148afc
[   76.101282][    C1] RAX: 00000000000006c0 RBX: ffff9bcf38e29fc0 RCX:
ffff9bcf35dfd800
[   76.108197][    C2] R13: 00000000000005c8 R14: 00000000000005c8 R15:
00000000000005c9
[   76.108198][    C2] FS:  0000000000000000(0000) GS:ffff9bcf3ba80000(0000)
knlGS:0000000000000000
[   76.108199][    C2] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   76.117038][    C1] RDX: ffffb497c0114b00 RSI: ffffb497c0114ab0 RDI:
0000000000000114
[   76.123962][    C2] CR2: 00007feec4003068 CR3: 000000001220a001 CR4:
00000000001606e0
[   76.123963][    C2] Call Trace:
[   76.132814][    C1] RBP: dead000000000100 R08: ffff9bcf35559700 R09:
0000000000000000
[   76.141663][    C2]  <IRQ>
[   76.150511][    C1] R10: 0000000000000114 R11: ffff9bcf38e29fc0 R12:
ffffb497c0114afc
[   76.159360][    C2]  bm_find+0x52/0x120 [ts_bm]
[   76.168209][    C1] R13: 0000000000000114 R14: 0000000000000114 R15:
0000000000000116
[   76.178016][    C2]  skb_find_text+0x77/0xd0
[   76.185475][    C1] FS:  0000000000000000(0000) GS:ffff9bcf3ba40000(0000)
knlGS:0000000000000000
[   76.194332][    C2]  string_mt+0x28/0x35 [xt_string]
[   76.194334][    C2]  ipt_do_table+0x29e/0x680 [ip_tables]
[   76.203202][    C1] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   76.207386][    C2]  ? ip_finish_output2+0x1ad/0x580
[   76.207392][    C2]  ? nf_confirm+0xcc/0xf0 [nf_conntrack]
[   76.216270][    C1] CR2: 00007f5182e735c0 CR3: 000000008f4f6002 CR4:
00000000001606e0
[   76.220035][    C2]  ? update_group_capacity+0x25/0x1e0
[   76.220037][    C2]  nf_hook_slow+0x40/0xb0
[   76.228932][    C1] Kernel panic - not syncing: Fatal exception in interrupt
[   76.234539][    C2]  ip_sublist_rcv+0x253/0x280
[   76.325336][    C2]  ? ip_rcv_finish_core.isra.0+0x390/0x390
[   76.332066][    C2]  ip_list_rcv+0x119/0x13d
[   76.337413][    C2]  __netif_receive_skb_list_core+0x246/0x270
[   76.344327][    C2]  netif_receive_skb_list_internal+0x1c3/0x2f0
[   76.351409][    C2]  gro_normal_list.part.0+0x19/0x40
[   76.357546][    C2]  napi_complete_done+0x86/0x120
[   76.363425][    C2]  bnx2_poll_msix+0x9f/0xd0 [bnx2]
[   76.369456][    C2]  net_rx_action+0x161/0x3b0
[   76.374942][    C2]  __do_softirq+0xee/0x2ff
[   76.380249][    C2]  irq_exit+0xe6/0xf0
[   76.385108][    C2]  do_IRQ+0x58/0xe0
[   76.389795][    C2]  common_interrupt+0xf/0xf
[   76.395176][    C2]  </IRQ>
[   76.398998][    C2] RIP: 0010:cpuidle_enter_state+0xc4/0x450
[   76.405687][    C2] Code: e8 c1 f0 a6 ff 80 7c 24 0f 00 74 17 9c 58 0f 1f 44
00 00 f6 c4 02 0f 85 61 03 00 00 31 ff e8 53 09 ad ff fb 66 0f 1f 44 00 00 <45>
85 e4 0f 88 8c 02 00 00 49 63 cc 4c 2b 6c 24 10 48 8d 04 49 48
[   76.427204][    C2] RSP: 0018:ffffb497c00afe68 EFLAGS: 00000246 ORIG_RAX:
ffffffffffffffda
[   76.436486][    C2] RAX: ffff9bcf3baaa940 RBX: ffffffffa22c6480 RCX:
000000000000001f
[   76.445316][    C2] RDX: 0000000000000000 RSI: 000000002962566a RDI:
0000000000000000
[   76.454125][    C2] RBP: ffff9bcf3bab4600 R08: 000000118e9c2d85 R09:
0000000000000390
[   76.462907][    C2] R10: ffff9bcf3baa9620 R11: ffff9bcf3baa9600 R12:
0000000000000004
[   76.471658][    C2] R13: 000000118e9c2d85 R14: 0000000000000004 R15:
ffff9bcf07f85f40
[   76.480393][    C2]  ? cpuidle_enter_state+0x9f/0x450
[   76.486333][    C2]  cpuidle_enter+0x29/0x40
[   76.491476][    C2]  do_idle+0x1e1/0x270
[   76.496265][    C2]  cpu_startup_entry+0x19/0x20
[   76.501741][    C2]  start_secondary+0x173/0x1c0
[   76.507197][    C2]  secondary_startup_64+0xa4/0xb0
[   76.512907][    C2] Modules linked in: tcp_diag inet_diag bridge stp llc
nf_conntrack_netlink xfrm_user xfrm_algo overlay af_packet cn xt_AUDIT
xt_recent xt_connlimit nf_conncount xt_conntrack iptable_filter iptable_mangle
xt_REDIREC
T xt_nat iptable_nat nf_nat xt_comment ts_bm xt_multiport xt_addrtype xt_CT
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 libcrc32c crc32c_generic xt_string
xt_set iptable_raw ip_tables x_tables bpfilter ip_set_hash_netportnet ip_set
nfnet
link msr binfmt_misc coretemp intel_rapl_msr intel_rapl_common
x86_pkg_temp_thermal intel_powerclamp kvm_intel kvm mgag200 drm_vram_helper ttm
drm_kms_helper irqbypass dm_mod crct10dif_pclmul crc32_pclmul
ghash_clmulni_intel drm aesni_i
ntel crypto_simd cryptd input_leds igb led_class glue_helper joydev usbkbd
intel_cstate intel_uncore dcdbas agpgart iTCO_wdt iTCO_vendor_support evdev
mac_hid ipmi_ssif sr_mod watchdog fb_sys_fops syscopyarea sysfillrect cdrom
sysimgblt
 intel_rapl_perf bnx2 ipmi_si i2c_i801 pcspkr
[   76.512938][    C2]  ie31200_edac hwmon ipmi_devintf dca edac_core thermal
i2c_algo_bit ipmi_msghandler lpc_ich wmi rtc_cmos i2c_core ata_generic
pata_acpi button fan ext4 crc16 jbd2 mbcache sd_mod hid_generic usbhid hid
ata_piix ehc
i_pci libata crc32c_intel ehci_hcd scsi_mod usbcore usb_common
[   76.633079][    C0] stack segment: 0000 [#3] SMP PTI
[   76.639022][    C0] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G      D        
T 5.4.15-ks-00023-gd18d22ce8f62 #4
[   76.649995][    C0] Hardware name: Dell Inc. PowerEdge R210 II/0CP8FC, BIOS
2.10.0 05/24/2018
[   76.659513][    C0] RIP: 0010:skb_seq_read+0x2c/0x200
[   76.665559][    C0] Code: 44 00 00 4c 8b 4a 20 03 3a 39 7a 04 0f 86 a0 01 00
00 55 41 89 fa 53 48 8b 6a 18 65 48 8b 1c 25 c0 6b 01 00 49 89 db 8b 7a 0c <44>
8b 45 70 41 01 f8 44 2b 45 74 45 39 c2 0f 83 a1 00 00 00 4d 85
[   76.687043][    C0] RSP: 0018:ffffb497c0003a98 EFLAGS: 00010286
[   76.693987][    C0] RAX: 00000000000006c0 RBX: ffffffffa2213780 RCX:
ffff9bcf35f97000
[   76.702842][    C0] RDX: ffffb497c0003b00 RSI: ffffb497c0003ab0 RDI:
00000000000005a0
[   76.711687][    C0] RBP: dead000000000100 R08: ffff9bcf3a9d4000 R09:
0000000000000000
[   76.720530][    C0] R10: 00000000000005a0 R11: ffffffffa2213780 R12:
ffffb497c0003afc
[   76.729374][    C0] R13: 00000000000005a0 R14: 00000000000005a0 R15:
00000000000005a8
[   76.738206][    C0] FS:  0000000000000000(0000) GS:ffff9bcf3ba00000(0000)
knlGS:0000000000000000
[   76.747991][    C0] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   76.755429][    C0] CR2: 000000000174b738 CR3: 000000001220a004 CR4:
00000000001606f0
[   76.764261][    C0] Call Trace:
[   76.768399][    C0]  <IRQ>
[   76.772088][    C0]  bm_find+0x52/0x120 [ts_bm]
[   76.777601][    C0]  skb_find_text+0x77/0xd0
[   76.782847][    C0]  string_mt+0x28/0x35 [xt_string]
[   76.788780][    C0]  ipt_do_table+0x29e/0x680 [ip_tables]
[   76.795154][    C0]  ? __hrtimer_run_queues+0x125/0x270
[   76.801344][    C0]  ? recalibrate_cpu_khz+0x10/0x10
[   76.807270][    C0]  nf_hook_slow+0x40/0xb0
[   76.812418][    C0]  ip_sublist_rcv+0x253/0x280
[   76.817899][    C0]  ? ip_rcv_finish_core.isra.0+0x390/0x390
[   76.824509][    C0]  ip_list_rcv+0x119/0x13d
[   76.829730][    C0]  __netif_receive_skb_list_core+0x246/0x270
[   76.836513][    C0]  netif_receive_skb_list_internal+0x1c3/0x2f0
[   76.843471][    C0]  gro_normal_list.part.0+0x19/0x40
[   76.849477][    C0]  napi_complete_done+0x86/0x120
[   76.855219][    C0]  bnx2_poll_msix+0x9f/0xd0 [bnx2]
[   76.861130][    C0]  net_rx_action+0x161/0x3b0
[   76.866519][    C0]  __do_softirq+0xee/0x2ff
[   76.871732][    C0]  irq_exit+0xe6/0xf0
[   76.876514][    C0]  do_IRQ+0x58/0xe0
[   76.881124][    C0]  common_interrupt+0xf/0xf
[   76.886421][    C0]  </IRQ>
[   76.890163][    C0] RIP: 0010:cpuidle_enter_state+0xc4/0x450
[   76.896776][    C0] Code: e8 c1 f0 a6 ff 80 7c 24 0f 00 74 17 9c 58 0f 1f 44
00 00 f6 c4 02 0f 85 61 03 00 00 31 ff e8 53 09 ad ff fb 66 0f 1f 44 00 00 <45>
85 e4 0f 88 8c 02 00 00 49 63 cc 4c 2b 6c 24 10 48 8d 04 49 48
[   76.918176][    C0] RSP: 0018:ffffffffa2203e58 EFLAGS: 00000246 ORIG_RAX:
ffffffffffffffda
[   76.927400][    C0] RAX: ffff9bcf3ba2a940 RBX: ffffffffa22c6480 RCX:
000000000000001f
[   76.936181][    C0] RDX: 0000000000000000 RSI: 000000002962566a RDI:
0000000000000000
[   76.944956][    C0] RBP: ffff9bcf3ba34600 R08: 000000118f7caec7 R09:
0000000000000385
[   76.953734][    C0] R10: ffff9bcf3ba29620 R11: ffff9bcf3ba29600 R12:
0000000000000004
[   76.962514][    C0] R13: 000000118f7caec7 R14: 0000000000000004 R15:
ffffffffa2213780
[   76.971297][    C0]  ? cpuidle_enter_state+0x9f/0x450
[   76.977307][    C0]  cpuidle_enter+0x29/0x40
[   76.982525][    C0]  do_idle+0x1e1/0x270
[   76.987390][    C0]  cpu_startup_entry+0x19/0x20
[   76.992957][    C0]  start_kernel+0x549/0x566
[   76.998261][    C0]  secondary_startup_64+0xa4/0xb0
[   77.004085][    C0] Modules linked in: tcp_diag inet_diag bridge stp llc
nf_conntrack_netlink xfrm_user xfrm_algo overlay af_packet cn xt_AUDIT
xt_recent xt_connlimit nf_conncount xt_conntrack iptable_filter iptable_mangle
xt_REDIREC
T xt_nat iptable_nat nf_nat xt_comment ts_bm xt_multiport xt_addrtype xt_CT
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 libcrc32c crc32c_generic xt_string
xt_set iptable_raw ip_tables x_tables bpfilter ip_set_hash_netportnet ip_set
nfnet
link msr binfmt_misc coretemp intel_rapl_msr intel_rapl_common
x86_pkg_temp_thermal intel_powerclamp kvm_intel kvm mgag200 drm_vram_helper ttm
drm_kms_helper irqbypass dm_mod crct10dif_pclmul crc32_pclmul
ghash_clmulni_intel drm aesni_i
ntel crypto_simd cryptd input_leds igb led_class glue_helper joydev usbkbd
intel_cstate intel_uncore dcdbas agpgart iTCO_wdt iTCO_vendor_support evdev
mac_hid ipmi_ssif sr_mod watchdog fb_sys_fops syscopyarea sysfillrect cdrom
sysimgblt
 intel_rapl_perf bnx2 ipmi_si i2c_i801 pcspkr
[   77.004103][    C0]  ie31200_edac hwmon ipmi_devintf dca edac_core thermal
i2c_algo_bit ipmi_msghandler lpc_ich wmi rtc_cmos i2c_core ata_generic
pata_acpi button fan ext4 crc16 jbd2 mbcache sd_mod hid_generic usbhid hid
ata_piix ehc
i_pci libata crc32c_intel ehci_hcd scsi_mod usbcore usb_common
[   77.124963][    C3] stack segment: 0000 [#4] SMP PTI
[   77.130902][    C3] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G      D        
T 5.4.15-ks-00023-gd18d22ce8f62 #4
[   77.141857][    C3] Hardware name: Dell Inc. PowerEdge R210 II/0CP8FC, BIOS
2.10.0 05/24/2018
[   77.151349][    C3] RIP: 0010:skb_seq_read+0x2c/0x200
[   77.157361][    C3] Code: 44 00 00 4c 8b 4a 20 03 3a 39 7a 04 0f 86 a0 01 00
00 55 41 89 fa 53 48 8b 6a 18 65 48 8b 1c 25 c0 6b 01 00 49 89 db 8b 7a 0c <44>
8b 45 70 41 01 f8 44 2b 45 74 45 39 c2 0f 83 a1 00 00 00 4d 85
[   77.178755][    C3] RSP: 0018:ffffb497c017ca98 EFLAGS: 00010286
[   77.185626][    C3] RAX: 00000000000006c0 RBX: ffff9bcf07f81fc0 RCX:
ffff9bcf363d1800
[   77.194410][    C3] RDX: ffffb497c017cb00 RSI: ffffb497c017cab0 RDI:
00000000000005a0
[   77.203197][    C3] RBP: dead000000000100 R08: ffff9bcf3a9edb00 R09:
0000000000000000
[   77.211973][    C3] R10: 00000000000005a0 R11: ffff9bcf07f81fc0 R12:
ffffb497c017cafc
[   77.220753][    C3] R13: 00000000000005a0 R14: 00000000000005a0 R15:
00000000000005ab
[   77.229531][    C3] FS:  0000000000000000(0000) GS:ffff9bcf3bac0000(0000)
knlGS:0000000000000000
[   77.239269][    C3] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   77.246667][    C3] CR2: 000055903a118028 CR3: 000000001220a001 CR4:
00000000001606e0
[   77.255447][    C3] Call Trace:
[   77.259544][    C3]  <IRQ>
[   77.263192][    C3]  bm_find+0x52/0x120 [ts_bm]
[   77.268667][    C3]  skb_find_text+0x77/0xd0
[   77.273883][    C3]  string_mt+0x28/0x35 [xt_string]
[   77.279797][    C3]  ipt_do_table+0x29e/0x680 [ip_tables]
[   77.280841][    C1] Shutting down cpus with NMI

-- 
You are receiving this mail because:
You are the assignee for the bug.
