Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71EB9178FC9
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 12:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387863AbgCDLtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 06:49:50 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:48400 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387799AbgCDLtu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 06:49:50 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 4 Mar 2020 13:49:43 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 024BnhYj021118;
        Wed, 4 Mar 2020 13:49:43 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH net-next 0/2] Fixes for tc act_ct software offload of established flows (diff v4->v6)
Date:   Wed,  4 Mar 2020 13:49:37 +0200
Message-Id: <1583322579-11558-1-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

v4 of the original patchset was accidentally merged while we moved ahead
with v6 review. This two patches are the diff between v4 that was merged and
v6 that was the final revision, which was acked by the community.

Paul Blakey (2):
  net/sched: act_ct: Fix ipv6 lookup of offloaded connections
  net/sched: act_ct: Use pskb_network_may_pull()

 net/sched/act_ct.c | 64 ++++++++++++++++++++++++------------------------------
 1 file changed, 28 insertions(+), 36 deletions(-)

-- 
1.8.3.1

