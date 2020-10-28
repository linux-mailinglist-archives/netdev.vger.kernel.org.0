Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18AA129D998
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389880AbgJ1W6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733138AbgJ1W5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:57:17 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 535B0C0613CF;
        Wed, 28 Oct 2020 15:57:17 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id p15so1339581ioh.0;
        Wed, 28 Oct 2020 15:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v8SmUy1p8YFPt0UuYt7UcwX4doZKfjAz+2UPXr9oenc=;
        b=UyEMln7+TFZqUXYaJ1spAOCY0uQKOp53Dkb2khpfw1DKzygHWHJ97MKLUBiXUuELz4
         Q96DqRl6E0+uw4xkFIebm9e7KX3iNQnaikMFa8rIk1hNtzZl0V2vuEhx8ZTqAqOhcErh
         gcsEkAb55AW4F3xggiBENAbzL9kOCKYcSxw0fMoqwquEBK5JOpUX6pxewhMp1wn2HVBZ
         XtIwm7QZPMtwEd5ihshnGyyY8zzgTwdFnPE8adIi1Rym3JP9nchLdeCHP71WqOu+yE+j
         bsxnLphIqQfuer8EOqDB34acdxGK3ZBTQ6P1r/Gj8RASKtyXgwPrEgc9dwcgb+uX/f4v
         cF7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v8SmUy1p8YFPt0UuYt7UcwX4doZKfjAz+2UPXr9oenc=;
        b=LgVLIbBdVeUbGjLrRjCGMamSYLIRcUEBB1VeRiJtRgZZcyEIYb+TLib9mjDCa5R2C3
         yvFhg4Xbsg282hsrRz/pdbaAb3ScnIMKxqL9FA/4bJn4U3yEr0W5P+G6sRyHjqCSHawO
         SkoDXlgcub+97xMtBV1S73KT42R+5sKE6LrxDpo4sg18dXWEdG/zFelsHleb0wuzSg7R
         q0LzC1KncYlAsaWcSCbccLPbDAAFnq/A68hxSTnqkGHhGPPf0RtVj3rjp0l0H6B0qlqV
         Pdkg6ZnVvtQk5VWpLd67X6IeYQIX/HD6Of+xG1ITIt/gx0drtu0VvZWNsemmF0OXU/UH
         8fSw==
X-Gm-Message-State: AOAM5328tIkQdG9PNtuvYev6yrthrC0toa7Km97eo42mhsQaJsLHjUvn
        dHZ49lCgPtDYmnnWztER+e4XSVfszwB37RQC
X-Google-Smtp-Source: ABdhPJxpWUdzBg5lguJKB9YOMXhmiOL2/FWHw9iEIGsS7ko1RmdRk47qvSzHoNGJPAbc8KWnaI9IoQ==
X-Received: by 2002:a65:4905:: with SMTP id p5mr6260513pgs.299.1603895167499;
        Wed, 28 Oct 2020 07:26:07 -0700 (PDT)
Received: from k5-sbwpb.flets-east.jp (i60-35-254-237.s41.a020.ap.plala.or.jp. [60.35.254.237])
        by smtp.gmail.com with ESMTPSA id 194sm6227192pfz.182.2020.10.28.07.26.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 07:26:07 -0700 (PDT)
From:   Tsuchiya Yuto <kitakar@gmail.com>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>, verdre@v0yd.nl,
        Tsuchiya Yuto <kitakar@gmail.com>
Subject: [PATCH 3/3] mwifiex: print message when changing ps_mode
Date:   Wed, 28 Oct 2020 23:24:33 +0900
Message-Id: <20201028142433.18501-4-kitakar@gmail.com>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201028142433.18501-1-kitakar@gmail.com>
References: <20201028142433.18501-1-kitakar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Users may want to know the ps_mode state change (e.g., diagnosing
connection issues). This commit adds the print when changing ps_mode.

Signed-off-by: Tsuchiya Yuto <kitakar@gmail.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 943bc1e8ceaee..a2eb8df8d3854 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -451,6 +451,13 @@ mwifiex_cfg80211_set_power_mgmt(struct wiphy *wiphy,
 		return -EPERM;
 	}
 
+	if (ps_mode)
+		mwifiex_dbg(priv->adapter, MSG,
+			    "Enabling ps_mode, disable if unstable.\n");
+	else
+		mwifiex_dbg(priv->adapter, MSG,
+			    "Disabling ps_mode.\n");
+
 	return mwifiex_drv_set_power(priv, &ps_mode);
 }
 
-- 
2.29.1

