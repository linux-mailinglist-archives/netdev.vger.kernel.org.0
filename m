Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 425407A5B6
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 12:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732141AbfG3KLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 06:11:51 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44381 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbfG3KLv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 06:11:51 -0400
Received: by mail-wr1-f68.google.com with SMTP id p17so65088393wrf.11;
        Tue, 30 Jul 2019 03:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=naKRDX9WVo3cs2KZ0MRfRmaNOOl0VGQTm099H1LHTFA=;
        b=mwt+N/rr9IRwMUmgbPph/bv0tW2YVSgPQpf9L7S+qZiQmvzTL3dnLmJtN3f+OCJ61d
         VR/zcfvsHPbiAY5aA+AJlwbmEh0IEOq6XOZlbP2wHe2G7ZLNmj8NWmH14udho7Xkrk+R
         3yxdWv4o4DYc3uHQzzMoonMViKrrfdQ+QQ3Ai98fARpP8HMd9+4OYL7e7U6YqUKnYu35
         kgnvWibdWrHw62aOXh6oi1qZ0Px0ZnBeEQl68DKc0rGYiYcfinSt0oDiLa3ls2qs8fvV
         lINJ1Ezp9L+LLnsFtU6Gy3BYtrYv1Hxl0A3vsgllGoyt69NDF13jzDbIsKmSFyJgYXKo
         oLdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=naKRDX9WVo3cs2KZ0MRfRmaNOOl0VGQTm099H1LHTFA=;
        b=IAFDXDTbSOe7N1xXJMOFaHWWKWR8XlQ1CUeCTNnTRYP6RArlP3CE3EThYd5iEEQtoY
         jvUBWNv53qr6An7xCvLctkMelZhU2ZrzEl6c4mRVZkDeSF66tPshruXXlaUBpY2e5YIU
         jieStr1FCBBekctmUEetVLVG67mh0qga6qK9O9iDXX4j4tDpZ4GFYMMfIP3iIePMZJFq
         cRhU8qeJWmOL/66gd99u7MSZXdfaBWoa7zFRj9/RqZBypk4LVc4YRVQe5X5iwVytUeDC
         5wzymLk63ugw4yJYrKCEXY1+EP8uuhcGs25knxtNfChY3XoKveyVUiPDdIiyUSOdYwQT
         rvww==
X-Gm-Message-State: APjAAAWwDJ5Igs46MpTXzizh5w/t6Z43gEQgnqthGBge7jt0fKF8sFc+
        kiZCYQFx4cVMNyEwnQF6HQguDN00
X-Google-Smtp-Source: APXvYqyOn10wVAdTCy2JJCYfoRBCb0ES9hi12BdNy0eCrTe+b372UObinJPXwZD13x/d3N6nZncwvw==
X-Received: by 2002:a05:6000:42:: with SMTP id k2mr6096793wrx.80.1564481508717;
        Tue, 30 Jul 2019 03:11:48 -0700 (PDT)
Received: from vd-lxpc-hfe.ad.vahle.at ([80.110.31.209])
        by smtp.gmail.com with ESMTPSA id y24sm47435687wmi.10.2019.07.30.03.11.47
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 03:11:48 -0700 (PDT)
From:   Hubert Feurstein <h.feurstein@gmail.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Hubert Feurstein <h.feurstein@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] net: dsa: mv88e6xxx: use link-down-define instead of plain value
Date:   Tue, 30 Jul 2019 12:11:42 +0200
Message-Id: <20190730101142.548-1-h.feurstein@gmail.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using the define here makes the code more expressive.

Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 58e298cc90e0..85638b868d8e 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -430,7 +430,7 @@ int mv88e6xxx_port_setup_mac(struct mv88e6xxx_chip *chip, int port, int link,
 		return 0;
 
 	/* Port's MAC control must not be changed unless the link is down */
-	err = chip->info->ops->port_set_link(chip, port, 0);
+	err = chip->info->ops->port_set_link(chip, port, LINK_FORCED_DOWN);
 	if (err)
 		return err;
 
-- 
2.22.0

