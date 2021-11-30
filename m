Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E63C462D48
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 08:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238944AbhK3HHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 02:07:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233094AbhK3HHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 02:07:05 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7DC6C061574
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 23:03:46 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id v1so82482112edx.2
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 23:03:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fgOiqpB1tXarJbSfmYMliPn3GvONsVS4HcW0F4qCZHU=;
        b=ibGtIuMus7VzHGQ/E0u3stlFRgn8PDi+xOG/W+IAhvuS0u6b+GDgOmOuMepjlwykak
         +zVcm/i0qyY/W7xIDw+A/fuT4oC6p96O6AaW7Ntsg5Q1OkA18Kj4BIK9zPSOhFwowW38
         7otIeqTF1uc1EgVc2rHxamq3Y41Dn9oWUWOtEKEdkSg9685MCTtcnvbCgMGZvfAdeqTg
         QczMm8FyGKbcg2QgJqh5qi+BaTpUPrvyNMkmy/+O7EnCcMyNyalvRB0YUyprJG6I4Cec
         EiXKuEFrbWSSP5qjsyObg18QSkZySOg/+ijd84fJqxh5Pyq0rVgTWS0Qcty+gUTxPgYW
         lfDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fgOiqpB1tXarJbSfmYMliPn3GvONsVS4HcW0F4qCZHU=;
        b=b+J7qyEonZfEt9gDLvb//J5OA5rnNRCBj+70mTUWj7dDblxAs0YvQrcWKNPsBGaUoF
         SnJ2uy342758/+PDk2Xr8xbTB7wyaDYGY+qemsPeruFVltto9C4bD9pGjbEl+t/pkWLZ
         FopGxD6JbkhNTJZgF1Vw7YDf507Bbm63xJh0uCSbfGnak4qyFvr0qQonKPA2+AuprBHM
         xxc0RglYn5wTL3iFxBCUJ8ijrqAi/1X7bFZymWxCr8Y8U+TCna9CzJ+aaq0fuLh/XgoN
         LH9yDrSH79Ax89ZNVgJaVxcjYJmquyfRgZZ1PkPtDv5ywzDy/jutoLF5bYZWaM4tco6I
         73Gw==
X-Gm-Message-State: AOAM531atbk+I3PjZf/cpLnv12NwcdGtRPQ5XjMaQclaJjS7zfEg46uF
        E75li67SMSlXeU3pdOS8lVE=
X-Google-Smtp-Source: ABdhPJwNezQ7Co8ahHMPkwzQWdrKupNRosdkXnG30PILcJJ9iLInB/XhRxGHc6Xxwv7Og4DhZiTniw==
X-Received: by 2002:a17:906:35d7:: with SMTP id p23mr65877544ejb.32.1638255825281;
        Mon, 29 Nov 2021 23:03:45 -0800 (PST)
Received: from localhost ([45.153.160.134])
        by smtp.gmail.com with ESMTPSA id i8sm12122153edc.12.2021.11.29.23.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 23:03:44 -0800 (PST)
From:   =?UTF-8?q?J=CE=B5an=20Sacren?= <sakiwit@gmail.com>
To:     rajur@chelsio.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next] net: cxgb3: fix typos in kernel doc
Date:   Tue, 30 Nov 2021 00:03:10 -0700
Message-Id: <20211130070312.5494-1-sakiwit@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jean Sacren <sakiwit@gmail.com>

Fix two trivial typos of 'pakcet' in cxgb3 kernel doc.

Signed-off-by: Jean Sacren <sakiwit@gmail.com>
---
 drivers/net/ethernet/chelsio/cxgb3/sge.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb3/sge.c b/drivers/net/ethernet/chelsio/cxgb3/sge.c
index 70f528a9c727..62dfbdd33365 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/sge.c
@@ -1956,7 +1956,7 @@ static int ofld_poll(struct napi_struct *napi, int budget)
  *	@rx_gather: a gather list of packets if we are building a bundle
  *	@gather_idx: index of the next available slot in the bundle
  *
- *	Process an ingress offload pakcet and add it to the offload ingress
+ *	Process an ingress offload packet and add it to the offload ingress
  *	queue. 	Returns the index of the next available slot in the bundle.
  */
 static inline int rx_offload(struct t3cdev *tdev, struct sge_rspq *rq,
@@ -2082,7 +2082,7 @@ static void cxgb3_process_iscsi_prov_pack(struct port_info *pi,
  *	@pad: padding
  *	@lro: large receive offload
  *
- *	Process an ingress ethernet pakcet and deliver it to the stack.
+ *	Process an ingress ethernet packet and deliver it to the stack.
  *	The padding is 2 if the packet was delivered in an Rx buffer and 0
  *	if it was immediate data in a response.
  */
