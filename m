Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4B8E2A2936
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728761AbgKBLYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:24:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728657AbgKBLYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:24:51 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7810EC0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:24:51 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id k10so12798614wrw.13
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:24:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O6+Wy4iFDi+o50ayVR/RzqW4RGQ8DgYcSYBAfri+vWM=;
        b=kBUokJkmggzU+k79iTdFrZMjYpcpgw2xTrk0pc63i9oIuSz6281y7DAobifGsbEnsk
         xIicxLS2Wl/6cy93dhlChVnHNFLBPYZ7xC3cLpUHQsO6gW5SRqvnitqQFQJJGcfLJ2dt
         KEQh2uZi9wpW2sygcz2xL2yqL+sBEYvAxmGsMEnaZm5i6BqTf5p7NO9V/06gqqMd6zbT
         vBqIh+52UHZ8gRsEIhECfKKrRcFIm5e7cigDq2bYXhxLpOoxOHTpUVtGHDmf8U1eDJ+r
         H56qwwyBFSXPEkpFPs3YLqFA4UZkOAasLZuWIxfumMFL1As5C0uJFhkzQILUTEppz1+M
         4WNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O6+Wy4iFDi+o50ayVR/RzqW4RGQ8DgYcSYBAfri+vWM=;
        b=SaorXT5LXN52sT18wjoYNMf9/f428eEplAH9R3js8fToPxkq6jSgjywynUyJlzUdgl
         dIsimarMz7e7xSeaH0OioY28rLq/pe3uG2FZeHbxNoEX0BpMHTWjAbUGE/C7QMWm6gF5
         r3sgZURFHYzUyhC3xeI+qglntJR3RWw44RZ5PZVdbb8fj0kDqUvoGn2mGjSYFSRdBNf5
         9JQ+3TsWRfKejHnouxYR/mX58Y5fRhyjjAXaYsBW3IUbNd02o8MixM6pR9fpwdoUJV3b
         6SiULoXUI3LFs+j4/myIClj0EFH0wFvDgSYXIqeXrgeZcU9yPtdJZAeRoT2CM+K6nd2u
         Pyxw==
X-Gm-Message-State: AOAM533LiFC/Cf72xw7zfHscQW4+VRwXzzmp6sdKKZeB7iw/y+HCNdcp
        itDff1Neb6vrBuVYu/Ueiw+rPw==
X-Google-Smtp-Source: ABdhPJwnLEQLz3pY8tA4hxEMZp/y+V47dybDwlTnafoF0OeZlke8fa+Yu4I7M7yjgvsVLy70yrtMaA==
X-Received: by 2002:a5d:688c:: with SMTP id h12mr20152408wru.92.1604316290204;
        Mon, 02 Nov 2020 03:24:50 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id m14sm21867354wro.43.2020.11.02.03.24.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:24:49 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 23/41] iwlwifi: iwl-phy-db: Add missing struct member description for 'trans'
Date:   Mon,  2 Nov 2020 11:23:52 +0000
Message-Id: <20201102112410.1049272-24-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102112410.1049272-1-lee.jones@linaro.org>
References: <20201102112410.1049272-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c:97: warning: Function parameter or member 'trans' not described in 'iwl_phy_db'

Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Luca Coelho <luciano.coelho@intel.com>
Cc: Intel Linux Wireless <linuxwifi@intel.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c b/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c
index ae83cfdb750e6..c9ce270ceee07 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c
@@ -79,11 +79,11 @@ struct iwl_phy_db_entry {
  *
  * @cfg: phy configuration.
  * @calib_nch: non channel specific calibration data.
- * @calib_ch: channel specific calibration data.
  * @n_group_papd: number of entries in papd channel group.
  * @calib_ch_group_papd: calibration data related to papd channel group.
  * @n_group_txp: number of entries in tx power channel group.
  * @calib_ch_group_txp: calibration data related to tx power chanel group.
+ * @trans: transport layer
  */
 struct iwl_phy_db {
 	struct iwl_phy_db_entry	cfg;
-- 
2.25.1

