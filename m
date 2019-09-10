Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7D1AF17B
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 21:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbfIJTEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 15:04:47 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44995 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbfIJTEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 15:04:46 -0400
Received: by mail-wr1-f65.google.com with SMTP id k6so9649637wrn.11;
        Tue, 10 Sep 2019 12:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=od6IWHhGZ3spsiCZG9/kdZx0y1/zoDRsOeEYPUkz2sQ=;
        b=Qfq48iz3esxK6VmHRhko2SXnnPs0vh5iPOv6axMSLBAZ4qaAVa0zw17HjdIUdqZ2Ck
         Icis/B0jwiEhVQLsCxRX8jLSXHxOMFAdxUvUkBC4qdcQlaOxEnVh6X6nL66R9+38gac2
         mdV02YVLzojkoXBhvlHSm1vHt/lPSDO+hBwoFkMj5mMH7eRBvZwYn/D5NyzqYcg5mJDr
         pAjfL/9vmIy15igl78dRoBChk1rucThQ9Mmi3UHzqMxLTkTN5m8Z1VQUMpr+5CFUlgXW
         RdJo7hmIWYa2DDHp0g3zE3oyrnpzrA+mAL//Z15qIsW48ivHXdW8A8bHaHPg9ACNhvcj
         dsrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=od6IWHhGZ3spsiCZG9/kdZx0y1/zoDRsOeEYPUkz2sQ=;
        b=s73TS7Ri33pPlcvTY8JAwUie8kEa6KmkhOHbxGFbBo2/XPP1vOWNRjhoeK4AAjhqHZ
         KJGxwV3ktQ2OEuvuYQxRoitRoAm/P5qV06B/RsfukFZCuZ6NkQLT45Qtl9BUZnd2RSJw
         hmqSLeh9JtcMchiT4PtJACxjH+BYEhAIPC5TgcqtuJzYbMe2v5ovsolEdIAoZCcHkPFW
         fK+7TlDI00OtSmC29w/ZFhsytD78w5/blYCsiHJS65mKaxHSbRu6rmUgCn8yTJldK0kg
         +wWkFwL5nZdrBnKfzbEziVJAbgT3nl6VGmNJ65Vua4m7XCcUPlvIFTGgdWaF8URM3KFO
         Ei5Q==
X-Gm-Message-State: APjAAAVBQyUhe7uZQoE6tGBp9jYp75RCP0fNwyPXEgf2HbLnLu2NkWRA
        Tpuex7Q44HTd59DLCBgSaEk=
X-Google-Smtp-Source: APXvYqwa23L2H2yM5Xh3ZjeyAtrKxXUPAe/e24njkdHnmteRl5sgMmnMu7x8F1sgr/a1jb/j9hVRlg==
X-Received: by 2002:adf:fe07:: with SMTP id n7mr1403110wrr.90.1568142284558;
        Tue, 10 Sep 2019 12:04:44 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8108:96bf:e0ab:2b68:5d76:a12a:e6ba])
        by smtp.gmail.com with ESMTPSA id w15sm14222967wru.53.2019.09.10.12.04.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2019 12:04:44 -0700 (PDT)
From:   Michael Straube <straube.linux@gmail.com>
To:     kvalo@codeaurora.org
Cc:     pkshih@realtek.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michael Straube <straube.linux@gmail.com>
Subject: [PATCH 0/3] rtlwifi: use generic rtl_evm_db_to_percentage
Date:   Tue, 10 Sep 2019 21:04:19 +0200
Message-Id: <20190910190422.63378-1-straube.linux@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Functions _rtl92{c,d}_evm_db_to_percentage are functionally identical
to the generic version rtl_evm_db_to percentage. This series converts
rtl8192ce, rtl8192cu and rtl8192de to use the generic version.

Michael Straube (3):
  rtlwifi: rtl8192ce: replace _rtl92c_evm_db_to_percentage with generic
    version
  rtlwifi: rtl8192cu: replace _rtl92c_evm_db_to_percentage with generic
    version
  rtlwifi: rtl8192de: replace _rtl92d_evm_db_to_percentage with generic
    version

 .../wireless/realtek/rtlwifi/rtl8192ce/trx.c  | 23 +------------------
 .../wireless/realtek/rtlwifi/rtl8192cu/mac.c  | 18 +--------------
 .../wireless/realtek/rtlwifi/rtl8192de/trx.c  | 18 ++-------------
 3 files changed, 4 insertions(+), 55 deletions(-)

-- 
2.23.0

