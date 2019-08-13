Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5128AF3B
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 08:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727420AbfHMGIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 02:08:13 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:33894 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbfHMGIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 02:08:12 -0400
Received: by mail-lj1-f195.google.com with SMTP id x18so3994248ljh.1;
        Mon, 12 Aug 2019 23:08:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MDG29oqYq4nVVn3hrh+2fbdajMYYSsCGEYHbdqYGlcU=;
        b=Fii6LhkROVK1fv2x+QlUx3ocjhOAx8AZABefif/L3FQ9Asa7zaM2/eFQbsl0CV1RNP
         W6ziaaEUHX5Mz/rYkTNUlAwrL2urFru8WcBUVvocokGodkGVCIdHv2lzq8KnKt93PkvV
         CNPCgnMu+OFJ+3DjeRNjB+S4J3My5Ebk+5YxHwiLHyqJlYvA97TzTd4NueUtxAX881v8
         xh6AOYzd+llTO2B8wmqe7gO/3VRzxt86506nnnWMip5jA03Xoi3agPSHZn6YXBPvh/wp
         F1sB0kOxAqkZlqDMk2eld+7dKhA1cr3HVoQUb71Wb2gTiuSUUgcX+wMrVzLBk7bjcNyF
         auiQ==
X-Gm-Message-State: APjAAAVAG3IE6rDdul9mgX1xRlLFqCqH33UtHCCHZeyHRtgQZ7NfN7IT
        gAgLRQz7j1o7vdF6RLDS8P3v/XnK9Ng=
X-Google-Smtp-Source: APXvYqwknx9v52tbRVWqkgQLlNMXeAKBWlf1KxDvXLFEh77Q/kJsDqd8VeP0tsogWsWN2uEhLh+ofg==
X-Received: by 2002:a2e:7614:: with SMTP id r20mr21213708ljc.42.1565676490536;
        Mon, 12 Aug 2019 23:08:10 -0700 (PDT)
Received: from localhost.localdomain (broadband-188-32-48-208.ip.moscow.rt.ru. [188.32.48.208])
        by smtp.googlemail.com with ESMTPSA id 25sm5791605lft.71.2019.08.12.23.08.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 23:08:09 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     linux-kernel@vger.kernel.org
Cc:     Denis Efremov <efremov@linux.com>, joe@perches.com,
        Heiner Kallweit <hkallweit1@gmail.com>, nic_swsd@realtek.com,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH] MAINTAINERS: r8169: Update path to the driver
Date:   Tue, 13 Aug 2019 09:07:59 +0300
Message-Id: <20190813060759.14256-1-efremov@linux.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <7cd8d12f59bcacd18a78f599b46dac555f7f16c0.camel@perches.com>
References: <7cd8d12f59bcacd18a78f599b46dac555f7f16c0.camel@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update MAINTAINERS record to reflect the filename change
from r8169.c to r8169_main.c

Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: nic_swsd@realtek.com
Cc: David S. Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Fixes: 25e992a4603c ("r8169: rename r8169.c to r8169_main.c")
Signed-off-by: Denis Efremov <efremov@linux.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 99a7392ad6bc..25eb86f3261e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -183,7 +183,7 @@ M:	Realtek linux nic maintainers <nic_swsd@realtek.com>
 M:	Heiner Kallweit <hkallweit1@gmail.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
-F:	drivers/net/ethernet/realtek/r8169.c
+F:	drivers/net/ethernet/realtek/r8169_main.c
 
 8250/16?50 (AND CLONE UARTS) SERIAL DRIVER
 M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
-- 
2.21.0

