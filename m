Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F61F252A49
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 11:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728564AbgHZJh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 05:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728380AbgHZJfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 05:35:07 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F9BAC06134F
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 02:34:34 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id p17so1090308wrj.8
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 02:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yvoQanaWTpWNQEXwywlAc7o43dgHa3QRlp1C/cAGUU4=;
        b=s03wRDxSuZJrkgF2oUckm/dxkHDlEzj7UzMo4Rqm6Jg4UF21WboPJXhBjmsdYI44VB
         T80Qv+u/ejdXfR88W2SGz656OtO/FWRBPOKx1iuuWvDdQrNMTfC5JE0nyJWAnusYydDc
         GOPazXC8CxR2wMTlSrN063oegcaXdEmuxL7OHTkh89TSmAWGWQJIp8QMfdTY51HreW3U
         kc8nEWXR50Oqtd60Nj305DBmXokL7F6Yf9ZUX0h/JTqLq9oSZV5GdQmUxXwIKir3clme
         AOdeWWnagZRvMsJg5BwaVzJpqvtcPMKSGuJ6WkwKZbXsyz1GFTc1PqqJ+D0GvAOe2vAZ
         2yhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yvoQanaWTpWNQEXwywlAc7o43dgHa3QRlp1C/cAGUU4=;
        b=POg0e7KXgKdTCIYwwyWbR4sJ3Db5ujUEVaeqGnVqZ/60a3fZDAO71YuIxe+jvreq6v
         Ebyfc5iyRbffQvvEQ+8eTmXZjW5uaXFX9rNnahZroBtth5W/TzDUgG0+CcRIdzxI5iZl
         GEfpyID8I0H3ZQDlH56vbnw31vd6Rkqsvlu1QAGnq8a9HkOD9UuXKywxGp6VPgZgrTLM
         rQxwH0kdbPC2Vp5W2D5CE9Vu3ksLIPhkrAM5OXVDsNMWqGQsOwPRu5OeOguA/AWqoxJR
         ISHDPuHEr+FOAAsZWBXrmQvXOG72x8W0KszdUAzRXZvfznhSlutjrWR/bCIY2TZpap4R
         rB+A==
X-Gm-Message-State: AOAM531SbQx1q8cltvOnyq8QjCMqKyv5XwaJoIvfBYYy010QxoDvAxuL
        3yZN3DkhjYJeYbJAoa5Dn8khvA==
X-Google-Smtp-Source: ABdhPJxOfF7uQYb9qaD3r7dWTNKRZIkhB0UM17JPesq9XXKWzSzFYvmfyfGy2TKdAm+01oYhG5XIAA==
X-Received: by 2002:a5d:43ca:: with SMTP id v10mr14464274wrr.299.1598434473214;
        Wed, 26 Aug 2020 02:34:33 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id u3sm3978759wml.44.2020.08.26.02.34.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 02:34:32 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Aurelien Alleaume <slts@free.fr>, Valerio Riedel <hvr@gnu.org>,
        "Luis R. Rodriguez" <mcgrof@ruslug.rutgers.edu>
Subject: [PATCH 23/30] wireless: intersil: prism54: isl_ioctl:  Remove unused variable 'j'
Date:   Wed, 26 Aug 2020 10:33:54 +0100
Message-Id: <20200826093401.1458456-24-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200826093401.1458456-1-lee.jones@linaro.org>
References: <20200826093401.1458456-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/intersil/prism54/isl_ioctl.c: In function ‘prism54_update_stats’:
 drivers/net/wireless/intersil/prism54/isl_ioctl.c:166:6: warning: variable ‘j’ set but not used [-Wunused-but-set-variable]

Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Aurelien Alleaume <slts@free.fr>
Cc: Valerio Riedel <hvr@gnu.org>
Cc: "Luis R. Rodriguez" <mcgrof@ruslug.rutgers.edu>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/intersil/prism54/isl_ioctl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intersil/prism54/isl_ioctl.c b/drivers/net/wireless/intersil/prism54/isl_ioctl.c
index 3ccf2a4b548c6..5c49b9e52a0c4 100644
--- a/drivers/net/wireless/intersil/prism54/isl_ioctl.c
+++ b/drivers/net/wireless/intersil/prism54/isl_ioctl.c
@@ -163,7 +163,6 @@ prism54_update_stats(struct work_struct *work)
 {
 	islpci_private *priv = container_of(work, islpci_private, stats_work);
 	char *data;
-	int j;
 	struct obj_bss bss, *bss2;
 	union oid_res_t r;
 
@@ -187,7 +186,7 @@ prism54_update_stats(struct work_struct *work)
 	kfree(data);
 
 	/* now ask for the corresponding bss */
-	j = mgt_get_request(priv, DOT11_OID_BSSFIND, 0, (void *) &bss, &r);
+	mgt_get_request(priv, DOT11_OID_BSSFIND, 0, (void *) &bss, &r);
 	bss2 = r.ptr;
 	/* report the rssi and use it to calculate
 	 *  link quality through a signal-noise
-- 
2.25.1

