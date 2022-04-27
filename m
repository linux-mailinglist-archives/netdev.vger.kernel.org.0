Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE00551207C
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243304AbiD0Qj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 12:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243446AbiD0QjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 12:39:22 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1831D31DC6
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 09:36:11 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id h12so1999278plf.12
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 09:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x88jfXHODIYZYYx8Evzl8Oyf6gg9JENCs/CHW2K9eDk=;
        b=Xaudg5KJ1tTSNXvgSfEblPx4ZD4NV+j+HN1yYSewcCnlzY0u6fjVj38H0Jpc4fJGAi
         Pzsrk+HRHIXJsckrZ9H0exVCr6HtT1rQtUugXgtsPbhQ/AevT9RDs0BQBRVVFWbR0Ghx
         G1/Gr+8E4wb7WrtjtKY8FNUF/O3FqT7js7DvGha0feK1D8AGz/n3epcYdLOvghbLCCG5
         FSh52tFn2nOjGXTlVvqjvH9S/uols4ZEhu9ebcpslKbRvGaoaF52Y2pZWsphufXjV3xf
         rvrwnb7rAVAIyYvLJYoPvjp6/qoDcH9FX7ewxTJ2cn4t1LhSlv+k1OgX9ITW1BMUBym+
         Oo4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x88jfXHODIYZYYx8Evzl8Oyf6gg9JENCs/CHW2K9eDk=;
        b=M81OVGjkPC4Vmwy2tlBuj7INqgWLxtTwbQ7m9OaowBwv0WmZjW4n9ep7EcQ+ZLTWR8
         ufk+BFyKcxqRu8NRRn3di93rN7Xx8HK6r4gBAV6CT5qupVukGqckX9nlhlkUkm1rJgh0
         w4znVol2Y465ptbKG8GcokX8unRQqgJrT2DSMVNuz5Ss0XGRNNVkElpCE4kcYfo4uz0c
         co0JPEPVEHSbJ8YrwzInPHOh7VZaf3etRJ6rZMSF8MdQ2CbV0xdMF3ehl81lkdn4aMHK
         zndGu5uw4G/ShBuICc/FRuQj8ysk2ejGyZ5tgYIzh7FE+iRMCwQeHXopy1mJm1S0ERsD
         9Arw==
X-Gm-Message-State: AOAM530BOWEGIPpoRMD7qC7Hl+LCA/RxoyQpM4nV/7Lb5cnegeWUGKZv
        u1ZUBI+f9cmREHgUITNsnZyhY/JF5qI=
X-Google-Smtp-Source: ABdhPJxEh9Td1rdrXgWeXbOYLOyRkxQRE/LoCak4s31kVh9+/sThMI/UJPc2S5uTQIlsHwDx1nEx6w==
X-Received: by 2002:a17:90b:4b0f:b0:1d9:f28f:735a with SMTP id lx15-20020a17090b4b0f00b001d9f28f735amr7943510pjb.160.1651077370310;
        Wed, 27 Apr 2022 09:36:10 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i23-20020a056a00225700b0050d38d0f58dsm12562187pfu.213.2022.04.27.09.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 09:36:09 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     michael.chan@broadcom.com, zajec5@gmail.com, andy@kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v2] MAINTAINERS: Update BNXT entry with firmware files
Date:   Wed, 27 Apr 2022 09:36:06 -0700
Message-Id: <20220427163606.126154-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There appears to be a maintainer gap for BNXT TEE firmware files which
causes some patches to be missed. Update the entry for the BNXT Ethernet
controller with its companion firmware files.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:

- corrected header path (missing leading include/)

 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index f585242da63d..7a032c4126d5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3927,7 +3927,9 @@ BROADCOM BNXT_EN 50 GIGABIT ETHERNET DRIVER
 M:	Michael Chan <michael.chan@broadcom.com>
 L:	netdev@vger.kernel.org
 S:	Supported
+F:	drivers/firmware/broadcom/tee_bnxt_fw.c
 F:	drivers/net/ethernet/broadcom/bnxt/
+F:	include/linux/firmware/broadcom/tee_bnxt_fw.h
 
 BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER
 M:	Arend van Spriel <aspriel@gmail.com>
-- 
2.25.1

