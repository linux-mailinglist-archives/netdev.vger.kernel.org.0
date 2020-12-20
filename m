Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4C802DF859
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 05:45:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728337AbgLUEn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Dec 2020 23:43:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726533AbgLUEn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Dec 2020 23:43:57 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A6EBC061282
        for <netdev@vger.kernel.org>; Sun, 20 Dec 2020 20:43:17 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id c12so5750854pfo.10
        for <netdev@vger.kernel.org>; Sun, 20 Dec 2020 20:43:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=BFnwQlQd49M9djaObusfiUyKPA9qWoz8f0zAPt1iI+Q=;
        b=kJQBL871Th/KU+Ekq3VjH9JbizT3zh7Ig0x5S+kWKj+auI5CtE1pifVfgRltYiYeCI
         emKZUb6ZuqcBuZOeNSxF2nCZb+1OhT43bIS4CkaxNUHz+/AqtrV5fYI1EBo0G7/rz6zf
         T4wXOnrQFcR+M8mO9ifE8CoKLdrBYJJ520fAW1mIJsfhSff70NzFfA974kLUSY6arNpI
         bigyIvcC/vn/MyxpLvyKON0LNazuwYsfOkjbstGUyA9H1K9e9JHlp6HsSIs906o8cnjL
         +zRLVy54MGG2q5f44IG8Ni9fn4Fc7q1n+0qX+inXTDrmNhtKY7aFVRdB8yQ4aWEPIRpY
         FeqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=BFnwQlQd49M9djaObusfiUyKPA9qWoz8f0zAPt1iI+Q=;
        b=XMDvEdZ3CjSl4vjWXOdli9lLLVfLsP9+cxH6k2ZWkxwJqSO03prtNBK3GkSnXAyhBj
         t4a+CXe53tx+8s/ruj56wiCG8r9P7fRJsjZmh0UdZkyPki+66zcx4MB8B1kDfw5R+xzj
         MStAC/gP933TegOFPtIaDz6ZLuSBwam3mKJOV1bgB1o0M9Ybtnf6mJXrDbURnS55NsIC
         MdNsjg3vaSGhU0LILfVO2p4fXg2rka3aezCRxG+J37Yj2AdhgnAoKTXRneXqGk1FJAUg
         yFb2ZJvCE5NjrEgiSzmvdW1NWH2BihOW12wyLg72BOh7Yh0dMxMjqKMNroBIIaLqhNvb
         aK1g==
X-Gm-Message-State: AOAM530Q16q6ZFp23paLYXqTnxtn52YRw30DzD9kqN1PePvz9YIIlvPI
        uOay4OYSWMZ6/J9z9b0yKkVoaepceLqLOg==
X-Google-Smtp-Source: ABdhPJxoJvDgE/QxAfZQR26eQqs9zy2Ed/zhWp4YGJQQ+Uy2A7SmfnrPaJ7Ck0W/E56fxJBG8EIPew==
X-Received: by 2002:a63:c155:: with SMTP id p21mr12281784pgi.377.1608495879689;
        Sun, 20 Dec 2020 12:24:39 -0800 (PST)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id cq15sm13138470pjb.27.2020.12.20.12.24.38
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Dec 2020 12:24:39 -0800 (PST)
Date:   Sun, 20 Dec 2020 12:24:21 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 210781] New: Tun.c fails with tc mirror when using bridges
Message-ID: <20201220122421.028c2f48@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Fri, 18 Dec 2020 23:24:31 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 210781] New: Tun.c fails with tc mirror when using bridges


https://bugzilla.kernel.org/show_bug.cgi?id=210781

            Bug ID: 210781
           Summary: Tun.c fails with tc mirror when using bridges
           Product: Networking
           Version: 2.5
    Kernel Version: 5.4.78
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: pablo.catalina@gmail.com
        Regression: No

Hi,

I got a kernel panic and after reboot I tried again and I got the following
error:


