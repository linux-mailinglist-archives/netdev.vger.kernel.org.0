Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7AB98EFB7
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 17:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730892AbfHOPrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 11:47:20 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:33743 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730805AbfHOPrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 11:47:20 -0400
Received: by mail-qk1-f193.google.com with SMTP id w18so1487792qki.0;
        Thu, 15 Aug 2019 08:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aZ6hbRSCANeTnY5EeSQItDTdFbcRAVg51vQth/ZCCRg=;
        b=rNusa0NrKS1LrFOUPj6tzQdh9Z3FrEeZqc8h4yEMvCtDWwn+M5waX8r6DRYyrmNJdZ
         Jw42Kh5zIWnriTxgrC0I/8V1wLlh+A37Zi868ky5EGfrcefYJQwep9SSBIPApGnYXwRU
         eW+tiMOTmUHxbb0/Yl/SPb5ST9YokBDCEeuSgnKWHYEhjnPGgkBv2W++Ur+I580TCT71
         CNH7+M6l0a8UP7xl5HVI8rqi25BvSAJ1gv9nPKB02ARNGi7kt+fu/QWSTqLxW0U5J4mF
         DYXyQ680bfgy6aSZbYP1rcGdkHu5XWJYg2j11D/tgH7IKlxlDXJjEN3MsbiZkcrq+pr8
         2pSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aZ6hbRSCANeTnY5EeSQItDTdFbcRAVg51vQth/ZCCRg=;
        b=uhPIvzh5H6eR7Piz/SHD/fIPZYyN/BSaKx4ZoU6jAJYv7Z2wa9KTRnEWk4IcIqbqhX
         DmSt5uMc9l9QG7BJIsZah+Hk369pqFmMGEb5m+N244o++jrIaCL4hYCIKQqtxrlO3goD
         jjv0CCH67KO343OvxiTX9oz9W4ztpJ+bYl+Almmt0W3HVJlgLsPBNgcrsBRhl7zJ/rtP
         jbJfXrYIfaNnqSSqnONl4Tim7poXHuGj2HHh6HhAX87fKsoxkKfB245QxR954oWlK/cx
         0l1/yVG8OZ2LDqCAxtKBffb3iQ5T3uAyaYx1RJpNxfg2N7+2lsmGujL9KXrloIcqM6bG
         js1g==
X-Gm-Message-State: APjAAAVIkmisZcO1YCicjEJuqS8Sgo63RTlIEX4LO3zv8ATw7zGAx0v9
        2mlRZxUSdPluhuVzsy9cDEyk6HC/ZKwOB7Uw4vk=
X-Google-Smtp-Source: APXvYqzNqDZQ0G+812Hbi1dOExuIFXXaE5X7cbA3ImWwT+0BfLLKwSv4cS2nHSVsh4dqr4JI1ISVHBcuTr0uTpEMUuM=
X-Received: by 2002:a37:a492:: with SMTP id n140mr4382980qke.137.1565884039270;
 Thu, 15 Aug 2019 08:47:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190813120558.6151-1-toshiaki.makita1@gmail.com>
In-Reply-To: <20190813120558.6151-1-toshiaki.makita1@gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Thu, 15 Aug 2019 08:46:41 -0700
Message-ID: <CALDO+SYC4sPw-7iDkFMCD=kf2UnTW2qc0m6Kgz41zLmNNxQ+Ww@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 00/14] xdp_flow: Flow offload to XDP
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 13, 2019 at 5:07 AM Toshiaki Makita
<toshiaki.makita1@gmail.com> wrote:
>
> This is a rough PoC for an idea to offload TC flower to XDP.
>
>
> * Motivation
>
> The purpose is to speed up software TC flower by using XDP.
>
> I chose TC flower because my current interest is in OVS. OVS uses TC to
> offload flow tables to hardware, so if TC can offload flows to XDP, OVS
> also can be offloaded to XDP.
>
> When TC flower filter is offloaded to XDP, the received packets are
> handled by XDP first, and if their protocol or something is not
> supported by the eBPF program, the program returns XDP_PASS and packets
> are passed to upper layer TC.
>
> The packet processing flow will be like this when this mechanism,
> xdp_flow, is used with OVS.
>
>  +-------------+
>  | openvswitch |
>  |    kmod     |
>  +-------------+
>         ^
>         | if not match in filters (flow key or action not supported by TC)
>  +-------------+
>  |  TC flower  |
>  +-------------+
>         ^
>         | if not match in flow tables (flow key or action not supported by XDP)
>  +-------------+
>  |  XDP prog   |
>  +-------------+
>         ^
>         | incoming packets
>
I like this idea, some comments about the OVS AF_XDP work.

