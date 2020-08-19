Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC34B249742
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 09:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgHSH2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 03:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726863AbgHSH0e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 03:26:34 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA29C0612F4
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 00:24:39 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id p14so1086792wmg.1
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 00:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RMRow1FU16at5Rxk8jpAW5P1dc+v6ZWHaxQDTPnHoRc=;
        b=SNPoZoJNR1nbdefomTlSYIsWbZuQ3Rb9aYVkCnxQ5EKjsw955VlAxn93wnWj6zKA++
         Z7P/HsmuuTN3e5lw379MJ++Q9oHqHlkKc2xO7lmhC7QUp+3010Y+xu6Wkwy8laR/Kvvj
         6NzThsBnRydY3/g605qzJcgQPu5ZZ/Fsrs4QhoxwL4bCxRHnvP4VGvxD02PKb+jawEw7
         LDLbQ1CJ+AcwZEpVWo+SbPaUA1G2oWvsWUygGHGFvFWUXOtPVugY2ciaRSjMvlw/h+Es
         gTSoOuYp86qhxiL1DUVcgh6xDOI4VUGam+nElnNCQE92OCBa3d708ajuHdfZpDxFJqHK
         79iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RMRow1FU16at5Rxk8jpAW5P1dc+v6ZWHaxQDTPnHoRc=;
        b=elSGY1qLYbLrh1wrVTp1E8qKvoaGOJTayhoJwM4TfTGIy0NR6m3jTA0zmvOIAgNbMm
         XVyjB0x1uTdNbPulmfheH/mdhJaw0eW/kWAmjIggyr45GWJmh0wLuYG99BFYo52DE5ID
         a6I1hRFW4eKIPiEqE45d4LrYDsP4bZG833kY77k4+7GJReIJWC5S2no3En3akpPQx9jK
         KacCSfCRYCa0Ox4AQOw2MxSeAhUXdSW78EmwPvsJRb31GHwesEQIESG1S+O8IyAaV6hD
         7nUYXygA0P69kDsDrTUQkKBB3ylCvdvYXEC6gAz6xLIRfXomIiVu3i5v6w4DSk5kyc+4
         x54Q==
X-Gm-Message-State: AOAM530wu2JVFxgQqnbVyrb2A2O6lYChBMZjocF31drTW28fckSCjfXi
        aYhHM6eSS4A/5S6y/+kWP3gYCw==
X-Google-Smtp-Source: ABdhPJxOxVsrmr1+wzB7UAUyNoVA3U7c2kWoJmPzX3BBMJXytEyId0jjtlXNg+/jue/OTnEZEesFjA==
X-Received: by 2002:a1c:6557:: with SMTP id z84mr3441429wmb.19.1597821877989;
        Wed, 19 Aug 2020 00:24:37 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id c145sm3795808wmd.7.2020.08.19.00.24.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 00:24:37 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        libertas-dev@lists.infradead.org
Subject: [PATCH 26/28] wireless: marvell: libertas: firmware: Fix misnaming for function param 'device'
Date:   Wed, 19 Aug 2020 08:24:00 +0100
Message-Id: <20200819072402.3085022-27-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200819072402.3085022-1-lee.jones@linaro.org>
References: <20200819072402.3085022-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/marvell/libertas/firmware.c:134: warning: Function parameter or member 'device' not described in 'lbs_get_firmware_async'
 drivers/net/wireless/marvell/libertas/firmware.c:134: warning: Excess function parameter 'dev' description in 'lbs_get_firmware_async'

Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: libertas-dev@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/marvell/libertas/firmware.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas/firmware.c b/drivers/net/wireless/marvell/libertas/firmware.c
index 69029c59a2726..f124110944b7e 100644
--- a/drivers/net/wireless/marvell/libertas/firmware.c
+++ b/drivers/net/wireless/marvell/libertas/firmware.c
@@ -121,12 +121,12 @@ void lbs_wait_for_firmware_load(struct lbs_private *priv)
  *  either a helper firmware and a main firmware (2-stage), or just the helper.
  *
  *  @priv:      Pointer to lbs_private instance
- *  @dev:     	A pointer to &device structure
+ *  @device:   	A pointer to &device structure
  *  @card_model: Bus-specific card model ID used to filter firmware table
  *		elements
  *  @fw_table:	Table of firmware file names and device model numbers
  *		terminated by an entry with a NULL helper name
- *	@callback: User callback to invoke when firmware load succeeds or fails.
+ *  @callback:	User callback to invoke when firmware load succeeds or fails.
  */
 int lbs_get_firmware_async(struct lbs_private *priv, struct device *device,
 			    u32 card_model, const struct lbs_fw_table *fw_table,
-- 
2.25.1

