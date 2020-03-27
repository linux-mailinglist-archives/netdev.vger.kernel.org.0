Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9303E19536C
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 09:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbgC0I5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 04:57:04 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:46105 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726661AbgC0I5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 04:57:01 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 1F05E5C03DF;
        Fri, 27 Mar 2020 04:57:00 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 27 Mar 2020 04:57:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=NLDCLkEP2pzPImizF0ljgLoXu4lcuTF7Zz5Lgdyw5i8=; b=lUo5A3b8
        TMggDR7E1wMK7xEIe5JORRAr7iRysivxYa5QRn5+VeROJY/rj55tZ+YgfIcW2b2t
        n/OlChYqz8juKrvm05wJlOjc8DeMXHuGA36XUFwkKGjvF1ABEA8WChJos8Z2SumC
        GJUn+RMTZVOhcJLjvsizzbEo/UtIJgI+/OjDf57S+zm5SbvdWTyrD1pq6xHlgMNk
        NcuvbRBMOZYtPsqKJvguT9c78fsm8FoLN9w2A6WO5OCQsvRIS/8IVRNVQBgSxIZC
        Rjq2eiSkQ8J5qbqmenKAV/SOrinx5++KmlI0pJ3NmI6m2qICJMofSOosSKWIBna1
        NoXdUzhCK3O1iw==
X-ME-Sender: <xms:2799XgFmV27RtTXCIvE7uxhzopJGa7AzTgt2CcM4XeP640bB-dtPpg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudehkedgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudekuddrudefvddrudeludenucevlhhushhtvg
    hrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhs
    tghhrdhorhhg
X-ME-Proxy: <xmx:3L99XgeG5tqadP4MRzxz9pctmNDewSp0_1IrPPZMIHstvVGoFgsaEA>
    <xmx:3L99XsjX3-AUxLREiQN8Gr2Gp0rZmPAYIM-SpdCNnhsD6_NezBTS6w>
    <xmx:3L99Xrx67PTHB5xxIyn6qL8Y2jjRvSV-p5Y4qoQ8nnBWjjgf_Iocnw>
    <xmx:3L99Xsh67ym1gt4ACeHsV8ZIk2vLJ8Ojm0hIsjwe0kRAAjOCIgptNQ>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id D372C306C157;
        Fri, 27 Mar 2020 04:56:58 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, kuba@kernel.org,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 5/6] mlxsw: switchx2: Remove unnecessary conversion to bool
Date:   Fri, 27 Mar 2020 11:55:24 +0300
Message-Id: <20200327085525.1906170-6-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200327085525.1906170-1-idosch@idosch.org>
References: <20200327085525.1906170-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Suppress following warning from coccinelle:

drivers/net/ethernet/mellanox/mlxsw//switchx2.c:183:63-68: WARNING:
conversion to bool not needed here

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/switchx2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
index f0e98ec8f1ee..90535820b559 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
@@ -180,7 +180,7 @@ static int mlxsw_sx_port_oper_status_get(struct mlxsw_sx_port *mlxsw_sx_port,
 	if (err)
 		return err;
 	oper_status = mlxsw_reg_paos_oper_status_get(paos_pl);
-	*p_is_up = oper_status == MLXSW_PORT_ADMIN_STATUS_UP ? true : false;
+	*p_is_up = oper_status == MLXSW_PORT_ADMIN_STATUS_UP;
 	return 0;
 }
 
-- 
2.24.1

