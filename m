Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 776C8292E2B
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 21:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731072AbgJSTHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 15:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730820AbgJSTHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 15:07:12 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B551C0613CE
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 12:07:12 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id b19so285217pld.0
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 12:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=GUF042H9Bl6WBF+3mGwYODLvg45SplP1rM20FcE3nu8=;
        b=WmIiltsJIktNYIibJ9CcVWm5AxTIpGg+CcoLvOOTHInWoIiMU+f/XhpEYHSzOTs0l9
         D6KMJmjeAzUXtJj/u9RgHeUjkHvM7TjnwpYVcdx2TxirFLT6+K91zYPImlgbmyjmJHbI
         OqoVrGxWqhz5k7ppjxxWZ3dE2kOwMOopTQ4lVHNz7hRYKpG2s20aJD1zYrZRnnRcQTTh
         OGXKBxM3a5Rpf7fdizSI4F9qfadY3linGAqX5QSEpgIGeAQCABNmscsx76f6B8OvOsFi
         HgAqkeef4bV4QGLIn0YniZdhXbu2ZeJPr1Yz0wegCgBTlFOyLzssXFAcKwcdySs/6MY5
         2WvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=GUF042H9Bl6WBF+3mGwYODLvg45SplP1rM20FcE3nu8=;
        b=eisi1c10rtvE4l+I0Id4S7CxHXDk0cJOyvLvcW3/tFIeYdlPHKZKqAEU/YHt81rvkZ
         MV1fQHLRUGOmBm0HcGKIW72t09chUy5GQWQKBOQrsF6SIAHV/B9r5X6m8zrbjrn8hfQr
         Od16R2bJeUTK0P5FColyvM1gXX+HMiwYUBE0xtB0JU06aeSA12f1S5EbwA1UeICdXGqY
         rw5SrpEuOl+wHnYhVOPm7wvRBibcKor9/hpBB4pyltzz0v2actrxWdOXh9AAqZnJM2KA
         f5AwAh5GuqN1D4mjgI78w6HJ7sm6Wh/76tgbrmDKZbnN87hcn7V5aqjL7DxpIh16sFFH
         TUTA==
X-Gm-Message-State: AOAM530Sx6rXZjSqbD9NXjmSdVinmKiEonDgekX5zevoXdCTPg7l5kK6
        nlYcnX9WfLCwdgmA6wFe15LOWD7imrNPrA==
X-Google-Smtp-Source: ABdhPJyd1+pi2GLkHWFvJVGq1ov/7erF59AXoW3rbJaP+ce0x9S1k7tVyWeEU2r+A6VX7884DsSM8w==
X-Received: by 2002:a17:90a:678a:: with SMTP id o10mr850886pjj.180.1603134430815;
        Mon, 19 Oct 2020 12:07:10 -0700 (PDT)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id z5sm533193pfn.20.2020.10.19.12.07.10
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 12:07:10 -0700 (PDT)
Date:   Mon, 19 Oct 2020 12:07:01 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: [ANNOUNCE] iproute2 5.9
Message-ID: <20201019120701.25764e73@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Time for a new version of iproute2 to go with the 5.9 kernel.
There are not a lot of changes in this version.

Note: iproute2 is now maintained on the "main" branch.
There are parallel copies (both updated) on kernel.org and github.

As always, it is recommended to always use the latest iproute2.
Do not treat iproute2 like perf and require matching packages.
The latest code will always run on older kernels (and vice versa);
this is possible because of the kernel API/ABI guarantees.

Except for rare cases, iproute2 does not do maintenance releases
and there is no long term stable version.


Download:
    https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-5.9.0.tar.=
gz

Repository for current release
    https://github.com/shemminger/iproute2.git
    git://git.kernel.org/pub/scm/network/iproute2/iproute2.git

And future release (net-next):
    git://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git

Thanks for all the contributions.

Report problems (or enhancements) to the netdev@vger.kernel.org mailing lis=
t.

Alexandre Cassen (1):
      add support to keepalived rtm_protocol

Amit Cohen (1):
      devlink: Add fflush() in cmd_mon_show_cb()

Briana Oursler (1):
      tc: Add space after format specifier

Danielle Ratson (2):
      devlink: Expose number of port lanes
      devlink: Expose port split ability

David Ahern (3):
      Update kernel headers
      Update kernel headers
      Update kernel headers

Dmitry Yakunin (1):
      lib: ignore invalid mounts in cg_init_map

Eyal Birger (1):
      ipntable: add missing ndts_table_fulls ntable stat

Jan Engelhardt (2):
      build: avoid make jobserver warnings
      ip: add error reporting when RTM_GETNSID failed

Kamal Heib (1):
      ip: iplink_ipoib.c: Remove extra spaces

Leon Romanovsky (2):
      rdma: Fix owner name for the kernel resources
      rdma: Properly print device and link names in CLI output

Maor Gottlieb (4):
      rdma: update uapi headers
      rdma: Add support to get QP in raw format
      rdma: Add support to get CQ in raw format
      rdma: Add support to get MR in raw format

Mark Zhang (3):
      rdma: update uapi headers
      rdma: Add "PID" criteria support for statistic counter auto mode
      rdma: Document the new "pid" criteria for auto mode

Murali Karicheri (2):
      iplink: hsr: add support for creating PRP device similar to HSR
      ip: iplink: prp: update man page for new parameter

Paolo Abeni (1):
      ss: mptcp: add msk diag interface support

Parav Pandit (3):
      devlink: Move devlink port code at start to reuse
      devlink: Support querying hardware address of port function
      devlink: Support setting port function hardware address

Petr Machata (5):
      tc: Add helpers to support qevent handling
      man: tc: Describe qevents
      tc: q_red: Add support for qevents "mark" and "early_drop"
      tc: Look for blocks in qevents
      tc: q_red: Implement has_block for RED

Petr Van=C4=9Bk (1):
      ip-xfrm: add support for oseq-may-wrap extra flag

Phil Sutter (1):
      ip link: Fix indenting in help text

Po Liu (2):
      action police: change the print message quotes style
      action police: make 'mtu' could be set independently in police action

Roman Mashak (1):
      ip: updated ip-link man page

Roopa Prabhu (2):
      ipnexthop: support for fdb nexthops
      bridge: support for nexthop id in fdb entries

Sascha Hauer (1):
      iproute2: ip maddress: Check multiaddr length

Stephen Hemminger (6):
      v5.8.0
      uapi: update kernel headers
      uapi: update bpf.h
      uapi: update headers from 5.9-rc7
      addr: Fix noprefixroute and autojoin for IPv4
      uapi: add new SNMP entry

Vasundhara Volam (1):
      devlink: Add board.serial_number to info subcommand.

Vladyslav Tarasiuk (3):
      devlink: Add a possibility to print arrays of devlink port handles
      devlink: Add devlink port health command
      devlink: Update devlink-health and devlink-port manpages

zhangkaiheb@126.com (1):
      tc: fq: clarify the length of orphan_mask.

