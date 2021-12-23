Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 094C647E0F8
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 10:47:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347549AbhLWJrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 04:47:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232539AbhLWJrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 04:47:20 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD176C061401;
        Thu, 23 Dec 2021 01:47:19 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id bg2-20020a05600c3c8200b0034565c2be15so5352523wmb.0;
        Thu, 23 Dec 2021 01:47:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1FljN4fCHiTpgSbWmh8CjysLa/wLOYbGIzjzvhbdhTs=;
        b=aKaqI8DPvlYgtzQmCHC56vZGt89dgMytdw1+t6ERoTmIZu04DdR7Na0cOtZPyhWkE7
         v5Vs9JB0NBO7rJAXhT0NRzbmFTfwGsd5u4Xx9fgu6DkvKm6+mXzeM0SO2DXYuO23xl8J
         NeZu+rk4nVaUIzvtdZkZtOkjnKGZlgCAlTOKsdGV/V+6zHLLzYuNdIDCgEzO5lGGw0ku
         7Mt5lmefX6Y+MylHMOc5LbzrHh9QvD5cQjIkVdhVd0KZQcuz08Cpbad+uUHsDo+B3jG2
         sTvHF3qqXTCqhHhDjBaAZDJU1f+8d9MASetG7kUWjp53eo/k3WhaezLr1Cl3muWHEgis
         PuZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1FljN4fCHiTpgSbWmh8CjysLa/wLOYbGIzjzvhbdhTs=;
        b=dTSEM2eQNv/H55ACnGpH2feeOREs8/U8SB83ovcCmQc0wDIWi5Lf6j8kzgrOraZsrI
         dtP4se0n3BFiKGG8KfjMJ+sDrkHJ3kGlapummGYNiJ/afQmgSsdUUNimDhQgpSFcSj+R
         waTx2xS9Du3HpBdesdJYPrgb3yOQAus3W7HlZ0uSCzwlOa/2Gw1HEG95eykB6TTcTjBh
         46gtmxu3Pe0j292s1TwVLH2tceF24/YMPs1HQaWVvSSUV9A2QpDICCjLFCVjS9mqWyKU
         taJgedX3ECMG0jiUV8dWxXYVfkr8qCNlpw8eGzhw7b0+ej5hGDKZ0wbh49XsNdjejrTZ
         YFBw==
X-Gm-Message-State: AOAM530+O0R1V6sImpppiLWOq4I5AuOmnvMqeUEao3MLpZ2PcEgOw3Tt
        NuBBKSwkhzMCUA+gyVxA/9U=
X-Google-Smtp-Source: ABdhPJyjD7EvPp8lRfhnncq2YVvShxYwbEfiq4O/bXG90uQ2M9lxW1eoItKFJ4vI/TbR37/utFxCqA==
X-Received: by 2002:a05:600c:3485:: with SMTP id a5mr1059237wmq.181.1640252838478;
        Thu, 23 Dec 2021 01:47:18 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id v6sm7626471wmh.8.2021.12.23.01.47.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Dec 2021 01:47:17 -0800 (PST)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] Bluetooth: MGMT: Fix spelling mistake "simultanous" -> "simultaneous"
Date:   Thu, 23 Dec 2021 09:47:17 +0000
Message-Id: <20211223094717.1310828-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a spelling mistake in a bt_dev_info message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 net/bluetooth/mgmt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 6f192efd9da0..37087cf7dc5a 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -4335,7 +4335,7 @@ static int set_le_simultaneous_roles_func(struct sock *sk, struct hci_dev *hdev,
 			hci_dev_clear_flag(hdev, HCI_LE_SIMULTANEOUS_ROLES);
 	}
 
-	bt_dev_info(hdev, "LE simultanous roles enable %d changed %d",
+	bt_dev_info(hdev, "LE simultaneous roles enable %d changed %d",
 		    val, changed);
 
 	memcpy(rp.uuid, le_simultaneous_roles_uuid, 16);
-- 
2.33.1

