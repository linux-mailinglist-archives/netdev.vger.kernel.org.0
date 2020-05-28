Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2B71E584F
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 09:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgE1HP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 03:15:58 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:52406 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgE1HP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 03:15:58 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 82E1241EE2;
        Thu, 28 May 2020 15:15:55 +0800 (CST)
From:   wenxu@ucloud.cn
To:     paulb@mellanox.com, saeedm@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 0/2] net/mlx5e: add nat support in ct_metadata
Date:   Thu, 28 May 2020 15:15:53 +0800
Message-Id: <1590650155-4403-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVIT0lLS0tLS0xNSUJIQllXWShZQU
        lCN1dZLVlBSVdZDwkaFQgSH1lBWR0yNQs4HD8VLzkQCSEYQh5OCBwLOhxWVlVJSkxISChJWVdZCQ
        4XHghZQVk1NCk2OjckKS43PllXWRYaDxIVHRRZQVk0MFkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Ogg6KQw*GDg*MzgRLD5ML0sX
        GTwKCghVSlVKTkJLTU5LSk5OTUNOVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpJTkk3Bg++
X-HM-Tid: 0a725a23324f2086kuqy82e1241ee2
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Currently all the conntrack entry offfload rules will be add
in both ct and ct_nat flow table in the mlx5e driver. It is
not makesense.

This serise provide nat attribute in the ct_metadata action which
tell driver the rule should add to ct or ct_nat flow table 

wenxu (2):
  net/sched: act_ct: add nat attribute in ct_metadata
  net/mlx5e: add ct_metadata.nat support in ct offload

 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 34 ++++++++--------------
 include/net/flow_offload.h                         |  1 +
 net/sched/act_ct.c                                 |  1 +
 3 files changed, 14 insertions(+), 22 deletions(-)

-- 
1.8.3.1

