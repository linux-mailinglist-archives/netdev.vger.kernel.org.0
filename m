Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0BA92024DD
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 17:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbgFTPoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 11:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727090AbgFTPoB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 11:44:01 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69FF6C0613EF
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 08:44:01 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id l12so13489591ejn.10
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 08:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=to2AqLSTfavP6U6YTyENCQo8HRlGiqd2+4cHvugjVIM=;
        b=QkPL7EvwvtYLHHnHW54+u3wAwWc7dsFTYsUzKEjZeK8YmsKtMWIrL4ug2DjJmSqY7X
         UWOp2QntsMRYv4Q4eTBdaOHUEEEVoZxSrBt3Heo1jZIAGWgKRtgjdmzoDETUD74pEAUO
         9ZwJzgBDqoRr8xGV1stfPFkLtBkz/tbwK9TIDhcu6BaZ19hns7u3dGjSZpf/nMtpB4nE
         sLp/Q27s7njxjkRKbVILeTQRLY+BtK5MEYq1ipURN7rtGqQY5mRVw8/XrGnOh+tv/xiW
         Rmfjchn2VrIAdyiAMl+FMd5ZtxS3ezqhJug8t+AijBNGU9E0952dloHmsS54XAKpJC9m
         wcMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=to2AqLSTfavP6U6YTyENCQo8HRlGiqd2+4cHvugjVIM=;
        b=ZdrRKkC6hsXfIwEMmj7ClXtIry7cXOLw4+Zm4JQKui0NUXbehlVjY1R+Ieau6TOwVV
         +ikl4wjHA5/NsD1h25j8BagXVvqXWb03QZMyTGp2SHi1Ubbr5uoA2hZy/REHbNopmDxd
         qIgS6X7cUiIikqgY7fIlgmCVfidpCurkAvJUS5pYaV3cGBykDQuMEfxWrdqO1tuxdHLF
         O6G1hi9ClgYk0vNpEpfFj/aiwQcV4+DVV91il9ngLrllieoLusdExMFaxg/q+IEOFhoy
         DANtezBMyksZDF2cvAe5mA0jKetm62ibZn48tF4OWVIjJeNnpjjnu58tjqrCDcmFVYPo
         d/pg==
X-Gm-Message-State: AOAM532ihZUAneEvCm2FiVHSWeHqBnlfRpkdblKxCLL2De/zibSx3N5p
        7dO4tOybTG2oy2/mS7uw5KI=
X-Google-Smtp-Source: ABdhPJy27SiXFaktmT/szJpfKdH52FfzgjGWaFaJCXgUhxwnfyAgOSafMTofKdQKD8ZBlWp6Ny2qpA==
X-Received: by 2002:a17:906:57d3:: with SMTP id u19mr8628124ejr.401.1592667840096;
        Sat, 20 Jun 2020 08:44:00 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id n25sm7721222edo.56.2020.06.20.08.43.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2020 08:43:59 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     UNGLinuxDriver@microchip.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com
Subject: [PATCH net-next 05/12] net: mscc: ocelot: rename module to mscc_ocelot
Date:   Sat, 20 Jun 2020 18:43:40 +0300
Message-Id: <20200620154347.3587114-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200620154347.3587114-1-olteanv@gmail.com>
References: <20200620154347.3587114-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

mscc_ocelot is a slightly better name for a module than ocelot_board or
ocelot_vsc7514 is, so let's use that.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/Makefile b/drivers/net/ethernet/mscc/Makefile
index ad97a5cca6f9..53572bb76ccd 100644
--- a/drivers/net/ethernet/mscc/Makefile
+++ b/drivers/net/ethernet/mscc/Makefile
@@ -2,4 +2,5 @@
 obj-$(CONFIG_MSCC_OCELOT_SWITCH) += mscc_ocelot_common.o
 mscc_ocelot_common-y := ocelot.o ocelot_io.o
 mscc_ocelot_common-y += ocelot_regs.o ocelot_tc.o ocelot_police.o ocelot_ace.o ocelot_flower.o ocelot_ptp.o
-obj-$(CONFIG_MSCC_OCELOT_SWITCH_OCELOT) += ocelot_vsc7514.o
+obj-$(CONFIG_MSCC_OCELOT_SWITCH_OCELOT) += mscc_ocelot.o
+mscc_ocelot-y := ocelot_vsc7514.o
-- 
2.25.1

