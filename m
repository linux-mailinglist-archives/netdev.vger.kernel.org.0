Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB651F888B
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 13:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgFNLNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 07:13:02 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:54952 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726630AbgFNLM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jun 2020 07:12:57 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from roid@mellanox.com)
        with SMTP; 14 Jun 2020 14:12:51 +0300
Received: from dev-r-vrt-138.mtr.labs.mlnx (dev-r-vrt-138.mtr.labs.mlnx [10.212.138.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 05EBCocn013296;
        Sun, 14 Jun 2020 14:12:51 +0300
From:   Roi Dayan <roid@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     pablo@netfilter.org, davem@davemloft.net,
        Jiri Pirko <jiri@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Roi Dayan <roid@mellanox.com>, Alaa Hleihel <alaa@mellanox.com>
Subject: [PATCH net 0/2] remove dependency between mlx5, act_ct, nf_flow_table
Date:   Sun, 14 Jun 2020 14:12:47 +0300
Message-Id: <20200614111249.6145-1-roid@mellanox.com>
X-Mailer: git-send-email 2.8.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Some exported functions from act_ct and nf_flow_table being used in mlx5_core.
This leads that mlx5 module always require act_ct and nf_flow_table modules.
Those small exported functions can be moved to the header files to
avoid this module dependency.

Thanks,
Roi

Alaa Hleihel (2):
  net/sched: act_ct: Make tcf_ct_flow_table_restore_skb inline
  netfilter: flowtable: Make nf_flow_table_offload_add/del_cb inline

 include/net/netfilter/nf_flow_table.h | 49 ++++++++++++++++++++++++++++++++---
 include/net/tc_act/tc_ct.h            | 11 +++++++-
 net/netfilter/nf_flow_table_core.c    | 45 --------------------------------
 net/sched/act_ct.c                    | 11 --------
 4 files changed, 55 insertions(+), 61 deletions(-)

-- 
2.8.4

