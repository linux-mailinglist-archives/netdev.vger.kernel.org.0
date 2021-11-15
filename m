Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D54F4451643
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 22:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243008AbhKOVSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 16:18:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350482AbhKOUX4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 15:23:56 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C64C061206
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 12:20:43 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id bi37so41798517lfb.5
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 12:20:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FWOr3QrE6ptqw2sQO4bDDCW0CNVpympwt1gaE5gu95A=;
        b=NfNBcI2RI3Jut3vXhRnuEPqguRgu/ZuuzT94vXmIJdsrAgcYVGzXTEMMr/iuM4CoMy
         UXUYEX2Wfs1YkiFqzbDhP8iXO+WnNBMAu7gSFZj6n/iEDt61x48amjMUk1cfc2kEw5Tf
         xUUCX5P2RuUJ2sPXQwZwWe0iz10j03DpPfIL8WNuHgBqTy+asj1bA6eq9KpvMaChhhA/
         qI+o8uZaiSkMKgFJQ0U0W245L5+9HYC8aidt/xlLKJwjDU+BkmAwaF3YfE/EEqKNpK3n
         fInZJcrQnmHMvYg5WHe/P73U3NQ5BG3ZnGTUNSUTz26FT42LhWACFu63bp+9jo7DEk9M
         BSiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FWOr3QrE6ptqw2sQO4bDDCW0CNVpympwt1gaE5gu95A=;
        b=J6Tg9VY/E/4amJH0+51vfqOjEwf5d4r7nDKWBfu7sUOFjWW89w8e4G0beGjxo/Ux7m
         dISwf/9yUGKuDoCfu+V9gomC+QPTWLQbpUYcUsRjglk66sCAtoqxWdUfNRY5MpKJ3mPK
         lHpiUTA4fNeLnjF4THXGDThiPkQuKCC0CVC3pXPb7QVnD63TFG8dr33WoT8ROreZK+qq
         l6/vwG42LjKQUdBlMD0onV/ZQ9bWwVb2PoVNyCayMsCptzA9CnbqE0DQVk4xdJPS1dno
         zoI926ityAALvmzRu//M2OvvMe8Ti3lqHZ09XLhrdnxSptuYdznvYDepV8/cxhmXJMQb
         Y7TA==
X-Gm-Message-State: AOAM532KgP8cPw7WP6IvYOVxq6heJQ/BI+k1t8YBnLukEV15z5N5vuUm
        /sAwOzyv9Z7VEZM5ja3CnaP7s9zMLu0=
X-Google-Smtp-Source: ABdhPJzPK7TUneYhnn+AnevVRTMOjBxGybCuvk4cYoE1ZcW3XxZPFJm8M5DMvrsAZTrlrNwHxOnPYg==
X-Received: by 2002:a05:6512:33a5:: with SMTP id i5mr1383320lfg.324.1637007641727;
        Mon, 15 Nov 2021 12:20:41 -0800 (PST)
Received: from localhost.localdomain ([94.103.224.112])
        by smtp.gmail.com with ESMTPSA id g3sm3940ljj.37.2021.11.15.12.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 12:20:41 -0800 (PST)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, aelior@marvell.com, skalluru@marvell.com,
        Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH] MAINTAINERS: remove GR-everest-linux-l2@marvell.com
Date:   Mon, 15 Nov 2021 23:20:28 +0300
Message-Id: <20211115202028.26637-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115061231.0426ceb4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211115061231.0426ceb4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I've sent a patch to GR-everest-linux-l2@marvell.com few days ago and
got a reply from postmaster@marvell.com:

	Delivery has failed to these recipients or groups:

	gr-everest-linux-l2@marvell.com<mailto:gr-everest-linux-l2@marvell.com>
	The email address you entered couldn't be found. Please check the
	recipient's email address and try to resend the message. If the problem
	continues, please contact your helpdesk.

Since this email bounces, let's remove it from MAINTAINERS file.

Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---

CCed others related maintainers from marvell, maybe they know what
happened with this email

---
 MAINTAINERS | 2 --
 1 file changed, 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7a2345ce8521..305008573765 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3733,7 +3733,6 @@ F:	drivers/scsi/bnx2i/
 BROADCOM BNX2X 10 GIGABIT ETHERNET DRIVER
 M:	Ariel Elior <aelior@marvell.com>
 M:	Sudarsana Kalluru <skalluru@marvell.com>
-M:	GR-everest-linux-l2@marvell.com
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/ethernet/broadcom/bnx2x/
@@ -15593,7 +15592,6 @@ F:	drivers/scsi/qedi/
 
 QLOGIC QL4xxx ETHERNET DRIVER
 M:	Ariel Elior <aelior@marvell.com>
-M:	GR-everest-linux-l2@marvell.com
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/ethernet/qlogic/qed/
-- 
2.33.1

