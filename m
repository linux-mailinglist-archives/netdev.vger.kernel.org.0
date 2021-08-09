Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2D773E4AEB
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 19:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234411AbhHIReA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 13:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234208AbhHIRd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 13:33:59 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23FD5C0613D3;
        Mon,  9 Aug 2021 10:33:39 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id i4so2949755ila.1;
        Mon, 09 Aug 2021 10:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Y/d9AEuDn9qTIXjnP+ytDxS2xGEJLagZM3xlSNM+4j8=;
        b=IpF41HUgHnX2VhabmkwUEJqAngPVn+hrOGQdHIYkBkxrPMarA5OQJLeci/dAv2vM5z
         6Dv8oiFKWB9c7fwPAJKfskDU54kRG5h9p6iyc8aSIOVrlYgLHdjH65x2hu0YV1riGoHc
         nQCAn8rZ8NhskaNsahNAPAL7BOn4KMhLetSadqDBGuDswbezUNdQFyAHjGwfVhtI5UFX
         R8Fa0oYXaqiduj4BPM42Cy29cDCib08xzZp5iH7o2gW3ywUbq8s/Bjm2qKA8fNrPOF++
         qbJimQkNOs0bx+SYJap+RjYehKaZUtizGE845D9F3dNDNZopvwCu5ek3NMB113B+fHFX
         ub7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Y/d9AEuDn9qTIXjnP+ytDxS2xGEJLagZM3xlSNM+4j8=;
        b=LdzJYtcrTBjFe+Ou1i5RRAGCe8hkh9fJ6DBLh6nMe03IrMbKRSGA/8u4w0UVx7cUiI
         9WUTuAc68hgd5vRdthSpwip9kh456QDqmRyWkrPW1IirokUKLZPLf1Z6lb7iHGtggjUx
         V2W6xqAUS8xUeY34FUK5KCYhu3wRbuAUTfkZLfUc3MjSm/msPcnsU4/tUrRQFImbPe2d
         rkd7v2f3StH830vHTVzC9oVLhtI2RdlJVKG1l3LIcJXhNTa36zK/n/+/jVLHmrPzwWtu
         O01N+FrpWU+iwxk5zJ18U6CBxncM2rnOg5VuDFHMpvnjLb0RZeY60XBO/PtwoNzyIWxR
         cioA==
X-Gm-Message-State: AOAM531hr2IpyzpslnMJSpgUAdnNmfi8JJS5kV8edMdWWoWLZyzAw35C
        7NW5Y0yI2NLN999UHJsqNkY=
X-Google-Smtp-Source: ABdhPJwx5OLOWTY0EkR9mEy6IFt7WbzlDn7QJftTmgUJlw3TMB3IEsxc9uUcs6mF8G9iOF6Hat6Wrw==
X-Received: by 2002:a92:db4b:: with SMTP id w11mr309ilq.297.1628530418466;
        Mon, 09 Aug 2021 10:33:38 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id r19sm4424932ilj.33.2021.08.09.10.33.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 10:33:37 -0700 (PDT)
Date:   Mon, 09 Aug 2021 10:33:28 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>, lkft-triage@lists.linaro.org,
        Netdev <netdev@vger.kernel.org>
Message-ID: <611166e8929db_2f710208a8@john-XPS-13-9370.notmuch>
In-Reply-To: <CA+G9fYuH=KQaCpbBuYV0EEXtVcF7hTr+x6C5zmyUeNqVwLneYQ@mail.gmail.com>
References: <20210806081113.718626745@linuxfoundation.org>
 <20210806081113.920577986@linuxfoundation.org>
 <CA+G9fYuH=KQaCpbBuYV0EEXtVcF7hTr+x6C5zmyUeNqVwLneYQ@mail.gmail.com>
