Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 913D648A3AF
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 00:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345124AbiAJXc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 18:32:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344346AbiAJXc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 18:32:27 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26063C061748
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 15:32:27 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id l10-20020a17090a384a00b001b22190e075so1487656pjf.3
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 15:32:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=AQDP9Fcd2KVxZ0Nj5aAYX7LJm7+STr5HL9lGGG5CJfw=;
        b=BHlbFifazYmFybBgFkcnTDrCI5Bk9eRIs1Veene/ahSg9kHjb0JFSHsOH9gz1rELrJ
         GZP3uYqgH/L9BfYIkpq/Nj6J9psuGnc70M1wG9BqtgpxDroMNySlmmJQZ1NTAarU3gRZ
         eozcbY98j2JrWyiJ5qs3idBr4a2y6CNDMZ9oddRGKSg0W5Zw1X6CtctbKb6Ntq9mcd4Y
         elDckoAJ9EFErpdiDdzV4NjbIudJs5Xd4MWSLJFomyLLqYMui2KG1VW/1HUQCpqbm/LJ
         879MRzAqfXwUrYLsQM9JfToCcsIA0Mv8WJ+PhJ5Zn4ImszBFfXL5gGMPCMqkiUij7Plj
         Dy/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=AQDP9Fcd2KVxZ0Nj5aAYX7LJm7+STr5HL9lGGG5CJfw=;
        b=Sj3jlgD0MFEtEvQ+q31RzD3XUXT1u1JIAxC3gzlYs5Oe7oPD0Vu9Sp8d6n8R+GO8Y2
         qRBOuGvJKOF1xoDq2Ccm5zNiYyMqHaMUM6HMaOd3MPnPqxW87tAbj8V17gMG13LVuqUb
         qiVpxjJWZ/mXIXN60qsZSgErkuTrJGMrW9pMSH6PR3pP292zFtS8h9mWD9ukmlqCcO6V
         slf/HfdBGRinYtl2ey3ANu88l7E7v0Udtmws3jkZgdwHtLJRQfIYK0TmooZbrdr3ypqD
         YxfVPbiwuI8lf+vyhRPr8poY4VRmUBFDHwGoGCyNULbygCGbTArplCe9gLf3pTr810pY
         Hv7w==
X-Gm-Message-State: AOAM5327HHVh+3zYH78/+WWM+QRI6BTIdNAcWkFNYfU0kl+Hu/01fnXo
        XJwHXfTyKiRKM3EJWHQ5iNEbeC1Bu+c3Ug==
X-Google-Smtp-Source: ABdhPJz2mYB+dM6EL5liJQIX/Zq8rixYKP4+Yz48E+RZrynl67f5ikz/2nXYGLunvIu9GXyn/v3PTg==
X-Received: by 2002:a17:90a:191a:: with SMTP id 26mr179017pjg.50.1641857546344;
        Mon, 10 Jan 2022 15:32:26 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id y29sm8304517pfa.54.2022.01.10.15.32.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 15:32:26 -0800 (PST)
Date:   Mon, 10 Jan 2022 15:32:23 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] iproute2 5.16
Message-ID: <20220110153223.253e1954@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

New year, new version of iproute2. This update is larger than normal
with changes to bridge and ip nexthop support.

     As always, it is recommended to always use the latest iproute2.
     Do not treat iproute2 like perf and require matching packages.
     The latest code will always run on older kernels (and vice versa);
     this is possible because of the kernel API/ABI guarantees.
     Except for rare cases, iproute2 does not do maintenance releases
     and there is no long term stable version.

Download:
    https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-5.16.0.tar.gz

Repository for current release
    https://github.com/shemminger/iproute2.git
    git://git.kernel.org/pub/scm/network/iproute2/iproute2.git

And future release (net-next):
    git://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git

Contributions:

Andrea Claudi (8):
      configure: fix parsing issue on include_dir option
      configure: fix parsing issue on libbpf_dir option
      configure: fix parsing issue with more than one value per option
      configure: simplify options parsing
      configure: support --param=value style
      configure: add the --prefix option
      configure: add the --libdir option
      testsuite: Fix tc/vlan.t test

Anssi Hannula (1):
      man: tc-u32: Fix page to match new firstfrag behavior

Daniel Borkmann (3):
      ip, neigh: Fix up spacing in netlink dump
      ip, neigh: Add missing NTF_USE support
      ip, neigh: Add NTF_EXT_MANAGED support

David Ahern (8):
      Update kernel headers
      Import ioam6 uapi headers
      Update kernel headers
      Update kernel headers
      Update kernel headers
      Update kernel headers
      Update kernel headers
      Import amt.h

Davide Caratti (1):
      mptcp: fix JSON output when dumping endpoints by id

Gokul Sivakumar (2):
      ipneigh: add support to print brief output of neigh cache in tabular format
      lib: bpf_legacy: add prog name, load time, uid and btf id in prog info dump

