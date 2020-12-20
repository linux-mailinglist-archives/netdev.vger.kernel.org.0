Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B426E2DF861
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 05:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbgLUEqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Dec 2020 23:46:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727569AbgLUEqc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Dec 2020 23:46:32 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC955C061285
        for <netdev@vger.kernel.org>; Sun, 20 Dec 2020 20:45:51 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id t6so4998720plq.1
        for <netdev@vger.kernel.org>; Sun, 20 Dec 2020 20:45:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=/5I+IwRWc6yQaXHGrTaY4QXvxkqMztX8GLLvJNaqk9E=;
        b=Hd4HuEMllJJEoa/SS2OsonS1BJlQfxzuBz16/REMsf8ufv/5+RuJz4IKMXzCdhBNU/
         qFHd1Fx4AZPQwQjT1xziamasIjEYoqcs4AwD8Jkpje4Lk/51aCN0gG/ClLqArUSB8khu
         KdV7p7EyTDEXGcB4VL3G6aXCxUzOIrPQuki4NFfBXn/8zOn9eekzWbrncwFtEOXetnGm
         sIO6cAdW03LU3RVCnCdMhC3374WDNDxhZkXj5VWpbJjXA9YXNaWxByCeUik3R+OfVXdj
         1CmhqDSYBAPQ7kVBhuonjrU9socBsNCavOJqs4R73co839NcoXjDJnvMfKbIWXekiC1M
         uK2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=/5I+IwRWc6yQaXHGrTaY4QXvxkqMztX8GLLvJNaqk9E=;
        b=dpnsvsgAkhFO6ZmnziALgke4KM1U7Y0e44A4xhpc5LpiM/UflpjjzjrHxvv99xO0wb
         9CU5c8Gjnv6bcVYtbCtuuFHPk3nATFK4eKDTflHN12SuIv/Wj2cBHv8V5mc32It+n4xt
         ab06FCJ6PNlxTQy2qURbtiKEZ5SwA1aehNYlr1D+qEd5hkXW6484BKROe8OOH4i5A1Ne
         cwtAvwWetFsrDlhWSLtoJEw4bpNoEUj1sQoWlidlEwyx4ttCzgIU4PoqXO366kyXHEeW
         jZh6iOTT8h+FSsocd8hPNwGVlb5FP/YJQVAGjUs6BxZiTNU2RDcNCZJjciuTvXq7YRwB
         mRCg==
X-Gm-Message-State: AOAM531SjdkF3/aIWGc5s48cgQ8dzLOgwL5zKKf/706f3KpSEzugamXo
        z01CIv9mYqvDi8himH1HM8Na8YzC5YJ+OA==
X-Google-Smtp-Source: ABdhPJw7V/aqh2FEI4h4RrbwnB+ZyOTeaGsRVfub7RkBdm2z1yqOnvyQl6xkyxFM37roY3x4dYhExg==
X-Received: by 2002:a17:902:7c0a:b029:da:62c8:90cb with SMTP id x10-20020a1709027c0ab02900da62c890cbmr13521856pll.59.1608497223942;
        Sun, 20 Dec 2020 12:47:03 -0800 (PST)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id h24sm14687489pfq.13.2020.12.20.12.47.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Dec 2020 12:47:03 -0800 (PST)
Date:   Sun, 20 Dec 2020 12:46:42 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] iproute2-5.10
Message-ID: <20201220124642.53cb4311@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Just in time for the holidays, new iproute2!

This update is smaller than usual, not a lot of new features.
It does NOT include libbpf, that will be merged in 5.11 (iproute2-next).

Download:
    https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-5.10.0.tar.gz

Repository for upcoming release:
    git://git.kernel.org/pub/scm/network/iproute2/iproute2.git

And future release (net-next):
    git://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git

Thanks for all the contributions.

Report problems (or enhancements) to the netdev@vger.kernel.org mailing list.

---
Andrea Claudi (4):
      man: tc-flower: fix manpage
      devlink: fix memory leak in cmd_dev_flash()
      tc: pedit: fix memory leak in print_pedit
      ss: mptcp: fix add_addr_accepted stat print

Antony Antony (2):
      ip xfrm: support printing XFRMA_SET_MARK_MASK attribute in states
      ip xfrm: support setting XFRMA_SET_MARK_MASK attribute in states

Ciara Loftus (1):
      ss: add support for xdp statistics

David Ahern (5):
      Update kernel headers
      Update kernel headers
      Update kernel headers
      Update kernel headers
      Update kernel headers

Guillaume Nault (5):
      m_vlan: add pop_eth and push_eth actions
      m_mpls: add mac_push action
      m_mpls: test the 'mac_push' action after 'modify'
      tc-vlan: fix help and error message strings
      tc-mpls: fix manpage example and help message string

Hoang Le (1):
      tipc: support 128bit node identity for peer removing

Jacob Keller (2):
      devlink: support setting the overwrite mask attribute
      devlink: display elapsed time during flash update

Jakub Kicinski (1):
      ip: promote missed packets to the -s row

Jiri Pirko (1):
      devlink: Add health reporter test command support

Johannes Berg (5):
      libnetlink: add rtattr_for_each_nested() iteration macro
      libnetlink: add nl_print_policy() helper
      genl: ctrl: support dumping netlink policy
      genl: ctrl: print op -> policy idx mapping
      libnetlink: define __aligned conditionally

Luca Boccassi (2):
      ip/netns: use flock when setting up /run/netns
      tc/mqprio: json-ify output

Nikolay Aleksandrov (6):
      bridge: mdb: add support for source address
      bridge: mdb: print fast_leave flag
      bridge: mdb: show igmpv3/mldv2 flags
      bridge: mdb: print filter mode when available
      bridge: mdb: print source list when available
      bridge: mdb: print protocol when available

Parav Pandit (2):
      devlink: Show external port attribute
      devlink: Show controller number of a devlink port

Roopa Prabhu (1):
      iplink: add support for protodown reason

Stephen Hemminger (15):
      v5.9.0
      uapi: updates from 5.10-rc1
      tc/m_gate: fix spelling errors
      man: fix spelling errors
      rdma: fix spelling error in comment
      uapi: update kernel headers from 5.10-rc2
      bridge: report correct version
      devlink: fix uninitialized warning
      bridge: fix string length warning
      tc: fix compiler warnings in ip6 pedit
      misc: fix compiler warning in ifstat and nstat
      f_u32: fix compiler gcc-10 compiler warning
      uapi: update devlink.h
      uapi: update devlink.h
      uapi: merge in change to bpf.h

Tuong Lien (2):
      tipc: add option to set master key for encryption
      tipc: add option to set rekeying for encryption

Wei Wang (1):
      iproute2: ss: add support to expose various inet sockopts

