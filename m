Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B73F72E214C
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 21:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729034AbgLWUZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 15:25:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55914 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728872AbgLWUZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 15:25:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608755014;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=jEGCTVE9ATlTdf8ZAj1SWqLSDSDRJD/XzKNah8054b8=;
        b=AHlAMYcaRPRNwiBsobD2ml70F4X0ITzIGrNM/12ZI/EglEMkTVzD9q0OM+Y/2bQbp3kjUR
        y0nip7POYx92FQf0EE+cPVMvcDQ7vmo74j9AUbqVGgHZhB/McYM1mlP5MsMmgMnTVUon0L
        UB3GRvD/Ob4UaRSbtGN3jY+w3SUD8TA=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-354-CEn2CnmXOG62UL3lXHraCg-1; Wed, 23 Dec 2020 15:23:32 -0500
X-MC-Unique: CEn2CnmXOG62UL3lXHraCg-1
Received: by mail-ot1-f69.google.com with SMTP id q8so103710otk.6
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 12:23:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jEGCTVE9ATlTdf8ZAj1SWqLSDSDRJD/XzKNah8054b8=;
        b=FHTM1ygKhh/HbiXanbIJKWI231Ke+UEfPbHoD/K9PA72ud+XOLQzUZw6ruk2WCQUIg
         mVpkXWuMZTCo/qUsG6vZGLuUHZO0xNmd25QiSG9u3LCnwV2VDxhnwDdAl/UZRuodYVVc
         EXbUVwa7GsZSA6VfLxb23PTpafbdZuL01V6PLH1gS2FOfqFMcrW84tIkf2+UWFmP+31I
         vv//LFjhQ0Y8s4MRuW3G0un19Uylam7ZabmxjI0hY+FoFE25wvIjYLWskqv8ozFQUyhE
         Sof9M4Z4X4B4LUMsucB9kXih4wHH3VQABbo2NpyTiUhVyXScuLTuKxcROvzwU4NJqllh
         oXLg==
X-Gm-Message-State: AOAM530LuVKpoxOrP0pk1EqN8U7QJUKLiZXU4hxBaSTirf63e9q6YIjD
        +3BsPZPpRiwNErAO7CX7NmojWoOaAXY81r6YcI2zMBwWl6qk3o9TDDD4Myr/yDkNXnTNK+XJtrQ
        eVFsMwZbHganCmuHg
X-Received: by 2002:a9d:1720:: with SMTP id i32mr20877435ota.84.1608755011396;
        Wed, 23 Dec 2020 12:23:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyFbSWkQxwEnx6ttmV2i8WlJq8bdhyK9MqNLBTw0YAoOpjxrAWooucw9P+vlT0EwJQN/JS9SA==
X-Received: by 2002:a9d:1720:: with SMTP id i32mr20877423ota.84.1608755011205;
        Wed, 23 Dec 2020 12:23:31 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id r204sm6107896oif.0.2020.12.23.12.23.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Dec 2020 12:23:30 -0800 (PST)
From:   trix@redhat.com
To:     romieu@fr.zoreil.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] via-velocity: remove h from printk format specifier
Date:   Wed, 23 Dec 2020 12:23:26 -0800
Message-Id: <20201223202326.132054-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

This change fixes the checkpatch warning described in this commit
commit cbacb5ab0aa0 ("docs: printk-formats: Stop encouraging use of unnecessary %h[xudi] and %hh[xudi]")

Standard integer promotion is already done and %hx and %hhx is useless
so do not encourage the use of %hh[xudi] or %h[xudi].

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/ethernet/via/via-velocity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/via/via-velocity.c b/drivers/net/ethernet/via/via-velocity.c
index b65767f9e499..119439f78c1b 100644
--- a/drivers/net/ethernet/via/via-velocity.c
+++ b/drivers/net/ethernet/via/via-velocity.c
@@ -1823,7 +1823,7 @@ static void velocity_error(struct velocity_info *vptr, int status)
 	if (status & ISR_TXSTLI) {
 		struct mac_regs __iomem *regs = vptr->mac_regs;
 
-		netdev_err(vptr->netdev, "TD structure error TDindex=%hx\n",
+		netdev_err(vptr->netdev, "TD structure error TDindex=%x\n",
 			   readw(&regs->TDIdx[0]));
 		BYTE_REG_BITS_ON(TXESR_TDSTR, &regs->TXESR);
 		writew(TRDCSR_RUN, &regs->TDCSRClr);
-- 
2.27.0

