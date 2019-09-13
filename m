Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F223B235C
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 17:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389619AbfIMP26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 11:28:58 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:35511 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388392AbfIMP26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 11:28:58 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 13 Sep 2019 18:28:56 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x8DFSuJC018845;
        Fri, 13 Sep 2019 18:28:56 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH net-next 0/3] More fixes for unlocked cls hardware offload API refactoring
Date:   Fri, 13 Sep 2019 18:28:38 +0300
Message-Id: <20190913152841.15755-1-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two fixes for my "Refactor cls hardware offload API to support
rtnl-independent drivers" series and refactoring patch that implements
infrastructure necessary for the fixes.

Vlad Buslov (3):
  net: sched: extend flow_action_entry with destructor
  net: sched: take reference to psample group in flow_action infra
  net: sched: use get_dev() action API in flow_action infra

 include/net/act_api.h          |  9 +++-
 include/net/flow_offload.h     |  6 ++-
 include/net/psample.h          |  1 +
 include/net/tc_act/tc_sample.h |  6 ---
 net/psample/psample.c          | 20 +++++---
 net/sched/act_mirred.c         | 21 +++++----
 net/sched/act_sample.c         | 27 +++++++++++
 net/sched/cls_api.c            | 83 ++++++++++++++++++++--------------
 8 files changed, 116 insertions(+), 57 deletions(-)

-- 
2.21.0

