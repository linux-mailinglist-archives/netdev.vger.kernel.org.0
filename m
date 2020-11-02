Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9052A29DE
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728822AbgKBLsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:48:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728667AbgKBLpw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:45:52 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9554FC061A54
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:45:47 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id 13so9092461wmf.0
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:45:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AWriSgrmFQKcR5kCIros4j6sVpvbfTSpmeIF4cEJj4k=;
        b=e43KOouByYFhUgBvOtp5cHfzHpKIf//0u16XInSVXKFhV9EnQYDi42dCz6s/RqbLj3
         niOVuSqxo7GznFN6nbDppNfg2jqsPC6wvGwXAzXoK//Srq5UoLk2IJuX7iojxWjdaz50
         ppYk6FnxxLZ2WkKLPu1Ne5k4O31koZZjogktp2TIXDVErjj4bSzgWvHRhXLpWqeWyRf6
         kMmphybgCaihly4pWLj9uKlLUfUspi1hN8TRZbpypQHP/S6lk5cAP07UhqQvJbrgOLt5
         sBDSF7FxSviEqC4ftQq5cv43HasZDmMuaL8isZHUWhL3NDk3iY+duN19/0iDexB/SXhK
         OhCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AWriSgrmFQKcR5kCIros4j6sVpvbfTSpmeIF4cEJj4k=;
        b=WIzC9YVGqkhvXWn/3q6wNnXBeHtW2TJ+o12sfXRq8/xyUodKguiu/HFsSzOXyGUQmI
         osfyhGGihr9NWz13fWPfkl3PtV7MRrTuWQO8/qrErH+zPQUaWb8SlX2UiD6gy8YquVFE
         eEo/rzsJ7J5m9anw3U44ZJ+cTS//dey4jxL910ZNNjqmJ1t1XiMAqtnmWcsvEw4ZLHYR
         ugsxXNJqDh+YnyBuQw2SDjivOAhma8SeNFyAmPQkIbe2Cr5/KxrvUeQ/VmF7O01ZNxM5
         yrCDTBNZkfoetXNk7rblUrcvuaWCzq3i6ZdrhaSuN9zOD5fvPafuP8+vZMgtF2UNYOqD
         JkWw==
X-Gm-Message-State: AOAM532+LxCWsd35fnkxindOmxEgMft0F6HSKSnQNhFXSyxUZMC/yvnC
        9ewRljqJSh/iYVzMEJavWjDAVQ==
X-Google-Smtp-Source: ABdhPJxF3BjV7c1IDu+m/wMMnZ1lMe4fIwNGQw+eqC+8fbuigkZVpETyEuu75ijq4q6zvJzwxqixrA==
X-Received: by 2002:a1c:c286:: with SMTP id s128mr17257532wmf.88.1604317546360;
        Mon, 02 Nov 2020 03:45:46 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id g66sm15545352wmg.37.2020.11.02.03.45.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:45:45 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net
Cc:     Lee Jones <lee.jones@linaro.org>, Jakub Kicinski <kuba@kernel.org>,
        Hayes Wang <hayeswang@realtek.com>,
        nic maintainers <nic_swsd@realtek.com>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 22/30] net: usb: r8152: Provide missing documentation for some struct members
Date:   Mon,  2 Nov 2020 11:45:04 +0000
Message-Id: <20201102114512.1062724-23-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102114512.1062724-1-lee.jones@linaro.org>
References: <20201102114512.1062724-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/usb/r8152.c:934: warning: Function parameter or member 'blk_hdr' not described in 'fw_mac'
 drivers/net/usb/r8152.c:934: warning: Function parameter or member 'reserved' not described in 'fw_mac'
 drivers/net/usb/r8152.c:947: warning: Function parameter or member 'blk_hdr' not described in 'fw_phy_patch_key'
 drivers/net/usb/r8152.c:947: warning: Function parameter or member 'reserved' not described in 'fw_phy_patch_key'
 drivers/net/usb/r8152.c:986: warning: Function parameter or member 'blk_hdr' not described in 'fw_phy_nc'
 drivers/net/usb/r8152.c:986: warning: Function parameter or member 'mode_pre' not described in 'fw_phy_nc'
 drivers/net/usb/r8152.c:986: warning: Function parameter or member 'mode_post' not described in 'fw_phy_nc'
 drivers/net/usb/r8152.c:986: warning: Function parameter or member 'reserved' not described in 'fw_phy_nc'

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Hayes Wang <hayeswang@realtek.com>
Cc: nic maintainers <nic_swsd@realtek.com>
Cc: linux-usb@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/usb/r8152.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index b1770489aca51..cebe2dc15c3f0 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -898,6 +898,7 @@ struct fw_header {
  * struct fw_mac - a firmware block used by RTL_FW_PLA and RTL_FW_USB.
  *	The layout of the firmware block is:
  *	<struct fw_mac> + <info> + <firmware data>.
+ * @blk_hdr: firmware descriptor (type, length)
  * @fw_offset: offset of the firmware binary data. The start address of
  *	the data would be the address of struct fw_mac + @fw_offset.
  * @fw_reg: the register to load the firmware. Depends on chip.
@@ -911,6 +912,7 @@ struct fw_header {
  * @bp_num: the break point number which needs to be set for this firmware.
  *	Depends on the firmware.
  * @bp: break points. Depends on firmware.
+ * @reserved: reserved space (unused)
  * @fw_ver_reg: the register to store the fw version.
  * @fw_ver_data: the firmware version of the current type.
  * @info: additional information for debugging, and is followed by the
@@ -936,8 +938,10 @@ struct fw_mac {
 /**
  * struct fw_phy_patch_key - a firmware block used by RTL_FW_PHY_START.
  *	This is used to set patch key when loading the firmware of PHY.
+ * @blk_hdr: firmware descriptor (type, length)
  * @key_reg: the register to write the patch key.
  * @key_data: patch key.
+ * @reserved: reserved space (unused)
  */
 struct fw_phy_patch_key {
 	struct fw_block blk_hdr;
@@ -950,6 +954,7 @@ struct fw_phy_patch_key {
  * struct fw_phy_nc - a firmware block used by RTL_FW_PHY_NC.
  *	The layout of the firmware block is:
  *	<struct fw_phy_nc> + <info> + <firmware data>.
+ * @blk_hdr: firmware descriptor (type, length)
  * @fw_offset: offset of the firmware binary data. The start address of
  *	the data would be the address of struct fw_phy_nc + @fw_offset.
  * @fw_reg: the register to load the firmware. Depends on chip.
@@ -960,6 +965,7 @@ struct fw_phy_patch_key {
  * @mode_reg: the regitster of switching the mode.
  * @mod_pre: the mode needing to be set before loading the firmware.
  * @mod_post: the mode to be set when finishing to load the firmware.
+ * @reserved: reserved space (unused)
  * @bp_start: the start register of break points. Depends on chip.
  * @bp_num: the break point number which needs to be set for this firmware.
  *	Depends on the firmware.
-- 
2.25.1

