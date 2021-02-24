Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2C16323655
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 05:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbhBXD7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 22:59:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbhBXD7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 22:59:41 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41A04C061574
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 19:59:01 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id o38so605055pgm.9
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 19:59:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=ev4Ew4D4rqUBZBk3kpHXOiH4NVllFUjoq6unX1l+lcI=;
        b=yXnOs3/4dsq4IQAEcxTXHK4imCsOj39y2KmCiyQVxUK+NuPJ7qMn12M1QrAYPMApoZ
         GdBwtAa4lRtSyyTTZ4guzW7ghvVja4qenagq1iz1E5KYFHMwf22CNbCzxOErJZ8CbZJS
         +LseSNyS40fj5pTa05FTIf2wOt30M7eBH4y+iKAzyoBsZ3MmvuyqW5q/ASnZW5rqHIGL
         rNtK+ezQWZpDxfLyO70A5tkcs9MGN8eRhqPSPo3zE5k0tNJbgfbziZ0xqBaOUT5lQGFb
         9om0+jtuy/5AmGWamIN2vk859Qx3QFT96cK4AyjLBdgOCrb+FZQqONSM9EHOYtwVop5+
         RvtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=ev4Ew4D4rqUBZBk3kpHXOiH4NVllFUjoq6unX1l+lcI=;
        b=FJHufkG3yYvbA0TrunYuT4DODgOmmw8jW0+H6x7K2mCEr8Emw4onQVY6L1d+MzjRiw
         thqNOwvMny/ihfSh+677KIBcfVi66mO/axW9CFajnv7vql6OOtS8cgUMUp4a0xTPGBMg
         nKod7q1jpSdXGAfbcOSTXmoWIe0gLzytl+L+YwkbZBvQkBGuHt910PaeEl390VH7nck/
         P8GwG/zlhb3w0l7Pr6ZFwTsvOA6HTwKwhO26nNPRMzVLoWgKKfXyPA+6R7q2q1yWiQPo
         J2bCPa8U224w7mEnhD2ckWPKbGONJCWSHTWAFFYOHQaBNNyr2Wc1rbqLIy2RUzp2q/+3
         ltQg==
X-Gm-Message-State: AOAM531EjJv6Ks2ITiD/N0nPyQCs5G0FL+LTthSsTSQlFwMtjy/rwT5z
        R+5Ug3UpoEoUDlDmt1cUIat1NYx/vFkbTw==
X-Google-Smtp-Source: ABdhPJwIgluKrZ+PH5+2ttDwhCR07WBa9j/ZtXFxcGlavPWBDu85cgoZoTIHjf2ZEy6HoA8W26Brpg==
X-Received: by 2002:a62:768e:0:b029:1ed:e31a:f71b with SMTP id r136-20020a62768e0000b02901ede31af71bmr3453329pfc.66.1614139140180;
        Tue, 23 Feb 2021 19:59:00 -0800 (PST)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id w187sm655942pfb.208.2021.02.23.19.58.59
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 19:58:59 -0800 (PST)
Date:   Tue, 23 Feb 2021 19:58:57 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: [ANNOUNCE] iproute2 5.11 release
Message-ID: <20210223195857.3de03c2a@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After weather delays, here is the new version of iproute2 to go
with the 5.11 kernel. Most of the changes in this release are updates
for new functionality for Data Center Bridging (dcb) utility.
Also several updates for bridge, and devlink.

Note: iproute2 is now maintained on the "main" branch.
There are parallel copies (both updated) on kernel.org and github.

As always, it is recommended to always use the latest iproute2.
Do not treat iproute2 like perf and require matching packages.
The latest code will always run on older kernels (and vice versa);
this is possible because of the kernel API/ABI guarantees.
Except for rare cases, iproute2 does not do maintenance releases
and there is no long term stable version.

Download:
    https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-5.11.0.tar.gz

Repository for current release
    https://github.com/shemminger/iproute2.git
    git://git.kernel.org/pub/scm/network/iproute2/iproute2.git

And future release (net-next):
    git://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git

Thanks for all the contributions.

Report problems (or enhancements) to the netdev@vger.kernel.org mailing list.

Andrea Claudi (6):
      tc: m_gate: use SPRINT_BUF when needed
      ip: lwtunnel: seg6: bail out if table ids are invalid
      lib/namespace: fix ip -all netns return code
      lib/bpf: Fix and simplify bpf_mnt_check_target()
      lib/fs: avoid double call to mkdir on make_path()
      lib/fs: Fix single return points for get_cgroup2_*

David Ahern (4):
      Update kernel headers
      Update kernel headers
      Only compile mnl_utils when HAVE_MNL is defined
      Update kernel headers

Edwin Peer (1):
      iplink: print warning for missing VF data

Guillaume Nault (3):
      testsuite: Add mpls packet matching tests for tc flower
      tc: flower: fix json output with mpls lse
      iplink_bareudp: cleanup help message and man page