[17665.950212] u32 classifier
[17665.950247]     input device check on
[17665.950278]     Actions configured
[17665.993688] Mirror/redirect action on
[17673.994202] tun: unexpected GSO type: 0x0, gso_size 289, hdr_len 355
[17673.994242] tun: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
................
[17673.994288] tun: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
................
[17673.994333] tun: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
................
[17673.994378] tun: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
................
[17673.994432] ------------[ cut here ]------------
[17673.994479] WARNING: CPU: 7 PID: 4700 at drivers/net/tun.c:2129
tun_do_read+0x535/0x6d0
[17673.994525] Modules linked in: sch_prio act_mirred cls_u32 sch_ingress
iptable_mangle xt_TEE nf_dup_ipv6 nf_dup_ipv4 snd_hda_codec_realtek
snd_hda_codec_generic ledtrig_audio veth nfsv3 rpcsec_gss_krb5 nfsv4 nfs
fscache ebtable_filter ebtables ip6table_raw ip6t_REJECT nf_reject_ipv6
ip6table_filter ip6_tables iptable_raw ipt_REJECT nf_reject_ipv4 xt_NFLOG
xt_set xt_physdev xt_addrtype xt_multiport xt_conntrack xt_mark ip_set_hash_net
ip_set sctp iptable_filter xt_nat xt_tcpudp xt_MASQUERADE xt_comment
iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 bpfilter bonding
zram softdog nfnetlink_log nfnetlink binfmt_misc i915 intel_rapl_msr
intel_rapl_common drm_kms_helper drm x86_pkg_temp_thermal intel_powerclamp
i2c_algo_bit coretemp fb_sys_fops syscopyarea sysfillrect sysimgblt
dm_thin_pool dm_persistent_data dm_bio_prison dm_bufio kvm_intel kvm
snd_hda_intel snd_intel_dspcfg irqbypass snd_hda_codec snd_hda_core
crct10dif_pclmul snd_hwdep crc32_pclmul snd_pcm ghash_clmulni_intel
[17673.994547]  aesni_intel ie31200_edac snd_timer snd crypto_simd eeepc_wmi
cryptd soundcore input_leds glue_helper rapl mac_hid asus_wmi intel_cstate
sparse_keymap serio_raw wmi_bmof vhost_net vhost tap ib_iser nfsd auth_rpcgss
nfs_acl lockd rdma_cm iw_cm ib_cm grace ib_core sunrpc iscsi_tcp libiscsi_tcp
libiscsi scsi_transport_iscsi ip_tables x_tables autofs4 btrfs zstd_compress
raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor
raid6_pq libcrc32c raid1 raid0 multipath linear ahci xhci_pci i2c_i801 libahci
lpc_ich e1000e xhci_hcd ehci_pci ehci_hcd megaraid_sas wmi video
[17673.994984] CPU: 7 PID: 4700 Comm: vhost-4644 Not tainted 5.4.78-2-pve #1
[17673.995022] Hardware name: System manufacturer System Product Name/P8B WS,
BIOS 9922 06/20/2019
[17673.995075] RIP: 0010:tun_do_read+0x535/0x6d0
[17673.995113] Code: 00 00 6a 01 0f b7 45 aa b9 10 00 00 00 48 c7 c6 f4 63 40
8a 48 c7 c7 ff 5c 35 8a 83 f8 40 48 0f 4f c2 31 d2 50 e8 6b c7 d5 ff <0f> 0b 58
5a 49 c7 c4 ea ff ff ff e9 c2 fc ff ff 4c 89 ea be 04 00
[17673.995187] RSP: 0018:ffffac334350bc80 EFLAGS: 00010246
[17673.995224] RAX: 0000000000000000 RBX: ffff992cb1941600 RCX:
0000000000000006
[17673.995263] RDX: 0000000000000000 RSI: 0000000000000096 RDI:
ffff992d1f3d78c0
[17673.995303] RBP: ffffac334350bd08 R08: 0000000000000643 R09:
ffffffff8abb56ec
[17673.995342] R10: 000000000000072e R11: ffffac334350ba08 R12:
000000000000016f
[17673.995381] R13: ffffac334350be30 R14: ffff992b7bd548c0 R15:
0000000000000000
[17673.995421] FS:  0000000000000000(0000) GS:ffff992d1f3c0000(0000)
knlGS:0000000000000000
[17673.996652] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[17673.996688] CR2: 00007f9a5458ad38 CR3: 00000006969bc003 CR4:
00000000001626e0
[17673.996726] Call Trace:
[17673.996763]  tun_recvmsg+0x76/0x110
[17673.996799]  handle_rx+0x5d4/0xa20 [vhost_net]
[17673.996837]  handle_rx_net+0x15/0x20 [vhost_net]
[17673.996873]  vhost_worker+0xba/0x110 [vhost]
[17673.996910]  kthread+0x120/0x140
[17673.996944]  ? log_used.part.45+0x20/0x20 [vhost]
[17673.996980]  ? kthread_park+0x90/0x90
[17673.997015]  ret_from_fork+0x35/0x40
[17673.997049] ---[ end trace dc2c3635b10ec80e ]---
[17674.304983] tun: unexpected GSO type: 0x0, gso_size 91, hdr_len 157
[17674.305024] tun: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
................
[17674.305070] tun: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
................
[17674.305116] tun: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
................
[17674.305161] tun: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
................
[17685.611046] device eth0 left promiscuous mode
[17691.890075] device eth0 entered promiscuous mode
[17698.446189] device eth0 entered promiscuous mode
[17734.423198] tun: unexpected GSO type: 0x0, gso_size 497, hdr_len 563
[17734.423240] tun: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
................
[17734.423288] tun: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
................
[17734.423335] tun: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
................
[17734.423382] tun: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
................
[17750.949141] tun: unexpected GSO type: 0x0, gso_size 497, hdr_len 563
[17750.949185] tun: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
................
[17750.949233] tun: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
................
[17750.949284] tun: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
................
[17750.949334] tun: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
................



Now, the environment:

Server using proxmox latest version.
I have ethernet connection, a tap interface using OpenVPN and two Linux
Bridges:
* VMBR0: several KVM VMs and LXC containers
* VMBR3: only one interface of one KVM

I wanted to mirror all the traffic on VMBR0 to VMBR3. THe iptables solution
does not work fine, the traffic appears duplicated or I miss the traffic from
VMBR0 to the TAP0 interface.

I tried to use tc to mirror the traffic using the following script:

#!/bin/sh
sif="vmbr0"
dif="vmbr3"


case "$1" in
        start)
                sif=vmbr0
                dif=vmbr3

                # ingress
                tc qdisc add dev "$sif" ingress
                tc filter add dev "$sif" parent ffff: \
                          protocol all \
                          u32 match u8 0 0 \
                          action mirred egress mirror dev "$dif"

                # egress
                tc qdisc add dev "$sif" handle 1: root prio
                tc filter add dev "$sif" parent 1: \
                          protocol all \
                          u32 match u8 0 0 \
                          action mirred egress mirror dev "$dif"

                ;;
        stop)
                tc qdisc del dev $sif ingress
                tc qdisc del dev $sif root
                ;;
        *)
                echo "usage $0 <start|stop>"
esac


When I start it I got the error above.
If I try to stop it, I get a kernel panic (I don't have access to the console,
so I cannot see the kernel panic).

Cheers,

Pablo

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
