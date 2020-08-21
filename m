Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A21C24CF34
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 09:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728465AbgHUHXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 03:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727912AbgHUHQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 03:16:59 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3629AC06134B
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 00:16:57 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id z18so974959wrm.12
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 00:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FczcR0ercDVomHQV+kYc66obKABVvqRvMsKpTYbOb2Y=;
        b=e0hXyqDlAAZ9jrSp0+sgcKZDbu6p3FBSXUaKZ6W+P9XOdw2nqYDzx952fChZnmGG91
         5+4qSQjtdLEMnOGgBECLn3s4SgE6TSGzzOBzw/bpfavLGVuTKKn+0jz8o2m7/Irjr/sx
         eYVjc3yKv9lWL99bA4znqsAheZKVhHJjZBZVMBJ9Sj1N3lfpSZMYPpINV+iJsgwnmVXS
         i3y8uVNt+iW7Akx5GXHpu4Tu4KnPCGYzlTyhkxVXEs6kLGaTwQEv9ZXz3/2F7P2OHwvy
         QimHNTb44nMbCeIyswq1Z7MXUPsBumZmemzb5Hae9i2zwh2dUzbIbhmxAtO5dUPwDnRt
         UAbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FczcR0ercDVomHQV+kYc66obKABVvqRvMsKpTYbOb2Y=;
        b=TF+zIqgnzs9Yd4MFyarlgRszPkNY8ktVLCjVDM+liovmBEuPDeW6beSk2IZzVPKrK7
         zA/DMgkskU+AsOwGhFCbZiPKJKluliQgyQcBzlSPms6i/TtkUSDYM+/dM3/PRMRxrBdI
         5vDBBg7ChTVBvhMvy/eJuGWt3qxW263jSaXRCrFhNPJgrE8SGCayI7yA8ge8UqbZUyPH
         MDnmiPmLdDkkm4l8raUdsZkcyOjjMSULtGCuMg9MBwC1Q+JXlkx/lyecqlVSwZdqcMfy
         80iekielPNJECtjmvjvaZwcwjgxmPdHZ20PiWYpsVEIsq+hdWtsRj3HLoOUo+vFwSbZb
         lvuQ==
X-Gm-Message-State: AOAM532krYLd2vlSXN+0HHo+LwNK+M2ywRVvnVTHtKMaPQw43NvwVsnc
        z69gwy39U0gydodvUh5/LfI7Xw==
X-Google-Smtp-Source: ABdhPJy3djGQTGa6RdmcN+ZodCOU6sEYPtl+YXW+C/GDR/ex5sdGuOEKhjfrWHWRXtavynqHSdfFpw==
X-Received: by 2002:adf:de8d:: with SMTP id w13mr1359898wrl.129.1597994215916;
        Fri, 21 Aug 2020 00:16:55 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id y24sm2667957wmi.17.2020.08.21.00.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 00:16:55 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>
Subject: [PATCH 06/32] wireless: rsi: rsi_91x_mgmt: Add descriptions for rsi_set_vap_capabilities()'s parameters
Date:   Fri, 21 Aug 2020 08:16:18 +0100
Message-Id: <20200821071644.109970-7-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821071644.109970-1-lee.jones@linaro.org>
References: <20200821071644.109970-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/rsi/rsi_91x_mgmt.c:713: warning: Function parameter or member 'mac_addr' not described in 'rsi_set_vap_capabilities'
 drivers/net/wireless/rsi/rsi_91x_mgmt.c:713: warning: Function parameter or member 'vap_id' not described in 'rsi_set_vap_capabilities'
 drivers/net/wireless/rsi/rsi_91x_mgmt.c:713: warning: Function parameter or member 'vap_status' not described in 'rsi_set_vap_capabilities'

Cc: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: Siva Rebbagondla <siva8118@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index c331084bdc170..33c76d39a8e96 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -702,6 +702,9 @@ static int rsi_program_bb_rf(struct rsi_common *common)
  * rsi_set_vap_capabilities() - This function send vap capability to firmware.
  * @common: Pointer to the driver private structure.
  * @mode: Operating mode of device.
+ * @mac_addr: MAC address
+ * @vap_id: Rate information - offset and mask
+ * @vap_status: VAP status - ADD, DELETE or UPDATE
  *
  * Return: 0 on success, corresponding negative error code on failure.
  */
-- 
2.25.1

