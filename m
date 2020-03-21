Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06DC918DFD3
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 12:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728461AbgCUL30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 07:29:26 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:47564 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726834AbgCUL3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 07:29:25 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id DE3DE41037;
        Sat, 21 Mar 2020 19:29:18 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, paulb@mellanox.com
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH nf-next 0/3] netfilter: nf_flow_table_offload: add nf_conn_acct for flowtable offload
Date:   Sat, 21 Mar 2020 19:29:15 +0800
Message-Id: <1584790158-9752-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVNSk9CQkJMTEpKSkNKTVlXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OD46Nxw5Nzg0PBMwAxAPIQk#
        MghPCVFVSlVKTkNPTEJLSk5DQkJLVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpIQ0o3Bg++
X-HM-Tid: 0a70fcdabe4e2086kuqyde3de41037
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

An offloaded conntrack in flowtable will never count the nf_conn_act
counter after the flow is offloaded in SW or HW.

wenxu (3):
  netfilter: nf_flow_table: add nf_conn_acct for SW flowtable offload
  netfilter: nf_flow_table: add nf_conn_acct for HW flowtable offload
  net/sched: act_ct: add nf_conn_acct for SW act_ct flowtable offload

 include/net/netfilter/nf_flow_table.h |  4 ++++
 net/netfilter/nf_flow_table_core.c    | 19 +++++++++++++++++++
 net/netfilter/nf_flow_table_ip.c      |  4 ++++
 net/netfilter/nf_flow_table_offload.c |  8 ++++++++
 net/sched/act_ct.c                    |  1 +
 5 files changed, 36 insertions(+)

-- 
1.8.3.1

