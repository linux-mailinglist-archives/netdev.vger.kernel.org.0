Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39E4D290767
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 16:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406500AbgJPOmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 10:42:43 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:45219 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2395259AbgJPOmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 10:42:43 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@nvidia.com)
        with SMTP; 16 Oct 2020 17:42:38 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 09GEgcnQ020163;
        Fri, 16 Oct 2020 17:42:38 +0300
From:   Vlad Buslov <vladbu@nvidia.com>
To:     dsahern@gmail.com, stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, ivecera@redhat.com,
        vlad@buslov.dev, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH iproute2-next v3 0/2] Implement filter terse dump mode support
Date:   Fri, 16 Oct 2020 17:42:03 +0300
Message-Id: <20201016144205.21787-1-vladbu@nvidia.com>
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
 tc/m_bpf.c        | 2 +-
 tc/m_connmark.c   | 2 +-
 tc/m_csum.c       | 2 +-
 tc/m_ct.c         | 2 +-
 tc/m_ctinfo.c     | 2 +-
 tc/m_gact.c       | 2 +-
 tc/m_ife.c        | 2 +-
 tc/m_ipt.c        | 2 +-
 tc/m_mirred.c     | 2 +-
 tc/m_mpls.c       | 2 +-
 tc/m_nat.c        | 2 +-
 tc/m_pedit.c      | 2 +-
 tc/m_sample.c     | 2 +-
 tc/m_simple.c     | 2 +-
 tc/m_skbedit.c    | 2 +-
 tc/m_skbmod.c     | 2 +-
 tc/m_tunnel_key.c | 2 +-
 tc/m_vlan.c       | 2 +-
 tc/m_xt.c         | 2 +-
 tc/m_xt_old.c     | 2 +-
 tc/tc.c           | 6 +++++-
 tc/tc_filter.c    | 9 +++++++++
 23 files changed, 40 insertions(+), 21 deletions(-)

-- 
2.21.0

