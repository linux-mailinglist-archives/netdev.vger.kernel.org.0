Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88FF225B462
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 21:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgIBT2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 15:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbgIBT2L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 15:28:11 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C987C061244;
        Wed,  2 Sep 2020 12:28:11 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id gf14so271519pjb.5;
        Wed, 02 Sep 2020 12:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4JhRROse+kNOO21QbHXBYJkQKD5eudT5u2bqbEXRZLc=;
        b=ObRTgZbxhc8vQ1RyTLeMBpxbQeIc/xpg+xw/I+Fwfjy7R9rcfML+6nMT7ua4LCOgpT
         o3d472eV1/oX/F3J+13DXYsL3gSHVDVE3Ksp1zBGVIuMaayCHZkhoH40jyWtc1PMsphe
         UG18bVYSFHlx+uaUDNkhalKfa+TL5gNykN32VGFGY3cZYXLg39MV94+6PlvpAXwNxnyM
         1sS3vffxSqYGmNU9xrN2/iCIuyi54fxd08RumDnALyPqWe+DVZ4ppCWVK5nSOqNtO5/J
         PqyPxuMoraloMWR5LL8uK2/FKrnLQ8fxe0nYmQDPmkmcD+mMoWDGbg0n2V0kQcxkrpId
         Od3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4JhRROse+kNOO21QbHXBYJkQKD5eudT5u2bqbEXRZLc=;
        b=L6z6842LBOWyLKRYoEInEDb5U4DAC4gJuMuncsyvqzA5tXW8LNHR0aKfLYB1/FbALc
         lz9W5igWIKDsiZWrqor+lMSX4NS72xHjTp+lCLW2GknS86MFY77Fd0z2qfHXRLhugRBZ
         erABAJwahpmPh86771BdJCu4aPR7gRgxuQK9Y1PTAuUq4IvrRD9Yj3HxOeqoWH7FBGNE
         l+UrgdTzTpDY9/1Gt8sG+2WeOlJysTJ0PzoEbm6+cr/i7d4UaEXCvGIK+MlkuTx4EKO/
         bX/egIhQwVdC8xvruN6W6oYhjpoIcUxJI5a698EyRv2ygaroT1kGzsDGC0wOE2kokYq/
         aeEA==
X-Gm-Message-State: AOAM532g2P2ptPMSxMQAesXnlE/XTXkoD+osF4RZynISuerbl69mFFeB
        JLbf3k2DRt2vmm7Jo5wzFs1P+Zgqaag=
X-Google-Smtp-Source: ABdhPJx0fduXCpVKXdGEu2D509a8G4OugP+Sc4hBxVTc0qSSocliwpSqNVQf/K8XI8s542Jx+6u0mQ==
X-Received: by 2002:a17:90a:8402:: with SMTP id j2mr3529296pjn.153.1599074890647;
        Wed, 02 Sep 2020 12:28:10 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8880:9ae0:b49f:31b6:73e2:b3d2])
        by smtp.gmail.com with ESMTPSA id w82sm272465pfc.183.2020.09.02.12.28.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 12:28:09 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Krzysztof Halasa <khc@pm.waw.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Xie He <xie.he.0141@gmail.com>, Martin Schiller <ms@dev.tdt.de>
Subject: [PATCH net v2] drivers/net/wan/hdlc: Change the default of hard_header_len to 0
Date:   Wed,  2 Sep 2020 12:28:05 -0700
Message-Id: <20200902192805.46994-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the default value of hard_header_len in hdlc.c from 16 to 0.

Currently there are 6 HDLC protocol drivers. Among them:

hdlc_raw_eth, hdlc_cisco, hdlc_ppp, hdlc_x25 set hard_header_len when
attaching the protocol, overriding the default. So this patch does not
affect them.

hdlc_raw and hdlc_fr don't set hard_header_len when attaching the
protocol. So this patch will change the hard_header_len of the HDLC
device for them from 16 to 0.

This is the correct change because both hdlc_raw and hdlc_fr don't have
header_ops, and the code in net/packet/af_packet.c expects the value of
hard_header_len to be consistent with header_ops.

In net/packet/af_packet.c, in the packet_snd function,
for AF_PACKET/DGRAM sockets it would reserve a headroom of
hard_header_len and call dev_hard_header to fill in that headroom,
and for AF_PACKET/RAW sockets, it does not reserve the headroom and
does not call dev_hard_header, but checks if the user has provided a
header of length hard_header_len (in function dev_validate_header).

Cc: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---

Change from v1:
Small fix for the English grammar in the commit message.

---
 drivers/net/wan/hdlc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wan/hdlc.c b/drivers/net/wan/hdlc.c
index 386ed2aa31fd..9b00708676cf 100644
--- a/drivers/net/wan/hdlc.c
+++ b/drivers/net/wan/hdlc.c
@@ -229,7 +229,7 @@ static void hdlc_setup_dev(struct net_device *dev)
 	dev->min_mtu		 = 68;
 	dev->max_mtu		 = HDLC_MAX_MTU;
 	dev->type		 = ARPHRD_RAWHDLC;
-	dev->hard_header_len	 = 16;
+	dev->hard_header_len	 = 0;
 	dev->needed_headroom	 = 0;
 	dev->addr_len		 = 0;
 	dev->header_ops		 = &hdlc_null_ops;
-- 
2.25.1

