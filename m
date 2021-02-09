Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10C803158A4
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 22:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234386AbhBIV2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 16:28:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233922AbhBIVOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 16:14:14 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA0EC0613D6
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 13:13:26 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id m7so20948650oiw.12
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 13:13:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=zOr93WXqZTrgj40r/VXH5RS6b9QPAmKqC4y8SY4MmVE=;
        b=IFfzTe2Vf7XGKUlO54vbIpDDLyvgED0kGUirNPBVeEj8z4rYkPjYgJ9LJlCuQsKQnt
         VjgIF+DzJDNOh0e98JWTVECnJiFOktX+GRv+Lq6q80o8VsQ8roSR4q/+Zd6QVe1QP9oo
         BMCZ5q0jDd+dcYyKWASOtEuATFeTckGKnT6fK3Vq2qdP6Eje4C5DP+c/zP271TmFQ1nU
         eg0fOGQAozdm56OItFl/oln4d/xDVkgKQsnpzKarNxSKQkb+8or4dz0QnXenvVRANOpV
         wx1Asuj3ri0OXRKTJQHo6Za6qaT7Hby12dx+M9eSgjn6wqLNJYazOvAz8Bnvlbzpl8Lk
         vJ1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=zOr93WXqZTrgj40r/VXH5RS6b9QPAmKqC4y8SY4MmVE=;
        b=HF+6XDji7OCHPypOE4+2bHyqAdHuVO6PiNugWRENo8DLPz6C2i0yQUV6jmQGQ5ks6+
         DG33OOvNXcQsGD1szVQkHqNRfBtEu8LGa0byXPprcp+QW5B67X8DH3oEBLk0Ayr8YZ2n
         XKeOFMXrRi7a1AqNcdyz14ymNoPYVJHgEdGOjEDAzuxpYJOuURsbf5/EA1rjQcb/7c2z
         gYgv/xlnjxo1/O1Wq0gtY7CxhmUsCESziJj20mBdEI6KlDNE1oR06gT+vOQ+FksLpzLg
         qL6tMKq81KOqJNJNlj+Sthxn8mSDFenubVHTmwcf8Lso8MSuAr3a9bIIz2QueDFDpPML
         6Uyg==
X-Gm-Message-State: AOAM530b1zWOj8u9QZV4Rq8/dhZWzkGARYof2H3cEZVG4zwXxZB3yShW
        NGpdsL/bluxAkdlNDesjYQ==
X-Google-Smtp-Source: ABdhPJwQPIVjg/jV61MvVZhkFP+s+dN16N9y4y2ncRKXop9+HP8hE+y3MzTIl73QXUwduzB+gYBDzQ==
X-Received: by 2002:aca:5f85:: with SMTP id t127mr3577862oib.76.1612905205795;
        Tue, 09 Feb 2021 13:13:25 -0800 (PST)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id r4sm2512777oig.52.2021.02.09.13.13.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Feb 2021 13:13:24 -0800 (PST)
From:   George McCollister <george.mccollister@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH net-next 1/2] net: dsa: xrs700x: fix unused warning for of_device_id
Date:   Tue,  9 Feb 2021 15:12:55 -0600
Message-Id: <20210209211256.111764-1-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix unused variable warning that occurs when CONFIG_OF isn't defined by
adding __maybe_unused.

>> drivers/net/dsa/xrs700x/xrs700x_i2c.c:127:34: warning: unused
variable 'xrs700x_i2c_dt_ids' [-Wunused-const-variable]
   static const struct of_device_id xrs700x_i2c_dt_ids[] = {

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: George McCollister <george.mccollister@gmail.com>
---
 drivers/net/dsa/xrs700x/xrs700x_i2c.c  | 2 +-
 drivers/net/dsa/xrs700x/xrs700x_mdio.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/xrs700x/xrs700x_i2c.c b/drivers/net/dsa/xrs700x/xrs700x_i2c.c
index 16a46a78a037..489d9385b4f0 100644
--- a/drivers/net/dsa/xrs700x/xrs700x_i2c.c
+++ b/drivers/net/dsa/xrs700x/xrs700x_i2c.c
@@ -121,7 +121,7 @@ static const struct i2c_device_id xrs700x_i2c_id[] = {
 
 MODULE_DEVICE_TABLE(i2c, xrs700x_i2c_id);
 
-static const struct of_device_id xrs700x_i2c_dt_ids[] = {
+static const struct of_device_id __maybe_unused xrs700x_i2c_dt_ids[] = {
 	{ .compatible = "arrow,xrs7003e", .data = &xrs7003e_info },
 	{ .compatible = "arrow,xrs7003f", .data = &xrs7003f_info },
 	{ .compatible = "arrow,xrs7004e", .data = &xrs7004e_info },
diff --git a/drivers/net/dsa/xrs700x/xrs700x_mdio.c b/drivers/net/dsa/xrs700x/xrs700x_mdio.c
index a10ee28eb86e..3b3b78f20263 100644
--- a/drivers/net/dsa/xrs700x/xrs700x_mdio.c
+++ b/drivers/net/dsa/xrs700x/xrs700x_mdio.c
@@ -138,7 +138,7 @@ static void xrs700x_mdio_remove(struct mdio_device *mdiodev)
 	xrs700x_switch_remove(priv);
 }
 
-static const struct of_device_id xrs700x_mdio_dt_ids[] = {
+static const struct of_device_id __maybe_unused xrs700x_mdio_dt_ids[] = {
 	{ .compatible = "arrow,xrs7003e", .data = &xrs7003e_info },
 	{ .compatible = "arrow,xrs7003f", .data = &xrs7003f_info },
 	{ .compatible = "arrow,xrs7004e", .data = &xrs7004e_info },
-- 
2.11.0

