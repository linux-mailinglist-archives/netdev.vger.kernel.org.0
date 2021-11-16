Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B70E4533DC
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 15:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237247AbhKPOQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 09:16:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237250AbhKPOQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 09:16:06 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5295EC061570;
        Tue, 16 Nov 2021 06:13:09 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id l22so53578407lfg.7;
        Tue, 16 Nov 2021 06:13:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SAFo3rW8eZqicBwfdhly0zJ3f49mYTVHGsP4fwuNE6M=;
        b=MUBZmLYHsWTdx+5/t1Gnba93NEA1+CzW6up/O8ayTi9yXCkqkPRb5LM7i9iyAOYpdt
         nQsSmAiVJJJet3zOnm1bL7QX5oW1JHGe7qEqh0eTTXKOqaXGiNG78R6fC+vguErWG0eq
         McCafKtF0gG6DbNjpp8HukkNDCP7ZJhNa1pjuj2h8SRtDnW1dl3SZS7ZetoxKw2Y9vfM
         pzzpcVhkTfsypm5ZjYIJ+saBBTJlMUIZVrMNIp3/AcZIxBfkOQsjtrar9q6AU2ccEl5C
         xjkDM4a4zblFULgbYABH8iDIfvnVr1IAnz0kx+un20/AzvG9dk84Kx9BFp2OEZJ7xyoz
         qrtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SAFo3rW8eZqicBwfdhly0zJ3f49mYTVHGsP4fwuNE6M=;
        b=tmjq9ptD5lWWGAlkEQvZR8GrGJREs5lCRQrXjOe6HmGLyMssgf7m/x9TThx+a92TOk
         vH8Lut4kIScV6pFA9lrtNyZ3950eDJ50C1pn2VTaTNB2EkyeeRB9K0ShBHWt9NNJb30p
         a1ZM9tzyCfxNDRDv6Pnr1fZjSFa69jGivPv3GnYH9CBYyEEfgzMmtqR3OIamoe3r93nc
         2LCg4NUf4fXHVMmQPDRTq/CjNuZfgZzBklD4qvZxpmQLmE8CGwFkHFPfVdmJBekm+ejZ
         UD1s7EidZoSJw0Ln2ktlf2SodIJqTY/9di/i1EYtAM9Tjh7/ux/Ey62lM2Adjfratpk/
         p43g==
X-Gm-Message-State: AOAM533iBJtczYyzjctbTawIkT3FvP7PnNWyG7FN81s9p9Y+xSPdd6jX
        t3vqNkphIx+ewXq1P+2QLYE=
X-Google-Smtp-Source: ABdhPJwLRyDiXtrBK8Po6LmQf+B7tKRmIG7EcnOt9NFPYmPQI/2U4h1HjQQJf29P0sG7sEqT1WJ3XA==
X-Received: by 2002:a05:6512:1520:: with SMTP id bq32mr7019710lfb.232.1637071987677;
        Tue, 16 Nov 2021 06:13:07 -0800 (PST)
Received: from localhost.localdomain ([94.103.224.112])
        by smtp.gmail.com with ESMTPSA id bt3sm1770397lfb.132.2021.11.16.06.13.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 06:13:07 -0800 (PST)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, manishc@marvell.com
Cc:     netdev@vger.kernel.org, aelior@marvell.com, skalluru@marvell.com,
        linux-kernel@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH v2] MAINTAINERS: remove GR-everest-linux-l2@marvell.com
Date:   Tue, 16 Nov 2021 17:13:03 +0300
Message-Id: <20211116141303.32180-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211116081601.11208-1-palok@marvell.com>
References: <20211116081601.11208-1-palok@marvell.com>
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

As requested by Alok Prasad, replacing GR-everest-linux-l2@marvell.com
with Manish Chopra's email address. [0]

Link: https://lore.kernel.org/all/20211116081601.11208-1-palok@marvell.com/ [0]
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---

Changes in v2:
	Replaced GR-everest-linux-l2@marvell.com with Manish Chopra's email, as
	requested by Alok.

---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7a2345ce8521..10c8ae3a8c73 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3733,7 +3733,7 @@ F:	drivers/scsi/bnx2i/
 BROADCOM BNX2X 10 GIGABIT ETHERNET DRIVER
 M:	Ariel Elior <aelior@marvell.com>
 M:	Sudarsana Kalluru <skalluru@marvell.com>
-M:	GR-everest-linux-l2@marvell.com
+M:	Manish Chopra <manishc@marvell.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/ethernet/broadcom/bnx2x/
@@ -15593,7 +15593,7 @@ F:	drivers/scsi/qedi/
 
 QLOGIC QL4xxx ETHERNET DRIVER
 M:	Ariel Elior <aelior@marvell.com>
-M:	GR-everest-linux-l2@marvell.com
+M:	Manish Chopra <manishc@marvell.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/ethernet/qlogic/qed/
-- 
2.33.1

