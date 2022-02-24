Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B32C84C28C1
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 11:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233188AbiBXKDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 05:03:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233178AbiBXKDE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 05:03:04 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC89E124C04;
        Thu, 24 Feb 2022 02:02:33 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id l1-20020a7bcf01000000b0037f881182a8so3152108wmg.2;
        Thu, 24 Feb 2022 02:02:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5V+8zESMqAOqhShcImxsVrwQqPApUYX212lfufDlzI4=;
        b=Ui8ORAybraPWfJ8gLXWOt/yX+8Py8ltRXxrn45enLFbpjw/LCz7AKbW8MzA10RJPbi
         YrAx7DSi0AgAQp/ljOGkALIDi1XQCHV2JQkOTAUhAQxz+CJ9esBhyBcJguiS/EmC3V4a
         QS0PMWFVyxrjTwO4BqERrXSqHUREj/aEeZX6/fzxW2zgHfYDmZvtbHjcC9zQo45IUVUz
         3ZeR6WblZoouXvrA8KeDWJ3oOiZ5moxicPpukuueD8W81j6QQu/H+jk374ub79a54Bi+
         nmf9BRfNAsDPlTsQ4MX5u4mbQ7fsS66X/UyK9BXJMZhn3FcZYMKHD7zn+5NIj0qw9R2J
         zgVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5V+8zESMqAOqhShcImxsVrwQqPApUYX212lfufDlzI4=;
        b=xfxe8Nq2dTUE+BIy+kAG+0B3NsDrUevAwmK8leqQDfu5Q9TaKgfFtq1AADLOh7PrqK
         QLKq/8q53TYe0/NTxXzMScAp+yc7c5qiTUUU93HRDUDn1TNdgCuHCWsgg+tAbRnO87yC
         ST4ZPKTGH4G+/r8HDD1see1zV35e8GrbejcP4cb+41xx9uaL65duCgcKkOAZNP2vzfbq
         2MdBhMvGWXfkEBmDvB60URTe7TPn+SVltsKxJE35erxLzEmGL7mWLZc8dr7KBt8eyY7V
         tbKckocN3SnxAIU/wpGb731cJn2TBWwa0ZVDUF0USoxnelMVOKJ6CRe2xZMQntN5lbLI
         Mf1g==
X-Gm-Message-State: AOAM532novlchXV98zaOU+zQVRyWZeD/aN9OiOBCATwj267tB8CPm7iV
        mv2HSHwWFXixgozLyb+5Q80=
X-Google-Smtp-Source: ABdhPJy3/oMg8ezNts7IDco/sL6COqLtAQmsk9VxvFN0rkACOsiHb7wusxREALjt38DRAk7F/e2hhQ==
X-Received: by 2002:a7b:c383:0:b0:381:1b50:a9d with SMTP id s3-20020a7bc383000000b003811b500a9dmr611336wmj.90.1645696952299;
        Thu, 24 Feb 2022 02:02:32 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id v2sm2132595wro.58.2022.02.24.02.02.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 02:02:31 -0800 (PST)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ilan Peer <ilan.peer@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] iwlwifi: mvm: Fix spelling mistake "Gerenal" -> "General"
Date:   Thu, 24 Feb 2022 10:02:31 +0000
Message-Id: <20220224100231.80152-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a spelling mistake in a IWL_DEBUG_SCAN debug message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index a4077053e374..493a62071d8e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -2291,7 +2291,7 @@ iwl_mvm_scan_umac_fill_general_p_v11(struct iwl_mvm *mvm,
 
 	iwl_mvm_scan_umac_dwell_v11(mvm, gp, params);
 
-	IWL_DEBUG_SCAN(mvm, "Gerenal: flags=0x%x, flags2=0x%x\n",
+	IWL_DEBUG_SCAN(mvm, "General: flags=0x%x, flags2=0x%x\n",
 		       gen_flags, gen_flags2);
 
 	gp->flags = cpu_to_le16(gen_flags);
-- 
2.34.1

