Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B54D2068AD
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 01:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387828AbgFWXxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 19:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387515AbgFWXxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 19:53:18 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B51C061573
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 16:53:16 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id u14so225229pjj.2
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 16:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+sseHvmJPgcqMjMeRkjWApobEadlkWyXEYqCAnizV5o=;
        b=DszBXIkBp/17nUiQ5OvV0DGkvTMYWeRaGDtTDKRSuH1J0LyzF3mVoeK56Bamgtn2Vx
         O47CqCmdmQnJ7GK906TWzXcVpBv3P/Ezly30dbn3/X0fLM/3P2NwOLz0+I6ImVQZFeBS
         bFZ2DZKgd1HDdXSKaTg/ySfc8qN8qecxpbAPR8UJ/iEiPiPlCh368d84NY6uUxm6vcXD
         CanA6pdz2Ngw9Za157gLH5Cizejln+HOXyBEIdFe0OhKGnNbRsYOzlTfKh5nL3npbhLJ
         K6EsmxwQyfxOdEeDd6dDx8EoWRhToxoxZTtFcjMJnkA44PlkccY89nrz8/1GI+A0Uot3
         78rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+sseHvmJPgcqMjMeRkjWApobEadlkWyXEYqCAnizV5o=;
        b=Ybac3NKR+Mu6vOStLtSvFLt0kfm/HWAwRo5L6hMol3FpRYJ91dp65VOtg1mw7PT+qu
         bEyfpICUNQpSvVePF8vzSogFStduScJGO8Q7cnOSLwmc/vIZxEuImVQzQidmbtagUrak
         98XRvBcQT2lp7mS5PYXoPnsPt50/VzVxJbH2LekBVA6ajlQsL8NXpS4OLl7DmSu8ygWH
         8mh64uSYoHEhCEcniEl4MR30YGY1DfSkYqDC5LwTnd50S5TUV+IUM3dL+pRsIQFOexY1
         dsJ6gyjzik+yoLMgpC1GZoby8n32eUd1CARj2+2eaVZ3I7HYYf6UglC0nWj9N+i0CyIN
         PYFQ==
X-Gm-Message-State: AOAM531MrERqmUlWk2iyM0PnOaSs8u13LfjarFO7zyeRXPIxyFM0vedb
        uEVJQ2xMrCVB+kVCX03H3q1Mf932iCs=
X-Google-Smtp-Source: ABdhPJxRKvwjWILzsugLYXjzr+VTNUbw1hfBK8y+tZ+FFgB79vOohrHiK2cgjDu/9lPkj5TkN2lSfg==
X-Received: by 2002:a17:902:7204:: with SMTP id ba4mr24647036plb.250.1592956395707;
        Tue, 23 Jun 2020 16:53:15 -0700 (PDT)
Received: from hermes.corp.microsoft.com (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 23sm18096521pfy.199.2020.06.23.16.53.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 16:53:14 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 0/5] Eliminate the term slave in iproute2
Date:   Tue, 23 Jun 2020 16:53:02 -0700
Message-Id: <20200623235307.9216-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches remove the term slave from the iproute2 visible
command line, documentation, and variable naming.

This needs doing despite the fact it will cause cosmetic
changes to visible outputs.

Stephen Hemminger (5):
  bpf: replace slave with sub
  bridge: remove slave from comments and message
  testsuite: replace Enslave with Insert
  ip: replace slave_kind
  ip: rename slave to subport

 bridge/vlan.c                                 |  4 +-
 ip/Makefile                                   |  4 +-
 ip/ip_common.h                                |  2 +-
 ip/ipaddress.c                                | 44 ++++++++--------
 ip/iplink.c                                   |  4 +-
 ip/iplink_bond.c                              | 44 ++++++++--------
 ...ink_bond_slave.c => iplink_bond_subport.c} | 48 ++++++++---------
 ...bridge_slave.c => iplink_bridge_subport.c} | 52 +++++++++----------
 ip/iplink_hsr.c                               | 20 +++----
 ip/iplink_team.c                              | 10 ++--
 ip/iplink_vrf.c                               |  8 +--
 ip/iplink_xstats.c                            |  2 +-
 lib/bpf.c                                     |  8 +--
 lib/namespace.c                               |  2 +-
 man/man8/ip-address.8.in                      |  8 +--
 man/man8/ip-link.8.in                         | 26 +++++-----
 man/man8/ip-nexthop.8                         |  2 +-
 testsuite/tests/bridge/vlan/show.t            |  4 +-
 testsuite/tests/bridge/vlan/tunnelshow.t      |  4 +-
 19 files changed, 148 insertions(+), 148 deletions(-)
 rename ip/{iplink_bond_slave.c => iplink_bond_subport.c} (74%)
 rename ip/{iplink_bridge_slave.c => iplink_bridge_subport.c} (88%)

-- 
2.26.2

