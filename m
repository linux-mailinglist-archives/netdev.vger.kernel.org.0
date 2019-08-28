Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1852AA0794
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 18:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbfH1Qlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 12:41:47 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:38428 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726315AbfH1Qlr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 12:41:47 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 28 Aug 2019 19:41:45 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x7SGfjCt013915;
        Wed, 28 Aug 2019 19:41:45 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, saeedm@mellanox.com, idosch@mellanox.com,
        Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH net-next 0/2] Fixes for unlocked cls hardware offload API refactoring
Date:   Wed, 28 Aug 2019 19:41:02 +0300
Message-Id: <20190828164104.6020-1-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two fixes for my "Refactor cls hardware offload API to support
rtnl-independent drivers" series.

Vlad Buslov (2):
  net: sched: cls_matchall: cleanup flow_action before deallocating
  net/mlx5e: Move local var definition into ifdef block

 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 6 ++++--
 net/sched/cls_matchall.c                          | 2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

-- 
2.21.0

