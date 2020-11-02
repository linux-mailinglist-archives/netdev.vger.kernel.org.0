Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB8EA2A29CC
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728773AbgKBLrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:47:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728679AbgKBLqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:46:00 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34B25C061A4B
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:45:54 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id h62so4366925wme.3
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:45:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d6wOWByAs5f7rPxO4TjrPC/r2b2juD5yTl6dq0Ru2bA=;
        b=w3v/425to/PN6qqmfV7Xffc9tidXa3aIqhEw/99cZfikh0L1vYo6bZkLAbNLAM4WV/
         6X3p5qEEAidUSJaQq09QNspMewmEXCBK6jydtHzEdJaSBrXiuxA8yLFclLzO7mAYbMLi
         PIpFohCM/NaOn6gAOE0RzCn8V4qifhiHeKubhlDq/IZ4K3IIK6qZ1eWh9DdZor5riHqF
         Jm9vxBUrSISCugSkpBuwXkanE2HaMBQYjTLZMyzQt3F+3RIZLPQeGAwbGGavDUt9RPDr
         crBJDbEeOoPjTrk9FqN0pwve6L+6l3Eg3mjlNy46gwluXGWJ8x59UfpjkYTdCJo3D1QJ
         Ub5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d6wOWByAs5f7rPxO4TjrPC/r2b2juD5yTl6dq0Ru2bA=;
        b=JEn6CvRSfiAuWmpHdt4NeNY6Vvp5SFvlpyf4oZCufs+oaomGhR3X0g/SoPE+ZixCHE
         /Gk2iHSdNn5A5PVuc3KFL47cvq+msYHZ09bh41cXdDIP+PCVaoOGTUrjxPVXUS0D16M9
         QxgOq88pRTxv7qursV2EmOVpxn7f2layLHw1nwxfNnOi0uv2hA8MgjRaAcrwzELVGxVg
         EjQ1tE+/qZ9K3fWPfxWbhrLbkIHaeS9cbH9+1VnGA2Pl9erGk69UDQMIhF3PLr9tBTUN
         Z0Jpu4GxCQXqWLt5T7djX6Xqalc/lw+wMDdUM3zB1IYcvhZOJuVeGfrAC4+WfFAxcMQw
         HiaQ==
X-Gm-Message-State: AOAM532WZ88gwN8ImSYqLOM0ZAGMlv4wr5KiSawVBbz2YkAlUtv/12M0
        d4u/6X6fCDICCeggsAsm/cl6IQ==
X-Google-Smtp-Source: ABdhPJyuV8hFjrgOthwkEdNUG99Fk5kK5NnRsdCIbtsCSyJsAfexvpjRgdIY4aDBFj1B9Ahew0rJiw==
X-Received: by 2002:a1c:4e0e:: with SMTP id g14mr8861120wmh.9.1604317552974;
        Mon, 02 Nov 2020 03:45:52 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id g66sm15545352wmg.37.2020.11.02.03.45.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:45:52 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net
Cc:     Lee Jones <lee.jones@linaro.org>, Jakub Kicinski <kuba@kernel.org>,
        Hayes Wang <hayeswang@realtek.com>,
        nic maintainers <nic_swsd@realtek.com>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 27/30] net: usb: r8152: Fix a couple of spelling errors in fw_phy_nc's docs
Date:   Mon,  2 Nov 2020 11:45:09 +0000
Message-Id: <20201102114512.1062724-28-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102114512.1062724-1-lee.jones@linaro.org>
References: <20201102114512.1062724-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/usb/r8152.c:992: warning: Function parameter or member 'mode_pre' not described in 'fw_phy_nc'
 drivers/net/usb/r8152.c:992: warning: Function parameter or member 'mode_post' not described in 'fw_phy_nc'

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Hayes Wang <hayeswang@realtek.com>
Cc: nic maintainers <nic_swsd@realtek.com>
Cc: linux-usb@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/usb/r8152.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index cebe2dc15c3f0..b9b3d19a2e988 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -963,8 +963,8 @@ struct fw_phy_patch_key {
  * @patch_en_addr: the register of enabling patch mode. Depends on chip.
  * @patch_en_value: patch mode enabled mask. Depends on the firmware.
  * @mode_reg: the regitster of switching the mode.
- * @mod_pre: the mode needing to be set before loading the firmware.
- * @mod_post: the mode to be set when finishing to load the firmware.
+ * @mode_pre: the mode needing to be set before loading the firmware.
+ * @mode_post: the mode to be set when finishing to load the firmware.
  * @reserved: reserved space (unused)
  * @bp_start: the start register of break points. Depends on chip.
  * @bp_num: the break point number which needs to be set for this firmware.
-- 
2.25.1

