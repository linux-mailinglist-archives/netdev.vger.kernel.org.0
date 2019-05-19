Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70A872284E
	for <lists+netdev@lfdr.de>; Sun, 19 May 2019 20:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729690AbfESSXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 May 2019 14:23:15 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42372 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbfESSXP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 May 2019 14:23:15 -0400
Received: by mail-pg1-f196.google.com with SMTP id 145so5653503pgg.9;
        Sun, 19 May 2019 11:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=WzJCr5Mqo7KDli7/APapwgRQAN+3Dg6ZabacVkfKewY=;
        b=bDPww6T9HxL4G0YBVqH8QA8CxtSPz0B8H38YvWR1qMuAfAhv4ImEaMvavxWgzBbY1S
         Ui44qaJO1e7sKwZqpav6+PoKS0jvRoCz9DpNUi5xytn1plf4WNQLdnOT1TDrSmIXZp8d
         7oMmJdHlmSP6IYMH1mxvfdm2/zWKht5zkFz13Y793V+GqLq3HlJP84FizNUIccz/qyV5
         DbW7830t96KocxtQu56drxYLzDznc1tgK4OCQoewDb4X0otT3bIhuWQpt9x5Si07IzQM
         1/XKlnL5gWsRnOy/gtTyPK0NXhSluLir8CnznHsvMMFnskMVDYOUoVB1EExDZ+qmlIgb
         jVuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=WzJCr5Mqo7KDli7/APapwgRQAN+3Dg6ZabacVkfKewY=;
        b=JOA8G4vnC+ZN8Ji9NdHzNieDoZoxfulruErsJ+br3Ivx7Ib/t4UX0eyYqNa0mxcMtc
         kOgj7Ri08XNyTRsSKIbmUhKJG+EghWyfwwD7PUz6HOq9W9isfoz0wYMZm7MnpeHwjgGj
         DnnLyGI1OCfEnfmVi+CS+ta+KhHP3s0rqhDqnfB8SX6a76YUfpKX3+C9gfkvWbR/aHQq
         9y05FtYfA3A4VXrKCTTEf3ajbuESc+4Rkllcnq5/hswIRV0kzs7Yc0KvEThCcnjm0dKB
         xVp2NsoqfRpmoY67Zni2/Bx1TGf2rExnpo3h6CLxQdWsDkeYQGX0QfZ6lUrIK0V8Uxo6
         TbIA==
X-Gm-Message-State: APjAAAXJVyqvTqnVD5fJQYaSyGd3NXSM7GL8Ui44IytjK81UYw0vSyBK
        hDrGwPQgPrbKmvMWQAhskvqtCaYEHHZbfA==
X-Google-Smtp-Source: APXvYqzUDhR+agkX0dI26XmwhEq48+gxrghmc6If8Xc5OS7eLq2qfmYj8EnWhg/A70HjcFg2S8X8Iw==
X-Received: by 2002:aa7:90ca:: with SMTP id k10mr72091047pfk.20.1558235368251;
        Sat, 18 May 2019 20:09:28 -0700 (PDT)
Received: from localhost ([43.224.245.181])
        by smtp.gmail.com with ESMTPSA id n127sm13217809pga.57.2019.05.18.20.09.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 18 May 2019 20:09:27 -0700 (PDT)
From:   Weitao Hou <houweitaoo@gmail.com>
To:     nbd@nbd.name, lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        royluo@google.com, kvalo@codeaurora.org, davem@davemloft.net,
        matthias.bgg@gmail.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Weitao Hou <houweitaoo@gmail.com>
Subject: [PATCH] net: fix typos in code comments
Date:   Sun, 19 May 2019 11:09:23 +0800
Message-Id: <20190519030923.18343-1-houweitaoo@gmail.com>
X-Mailer: git-send-email 2.18.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fix lenght to length

Signed-off-by: Weitao Hou <houweitaoo@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
index 6b89f7eab26c..e0f5e6202a27 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
@@ -53,7 +53,7 @@ int mt76x02u_skb_dma_info(struct sk_buff *skb, int port, u32 flags)
 	pad = round_up(skb->len, 4) + 4 - skb->len;
 
 	/* First packet of a A-MSDU burst keeps track of the whole burst
-	 * length, need to update lenght of it and the last packet.
+	 * length, need to update length of it and the last packet.
 	 */
 	skb_walk_frags(skb, iter) {
 		last = iter;
-- 
2.18.0

