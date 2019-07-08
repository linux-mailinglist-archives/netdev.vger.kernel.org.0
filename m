Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 940EF6242A
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 17:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388947AbfGHP0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 11:26:55 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:35191 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388938AbfGHP0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 11:26:54 -0400
Received: by mail-pl1-f196.google.com with SMTP id w24so8454384plp.2
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 08:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=7uQTH3OcgzeKrUaIrqap40UutFGlqwAtpcZhCaX6jUc=;
        b=NZCX+JPb3J/Ba1H15qxqjVVmC43oGd0/5R+fizpHvOHReDSm71HhQWpzicKanc7zuU
         xTkjlduOzAXIkqcuaJ+rSst+RkY0OdSqgMFCOf9PqJMiESecfIi3GYb7BBVMb+ZErtbc
         jVtqr7S+OSEthgMCTd2qX5QUDs+7EIEzd5+ZsBh7MiPzNhPx9HIMsPqyrJ4W4SNCPxhf
         yVndlq9o+r5mbNPvgj4tevsFcoThGyckNNLwtvEIO0XS1vpy8imYZyMqosQTGKOZgIA3
         rFogvC2d8ffM+YNwwo4CQi/SK3OEYfGpCVfMXzC5nfA5FZoBhIZEw6bmnhyrGqZqkCtK
         3Ieg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=7uQTH3OcgzeKrUaIrqap40UutFGlqwAtpcZhCaX6jUc=;
        b=kMpa5x5EQN/miX/S+pYO/7PB4CBse7VvUlxAay+Vk64FD5K4hpxIuE8pZRqOII799m
         mWHsy2NhgSol5e91iv8oE8A/48G4sjqkC6xG2jcT7NMABFunfc8FlLDQVmzSw3W0uLv6
         Tq6JcPXPpONRlP8CMD/zWb4bkcQTM+UajkJ8hjIYFt9gmMDq78mPP07o5qNBIgENzUaY
         908K9cItuifmeonBTw7/chDs0bqvIljCzZTi5xkEJZJrtEUCadY8/+ucRYw1E7ntqm8o
         LXRuapM4pOnLwiLjPkMKugkrKAj3b20IQe+WCleivdmUySTOmwhHPOqMl2VeJrNreGiC
         AFXg==
X-Gm-Message-State: APjAAAWIF0izillemRObjH2jMJ/XB/4ieW4fmJ/pKMam7f0Pufk/va1S
        YrISAhSeJnMlMPfaBn68iGLFtLWmidY=
X-Google-Smtp-Source: APXvYqy4tOhnyVmwkiETtoSux9WBcSLUM3Tp33UkOdSJp4D6eiUl2ThY74SdfVRxBWmuyS00Xq6cGg==
X-Received: by 2002:a17:902:aa5:: with SMTP id 34mr26642421plp.166.1562599613134;
        Mon, 08 Jul 2019 08:26:53 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id w14sm20758035pfn.47.2019.07.08.08.26.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 08:26:53 -0700 (PDT)
Date:   Mon, 8 Jul 2019 08:26:46 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] iproute2 5.2
Message-ID: <20190708082646.37428502@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 5.2 kernel has been released, and therefore time for another
update to iproute2.

Not a lot of big new features in this release. Just the usual array of
small fixes across the board.

Download:
    https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-5.2.0.tar.gz

Repository for upcoming release:
    git://git.kernel.org/pub/scm/network/iproute2/iproute2.git

And future release (net-next):
    git://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git

Thanks for all the contributions.

Report problems (or enhancements) to the netdev@vger.kernel.org mailing list.

---
Andrea Claudi (6):
      Makefile: use make -C
      ip address: do not set nodad option for IPv4 addresses
      ip address: do not set home option for IPv4 addresses
      ip address: do not set mngtmpaddr option for IPv4 addresses
      man: tc-netem.8: fix URL for netem page
      tc: netem: fix r parameter in Bernoulli loss model

Baruch Siach (2):
      devlink: fix format string warning for 32bit targets
      devlink: fix libc and kernel headers collision

David Ahern (5):
      Update kernel headers
      Update kernel headers
      Update kernel headers
      uapi: wrap SIOCGSTAMP and SIOCGSTAMPNS in ifndef
      Update kernel headers

Davide Caratti (2):
      man: tc-skbedit.8: document 'inheritdsfield'
      tc: simple: don't hardcode the control action

Eyal Birger (1):
      tc: adjust xtables_match and xtables_target to changes in recent iptables

Gal Pressman (1):
      rdma: Update node type strings

Hangbin Liu (1):
      ip/iptoken: fix dump error when ipv6 disabled

Hoang Le (3):
      tipc: add link broadcast set method and ratio
      tipc: add link broadcast get
      tipc: add link broadcast man page

Ido Schimmel (2):
      ipneigh: Print neighbour offload indication
      devlink: Increase column size for larger shared buffers

Josh Hunt (1):
      ss: add option to print socket information on one line

Kristian Evensen (1):
      ip fou: Support binding FOU ports

Lucas Siba 2019-04-20 11:40 UTC (1):
      Update tc-bpf.8 man page examples

Lukasz Czapnik (1):
      tc: flower: fix port value truncation

Mahesh Bandewar (1):
      ip6tunnel: fix 'ip -6 {show|change} dev <name>' cmds

Matteo Croce (4):
      ip: reset netns after each command in batch mode
      netns: switch netns in the child when executing commands
      ip vrf: use hook to change VRF in the child
      netns: make netns_{save,restore} static

Michael Forney (1):
      ipmroute: Prevent overlapping storage of `filter` global

Mike Manning (1):
      iplink_vlan: add support for VLAN bridge binding flag

Moshe Shemesh (1):
      devlink: mnlg: Catch returned error value of dumpit commands

Nicolas Dichtel (3):
      lib: suppress error msg when filling the cache
      iplink: don't try to get ll addr len when creating an iface
      ip monitor: display interfaces from all groups

Nikolay Aleksandrov (2):
      iplink: bridge: add support for vlan_stats_per_port
      bridge: mdb: restore text output format

Paolo Abeni (2):
      tc: add support for plug qdisc
      m_mirred: don't bail if the control action is missing

Parav Pandit (1):
      devlink: Increase bus, device buffer size to 64 bytes

Pete Morici (1):
      Add support for configuring MACsec gcm-aes-256 cipher type.

Roman Mashak (1):
      tc: Fix binding of gact action by index.

Stefano Brivio (1):
      iproute: Set flags and attributes on dump to get IPv6 cached routes to be flushed

Stephen Hemminger (14):
      uapi: update to elf-em header
      uapi: add include/linux/net.h
      uapi: update headers to import asm-generic/sockios.h
      mailmap: add myself
      mailmap: map David's mail address
      uapi: add sockios.h
      uapi: merge bpf.h from 5.2
      rdma: update uapi headers
      man: fix macaddr section of ip-link
      uapi: minor upstream btf.h header change
      testsuite: intent if/else in Makefile
      uapi: update headers and add if_link.h and if_infiniband.h
      devlink: replace print macros with functions
      vv5.2.0

Steve Wise (4):
      Add .mailmap file
      rdma: add helper rd_sendrecv_msg()
      rdma: add 'link add/delete' commands
      rdma: man page update for link add/delete

Tomasz Torcz (1):
      ss: in --numeric mode, print raw numbers for data rates

Vinicius Costa Gomes (2):
      taprio: Add support for changing schedules
      taprio: Add support for cycle_time and cycle_time_extension

