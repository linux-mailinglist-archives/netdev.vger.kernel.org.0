Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1628D1A001F
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 23:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbgDFV3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 17:29:33 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38262 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbgDFV3d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 17:29:33 -0400
Received: by mail-wr1-f67.google.com with SMTP id 31so1308235wre.5
        for <netdev@vger.kernel.org>; Mon, 06 Apr 2020 14:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4peStimuioJ5yeUio3K13tIDTmTCRqo2KbJ0rBh2RDE=;
        b=C4hoCWaOvfzmx26ysOxkZe4aT3zfdPhSjn8ggmupAXCKgm4Qgo4QL5+1qOrzGH2NK/
         R7i8HfCQtQXgFcZ3KP9v5KzoHzADZQHYc/W8wZXjZf3u4HCG3KzyUHxC8p0yUOOnWsqM
         tqqPxU+23zDyx+EXSu6evirG10WFizT/AQ6of+vBpHSnQ91JHYjT5vXTjhcDmRM75EHH
         ldjGnhpu6cGb6scKGZPcciuTtDA7Jsvpb7CQKegyAnkog+/6+x/tYqu+HKurQ9lHuw6f
         p80CXk+rV8SKNXnNV79p7qBHIAAmuq7wWZq3SQSFTZ+hIYaYEieyZ8rPrFY/5qof+ZUE
         NaMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4peStimuioJ5yeUio3K13tIDTmTCRqo2KbJ0rBh2RDE=;
        b=KELfw5ddO88MZbcmYBLmzaDBFUJY8Eold58gvvqxkYmketELlYhPmoYe6hTYvEzfdz
         wLlAZi3d/KiUWFncNGXBBOy18TQtiXXMUacmaS90SzXHY2qZS+SM8oOY8PC+aR0Cyhse
         F1K9crcL4n1AnMbKZOK7y2wnLz4zgTH39EQxRQ4DWIEBUI1DaIYV7gFWRjNX/tcbz/XQ
         Zxx0y28IxUxakqOKT1emq+mT6jm+woEm3AnJxZhstyfIrkUKnuHTV/xB4b744jP8nrqt
         l1Bh60UaGgnBIG1ijdsUZvCrfK+63AJ8uordsRgcmM/Lzol+IhBbu1N21HI2KpjpLTyP
         DEmA==
X-Gm-Message-State: AGi0PuaeRdz/mBQNPVlObvVnrdKN9lanmoUHcLV15lYm8UUeYJ7XdU4+
        9svWGY8GDbH6xQs6Rv/kNZjmaW3d8qM=
X-Google-Smtp-Source: APiQypI7vjoTmWatxFk2HtgRUQGwMMXFdEfyKpu22oKCJ4etAw6YmuFrOX5cMKzKE/9tAnlpIx/Jog==
X-Received: by 2002:a5d:610b:: with SMTP id v11mr1275512wrt.212.1586208571662;
        Mon, 06 Apr 2020 14:29:31 -0700 (PDT)
Received: from de0709bef958.v.cablecom.net ([185.104.184.118])
        by smtp.gmail.com with ESMTPSA id w66sm1062088wma.38.2020.04.06.14.29.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 14:29:31 -0700 (PDT)
From:   Lothar Rubusch <l.rubusch@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Lothar Rubusch <l.rubusch@gmail.com>
Subject: [PATCH] Documentation: mdio_bus.c - fix warnings
Date:   Mon,  6 Apr 2020 21:29:20 +0000
Message-Id: <20200406212920.20229-1-l.rubusch@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix wrong parameter description and related warnings at 'make htmldocs'.

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/net/phy/mdio_bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 522760c8bca6..7a4eb3f2cb74 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -464,7 +464,7 @@ static struct class mdio_bus_class = {
 
 /**
  * mdio_find_bus - Given the name of a mdiobus, find the mii_bus.
- * @mdio_bus_np: Pointer to the mii_bus.
+ * @mdio_name: The name of a mdiobus.
  *
  * Returns a reference to the mii_bus, or NULL if none found.  The
  * embedded struct device will have its reference count incremented,
-- 
2.20.1

