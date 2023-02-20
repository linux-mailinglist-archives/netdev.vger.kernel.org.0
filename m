Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0D7869D398
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 19:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232740AbjBTS7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 13:59:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232921AbjBTS7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 13:59:34 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2988BF8
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 10:58:52 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id i1-20020a17090ad34100b00234463de251so2251055pjx.3
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 10:58:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:subject:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eFDc81urHeoTDhsud9i4uTs1xVvuDXzUensfcn1Qjz0=;
        b=S3N9dYL4tH3zFkb7AknyK90r0nV9JR2fMH/F+1YKOVSOm1KesfaJeRk4XVoixj5tyD
         6ig6s/RdYFrRr7UI8wVYQ/qpvSddq9W1sbzX7CZ3l6jjiL2tMQoZzoTFgVaSa6X3WtLK
         rUqJX2a/p/VSx4XfhTqoa0eTeYG6cImC/eECU2B3YbSgsyCrN5SkU30k79Aeg75iX9iT
         AhlZYmCCYHQBvL0Y/AKyQkcDLyCOVCFZg9sUSHdItLInjfJ0VZxgz1HZrzqWW2NYN72l
         SS6K3UwN1FbJzOfJaNUdi6ggwU6mVqmtnc2/DdUbz+YBd+ZD4ZoF+7NAcf4w0Cvh0sOv
         belg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:subject:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eFDc81urHeoTDhsud9i4uTs1xVvuDXzUensfcn1Qjz0=;
        b=DC15Wm0i2Z7mH2nBfDJmCafl3t5qrlZDurleJ02/OanrUBI6ryPHiRwutV2v+d94vt
         JtAabDxkliDncVWnYgjlGXBmSlgVkVLoqMkTaeQD1dc5sch/AIxgdcgjbBWEr4qKyncW
         Xpa+t0c6aKWpOR/BppvKPTZFTVzRyxolpXkBka6jP6QwltbR00vGxPcegatXmbPqS6pC
         bob4L2HS5DSXwZWXCAzFQPoReLNkvfUF0RC09/etKaQ8GQ5dc6pSrsM9xyiXV8GtCR3v
         bYddita3h1pF8kVNbb1pNFa9Asc7cejWaykBhU77hBPWzrZGTrxsXCpLwf0zhzx2SYVv
         HP6Q==
X-Gm-Message-State: AO0yUKUVQej4aqU4LhN0F0pnGGuHh4dM8zn1vfxkGwsUn7EsUmVaWAiy
        3VFylnhOA1MaWuk2hlEK0Si6/bZq727oBaBpnOc=
X-Google-Smtp-Source: AK7set9SftEn1BPq0zYLsKw6wJwGEKsbr/3k6RMv51DqeM0xEO3TyYXQuppPZjt4z5VrJQ63w0nm5Q==
X-Received: by 2002:a17:902:cec1:b0:199:2f0a:697 with SMTP id d1-20020a170902cec100b001992f0a0697mr5295182plg.33.1676919493385;
        Mon, 20 Feb 2023 10:58:13 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id ix10-20020a170902f80a00b00186a2274382sm8323016plb.76.2023.02.20.10.58.13
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Feb 2023 10:58:13 -0800 (PST)
Date:   Mon, 20 Feb 2023 10:58:11 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: [ANNOUNCE] iproute2 6.2 release
Message-ID: <20230220105811.674bd304@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the release of iproute2 corresponding to the 6.2 kernel.
Like the kernel, not a sexy release just a regular pedestrian update.
Moof the changes are in the devlink command.

Download:
    https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-6.2.tar.gz

Repository for current release
    https://github.com/shemminger/iproute2.git
    git://git.kernel.org/pub/scm/network/iproute2/iproute2.git

And future release (net-next):
    git://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git

Contributions:

Benjamin Poirier (1):
      bridge: Remove unused function argument

Daniel Machon (2):
      dcb: add new pcp-prio parameter to dcb app
      dcb: add new subcommand for apptrust

David Ahern (3):
      Update kernel headers
      Update kernel headers
      Update kernel headers

Denys Fedoryshchenko (1):
      libnetlink.c: Fix memory leak in batch mode

Emeel Hakim (2):
      macsec: Fix Macsec replay protection
      macsec: Fix Macsec packet number attribute print

Hans Schultz (2):
      bridge: fdb: Add support for locked FDB entries
      bridge: link: Add MAC Authentication Bypass (MAB) support

Hauke Mehrtens (1):
      configure: Remove include <sys/stat.h>

Ido Schimmel (4):
      man: bridge: Reword description of "locked" bridge port option
      libnetlink: Fix wrong netlink header placement
      dcb: Do not leave ACKs in socket receive buffer
      bridge: mdb: Remove double space in MDB dump

Jacob Keller (1):
      devlink: support direct region read requests

Jakub Wilk (1):
      man: ss: remove duplicated option name

Jason Wang (1):
      vdpa: allow provisioning device features

Jiri Pirko (5):
      devlink: add ifname_map_add/del() helpers
      devlink: get devlink port for ifname using RTNL get link command
      devlink: push common code to __pr_out_port_handle_start_tb()
      devlink: update ifname map when message contains DEVLINK_ATTR_PORT_NETDEV_NAME
      devlink: fix mon json output for trap-policer

Leon Romanovsky (3):
      xfrm: prepare state offload logic to set mode
      xfrm: add packet offload mode to xfrm state
      xfrm: add an interface to offload policy

Leonard Crestez (2):
      ip neigh: Support --json on ip neigh get
      testsuite: Add test for ip --json neigh get

Matthieu Baerts (1):
      mptcp: add new listener events

Max Tottenham (1):
      tc: Add JSON output to tc-class

Michal Wilczynski (3):
      devlink: Introduce new attribute 'tx_priority' to devlink-rate
      devlink: Introduce new attribute 'tx_weight' to devlink-rate
      devlink: Add documentation for tx_prority and tx_weight

Sam James (1):
      ip: fix UB in strncpy (e.g. truncated ip route output)

Shay Drory (3):
      devlink: Support setting port function roce cap
      devlink: Support setting port function migratable cap
      devlink: Add documentation for roce and migratable port function attributes

Stefan Pietsch (1):
      man: ip-link.8: Fix formatting

Stephen Hemminger (19):
      uapi: update headers to 6.2-rc1
      uapi: update vdpa.h
      tc/htb: break long lines
      tc/htb: add SPDX comment
      tc: remove support for rr qdisc
      bridge: use SPDX
      genl: use SPDX
      lib: replace GPL boilerplate with SPDX
      devlink: use SPDX
      ip: use SPDX
      testsuite: use SPDX
      tipc: use SPDX
      tc: replace GPL-BSD boilerplate in codel and fq
      tc: use SPDX
      misc: use SPDX
      netem: add SPDX license header
      add space after keyword
      uapi: update headers to 6.2-rc8
      v6.2.0

Sven Neuhaus (1):
      ip-rule.8: Bring synopsis in line with description

Tan Tee Min (1):
      taprio: fix wrong for loop condition in add_tc_entries()

Vladimir Oltean (2):
      taprio: don't print the clockid if invalid
      taprio: support dumping and setting per-tc max SDU

Wojciech Drewek (1):
      f_flower: Introduce L2TPv3 support

Xin Long (1):
      iplink: fix the gso and gro max_size names in documentation

gaoxingwang (1):
      testsuite: fix testsuite build failure when iproute build without libcap-devel

