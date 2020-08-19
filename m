Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6967F24971B
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 09:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbgHSHZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 03:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726982AbgHSHYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 03:24:18 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0696C061345
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 00:24:13 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id x5so1079535wmi.2
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 00:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2BVsdrFO67l+LY2/RUcOBcwvHM2Wo8sTbd6g8xd/h5g=;
        b=mujsbfdO8EPBn3dEm0AoUidJtUtgMIe3rCiUJTGjLX3Of158SoNm0koW6RMNXvRJ/8
         lmzpDeWgkzzlsBh1dkX94BKJ3fyVLHI4T9Ilj1yREwQ+2unf4WiSBef0NTlTQIBSS52E
         Y+J94jgeNaHh0/B/l2vklzeWB+Sh1oB4lQfFLe/+ItNVTU16zyLGgCkOuuHE+6fExHeF
         Pg0C28K20jhWeJOlMn9pVb9Q/4HMZs0tmZFsGIcuYFOSAcGwBV80k25bzyzxhBkEYzLd
         ixSGSFBGYU2yUcpV/njAISleaur9hsNtMbg1cJ0e5gqoSyLVKFUa/bk2UDRYTEAgllnE
         9KPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2BVsdrFO67l+LY2/RUcOBcwvHM2Wo8sTbd6g8xd/h5g=;
        b=pTUkHH6Pv1YK2VMWJ0cHnqRblQs/6GI/5/qlhYEQfxVWQzlKk8R9eWhW6sfaUCWbns
         JmPp/X/omR0X5qI7/R3x+snkRpYEFSegnAHjH/zz//PGcBK8uIVZw+3oL92AjwMb+7/n
         o/eb0HQA+Td16XU7nLybztwno+VBvNN1yY+ud+AJi7yE3ifUCwJBHLVIu2M99RMmgeJ9
         r6wxpY2m8Dw41b2KieZhB71QQftMAlfuB4ubMcwfdUNIntEaqWhOXge+e6w18yKJrEyW
         afq4RIs1KH18Qxa5ZEltNs3lY9oWWr5dGM71Y3MvZpxatJdGo1pyRIVbvKB6X9yTDg11
         dyKA==
X-Gm-Message-State: AOAM530ibPuzpl4fmilojlK7vCnsNUJZlXu5y5uLYoZt3rVZLoFvb5Ae
        qp7TQQt/2E/B9LayuuHkTOz0EQ==
X-Google-Smtp-Source: ABdhPJxIoUgrKQMpLoNqNQxcmnOWW8PzaBUbxjBOwkWVoTHhuCMKJfEJKdhkN/M7RLhyWURYk4tzzQ==
X-Received: by 2002:a1c:286:: with SMTP id 128mr3361675wmc.37.1597821852427;
        Wed, 19 Aug 2020 00:24:12 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id c145sm3795808wmd.7.2020.08.19.00.24.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 00:24:11 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Hari Nagalla <hnagalla@gmail.com>, Guy Mishol <guym@ti.com>,
        Maital Hahn <maitalm@ti.com>,
        Luciano Coelho <luciano.coelho@nokia.com>
Subject: [PATCH 06/28] wireless: ti: wlcore: cmd: Fix some parameter description disparities
Date:   Wed, 19 Aug 2020 08:23:40 +0100
Message-Id: <20200819072402.3085022-7-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200819072402.3085022-1-lee.jones@linaro.org>
References: <20200819072402.3085022-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Firstly a rename, then a split (there are 2 'len's that need documenting).

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/ti/wlcore/cmd.c:832: warning: Function parameter or member 'buf_len' not described in 'wl1271_cmd_test'
 drivers/net/wireless/ti/wlcore/cmd.c:832: warning: Excess function parameter 'len' description in 'wl1271_cmd_test'
 drivers/net/wireless/ti/wlcore/cmd.c:862: warning: Function parameter or member 'cmd_len' not described in 'wl1271_cmd_interrogate'
 drivers/net/wireless/ti/wlcore/cmd.c:862: warning: Function parameter or member 'res_len' not described in 'wl1271_cmd_interrogate'
 drivers/net/wireless/ti/wlcore/cmd.c:862: warning: Excess function parameter 'len' description in 'wl1271_cmd_interrogate'

Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Hari Nagalla <hnagalla@gmail.com>
Cc: Guy Mishol <guym@ti.com>
Cc: Maital Hahn <maitalm@ti.com>
Cc: Luciano Coelho <luciano.coelho@nokia.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/ti/wlcore/cmd.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 6ef8fc9ae6271..745101633a3f1 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -825,7 +825,7 @@ int wl12xx_cmd_role_start_ibss(struct wl1271 *wl, struct wl12xx_vif *wlvif)
  *
  * @wl: wl struct
  * @buf: buffer containing the command, with all headers, must work with dma
- * @len: length of the buffer
+ * @buf_len: length of the buffer
  * @answer: is answer needed
  */
 int wl1271_cmd_test(struct wl1271 *wl, void *buf, size_t buf_len, u8 answer)
@@ -855,7 +855,8 @@ EXPORT_SYMBOL_GPL(wl1271_cmd_test);
  * @wl: wl struct
  * @id: acx id
  * @buf: buffer for the response, including all headers, must work with dma
- * @len: length of buf
+ * @cmd_len: length of command
+ * @res_len: length of payload
  */
 int wl1271_cmd_interrogate(struct wl1271 *wl, u16 id, void *buf,
 			   size_t cmd_len, size_t res_len)
-- 
2.25.1

