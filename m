Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34A5D43E84D
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 20:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbhJ1S1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 14:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbhJ1S1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 14:27:33 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A706C061570
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 11:25:06 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id 62so1909702iou.2
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 11:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RqZ7/5CA1HODzC9Qv9dBD6omMYJNFsXiBGP3IPanlnI=;
        b=K22kdG/EiRNFHLofNmyuVgeYMt03s9bgzEBYacYOlSZVgW3i/AXdeSvHp9dvPMfzKw
         E6lTnhg1bzj4i4RdOdyDOqx55kGkw61CfB80DD+eTkJAYq/JXfTjS9n4qf57XwZyTyHA
         xuJRsIF/D1+ec8gEynuVNMNfOJJlFQZ8nl/LBHdKdmEkQNn4QwyVsx3QST7rq9Q4enii
         etVUUp6wixaQ204+OmLYDwGI9lLiM1nJNZ/7TQi8liR5tCkzvWT30ssJZ/RU/1EsrLR8
         l88uDq2WP+ZAwqlOqQJUsjNb/ccXTUAKBk7TXzeuxdEhFsWG6KNSQwqJeEr1PRFtlHJV
         CFqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RqZ7/5CA1HODzC9Qv9dBD6omMYJNFsXiBGP3IPanlnI=;
        b=w3YvqYgmpzf7vcOxQhQuzll1l09DnHh1Um1x8ZwDzwuU8JfrKpgn9WqlOjyoRZEBWh
         Oab9sXqpF+peNhjHw1wuhIFaEBzD0svkILzaW0BsDv98/Zld9U5Y1amRr/Nf7/OdEhzu
         jPHG+4n85aymLfJi8zdEG0n+RagxWYU6lkFBXkPXCVqg+3ZmUrdCEryt3xaJF4Qm3z8e
         x5A5FWCGwm0OBp0r1zkO3fNO9pvVopskXaoCBZWJ6cvxM6XF7BiLWysaAIP2a/s+b4HK
         YJu6FaJW+ERJUsD+LrZNw9zWcODrETUN087NQeb0icM+bU70x8CIzkZ+MIKfsCwihPMF
         Rj6w==
X-Gm-Message-State: AOAM533zoCWTZOGmJHf3GiRwVarDdPhlV0gUAE3uPkfGJALUdm9Ds/3r
        KTkvRrviUJMpmsYpnLuIDgo=
X-Google-Smtp-Source: ABdhPJznVQf9Pkv1/U6yrJBipQ+k4h67fILrSU02WAuVQucCeNTjTZDkN63zy9z1qHVgOOf+uAlqLQ==
X-Received: by 2002:a5d:9149:: with SMTP id y9mr4184274ioq.67.1635445504315;
        Thu, 28 Oct 2021 11:25:04 -0700 (PDT)
Received: from localhost (elenagb.nos-oignons.net. [185.233.100.23])
        by smtp.gmail.com with ESMTPSA id a20sm1996267ila.22.2021.10.28.11.25.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 11:25:03 -0700 (PDT)
From:   =?UTF-8?q?J=CE=B5an=20Sacren?= <sakiwit@gmail.com>
To:     manishc@marvell.com, rahulv@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next] net: netxen: fix code indentation
Date:   Thu, 28 Oct 2021 12:24:52 -0600
Message-Id: <20211028182453.9713-1-sakiwit@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jean Sacren <sakiwit@gmail.com>

Remove additional character in the source to properly indent if branch.

Signed-off-by: Jean Sacren <sakiwit@gmail.com>
---
 drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
index 4cfab4434e80..07dd3c3b1771 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -844,7 +844,7 @@ netxen_check_options(struct netxen_adapter *adapter)
 	adapter->fw_version = NETXEN_VERSION_CODE(fw_major, fw_minor, fw_build);
 
 	/* Get FW Mini Coredump template and store it */
-	 if (NX_IS_REVISION_P3(adapter->ahw.revision_id)) {
+	if (NX_IS_REVISION_P3(adapter->ahw.revision_id)) {
 		if (adapter->mdump.md_template == NULL ||
 				adapter->fw_version > prev_fw_version) {
 			kfree(adapter->mdump.md_template);
