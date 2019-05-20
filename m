Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6D8E23A22
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 16:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732544AbfETOe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 10:34:59 -0400
Received: from mail-wm1-f42.google.com ([209.85.128.42]:40693 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731240AbfETOe6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 10:34:58 -0400
Received: by mail-wm1-f42.google.com with SMTP id 15so9253620wmg.5
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 07:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T+BMa4gsX2SpWHDg4/WOwzhZkAoB1v5cWmwKV6NHcXY=;
        b=ukY8+mENM/jud63R4hHoyLnpb5YoLntE59nddqMWgAWBxvI8Ge+UqHnh2bsKJMcHrg
         z4bfVaI0pNwpaiTKqWx9fvMdMUE+3W1FE9QBzIUA9kpLOhx+VTOAniJ7Ys+sLj1VP8jO
         q5uurLzzFO6dmFja+ooLoRdGt9x6ZaUlsgBi31xyuSapXUPbNylOjSx3gBMPbOcPKU5C
         AK2lIN1NNbvyviI+UaDdFYkSKP/dtX468MCfLg/UCqGZQWza7rz74tCw/Gisx5P0N+/g
         UmU60+F+YHqLMfcdS1P+tY2ZDYVWXYicA6VdTFokP+cKB8ZC0ZmmLcb/txe/VdsBhJq2
         PhNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T+BMa4gsX2SpWHDg4/WOwzhZkAoB1v5cWmwKV6NHcXY=;
        b=mGqf1MZBgFaMDI+uK2UcHNVnWkgKN0tT2isbWEnPB6RFaPi5n3g6BOOp4S2uswnzRh
         O5K3NZESmnnklZDpYmAicYNto/G4zsYV9bJ7tz6bplTt0amABNdPxadPlRIMMPM3u2ZJ
         +b5mTyS1DT3LnpIkhTTNdgVbYjaH2CXtw/b41D11TVg9pTpesldXoGxYwjEEvcNJJxhA
         b6VhjP4jBHmQvNeOHIljSpYJaXPQYyXrkCUcDNFDdux6NSK/4/U7aSJI9howEpBHoA65
         fPLXiXqP+7gOGe/+/38S3TxVufiOnHWw14ikfxmc2H1123TB2M3jI30gnHAKWS+1xPEC
         8nlQ==
X-Gm-Message-State: APjAAAXWvOVJcAEQqRuNJ1rES3GI6SpH00ppdrYl59B5DufSfKR/TX0a
        9Ku9P3cTBL3YC6ZMATzoOkw0VQ==
X-Google-Smtp-Source: APXvYqzlWv9ZU+3BpEhFfR0ZEw53esmcczKsZgnkpqrvwm3DR8JioPy73X+ScQPOKEO+mUDg1IMuKw==
X-Received: by 2002:a1c:ed07:: with SMTP id l7mr8758291wmh.148.1558362896292;
        Mon, 20 May 2019 07:34:56 -0700 (PDT)
Received: from bender.baylibre.local (lmontsouris-657-1-212-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.gmail.com with ESMTPSA id c2sm12756186wrr.13.2019.05.20.07.34.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 20 May 2019 07:34:55 -0700 (PDT)
From:   Neil Armstrong <narmstrong@baylibre.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Neil Armstrong <narmstrong@baylibre.com>
Subject: [PATCH net-next 0/2] net: stmmac: dwmac-meson: update with SPDX Licence identifier
Date:   Mon, 20 May 2019 16:34:48 +0200
Message-Id: <20190520143450.2143-1-narmstrong@baylibre.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the SPDX Licence identifier for the Amlogic Meson6 and Meson8 dwmac
glue drivers.

Neil Armstrong (2):
  net: stmmac: dwmac-meson: update with SPDX Licence identifier
  net: stmmac: dwmac-meson8b: update with SPDX Licence identifier

 drivers/net/ethernet/stmicro/stmmac/dwmac-meson.c   | 8 +-------
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c | 8 +-------
 2 files changed, 2 insertions(+), 14 deletions(-)

-- 
2.21.0

