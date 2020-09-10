Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE89D263E10
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 09:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730245AbgIJHIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 03:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729942AbgIJHBP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 03:01:15 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA99DC061371
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 23:55:26 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id e17so4479630wme.0
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 23:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ber61nCfGX/LBYmzLblmZwxpl0GZA9+O2Yw5fYt8Kvw=;
        b=deR4l/SvWidt++EwWJEQ0E9qOniHgPvaCffVrMJK8v/IkYr3EfA7i5GWTZFOvow8A8
         gWMvJTMbMWprCF9pH3UNP7lfNeJkZTp3PbFgwKJrGah9//3ZkFntHpJzAwwIYhXORLrk
         An8/+s0JbkXPgKVaRPMGM4N1vuMZAV4n/+b8vfSKXXxaTUpLSq8qyMxoCJxh/mZmnkq8
         X4M2JwoZRxjxPrTTGq19Ro1u8mDeHofCGKR3fyNx4u/SDL8IdwtT23FHYzaIARk9TRnV
         4300x88RRXrgQZxU8pQdD3mR97xYnLNH+UlP8vBbVvvIOwa1nt5I2nUZ/V4A9ZM9a+TY
         14IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ber61nCfGX/LBYmzLblmZwxpl0GZA9+O2Yw5fYt8Kvw=;
        b=MhoOTdOwtkuDziggZ6ZlseX5CuL+TUXJR1TfKsKNGQoEzbb2vOGgQoLZYjAmSZXNYu
         feezWwovTWahqTjjx6M1X1nbJuDMHlIMsJ3eP/+rA4d/AL+BdllLMUBUJumx2b+NIKbk
         1Yv01u6pJ7/faV8XvZEjbBYsTdhpDYFDnRjoW/qrKUyJEA+3JQ9LKPTQuchsYEb/BTiB
         c5bKwGp1QdNYyk3WJzor6YMAWzup/4hZeVkYjlB4Mi0oPowoa3vmF8p/A/4qjRFSGa9Y
         G/9y04Rf9hDrYoQJQyjwPufAlUPjr0dIskC5tx2e6doooJ8KeBuoYJ93gQjgKEtnGbA8
         X0mw==
X-Gm-Message-State: AOAM531vapVnKZv8ZsyiTEcpVUAkGJepBSHYp4B9dNznAbp3mCPczSDS
        s6s43VCIlFb3tBJBvu2IXnixjg==
X-Google-Smtp-Source: ABdhPJw5H4OWts/YLTGzvF0IpkpQLEtjcIKcDuLQEIfcSNW7xtBFWBzsUCVPlVNJpxVYbV24qw4ajw==
X-Received: by 2002:a1c:2bc7:: with SMTP id r190mr4663735wmr.116.1599720925509;
        Wed, 09 Sep 2020 23:55:25 -0700 (PDT)
Received: from dell.default ([91.110.221.246])
        by smtp.gmail.com with ESMTPSA id m3sm2444028wme.31.2020.09.09.23.55.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 23:55:25 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 28/29] brcmsmac: phytbl_lcn: Remove unused array 'dot11lcn_gain_tbl_rev1'
Date:   Thu, 10 Sep 2020 07:54:30 +0100
Message-Id: <20200910065431.657636-29-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200910065431.657636-1-lee.jones@linaro.org>
References: <20200910065431.657636-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phytbl_lcn.c:108:18: warning: unused variable 'dot11lcn_gain_tbl_rev1' [-Wunused-const-variable]
 static const u32 dot11lcn_gain_tbl_rev1[] = {

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 .../brcm80211/brcmsmac/phy/phytbl_lcn.c       | 99 -------------------
 1 file changed, 99 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phytbl_lcn.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phytbl_lcn.c
index 7526aa441de11..5331b5468e148 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phytbl_lcn.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phytbl_lcn.c
@@ -105,105 +105,6 @@ static const u32 dot11lcn_gain_tbl_rev0[] = {
 	0x00000000,
 };
 
-static const u32 dot11lcn_gain_tbl_rev1[] = {
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000008,
-	0x00000004,
-	0x00000008,
-	0x00000001,
-	0x00000005,
-	0x00000009,
-	0x0000000D,
-	0x00000011,
-	0x00000051,
-	0x00000091,
-	0x00000011,
-	0x00000051,
-	0x00000091,
-	0x000000d1,
-	0x00000053,
-	0x00000093,
-	0x000000d3,
-	0x000000d7,
-	0x00000117,
-	0x00000517,
-	0x00000917,
-	0x00000957,
-	0x00000d57,
-	0x00001157,
-	0x00001197,
-	0x00005197,
-	0x00009197,
-	0x0000d197,
-	0x00011197,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000008,
-	0x00000004,
-	0x00000008,
-	0x00000001,
-	0x00000005,
-	0x00000009,
-	0x0000000D,
-	0x00000011,
-	0x00000051,
-	0x00000091,
-	0x00000011,
-	0x00000051,
-	0x00000091,
-	0x000000d1,
-	0x00000053,
-	0x00000093,
-	0x000000d3,
-	0x000000d7,
-	0x00000117,
-	0x00000517,
-	0x00000917,
-	0x00000957,
-	0x00000d57,
-	0x00001157,
-	0x00005157,
-	0x00009157,
-	0x0000d157,
-	0x00011157,
-	0x00015157,
-	0x00019157,
-	0x0001d157,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-	0x00000000,
-};
-
 static const u16 dot11lcn_aux_gain_idx_tbl_rev0[] = {
 	0x0401,
 	0x0402,
-- 
2.25.1

