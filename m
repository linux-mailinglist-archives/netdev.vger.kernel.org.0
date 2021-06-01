Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4EFC396A82
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 02:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232622AbhFAAyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 20:54:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:46280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232583AbhFAAx7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 20:53:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E5AD6128A;
        Tue,  1 Jun 2021 00:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622508739;
        bh=kG+9RtVXlyMIsugN7bZXLPw5uQxPiZSYOoDwJAj9cwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=grKyL/RUceFsztbX0dt5ZzE6I6q2KwirV0kwMf8VsfySqDElcLxQ6AO5Gg3n419u0
         IOtHpXhhz6DwHglR/2Zd6ILyW4aMlunZHvuOAUjqsShyPct8QDNdKs9JkhMmP/5xOU
         NwRydFV9A9Y9NQSuiEYyDLRMieeXltzIne7w5ycMD3hJ8WUPno1NCx6ImJu3UlzQ26
         t6yQ9L5CP5hisYx0VaB8Dzis3XOaXqZkdMlYuKVqkvXCWEWn8ZHHed9b0opMBRJAGb
         bXUOG8stkJVoBDRp+tqcZzf23CVkMwPqdmvrg0CdjfP4LdH9i+dceamy8jy/C7SQDu
         52O8NPaXaw82w==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     linux-leds@vger.kernel.org
Cc:     netdev@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Dan Murphy <dmurphy@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH leds v2 09/10] leds: turris-omnia: initialize each multicolor LED to white color
Date:   Tue,  1 Jun 2021 02:51:54 +0200
Message-Id: <20210601005155.27997-10-kabel@kernel.org>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210601005155.27997-1-kabel@kernel.org>
References: <20210601005155.27997-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Initialize the intensity of each multi-color LED to white color (255,
255, 255).

This is what the hardware does by default when the driver is not
present.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/leds/leds-turris-omnia.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/leds/leds-turris-omnia.c b/drivers/leds/leds-turris-omnia.c
index 2b51c14b8363..b3581b98c75d 100644
--- a/drivers/leds/leds-turris-omnia.c
+++ b/drivers/leds/leds-turris-omnia.c
@@ -117,10 +117,13 @@ static int omnia_led_register(struct i2c_client *client, struct omnia_led *led,
 
 	led->subled_info[0].color_index = LED_COLOR_ID_RED;
 	led->subled_info[0].channel = 0;
+	led->subled_info[0].intensity = 255;
 	led->subled_info[1].color_index = LED_COLOR_ID_GREEN;
 	led->subled_info[1].channel = 1;
+	led->subled_info[1].intensity = 255;
 	led->subled_info[2].color_index = LED_COLOR_ID_BLUE;
 	led->subled_info[2].channel = 2;
+	led->subled_info[2].intensity = 255;
 
 	led->mc_cdev.subled_info = led->subled_info;
 	led->mc_cdev.num_colors = OMNIA_LED_NUM_CHANNELS;
-- 
2.26.3

