Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 960B9BD2C3
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 21:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730950AbfIXTgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 15:36:41 -0400
Received: from mail-pl1-f177.google.com ([209.85.214.177]:34285 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730848AbfIXTgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 15:36:40 -0400
Received: by mail-pl1-f177.google.com with SMTP id k7so818954pll.1
        for <netdev@vger.kernel.org>; Tue, 24 Sep 2019 12:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=a2iDd3m2G/l9th7WtI3MkUeQsp//0X2JF0EBn/AYxd0=;
        b=pihrBvs8X0bLOcDtEsRFXSbuZhyVBEI3lR1ED5LF9LUL40ijueBJaLEeZ7R/gumwx4
         3i9EWrBRkJgbp9ibQUVXs/gfpASS8ze99irayhDjglYH9GDPQG9P4IHsFSsFk8p0L9HP
         o4hVi2e2DHHpWc0kkU8XQ7by/WeZiDd9Gr8L2/OlmMQ4HULQfq/Bb5GYR3BlXumv+E52
         E4qlQHPX43P8l+8J38RmCee4zK7CFRN/t+RBIiSnI6HupUjZr42Zs7b7MhBx7GLyvLGK
         TyLzHomlMX8MDa4mjjRhCAxWH5pKFc1kaSDA1F0EaB7KNGHuQ3lww19Z7a/+QJADbVUg
         /rPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=a2iDd3m2G/l9th7WtI3MkUeQsp//0X2JF0EBn/AYxd0=;
        b=oCI+vr2LsWjZcsiTyPaJfpQvUhSsKKJ5zMuAktvFbR3tNzcwEeXlF2AfuWqsXQDQrp
         kDYE6kF0GOFHbC+dYkQaroiTmpTQr8bkYsw9RvKwOUUnMhW5tbVUDrOcQje+fg2pgAqp
         g3ZQ2SxC0F7Vl1F733aqn4UwHlSM0aXnCnk6GfW7XJhCkpe78zyQHaIOZoXLn9Wc1BCK
         GfI4Lc8pE0NXpzH+mXfiYZJ6iiW09s1VAlGjPQ9qUiGec5Cgw1t0kMfPsSvTTqL5SfSc
         o+SnoYoABZwWg8jYq6BiJyShcva/MpU3DKBBOXPmmIrjlekSUQd79nnXY9c9jwcKH+vZ
         pbgQ==
X-Gm-Message-State: APjAAAXrl8BbeUFJFKRVfipxiF4QGrCE9z58+V3xTmskdJaa6OvPENG5
        xpqrX9aQ1HRIZLRACjmk0IvewjYvfQQ=
X-Google-Smtp-Source: APXvYqxDdE7b8I+ib7EBWCuRp3uGi5VQ89AmNNTYtyMi54Ibl5yHVeL/Rre/L6VjgTe7WP6mpKDC7Q==
X-Received: by 2002:a17:902:b7c3:: with SMTP id v3mr4512090plz.139.1569353799756;
        Tue, 24 Sep 2019 12:36:39 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id h9sm2506102pgh.51.2019.09.24.12.36.39
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2019 12:36:39 -0700 (PDT)
Date:   Tue, 24 Sep 2019 12:36:38 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: [ANNOUNCE] iproute2 5.3 release
Message-ID: <20190924123638.1c396f2c@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 5.3 kernel has been released, and the last patches have
been applied to iproute2.

This update includes usual ammount of minor fixes and to tools and
documentation. More to the newer tools like devlink and rdma.

Download:
    https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-5.3.0.tar.gz

Repository for upcoming release:
    git://git.kernel.org/pub/scm/network/iproute2/iproute2.git

And future release (net-next):
    git://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git

Thanks for all the contributions.

Report problems (or enhancements) to the netdev@vger.kernel.org mailing list.

---
Andrea Claudi (8):
      Makefile: use make -C to change directory
      utils: move parse_percent() to tc_util
      ip-route: fix json formatting for metrics
      tc: util: constrain percentage in 0-100 interval
      Revert "ip6tunnel: fix 'ip -6 {show|change} dev <name>' cmds"
      ip tunnel: warn when changing IPv6 tunnel without tunnel name
      devlink: fix segfault on health command
      man: ss.8: add documentation for drop counter

Antonio Borneo (1):
      iplink_can: fix format output of clock with flag -details

Aya Levin (3):
      devlink: Change devlink health dump show command to dumpit
      devlink: Fix binary values print
      devlink: Remove enclosing array brackets binary print with json format

David Ahern (20):
      Update kernel headers and add asm-generic/sockios.h
      Update kernel headers
      Update kernel headers
      uapi: Import tc_ctinfo uapi
      libnetlink: Set NLA_F_NESTED in rta_nest
      lwtunnel: Pass encap and encap_type attributes to lwt_parse_encap
      libnetlink: Add helper to add a group via setsockopt
      uapi: Import nexthop object API
      libnetlink: Add helper to create nexthop dump request
      ip route: Export print_rt_flags, print_rta_if and print_rta_gateway
      Add support for nexthop objects
      ip: Add man page for nexthop command
      ip route: Add option to use nexthop objects
      ipmonitor: Add nexthop option to monitor
      tools: Fix include path for generate_nlmsg
      Update kernel headers
      ss: Change resolve_services to numeric
      Update kernel headers
      Import tc_mpls.h uapi header
      nexthop: Add space after blackhole

Denis Kirjanov (1):
      ipaddress: correctly print a VF hw address in the IPoIB case

Donald Sharp (1):
      ip nexthop: Add space to display properly when showing a group

Hangbin Liu (1):
      ip: add a new parameter -Numeric

Hoang Le (1):
      tipc: support interface name when activating UDP bearer

Ido Schimmel (1):
      tc: Fix block-handle support for filter operations

Ivan Delalande (1):
      json: fix backslash escape typo in jsonw_puts

Jakub Kicinski (1):
      tc: q_netem: JSON-ify the output

Jiri Pirko (1):
      devlink: finish queue.h to list.h transition

Joe Stringer (1):
      bpf: Fix race condition with map pinning

John Hurley (3):
      lib: add mpls_uc and mpls_mc as link layer protocol names
      tc: add mpls actions
      man: update man pages for TC MPLS actions

Kevin Darbyshire-Bryant (1):
      tc: add support for action act_ctinfo

Kurt Kanzenbach (1):
      utils: Fix get_s64() function

Mark Zhang (8):
      rdma: Add "stat qp show" support
      rdma: Add get per-port counter mode support
      rdma: Add rdma statistic counter per-port auto mode support
      rdma: Make get_port_from_argv() returns valid port in strict port mode
      rdma: Add stat manual mode support
      rdma: Add default counter show support
      rdma: Document counter statistic
      rdma: Check comm string before print in print_comm()

Matteo Croce (2):
      treewide: refactor help messages
      utils: don't match empty strings as prefixes

Nicolas Dichtel (1):
      link_xfrm: don't force to set phydev

Parav Pandit (6):
      rdma: Add an option to query,set net namespace sharing sys parameter
      rdma: Add man pages for rdma system commands
      rdma: Add an option to set net namespace of rdma device
      rdma: Add man page for rdma dev set netns command
      devlink: Show devlink port number
      devlink: Introduce PCI PF and VF port flavour and attribute

Patrick Talbert (2):
      ss: sctp: fix typo for nodelay
      ss: sctp: Formatting tweak in sctp_show_info for locals

Roman Mashak (2):
      tc: added mask parameter in skbedit action
      tc: document 'mask' parameter in skbedit man page

Sergei Trofimovich (1):
      iproute2: devlink: port from sys/queue.h to list.h

Stephen Hemminger (18):
      tc: print all error messages to stderr
      uapi: fix bpf.h link
      uapi: update uapi/magic.h
      uapi: rdma netlink.h update
      uapi: fix bpf comment typo
      uapi: update kernel headers from 5.3-rc1
      iplink: document 'change' option to ip link
      json_print: drop extra semi-colons
      Revert "tc: Remove pointless assignments in batch()"
      Revert "tc: flush after each command in batch mode"
      Revert "tc: fix batch force option"
      Revert "tc: Add batchsize feature for filter and actions"
      tc: fflush after each command in batch mode
      uapi: update socket.h
      tc: fix spelling errors
      lib: fix spelling errors
      uapi: update bpf.h header
      v5.3.0

Vincent Bernat (1):
      ip: bond: add peer notification delay support

Yamin Friedman (2):
      rdma: Control CQ adaptive moderation (DIM)
      rdma: Document adaptive-moderation

