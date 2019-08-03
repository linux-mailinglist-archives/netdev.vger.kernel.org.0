Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF05F80656
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 15:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390961AbfHCNgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Aug 2019 09:36:44 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:35703 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388206AbfHCNgn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Aug 2019 09:36:43 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 3 Aug 2019 16:36:41 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x73DafNd027404;
        Sat, 3 Aug 2019 16:36:41 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     pieter.jansenvanvuuren@netronome.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH net 0/2] action fixes for flow_offload infra compatibility
Date:   Sat,  3 Aug 2019 16:36:17 +0300
Message-Id: <20190803133619.10574-1-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix rcu warnings due to usage of action helpers that expect rcu read lock
protection from rtnl-protected context of flow_offload infra.

Vlad Buslov (2):
  net: sched: police: allow accessing police->params with rtnl
  net: sched: sample: allow accessing psample_group with rtnl

 include/net/tc_act/tc_police.h | 4 ++--
 include/net/tc_act/tc_sample.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

-- 
2.21.0

