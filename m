Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D847B18DDDF
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 05:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbgCUEsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 00:48:09 -0400
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:18696 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbgCUEsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 00:48:09 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id E989B5C0F43;
        Sat, 21 Mar 2020 12:39:44 +0800 (CST)
From:   wenxu@ucloud.cn
To:     saeedm@mellanox.com
Cc:     paulb@mellanox.com, vladbu@mellanox.com, netdev@vger.kernel.org
Subject: [PATCH net-next v3 0/2] net/mlx5e: add indr block support in the FT mode
Date:   Sat, 21 Mar 2020 12:39:42 +0800
Message-Id: <1584765584-4168-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVJQ0NLS0tKS01DSkpOSVlXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PEk6FBw5KzgrDhMDHAMcPD86
        ChMwCjJVSlVKTkNPTE1OTkNOS09KVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUJLQzcG
X-HM-Tid: 0a70fb63c64f2087kuqye989b5c0f43
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>


wenxu (2):
  net/mlx5e: refactor indr setup block
  net/mlx5e: add mlx5e_rep_indr_setup_ft_cb support

 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 94 ++++++++++++++++++------
 1 file changed, 73 insertions(+), 21 deletions(-)

-- 
1.8.3.1