Subject: Re: [PATCH 5.13 06/35] bpf, sockmap: On cleanup we additionally need
 to remove cached skb
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Naresh Kamboju wrote:
> While running packetdrill test suite on qemu aarch64 the following warning
> noticed with stable-rc 5.13.9-rc1 kernel intermittently.
> 
> On Fri, 6 Aug 2021 at 13:52, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: John Fastabend <john.fastabend@gmail.com>
> >
> > [ Upstream commit 476d98018f32e68e7c5d4e8456940cf2b6d66f10 ]
> 
> <trim>
> 
> > With this fix we no longer see this warning splat from tcp side on
> > socket close when we hit the above case with redirect to ingress self.
> >
> > [224913.935822] WARNING: CPU: 3 PID: 32100 at net/core/stream.c:208 sk_stream_kill_queues+0x212/0x220
> > [224913.935841] Modules linked in: fuse overlay bpf_preload x86_pkg_temp_thermal intel_uncore wmi_bmof squashfs sch_fq_codel efivarfs ip_tables x_tables uas xhci_pci ixgbe mdio xfrm_algo xhci_hcd wmi
> > [224913.935897] CPU: 3 PID: 32100 Comm: fgs-bench Tainted: G          I       5.14.0-rc1alu+ #181
> > [224913.935908] Hardware name: Dell Inc. Precision 5820 Tower/002KVM, BIOS 1.9.2 01/24/2019
> > [224913.935914] RIP: 0010:sk_stream_kill_queues+0x212/0x220
> 
> 
> steps to reproduce:
> -------------------
> # boot qemu aarch64 with stable-rc 5.13.9-rc1 kernel
> # /usr/bin/qemu-system-aarch64 -cpu max -machine virt,accel=kvm
> -nographic -net nic,model=virtio,macaddr=BC:DD:AD:CC:09:01 -net tap -m
> 4096 -monitor none -kernel kernel/Image.gz --append "console=ttyAMA0
> root=/dev/vda rw" -hda
> rpb-console-image-lkft-juno-20210525221209.rootfs.ext4 -m 4096 -smp 4
> -nographic
> 
> # Run test
> #  cd ./automated/linux/packetdrill/
> #  ./configure
> #  make all
> #  python3 ./packetdrill/run_all.py -v -l -L
> 
> ## Build
> * kernel: 5.13.9-rc1
> * git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> * git branch: linux-5.13.y
> * git commit: 1eb1590ab470d5f73dd2d20a7196bca35fa3d3e7
> * git describe: v5.13.8-36-g1eb1590ab470
> * test details:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.13.y/build/v5.13.8-36-g1eb1590ab470

Hi Naresh,

The fix here should only be visible with sockmap BPF programs running. The
trace below doesn't seem to have any of the BPF calls. I tried to parse
the test details, but I didn't see how packetdrill and the BPF tests
are related. The test that would be relevant linked here seems to be
passing in your case.

https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.13.y/build/v5.13.8-36-g1eb1590ab470/testrun/5382761/suite/kselftest-bpf/test/bpf.test_sockmap/details/

Am I correct in assuming that you bisected to this patch somehow, but
did not have any BPF programs running?

Thanks,
John

