Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3DAA1897F2
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 10:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727476AbgCRJcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 05:32:45 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:43910 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726994AbgCRJcp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 05:32:45 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 84B844164F;
        Wed, 18 Mar 2020 17:32:39 +0800 (CST)
From:   wenxu@ucloud.cn
To:     saeedm@mellanox.com, paulb@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next v2 0/2] net/mlx5e: add indr block support in the FT mode
Date:   Wed, 18 Mar 2020 17:32:37 +0800
Message-Id: <1584523959-6587-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVNSkJLS0tKQk1PTk1CSllXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6M1E6Lgw5SDg#PBwhHBgXGBMr
        DDwaFEtVSlVKTkNPTklIQk5CTUxKVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUNNTzcG
X-HM-Tid: 0a70ecfcdd0e2086kuqy84b844164f
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>


wenxu (2):
  net/mlx5e: refactor indr setup block
  net/mlx5e: add mlx5e_rep_indr_setup_ft_cb support

 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 92 ++++++++++++++++++------
 1 file changed, 71 insertions(+), 21 deletions(-)

-- 
1.8.3.1

