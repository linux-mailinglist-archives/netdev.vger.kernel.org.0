Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 496752971C3
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 16:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S465389AbgJWOzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 10:55:44 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:40800 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S461140AbgJWOzo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 10:55:44 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@nvidia.com)
        with SMTP; 23 Oct 2020 17:55:42 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 09NEtgp3012350;
        Fri, 23 Oct 2020 17:55:42 +0300
From:   Vlad Buslov <vladbu@nvidia.com>
To:     dsahern@gmail.com, stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, ivecera@redhat.com,
        vlad@buslov.dev, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH iproute2-next v4 0/2] Implement filter terse dump mode support
Date:   Fri, 23 Oct 2020 17:55:34 +0300
Message-Id: <20201023145536.27578-1-vladbu@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement support for terse dump mode which provides only essential
classifier/action info (handle, stats, cookie, etc.). Use new
TCA_DUMP_FLAGS_TERSE flag to prevent copying of unnecessary data from
kernel.

Vlad Buslov (2):
  tc: skip actions that don't have options attribute when printing
  tc: implement support for terse dump

 man/man8/tc.8     | 6 ++++++
 tc/m_bpf.c        | 4 ++--
 tc/m_connmark.c   | 4 ++--
 tc/m_csum.c       | 4 ++--
 tc/m_ct.c         | 5 ++---
 tc/m_ctinfo.c     | 4 ++--
 tc/m_gact.c       | 4 ++--
 tc/m_ife.c        | 4 ++--
 tc/m_ipt.c        | 2 +-
 tc/m_mirred.c     | 4 ++--
 tc/m_mpls.c       | 4 ++--
 tc/m_nat.c        | 4 ++--
 tc/m_pedit.c      | 4 ++--
 tc/m_sample.c     | 4 ++--
 tc/m_simple.c     | 2 +-
 tc/m_skbedit.c    | 5 ++---
 tc/m_skbmod.c     | 2 +-
 tc/m_tunnel_key.c | 5 ++---
 tc/m_vlan.c       | 4 ++--
 tc/m_xt.c         | 2 +-
 tc/m_xt_old.c     | 2 +-
 tc/tc.c           | 6 +++++-
 tc/tc_filter.c    | 9 +++++++++
 23 files changed, 55 insertions(+), 39 deletions(-)

-- 
2.21.0