Hangbin Liu (5):
      iproute2: add check_libbpf() and get_libbpf_version()
      lib: make ipvrf able to use libbpf and fix function name conflicts
      lib: add libbpf support
      examples/bpf: move struct bpf_elf_map defined maps to legacy folder
      examples/bpf: add bpf examples with BTF defined maps

Ido Kalir (1):
      rdma: Fix statistics bind/unbing argument handling

Ido Schimmel (2):
      ip route: Print "trap" nexthop indication
      nexthop: Always print nexthop flags

Luca Boccassi (4):
      Add dcb/.gitignore
      vrf: print BPF log buffer if bpf_program_load fails
      vrf: fix ip vrf exec with libbpf
      iproute: force rtm_dst_len to 32/128

Moshe Shemesh (3):
      devlink: Add devlink reload action and limit options
      devlink: Add pr_out_dev() helper function
      devlink: Add reload stats to dev show

Paolo Abeni (1):
      ss: do not emit warn while dumping MPTCP on old kernels

Paolo Lungaroni (1):
      seg6: add support for vrftable attribute in SRv6 End.DT4/DT6 behaviors

Petr Machata (39):
      Unify batch processing across tools
      lib: Add parse_one_of(), parse_on_off()
      lib: json_print: Add print_on_off()
      lib: Extract from devlink/mnlg a helper, mnlu_socket_open()
      lib: Extract from devlink/mnlg a helper, mnlu_msg_prepare()
      lib: Extract from devlink/mnlg a helper, mnlu_socket_recv_run()
      lib: Extract from iplink_vlan a helper to parse key:value arrays
      lib: parse_mapping: Update argc, argv on error
      lib: parse_mapping: Recognize a keyword "all"
      Add skeleton of a new tool, dcb
      dcb: Add a subtool for the DCB ETS object
      bridge: link: Port over to parse_on_off()
      bridge: link: Convert to use print_on_off()
      ip: iplink: Convert to use parse_on_off()
      ip: iplink_bridge_slave: Port over to parse_on_off()
      ip: iplink_bridge_slave: Convert to use print_on_off()
      ip: ipnetconf: Convert to use print_on_off()
      ip: iptuntap: Convert to use print_on_off()
      Move the use_iec declaration to the tools
      lib: Move print_rate() from tc here; modernize
      lib: Move sprint_size() from tc here, add print_size()
      lib: sprint_size(): Uncrustify the code a bit
      lib: print_color_rate(): Fix formatting small rates in IEC mode
      lib: Move get_rate(), get_rate64() from tc here
      lib: Move get_size() from tc here
      dcb: Remove unsupported command line arguments from getopt_long()
      dcb: ets: Fix help display for "show" subcommand
      dcb: ets: Change the way show parameters are given in synopsis
      man: dcb-ets: Remove an unnecessary empty line
      dcb: Add dcb_set_u32(), dcb_set_u64()
      dcb: Add -s to enable statistics
      dcb: Add -i to enable IEC mode
      dcb: Add a subtool for the DCB PFC object
      dcb: Add a subtool for the DCB buffer object
      dcb: Add a subtool for the DCB maxrate object
      include: uapi: Carry dcbnl.h
      dcb: Set values with RTM_SETDCB type
      dcb: Plug a leaking DCB socket buffer
      dcb: Change --Netns/-N to --netns/-n

Roi Dayan (2):
      tc flower: fix parsing vlan_id and vlan_prio
      build: Fix link errors on some systems

Sergey Ryazanov (1):
      ip: add IP_LIB_DIR environment variable

Stephen Hemminger (4):
      uapi: update kernel headers to 5.11 pre rc1
      uapi: update if_link.h from upstream
      uapi: pick up rpl.h fix
      v5.11.0

Thayne McCombs (2):
      Add documentation of ss filter to man page
      ss: Add clarification about host conditions with multiple familes to man

Thomas Karlsson (1):
      iplink:macvlan: Added bcqueuelen parameter

Vlad Buslov (4):
      tc: skip actions that don't have options attribute when printing
      tc: implement support for terse dump
      tc: use TCA_ACT_ prefix for action flags
      tc: implement support for action terse dump

Vladimir Oltean (8):
      bridge: add support for L2 multicast groups
      man: tc-taprio.8: document the full offload feature
      man8/bridge.8: document the "permanent" flag for "bridge fdb add"
      man8/bridge.8: document that "local" is default for "bridge fdb add"
      man8/bridge.8: explain what a local FDB entry is
      man8/bridge.8: fix which one of self/master is default for "bridge fdb"
      man8/bridge.8: explain self vs master for "bridge fdb add"
      man8/bridge.8: be explicit that "flood" is an egress setting

Zahari Doychev (1):
      tc flower: use right ethertype in icmp/arp parsing