> 
> 
> Crash log:
> -----------
> INFO: Skip installing package dependency for packetdrill
> /opt/packetdrill /lava-3242370/0/tests/1_packetdrill/automated/linux/packetdrill
> [   11.329564] tun: Universal TUN/TAP device driver, 1.6
> [   14.801347] TCP: tun0: Driver has suspect GRO implementation, TCP
> performance may be compromised.
> [   15.113626] ------------[ cut here ]------------
> [   15.115380] WARNING: CPU: 3 PID: 671 at net/core/stream.c:207
> sk_stream_kill_queues+0x104/0x130
> [   15.118527] Modules linked in: tun crct10dif_ce rfkill fuse
> [   15.120361] CPU: 3 PID: 671 Comm: packetdrill Not tainted 5.13.9-rc1 #1
> [   15.122587] Hardware name: linux,dummy-virt (DT)
> [   15.124123] pstate: 80000005 (Nzcv daif -PAN -UAO -TCO BTYPE=--)
> [   15.126117] pc : sk_stream_kill_queues+0x104/0x130
> [   15.127764] lr : inet_csk_destroy_sock+0x68/0x130
> [   15.129326] sp : ffff8000109f36d0
> [   15.130484] x29: ffff8000109f36d0 x28: 0000000000000005 x27: fffffffffffffff2
> [   15.132807] x26: 0000000000000001 x25: ffffa05141000900 x24: ffff6f1e0b51dc40
> [   15.136643] x23: 0000000000000000 x22: 0000000000000000 x21: ffff6f1e11e7e054
> [   15.139117] x20: ffff6f1e08a0dd30 x19: ffff6f1e08a0dc80 x18: 0000000000000000
> [   15.141494] x17: 0000000000000000 x16: 0000000000000000 x15: 00000000238ecea0
> [   15.143903] x14: 0000000000000000 x13: 000000000000dd86 x12: 000000007ffff000
> [   15.146292] x11: 0000000000000004 x10: 0000000000000000 x9 : ffffa051410d5148
> [   15.148660] x8 : 0000000000000000 x7 : ffffffffd3039400 x6 : 0000000000000202
> [   15.151071] x5 : ffff6f1e08a0dd00 x4 : 0000000000000004 x3 : 0000000000000007
> [   15.153435] x2 : ffff6f1e08a0e560 x1 : 0000000000000180 x0 : 00000000fffffe80
> [   15.155835] Call trace:
> [   15.156675]  sk_stream_kill_queues+0x104/0x130
> [   15.163667]  inet_csk_destroy_sock+0x68/0x130
> [   15.165139]  tcp_done+0x120/0x1b0
> [   15.166274]  tcp_reset+0x74/0x130
> [   15.167445]  tcp_validate_incoming+0x394/0x510
> [   15.168953]  tcp_rcv_state_process+0x2d8/0x15c0
> [   15.170512]  tcp_v4_do_rcv+0x15c/0x2d4
> [   15.171798]  tcp_v4_rcv+0x9c0/0xaa4
> [   15.173009]  ip_protocol_deliver_rcu+0x4c/0x184
> [   15.174597]  ip_local_deliver_finish+0x74/0x90
> [   15.176103]  ip_local_deliver+0x88/0x130
> [   15.177429]  ip_rcv+0x7c/0x130
> [   15.178512]  __netif_receive_skb_one_core+0x60/0x8c
> [   15.180143]  __netif_receive_skb+0x20/0x70
> [   15.181527]  netif_receive_skb+0x48/0x1e0
> [   15.182930]  tun_get_user+0xbe4/0xd70 [tun]
> [   15.184368]  tun_chr_write_iter+0x68/0xf0 [tun]
> [   15.185936]  do_iter_readv_writev+0x100/0x1a4
> [   15.187448]  do_iter_write+0x98/0x1fc
> [   15.188735]  vfs_writev+0xb4/0x170
> [   15.189956]  do_writev+0x7c/0x140
> [   15.191115]  __arm64_sys_writev+0x2c/0x40
> [   15.192481]  invoke_syscall+0x50/0x120
> [   15.193754]  el0_svc_common.constprop.0+0xf4/0x104
> [   15.195391]  do_el0_svc+0x34/0x9c
> [   15.196558]  el0_svc+0x2c/0x54
> [   15.197653]  el0_sync_handler+0xa4/0x130
> [   15.199054]  el0_sync+0x198/0x1c0
> [   15.200182] ---[ end trace c9faa1be6c93e4fb ]---
> [   15.201864] ------------[ cut here ]------------
> [   15.203404] WARNING: CPU: 3 PID: 671 at net/core/stream.c:208
> sk_stream_kill_queues+0x110/0x130
> [   15.206141] Modules linked in: tun crct10dif_ce rfkill fuse
> [   15.207976] CPU: 3 PID: 671 Comm: packetdrill Tainted: G        W
>       5.13.9-rc1 #1
> [   15.210542] Hardware name: linux,dummy-virt (DT)
> [   15.212029] pstate: 80000005 (Nzcv daif -PAN -UAO -TCO BTYPE=--)
> [   15.213947] pc : sk_stream_kill_queues+0x110/0x130
> [   15.215546] lr : inet_csk_destroy_sock+0x68/0x130
> [   15.217097] sp : ffff8000109f36d0
> [   15.218204] x29: ffff8000109f36d0 x28: 0000000000000005 x27: fffffffffffffff2
> [   15.220548] x26: 0000000000000001 x25: ffffa05141000900 x24: ffff6f1e0b51dc40
> [   15.223012] x23: 0000000000000000 x22: 0000000000000000 x21: ffff6f1e11e7e054
> [   15.225350] x20: ffff6f1e08a0dd30 x19: ffff6f1e08a0dc80 x18: 0000000000000000
> [   15.227705] x17: 0000000000000000 x16: 0000000000000000 x15: 00000000238ecea0
> [   15.230042] x14: 0000000000000000 x13: 000000000000dd86 x12: 000000007ffff000
> [   15.232454] x11: 0000000000000004 x10: 0000000000000000 x9 : ffffa051410d5148
> [   15.234896] x8 : 0000000000000000 x7 : ffffffffd3039400 x6 : 0000000000000202
> [   15.237544] x5 : ffff6f1e08a0dd00 x4 : 0000000000000004 x3 : 0000000000000007
> [   15.239933] x2 : ffff6f1e08a0e560 x1 : 0000000000000180 x0 : 0000000000000180
> [   15.242315] Call trace:
> [   15.243203]  sk_stream_kill_queues+0x110/0x130
> [   15.244721]  inet_csk_destroy_sock+0x68/0x130
> [   15.246191]  tcp_done+0x120/0x1b0
> [   15.247388]  tcp_reset+0x74/0x130
> [   15.248540]  tcp_validate_incoming+0x394/0x510
> [   15.250057]  tcp_rcv_state_process+0x2d8/0x15c0
> [   15.251636]  tcp_v4_do_rcv+0x15c/0x2d4
> [   15.252908]  tcp_v4_rcv+0x9c0/0xaa4
> [   15.254095]  ip_protocol_deliver_rcu+0x4c/0x184
> [   15.255643]  ip_local_deliver_finish+0x74/0x90
> [   15.257138]  ip_local_deliver+0x88/0x130
> [   15.258516]  ip_rcv+0x7c/0x130
> [   15.259573]  __netif_receive_skb_one_core+0x60/0x8c
> [   15.261561]  __netif_receive_skb+0x20/0x70
> [   15.263355]  netif_receive_skb+0x48/0x1e0
> [   15.264721]  tun_get_user+0xbe4/0xd70 [tun]
> [   15.266110]  tun_chr_write_iter+0x68/0xf0 [tun]
> [   15.267704]  do_iter_readv_writev+0x100/0x1a4
> [   15.269162]  do_iter_write+0x98/0x1fc
> [   15.270721]  vfs_writev+0xb4/0x170
> [   15.271948]  do_writev+0x7c/0x140
> [   15.273120]  __arm64_sys_writev+0x2c/0x40
> [   15.274527]  invoke_syscall+0x50/0x120
> [   15.275805]  el0_svc_common.constprop.0+0xf4/0x104
> [   15.277278]  do_el0_svc+0x34/0x9c
> [   15.278832]  el0_svc+0x2c/0x54
> [   15.280081]  el0_sync_handler+0xa4/0x130
> [   15.281614]  el0_sync+0x198/0x1c0
> [   15.282899] ---[ end trace c9faa1be6c93e4fc ]---
> [   15.284650] ------------[ cut here ]------------
> [   15.286116] WARNING: CPU: 3 PID: 671 at net/ipv4/af_inet.c:156
> inet_sock_destruct+0x190/0x1b0
> [   15.288999] Modules linked in: tun crct10dif_ce rfkill fuse
> [   15.290884] CPU: 3 PID: 671 Comm: packetdrill Tainted: G        W
>       5.13.9-rc1 #1
> [   15.294511] Hardware name: linux,dummy-virt (DT)
> [   15.296041] pstate: 60000005 (nZCv daif -PAN -UAO -TCO BTYPE=--)
> [   15.298073] pc : inet_sock_destruct+0x190/0x1b0
> [   15.299743] lr : __sk_destruct+0x38/0x23c
> [   15.301154] sp : ffff8000109f37c0
> [   15.302291] x29: ffff8000109f37c0 x28: 0000000000000005 x27: fffffffffffffff2
> [   15.304703] x26: 0000000000000001 x25: ffffa05141000900 x24: ffffa05142a8be80
> [   15.307100] x23: 0000000000000000 x22: ffff6f1e08a0dd08 x21: ffff6f1e08a0dc80
> [   15.309419] x20: ffff6f1e08a0dd30 x19: ffff6f1e08a0dc80 x18: 0000000000000000
> [   15.311764] x17: 0000000000000000 x16: 0000000000000000 x15: 00000000238ecea0
> [   15.314056] x14: 0000000000000000 x13: 000000000000dd86 x12: 000000007ffff000
> [   15.316392] x11: 0000000000000004 x10: 0000000000000000 x9 : ffffa05141003acc
> [   15.318680] x8 : 0000000000000000 x7 : ffffffffd3039400 x6 : ffff6f1e08a0ddbc
> [   15.320920] x5 : 0000000000000001 x4 : 0000000000000000 x3 : ffffceccfd9db000
> [   15.323197] x2 : ffff6f1e02c00810 x1 : 0000000000000180 x0 : 00000000fffffe80
> [   15.325465] Call trace:
> [   15.326270]  inet_sock_destruct+0x190/0x1b0
> [   15.327643]  __sk_destruct+0x38/0x23c
> [   15.328842]  __sk_free+0x80/0x120
> [   15.329923]  sk_free+0x68/0x90
> [   15.330941]  sock_put+0x5c/0x80
> [   15.331963]  tcp_v4_rcv+0xa40/0xaa4
> [   15.333091]  ip_protocol_deliver_rcu+0x4c/0x184
> [   15.334585]  ip_local_deliver_finish+0x74/0x90
> [   15.336000]  ip_local_deliver+0x88/0x130
> [   15.337273]  ip_rcv+0x7c/0x130
> [   15.338277]  __netif_receive_skb_one_core+0x60/0x8c
> [   15.339869]  __netif_receive_skb+0x20/0x70
> [   15.341221]  netif_receive_skb+0x48/0x1e0
> [   15.342558]  tun_get_user+0xbe4/0xd70 [tun]
> [   15.343929]  tun_chr_write_iter+0x68/0xf0 [tun]
> [   15.345395]  do_iter_readv_writev+0x100/0x1a4
> [   15.346831]  do_iter_write+0x98/0x1fc
> [   15.348025]  vfs_writev+0xb4/0x170
> [   15.349136]  do_writev+0x7c/0x140
> [   15.350224]  __arm64_sys_writev+0x2c/0x40
> [   15.351556]  invoke_syscall+0x50/0x120
> [   15.352789]  el0_svc_common.constprop.0+0xf4/0x104
> [   15.354335]  do_el0_svc+0x34/0x9c
> [   15.355451]  el0_svc+0x2c/0x54
> [   15.356460]  el0_sync_handler+0xa4/0x130
> [   15.357740]  el0_sync+0x198/0x1c0
> [   15.358861] ---[ end trace c9faa1be6c93e4fd ]---
> [   15.360555] ------------[ cut here ]------------
> [   15.361959] WARNING: CPU: 3 PID: 671 at net/ipv4/af_inet.c:157
> inet_sock_destruct+0x16c/0x1b0
> [   15.364603] Modules linked in: tun crct10dif_ce rfkill fuse
> [   15.366276] CPU: 3 PID: 671 Comm: packetdrill Tainted: G        W
>       5.13.9-rc1 #1
> [   15.373031] Hardware name: linux,dummy-virt (DT)
> [   15.377359] pstate: 60000005 (nZCv daif -PAN -UAO -TCO BTYPE=--)
> [   15.381502] pc : inet_sock_destruct+0x16c/0x1b0
> [   15.384348] lr : __sk_destruct+0x38/0x23c
> [   15.387724] sp : ffff8000109f37c0
> [   15.388842] x29: ffff8000109f37c0 x28: 0000000000000005 x27: fffffffffffffff2
> [   15.391840] x26: 0000000000000001 x25: ffffa05141000900 x24: ffffa05142a8be80
> [   15.394837] x23: 0000000000000000 x22: ffff6f1e08a0dd08 x21: ffff6f1e08a0dc80
> [   15.398292] x20: ffff6f1e08a0dd30 x19: ffff6f1e08a0dc80 x18: 0000000000000000
> [   15.401315] x17: 0000000000000000 x16: 0000000000000000 x15: 00000000238ecea0
> [   15.403655] x14: 0000000000000000 x13: 000000000000dd86 x12: 000000007ffff000
> [   15.405967] x11: 0000000000000004 x10: 0000000000000000 x9 : ffffa05141003acc
> [   15.408287] x8 : 0000000000000000 x7 : ffffffffd3039400 x6 : ffff6f1e08a0ddbc
> [   15.410616] x5 : 0000000000000001 x4 : 0000000000000000 x3 : ffffceccfd9db000
> [   15.412969] x2 : ffff6f1e02c00810 x1 : 0000000000000180 x0 : 0000000000000180
> [   15.415332] Call trace:
> [   15.416187]  inet_sock_destruct+0x16c/0x1b0
> [   15.417551]  __sk_destruct+0x38/0x23c
> [   15.418793]  __sk_free+0x80/0x120
> [   15.419886]  sk_free+0x68/0x90
> [   15.420916]  sock_put+0x5c/0x80
> [   15.421974]  tcp_v4_rcv+0xa40/0xaa4
> [   15.423182]  ip_protocol_deliver_rcu+0x4c/0x184
> [   15.424649]  ip_local_deliver_finish+0x74/0x90
> [   15.426214]  ip_local_deliver+0x88/0x130
> [   15.427869]  ip_rcv+0x7c/0x130
> [   15.428884]  __netif_receive_skb_one_core+0x60/0x8c
> [   15.430545]  __netif_receive_skb+0x20/0x70
> [   15.432679]  netif_receive_skb+0x48/0x1e0
> [   15.435651]  tun_get_user+0xbe4/0xd70 [tun]
> [   15.437662]  tun_chr_write_iter+0x68/0xf0 [tun]
> [   15.439835]  do_iter_readv_writev+0x100/0x1a4
> [   15.441836]  do_iter_write+0x98/0x1fc
> [   15.443588]  vfs_writev+0xb4/0x170
> [   15.445150]  do_writev+0x7c/0x140
> [   15.446713]  __arm64_sys_writev+0x2c/0x40
> [   15.448639]  invoke_syscall+0x50/0x120
> [   15.450373]  el0_svc_common.constprop.0+0xf4/0x104
> [   15.452642]  do_el0_svc+0x34/0x9c
> [   15.454230]  el0_svc+0x2c/0x54
> [   15.455743]  el0_sync_handler+0xa4/0x130
> [   15.457486]  el0_sync+0x198/0x1c0
> [   15.458659] ---[ end trace c9faa1be6c93e4fe ]---
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> --
> Linaro LKFT
> https://lkft.linaro.org


