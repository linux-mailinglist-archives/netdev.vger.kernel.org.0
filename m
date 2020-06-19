Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4D3200484
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 11:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731104AbgFSJCM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 05:02:12 -0400
Received: from smtp.asem.it ([151.1.184.197]:58300 "EHLO smtp.asem.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728712AbgFSJCL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 05:02:11 -0400
Received: from webmail.asem.it
        by asem.it (smtp.asem.it)
        (SecurityGateway 6.5.2)
        with ESMTP id SG000329187.MSG 
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 11:02:07 +0200S
Received: from ASAS044.asem.intra (172.16.16.44) by ASAS044.asem.intra
 (172.16.16.44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 19
 Jun 2020 11:02:05 +0200
Received: from flavio-x.asem.intra (172.16.17.208) by ASAS044.asem.intra
 (172.16.16.44) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 19 Jun 2020 11:02:05 +0200
From:   Flavio Suligoi <f.suligoi@asem.it>
To:     Jon Mason <jdmason@kudzu.us>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Zheng Wei <wei.zheng@vivo.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>, Flavio Suligoi <f.suligoi@asem.it>
Subject: [PATCH 1/1] net: ethernet: neterion: vxge: fix spelling mistake
Date:   Fri, 19 Jun 2020 11:02:04 +0200
Message-ID: <20200619090204.27503-1-f.suligoi@asem.it>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-SGHeloLookup-Result: pass smtp.helo=webmail.asem.it (ip=172.16.16.44)
X-SGSPF-Result: none (smtp.asem.it)
X-SGOP-RefID: str=0001.0A09020B.5EEC7F0E.0002,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0 (_st=1 _vt=0 _iwf=0)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix typo: "trigered" --> "triggered"

Signed-off-by: Flavio Suligoi <f.suligoi@asem.it>
---
 drivers/net/ethernet/neterion/vxge/vxge-config.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/neterion/vxge/vxge-config.h b/drivers/net/ethernet/neterion/vxge/vxge-config.h
index 628fa9b2f741..373165119850 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-config.h
+++ b/drivers/net/ethernet/neterion/vxge/vxge-config.h
@@ -297,7 +297,7 @@ struct vxge_hw_fifo_config {
  * @greedy_return: If Set it forces the device to return absolutely all RxD
  *             that are consumed and still on board when a timer interrupt
  *             triggers. If Clear, then if the device has already returned
- *             RxD before current timer interrupt trigerred and after the
+ *             RxD before current timer interrupt triggered and after the
  *             previous timer interrupt triggered, then the device is not
  *             forced to returned the rest of the consumed RxD that it has
  *             on board which account for a byte count less than the one
-- 
2.17.1