Another way when using OVS AF_XDP is to serve as slow path of TC flow
HW offload.
For example:

 Userspace OVS datapath (The one used by OVS-DPDK)
     ^
      |
  +------------------------------+
  |  OVS AF_XDP netdev |
  +------------------------------+
         ^
         | if not supported or not match in flow tables
  +---------------------+
  |  TC HW flower  |
  +---------------------+
         ^
         | incoming packets

So in this case it's either TC HW flower offload, or the userspace PMD OVS.
Both cases should be pretty fast.

I think xdp_flow can also be used by OVS AF_XDP netdev, sitting between
TC HW flower and OVS AF_XDP netdev.
Before the XDP program sending packet to AF_XDP socket, the
xdp_flow can execute first, and if not match, then send to AF_XDP.
So in your patch set, implement s.t like
  bpf_redirect_map(&xsks_map, index, 0);

Another thing is that at each layer we are doing its own packet parsing.
From your graph, first parse at XDP program, then at TC flow, then at
openvswitch kmod.
I wonder if we can reuse some parsing result.

Regards,
William

> This is useful especially when the device does not support HW-offload.
> Such interfaces include virtual interfaces like veth.
>
>
> * How to use
>
> It only supports ingress (clsact) flower filter at this point.
> Enable the feature via ethtool before adding ingress/clsact qdisc.
>
>  $ ethtool -K eth0 tc-offload-xdp on
>
> Then add qdisc/filters as normal.
>
>  $ tc qdisc add dev eth0 clsact
>  $ tc filter add dev eth0 ingress protocol ip flower skip_sw ...
>
> Alternatively, when using OVS, adding qdisc and filters will be
> automatically done by setting hw-offload.
>
>  $ ovs-vsctl set Open_vSwitch . other_config:hw-offload=true
>  $ systemctl stop openvswitch
>  $ tc qdisc del dev eth0 ingress # or reboot
>  $ ethtool -K eth0 tc-offload-xdp on
>  $ systemctl start openvswitch
>
>
> * Performance
>
> I measured drop rate at veth interface with redirect action from physical
> interface (i40e 25G NIC, XXV 710) to veth. The CPU is Xeon Silver 4114
> (2.20 GHz).
>                                                                  XDP_DROP
>                     +------+                        +-------+    +-------+
>  pktgen -- wire --> | eth0 | -- TC/OVS redirect --> | veth0 |----| veth1 |
>                     +------+   (offloaded to XDP)   +-------+    +-------+
>
> The setup for redirect is done by OVS like this.
>
>  $ ovs-vsctl add-br ovsbr0
>  $ ovs-vsctl add-port ovsbr0 eth0
>  $ ovs-vsctl add-port ovsbr0 veth0
>  $ ovs-vsctl set Open_vSwitch . other_config:hw-offload=true
>  $ systemctl stop openvswitch
>  $ tc qdisc del dev eth0 ingress
>  $ tc qdisc del dev veth0 ingress
>  $ ethtool -K eth0 tc-offload-xdp on
>  $ ethtool -K veth0 tc-offload-xdp on
>  $ systemctl start openvswitch
>
> Tested single core/single flow with 3 configurations.
> - xdp_flow: hw-offload=true, tc-offload-xdp on
> - TC:       hw-offload=true, tc-offload-xdp off (software TC)
> - ovs kmod: hw-offload=false
>
>  xdp_flow  TC        ovs kmod
>  --------  --------  --------
>  4.0 Mpps  1.1 Mpps  1.1 Mpps
>
> So xdp_flow drop rate is roughly 4x faster than software TC or ovs kmod.
>
> OTOH the time to add a flow increases with xdp_flow.
>
> ping latency of first packet when veth1 does XDP_PASS instead of DROP:
>
>  xdp_flow  TC        ovs kmod
>  --------  --------  --------
>  25ms      12ms      0.6ms
>
> xdp_flow does a lot of work to emulate TC behavior including UMH
> transaction and multiple bpf map update from UMH which I think increases
> the latency.
>
>
> * Implementation
>
> xdp_flow makes use of UMH to load an eBPF program for XDP, similar to
> bpfilter. The difference is that xdp_flow does not generate the eBPF
> program dynamically but a prebuilt program is embedded in UMH. This is
> mainly because flow insertion is considerably frequent. If we generate
> and load an eBPF program on each insertion of a flow, the latency of the
> first packet of ping in above test will incease, which I want to avoid.
>
>                          +----------------------+
>                          |    xdp_flow_umh      | load eBPF prog for XDP
>                          | (eBPF prog embedded) | update maps for flow tables
>                          +----------------------+
>                                    ^ |
>                            request | v eBPF prog id
>  +-----------+  offload  +-----------------------+
>  | TC flower | --------> |    xdp_flow kmod      | attach the prog to XDP
>  +-----------+           | (flow offload driver) |
>                          +-----------------------+
>
> - When ingress/clsact qdisc is created, i.e. a device is bound to a flow
>   block, xdp_flow kmod requests xdp_flow_umh to load eBPF prog.
>   xdp_flow_umh returns prog id and xdp_flow kmod attach the prog to XDP
>   (the reason of attaching XDP from kmod is that rtnl_lock is held here).
>
> - When flower filter is added, xdp_flow kmod requests xdp_flow_umh to
>   update maps for flow tables.
>
>
> * Patches
>
> - patch 1
>  Basic framework for xdp_flow kmod and UMH.
>
> - patch 2
>  Add prebuilt eBPF program embedded in UMH.
>
> - patch 3, 4
>  Attach the prog to XDP in kmod after using the prog id returned from
>  UMH.
>
> - patch 5, 6
>  Add maps for flow tables and flow table manipulation logic in UMH.
>
> - patch 7
>  Implement flow lookup and basic actions in eBPF prog.
>
> - patch 8
>  Implement flow manipulation logic, serialize flow key and actions from
>  TC flower and make requests to UMH in kmod.
>
> - patch 9
>  Add tc-offload-xdp netdev feature and hooks to call xdp_flow kmod in
>  TC flower offload code.
>
> - patch 10, 11
>  Add example actions, redirect and vlan_push.
>
> - patch 12
>  Add testcase for xdp_flow.
>
> - patch 13, 14
>  These are unrelated patches. They just improves XDP program's
>  performance. They are included to demonstrate to what extent xdp_flow
>  performance can increase. Without them, drop rate goes down from 4Mpps
>  to 3Mpps.
>
>
> * About OVS AF_XDP netdev
>
> Recently OVS has added AF_XDP netdev type support. This also makes use
> of XDP, but in some ways different from this patch set.
>
> - AF_XDP work originally started in order to bring BPF's flexibility to
>   OVS, which enables us to upgrade datapath without updating kernel.
>   AF_XDP solution uses userland datapath so it achieved its goal.
>   xdp_flow will not replace OVS datapath completely, but offload it
>   partially just for speed up.
>
> - OVS AF_XDP requires PMD for the best performance so consumes 100% CPU.
>
> - OVS AF_XDP needs packet copy when forwarding packets.
>
> - xdp_flow can be used not only for OVS. It works for direct use of TC
>   flower. nftables also can be offloaded by the same mechanism in the
>   future.
>
>
> * About alternative userland (ovs-vswitchd etc.) implementation
>
> Maybe a similar logic can be implemented in ovs-vswitchd offload
> mechanism, instead of adding code to kernel. I just thought offloading
> TC is more generic and allows wider usage with direct TC command.
>
> For example, considering that OVS inserts a flow to kernel only when
> flow miss happens in kernel, we can in advance add offloaded flows via
> tc filter to avoid flow insertion latency for certain sensitive flows.
> TC flower usage without using OVS is also possible.
>
> Also as written above nftables can be offloaded to XDP with this
> mechanism as well.
>
>
> * Note
>
> This patch set is based on top of commit a664a834579a ("tools: bpftool:
> fix reading from /proc/config.gz").
>
> Any feedback is welcome.
> Thanks!
>
> Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
>
> Toshiaki Makita (14):
>   xdp_flow: Add skeleton of XDP based TC offload driver
>   xdp_flow: Add skeleton bpf program for XDP
>   bpf: Add API to get program from id
>   xdp_flow: Attach bpf prog to XDP in kernel after UMH loaded program
>   xdp_flow: Prepare flow tables in bpf
>   xdp_flow: Add flow entry insertion/deletion logic in UMH
>   xdp_flow: Add flow handling and basic actions in bpf prog
>   xdp_flow: Implement flow replacement/deletion logic in xdp_flow kmod
>   xdp_flow: Add netdev feature for enabling TC flower offload to XDP
>   xdp_flow: Implement redirect action
>   xdp_flow: Implement vlan_push action
>   bpf, selftest: Add test for xdp_flow
>   i40e: prefetch xdp->data before running XDP prog
>   bpf, hashtab: Compare keys in long
>
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c  |    1 +
>  include/linux/bpf.h                          |    6 +
>  include/linux/netdev_features.h              |    2 +
>  include/linux/netdevice.h                    |    4 +
>  include/net/flow_offload_xdp.h               |   33 +
>  include/net/pkt_cls.h                        |    5 +
>  include/net/sch_generic.h                    |    1 +
>  kernel/bpf/hashtab.c                         |   27 +-
>  kernel/bpf/syscall.c                         |   26 +-
>  net/Kconfig                                  |    1 +
>  net/Makefile                                 |    1 +
>  net/core/dev.c                               |   13 +-
>  net/core/ethtool.c                           |    1 +
>  net/sched/cls_api.c                          |   67 +-
>  net/xdp_flow/.gitignore                      |    1 +
>  net/xdp_flow/Kconfig                         |   16 +
>  net/xdp_flow/Makefile                        |  112 +++
>  net/xdp_flow/msgfmt.h                        |  102 +++
>  net/xdp_flow/umh_bpf.h                       |   34 +
>  net/xdp_flow/xdp_flow_core.c                 |  126 ++++
>  net/xdp_flow/xdp_flow_kern_bpf.c             |  358 +++++++++
>  net/xdp_flow/xdp_flow_kern_bpf_blob.S        |    7 +
>  net/xdp_flow/xdp_flow_kern_mod.c             |  645 ++++++++++++++++
>  net/xdp_flow/xdp_flow_umh.c                  | 1034 ++++++++++++++++++++++++++
>  net/xdp_flow/xdp_flow_umh_blob.S             |    7 +
>  tools/testing/selftests/bpf/Makefile         |    1 +
>  tools/testing/selftests/bpf/test_xdp_flow.sh |  103 +++
>  27 files changed, 2716 insertions(+), 18 deletions(-)
>  create mode 100644 include/net/flow_offload_xdp.h
>  create mode 100644 net/xdp_flow/.gitignore
>  create mode 100644 net/xdp_flow/Kconfig
>  create mode 100644 net/xdp_flow/Makefile
>  create mode 100644 net/xdp_flow/msgfmt.h
>  create mode 100644 net/xdp_flow/umh_bpf.h
>  create mode 100644 net/xdp_flow/xdp_flow_core.c
>  create mode 100644 net/xdp_flow/xdp_flow_kern_bpf.c
>  create mode 100644 net/xdp_flow/xdp_flow_kern_bpf_blob.S
>  create mode 100644 net/xdp_flow/xdp_flow_kern_mod.c
>  create mode 100644 net/xdp_flow/xdp_flow_umh.c
>  create mode 100644 net/xdp_flow/xdp_flow_umh_blob.S
>  create mode 100755 tools/testing/selftests/bpf/test_xdp_flow.sh
>
> --
> 1.8.3.1
>
