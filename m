Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF78D37654F
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 14:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236866AbhEGMjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 08:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234637AbhEGMjy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 08:39:54 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56CDC061574;
        Fri,  7 May 2021 05:38:53 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id h20so5074444plr.4;
        Fri, 07 May 2021 05:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V2QkfKdpEHJJIIb1JoACkfG5cOz8DGvT5HaBWD4QhcQ=;
        b=vNOdDHoEy0rFlewwAuucQqgBrKDIe6bCb83y1XBeIFa9kXUulQXxcC39Z4g8Mbb3YF
         Wj36BcQ2JgMkQ12fuQr8UPVTGxccWonHD+P2fp/4LMHgu49K0XDKC4l0wYhPuJx+xms/
         yGK5+z8ftaWiH6pnUghFomdQ5CNQhVWhW5GJM9S1iwiea0li38KInNiOUf4pOKfcoVTq
         SDZ+nJC29fRD2M13BgCdO+3ZfYDOLD3m0zJOfMNVWBNA41E7Ejn2HWL4fsvOFK85Ntr1
         yYmxw083idXScby1lcAr9LtbNFXO6xT1S+POXHZoLbQug+ewHSgayjcIF2pXvV5f/6fF
         Kanw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V2QkfKdpEHJJIIb1JoACkfG5cOz8DGvT5HaBWD4QhcQ=;
        b=bd3OKqu0lT/D+9eWwzeBhjrMAnAOFwIFCDK2lPBuLGAH5dbqdNGzPEpPD5qtDEgMQo
         Z4qeqzgNosT7ud+zHrbYLSx4CDqWVP2ZfFIOphHQ/P6OD1DsIzmCue4fBveQ3fFlRiRi
         QHF4RRrAzkWsMIf9qIZtmWkisqkDbRu7e4p0wmQhXlaIVGnBsjVm8ppivft3pLTG3gxV
         96ecCCN4QlIc/EG3Vm1AiLu6mVZglyQof1vv9wTENVwP6PbIaXRvLCx/a687vz4eXdzm
         uGOYSOQ4cttRnkjEg6OMvSXQnevwiLJlfafg0GX9wOIMQEVnNaO0Kh1FjkZ0SYIEymxo
         RL/A==
X-Gm-Message-State: AOAM532rK5bJSCIclMjyiFCCgdtaYRBnsL0gfNbiduIh+2klPTPB4t1j
        x2AgdFnozDKmXZVYy8Z5j8W/B3hwYLv+mCg0joQ=
X-Google-Smtp-Source: ABdhPJx0ynkI4saw2/ZHzQHS55qTCskrcOpSISb5mZNj+4j6Ddb3zi6Kbtufw9xPKScr7LQORlhgew==
X-Received: by 2002:a17:902:8303:b029:ee:f005:48c with SMTP id bd3-20020a1709028303b02900eef005048cmr9590104plb.71.1620391133126;
        Fri, 07 May 2021 05:38:53 -0700 (PDT)
Received: from localhost.localdomain (host-219-71-67-82.dynamic.kbtelecom.net. [219.71.67.82])
        by smtp.gmail.com with ESMTPSA id j12sm4504705pff.49.2021.05.07.05.38.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 05:38:52 -0700 (PDT)
From:   Wei Ming Chen <jj251510319013@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     3chas3@gmail.com, netdev@vger.kernel.org,
        Wei Ming Chen <jj251510319013@gmail.com>
Subject: [PATCH] atm: firestream: Use fallthrough pseudo-keyword
Date:   Fri,  7 May 2021 20:38:43 +0800
Message-Id: <20210507123843.10602-1-jj251510319013@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add pseudo-keyword macro fallthrough[1]

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through

Signed-off-by: Wei Ming Chen <jj251510319013@gmail.com>
---
 drivers/atm/firestream.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/atm/firestream.c b/drivers/atm/firestream.c
index 0ddd611b4277..3bc3c314a467 100644
--- a/drivers/atm/firestream.c
+++ b/drivers/atm/firestream.c
@@ -795,6 +795,7 @@ static void process_incoming (struct fs_dev *dev, struct queue *q)
 		switch (STATUS_CODE (qe)) {
 		case 0x1:
 			/* Fall through for streaming mode */
+			fallthrough;
 		case 0x2:/* Packet received OK.... */
 			if (atm_vcc) {
 				skb = pe->skb;
-- 
2.25.1

