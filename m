Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC9D1D312C
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 15:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726848AbgENNXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 09:23:17 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:51124 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726087AbgENNXQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 09:23:16 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 14 May 2020 16:23:12 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 04EDNCBi013405;
        Thu, 14 May 2020 16:23:12 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     dsahern@gmail.com, stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        marcelo.leitner@gmail.com, dcaratti@redhat.com,
        Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH iproute2-next 0/2] Implement filter terse dump mode support
Date:   Thu, 14 May 2020 16:23:04 +0300
Message-Id: <20200514132306.29961-1-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200514114026.27047-1-vladbu@mellanox.com>
References: <20200514114026.27047-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
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

 include/uapi/linux/rtnetlink.h |  6 ++++++
 tc/m_bpf.c                     |  2 +-
 tc/m_connmark.c                |  2 +-
 tc/m_csum.c                    |  2 +-
 tc/m_ct.c                      |  2 +-
 tc/m_ctinfo.c                  |  2 +-
 tc/m_gact.c                    |  2 +-
 tc/m_ife.c                     |  2 +-
 tc/m_ipt.c                     |  2 +-
 tc/m_mirred.c                  |  2 +-
 tc/m_mpls.c                    |  2 +-
 tc/m_nat.c                     |  2 +-
 tc/m_pedit.c                   |  2 +-
 tc/m_sample.c                  |  2 +-
 tc/m_simple.c                  |  2 +-
 tc/m_skbedit.c                 |  2 +-
 tc/m_skbmod.c                  |  2 +-
 tc/m_tunnel_key.c              |  2 +-
 tc/m_vlan.c                    |  2 +-
 tc/m_xt.c                      |  2 +-
 tc/m_xt_old.c                  |  2 +-
 tc/tc_filter.c                 | 12 ++++++++++++
 22 files changed, 38 insertions(+), 20 deletions(-)

-- 
2.21.0

