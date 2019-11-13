Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D541FFA929
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 05:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbfKMEqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 23:46:55 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:41504 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727196AbfKMEqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 23:46:52 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 66C33417D0;
        Wed, 13 Nov 2019 12:46:43 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, davem@davemloft.net
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 0/4] netfilter: flow_table_offload something fixes
Date:   Wed, 13 Nov 2019 12:46:38 +0800
Message-Id: <1573620402-10318-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVOTU5LS0tLTkxJSUtPTVlXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6M006Axw6NDg#MRQDNkkoHQkY
        OTcKCS1VSlVKTkxITUlLT0tITklLVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpJSUs3Bg++
X-HM-Tid: 0a6e6315ccf32086kuqy66c33417d0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>


wenxu (4):
  netfilter: flow_table_offload: Fix check ndo_setup_tc when setup_block
  netfilter: flow_table_core: remove unnecessary parameter in
    flow_offload_fill_dir
  netfilter: nf_tables: Fix check the err for FLOW_BLOCK_BIND setup call
  netfilter: nf_tables_api: Fix UNBIND setup in the nft_flowtable_event

 net/netfilter/nf_flow_table_core.c    |  8 ++++----
 net/netfilter/nf_flow_table_offload.c |  3 +++
 net/netfilter/nf_tables_api.c         | 10 ++++++++--
 3 files changed, 15 insertions(+), 6 deletions(-)

-- 
1.8.3.1

