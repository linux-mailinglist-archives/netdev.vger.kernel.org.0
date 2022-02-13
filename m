Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 188C44B3A0E
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 09:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234287AbiBMIBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 03:01:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiBMIBv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 03:01:51 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A745E763;
        Sun, 13 Feb 2022 00:01:44 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id r18-20020a05683001d200b005ac516aa180so2386912ota.6;
        Sun, 13 Feb 2022 00:01:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:subject:message-id:mime-version:content-disposition;
        bh=jCb7gqCl87X3lFj4ik/ZrnZ/1M02vgp0liV79nV0e+c=;
        b=WtwY2kV61B9rqWF57KH7fQyRqi2o5VI7On4ZCqpS9dsAoxL3uaxCUFJO+ixsAdkt6v
         eBwFa/lhk0iVbByKr6pl8ScsBXsk/wPAaDB3kSgkRGA3HnDUNRB3gVNc1ohdDLBEPriY
         gi1S5a2jnxXs5NfWwGZTyOqJKSkVjdm05M+MZFKNmsAKQCFYhumyqtIKkv2v0c2A/eVL
         zMCNuouixbuz3t3a+w0ljv8Df3H4WzEYFUss9+5dMH/RXvfD4mO5uYgn7SIDSUFdtjzS
         Vlgy0xd4k0wONF1eUkgBRaetYt49bU1G4zsbySctkeGRvuiFpdBW22FCR2ADmUs/eo08
         bAJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=jCb7gqCl87X3lFj4ik/ZrnZ/1M02vgp0liV79nV0e+c=;
        b=1V/pFU1qP4tyWqjSEzUlj6tvnMkhahGq/gi1iNlus/78EQvAV3o601Px3dsQrH7oqH
         cnwJvuJ9f71rG8JTsPfme2ZpbAngJAtPyIfgd9jbL9grhvspubK4QLpReaywV/AYpW6Z
         1uHNIhU3pQidU1uhnk9OozdqiC27UNa4XO9UcUhtiMuIUn9JN9vCp67Cr4nQdkAoTnBk
         TRlvlAozqxOfx4/R2cN6tuHq8y6TJ7/HKe0uRhmhgwVfOzSPHtXuDte8bvstZIMq8Z1F
         0hCaoZgh6QueFf0vxJpr8VInWhwp1JbPzjYdrDoa+gFxyovD8Iut6z7zoVMpXOYGzTh/
         ivlg==
X-Gm-Message-State: AOAM530dM+rmd3yxURhzcF4r4mmSTpDOkI+1+T4GB3tNMihwvShQZR2z
        mR8fpTq7fHAt7xAXZzbtM1zB5V+nJ+sK6A==
X-Google-Smtp-Source: ABdhPJxdS9SM2g6MaOy6mBPWI2vmjJ0/+K9otu2OmCl3OBYOH6XPra8o1PEQg96NSf2Wp3xICijgOg==
X-Received: by 2002:a9d:6e0f:: with SMTP id e15mr3083317otr.103.1644739303734;
        Sun, 13 Feb 2022 00:01:43 -0800 (PST)
Received: from fedora (c-73-59-148-95.hsd1.tn.comcast.net. [73.59.148.95])
        by smtp.gmail.com with ESMTPSA id q16sm3664519oiv.16.2022.02.13.00.01.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Feb 2022 00:01:43 -0800 (PST)
Date:   Sun, 13 Feb 2022 02:01:41 -0600
From:   Michael Catanzaro <mcatanzaro.kernel@gmail.com>
To:     mst@redhat.com, jasowang@redhat.com, davem@davemloft.net,
        kuba@kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mcatanzaro.kernel@gmail.com
Subject: [PATCH] virtio_net: Fix code indent error
Message-ID: <Ygi65QUzYL9oawO8@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes the checkpatch.pl warning:

ERROR: code indent should use tabs where possible #3453: FILE: drivers/net/virtio_net.c:3453: ret = register_virtio_driver(&virtio_net_driver);$

Uneccessary newline was also removed making line 3453 now 3452.

Signed-off-by: Michael Catanzaro <mcatanzaro.kernel@gmail.com>
---
 drivers/net/virtio_net.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index a801ea40908f..11f26b00a226 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3449,8 +3449,7 @@ static __init int virtio_net_driver_init(void)
 				      NULL, virtnet_cpu_dead);
 	if (ret)
 		goto err_dead;
-
-        ret = register_virtio_driver(&virtio_net_driver);
+	ret = register_virtio_driver(&virtio_net_driver);
 	if (ret)
 		goto err_virtio;
 	return 0;
-- 
2.34.1

