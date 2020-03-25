Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F31731920C8
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 06:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727376AbgCYF4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 01:56:37 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:42653 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbgCYF4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 01:56:36 -0400
Received: by mail-lj1-f194.google.com with SMTP id q19so1127117ljp.9;
        Tue, 24 Mar 2020 22:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KXLP0/H62Iyak+HWMvNxv2asCanHU5NDryMupzQljyQ=;
        b=pZR9ei1vxMr3u8y5qL+mLZGwU/2WSStdK5WDY0E67329D/GFURPI717SH1LJJ8Pjl7
         wUdOM8f3RY5tMwLxdZsfS2NcnGAlpDtHxYI0uxbPL6F9TO7dGiB4hByqOrnYTrxKfmTo
         A9UGNoNuiQS8omgDrK2UzlP1gAqF/MB49ucMu7uZDJnyngiYbvPjENn2qXW3Rvwl/ggV
         7Nsvzpj0Rsp1IIXZDXTPcAhvp88VuGFAb6uU8X7xM4ZAtLdxAZJUVQaP9mjst3dNvyH6
         zUEeJAmo1krCrnnxTFUZrv9Vlh7c7wpu+5450YoGJZ1wXhHlZZaBDIF8ZrAWkm9SL/jK
         8qWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KXLP0/H62Iyak+HWMvNxv2asCanHU5NDryMupzQljyQ=;
        b=I8xT6ZihSHIoVXxYazCLGFQIHPGwmAMWhIKTTOBzepjtgWNQaX5v173aN/3RNgxE1y
         ruu6SEs73v85BBQ4q1aJzLDYIYfQc4vBfs34NL74LK8NPHINGlh6B+25nBHMPkFWE6dE
         gijm81X/T4IF/sWkockwt9GNwzifR/GuMzPyyjBAu+U6q1vKwbGg/JSRCVme8F26By8K
         kAOSe7CKWIR141bQDiFkO71PZsV8xL8JDJbEQ7JYRJxLnnlSArQTgxCepwB8SCJtXBzI
         WvfFgdxYI/kj0KiEnHDmdoGs7vIklexno1d4d26DwRtd6onTEfsjinCq/MWcYUfp1qPK
         uBwg==
X-Gm-Message-State: AGi0Pub44ziro9PAxnXedMvzOawcPRqS1W7458umI1PQfRT6Ye4rW3bX
        PR/z9rzHnnsXhMo2Favud0c=
X-Google-Smtp-Source: ADFU+vu3fs9td+AZg+GfH8KE6sCDA0t03LRyFkKaskNvANi2tSXlhNrCU5zMzOlFPRoZLQ/GPlGnQg==
X-Received: by 2002:a2e:878a:: with SMTP id n10mr885894lji.130.1585115794908;
        Tue, 24 Mar 2020 22:56:34 -0700 (PDT)
Received: from localhost.localdomain ([185.188.71.122])
        by smtp.gmail.com with ESMTPSA id y20sm3453692ljy.100.2020.03.24.22.56.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 22:56:34 -0700 (PDT)
From:   Pawel Dembicki <paweldembicki@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Pawel Dembicki <paweldembicki@gmail.com>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Roy Luo <royluo@google.com>, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mt76: mt76x0: pci: add mt7610 PCI ID
Date:   Wed, 25 Mar 2020 06:55:23 +0100
Message-Id: <20200325055525.20279-1-paweldembicki@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add mt7610 PCI id found on D-Link DWR-960 to pci_device_id table.

Run-tested on D-Link DWR-960 with no-name half-size mPCIE card
with mt7610e.

Signed-off-by: Pawel Dembicki <paweldembicki@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index e2974e0ae1fc..3bd753cda190 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -215,6 +215,7 @@ mt76x0e_remove(struct pci_dev *pdev)
 }
 
 static const struct pci_device_id mt76x0e_device_table[] = {
+	{ PCI_DEVICE(0x14c3, 0x7610) },
 	{ PCI_DEVICE(0x14c3, 0x7630) },
 	{ PCI_DEVICE(0x14c3, 0x7650) },
 	{ },
-- 
2.20.1