Hangbin Liu (1):
      ip/bond: add lacp active support

Ilya Dmitrichenko (1):
      ip/tunnel: always print all known attributes

Jacob Keller (1):
      devlink: print maximum number of snapshots if available

Justin Iurman (6):
      Add, show, link, remove IOAM namespaces and schemas
      New IOAM6 encap type for routes
      IOAM man8
      ipioam6: use print_nl instead of print_null
      Add support for IOAM encap modes
      Update documentation

Lahav Schlesinger (1):
      ip: Support filter links/neighs with no master

Lennert Buytenhek (1):
      man: ip-macsec: fix gcm-aes-256 formatting issue

Luca Boccassi (1):
      Fix some typos detected by Lintian in manpages

Maxim Petrov (3):
      tc/m_vlan: fix print_vlan() conditional on TCA_VLAN_ACT_PUSH_ETH
      lib/bpf_legacy: remove always-true check
      ip/ipnexthop: fix unsigned overflow in parse_nh_group_type_res()

Moshe Shemesh (1):
      devlink: Fix cmd_dev_param_set() to check configuration mode

Neta Ostrovsky (3):
      rdma: Update uapi headers
      rdma: Add stat "mode" support
      rdma: Add optional-counters set/unset support

Nicolas Dichtel (2):
      iplink: enable to specify index when changing netns
      xfrm: enable to manage default policies

Nikolay Aleksandrov (34):
      ip: bridge: add support for mcast_vlan_snooping
      bridge: vlan: factor out vlan option printing
      bridge: vlan: skip unknown attributes when printing options
      bridge: vlan: add support to show global vlan options
      bridge: vlan: add support for vlan filtering when dumping options
      bridge: vlan: add support to set global vlan options
      bridge: vlan: add global mcast_snooping option
      bridge: vlan: add global mcast_igmp_version option
      bridge: vlan: add global mcast_mld_version option
      bridge: vlan: add global mcast_last_member_count option
      bridge: vlan: add global mcast_startup_query_count option
      bridge: vlan: add global mcast_last_member_interval option
      bridge: vlan: add global mcast_membership_interval option
      bridge: vlan: add global mcast_querier_interval option
      bridge: vlan: add global mcast_query_interval option
      bridge: vlan: add global mcast_query_response_interval option
      bridge: vlan: add global mcast_startup_query_interval option
      bridge: vlan: add global mcast_querier option
      bridge: vlan: add support for dumping router ports
      bridge: vlan: set vlan option attributes while parsing
      bridge: vlan: add support for mcast_router option
      ip: print_rta_if takes ifindex as device argument instead of attribute
      ip: export print_rta_gateway version which outputs prepared gateway string
      ip: nexthop: add resilient group structure
      ip: nexthop: split print_nh_res_group into parse and print parts
      ip: nexthop: add nh entry structure
      ip: nexthop: parse attributes into nh entry structure before printing
      ip: nexthop: factor out print_nexthop's nh entry printing
      ip: nexthop: factor out ipnh_get_id rtnl talk into a helper
      ip: nexthop: add cache helpers
      ip: nexthop: add a helper which retrieves and prints cached nh entry
      ip: route: print and cache detailed nexthop information when requested
      ip: nexthop: add print_cache_nexthop which prints and manages the nh cache
      ip: nexthop: keep cache netlink socket open

Paul Blakey (1):
      tc: flower: Fix buffer overflow on large labels

Paul Chaignon (1):
      lib/bpf: fix verbose flag when using libbpf

Peilin Ye (1):
      tc/skbmod: Introduce SKBMOD_F_ECN option

Ralf Baechle (6):
      AX.25: Add ax25_ntop implementation.
      AX.25: Print decoded addresses rather than hex numbers.
      NETROM: Add netrom_ntop implementation.
      NETROM: Print decoded addresses rather than hex numbers.
      ROSE: Add rose_ntop implementation.
      ROSE: Print decoded addresses rather than hex numbers.

Stephen Hemminger (11):
      ip: remove old rtpr script
      ip: remove ifcfg script
      ip: remove routef script
      ip: rewrite routel in python
      mptcp: cleanup include section.
      uapi: update vdpa.h
      vdpa: align uapi headers
      rdma: update uapi headers
      uapi: update to if_ether.h
      uapi: update to mptcp.h
      v5.16.0

Taehee Yoo (1):
      ip: add AMT support

Vincent Mailhol (5):
      iplink_can: fix configuration ranges in print_usage() and add unit
      iplink_can: code refactoring of print_ctrlmode()
      iplink_can: use PRINT_ANY to factorize code and fix signedness
      iplink_can: print brp and dbrp bittiming variables
      iplink_can: add new CAN FD bittiming parameters: Transmitter Delay Compensation (TDC)

[200~jiangheng (1):
      lnstat: fix buffer overflow in header output

