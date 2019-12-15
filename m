Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 836B311FA3A
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 18:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbfLOR6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 12:58:49 -0500
Received: from mta-p5.oit.umn.edu ([134.84.196.205]:39152 "EHLO
        mta-p5.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbfLOR6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 12:58:48 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-p5.oit.umn.edu (Postfix) with ESMTP id 47bXFz6FY1z9vYjJ
        for <netdev@vger.kernel.org>; Sun, 15 Dec 2019 17:58:47 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p5.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p5.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 2_bj_gaBWpJx for <netdev@vger.kernel.org>;
        Sun, 15 Dec 2019 11:58:47 -0600 (CST)
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com [209.85.219.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p5.oit.umn.edu (Postfix) with ESMTPS id 47bXFz5FwLz9vYj0
        for <netdev@vger.kernel.org>; Sun, 15 Dec 2019 11:58:47 -0600 (CST)
Received: by mail-yb1-f197.google.com with SMTP id x18so4730886ybr.15
        for <netdev@vger.kernel.org>; Sun, 15 Dec 2019 09:58:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jU+IZfsrbWu2RYKQORP75VmblWiOY4wZRLGbP+XVlQc=;
        b=K/4WYQMbmQ1wpcHdnuZeoJwrgi1TuSRJxWawgTjssgCRnX8GiJ6iRyBlTqADg15eX0
         48CwOuD9aEvwjfg8cpARkHqUADVenh2nclXVmA42nA7VHZzjtIYXgH9HSmT/K6mwQ5yQ
         Wr0g2dZd6zj3FKFJbhcx+2DdrGBIXJX/+dXGuQeJRI4LOMPFLg28QeYB3tWJQ3jOybg1
         bflpmQLNnlFFZ28wh0+p8QKU7/9g/9yfFDVabGzh3EU8hXJf0FE4RA8kCoIzSbJqvpET
         vm5r2Xq/Uy50ZVhZ5Q3JTiCITOQZlM33gZGhu0U20c0lz6QudM6oqhn52R2C/x6hppJu
         YsKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jU+IZfsrbWu2RYKQORP75VmblWiOY4wZRLGbP+XVlQc=;
        b=LMYmE52EXQVN62QipoiqoHENmeJJ7478edcpxBd2vSTPoAnlvE8PKddQNIKeVCWC1p
         TabELN6j3NOgnPo0YUOV/TGRvPf4uBU+XN2Evwte2aNRsxdRv0sIJsJiKExDsL6/DWri
         23udC76Nus8ea7apDisgbIoOdx6WJ89QfHl+qJbvozY9zjcNGFE9xbnl4SSy/j2Qqz+g
         3DkwgJROtmTB/pbKiyzy2lH1qj7HcFPSbL1c7ZhPBnhW3GbX2xOuwORvXtvDnhI3jkvn
         nYjGO8JnLxHyZjmykOqHasK2BVGumADMdf/1sAHpFBo4gsEcXzTseo7TgKc1b5M1ruMA
         JXDQ==
X-Gm-Message-State: APjAAAXVDf2LYrccoakgQoiaI4WK5MTUUTX4r9Va3kPh7eP12V22wLky
        u4BPLJUC46/K/g3pJtYXV1qnj4vSitVthBxZ/43tEK0qNjqR6Tj/yUyXPwj/B1vsLPMOPv6ND1e
        pcpqr0zyYBczENUwg9mom
X-Received: by 2002:a25:c884:: with SMTP id y126mr18656403ybf.406.1576432727235;
        Sun, 15 Dec 2019 09:58:47 -0800 (PST)
X-Google-Smtp-Source: APXvYqxLm13Xu0mUMgPfV76cA+1JEcVfLMMY9sBlXwtZ/dJhI+on6PQRm9vQAfnecJEurrKb9n20AQ==
X-Received: by 2002:a25:c884:: with SMTP id y126mr18656390ybf.406.1576432727025;
        Sun, 15 Dec 2019 09:58:47 -0800 (PST)
Received: from cs-u-syssec1.dtc.umn.edu (cs-u-syssec1.cs.umn.edu. [128.101.106.66])
        by smtp.gmail.com with ESMTPSA id l39sm7400528ywk.36.2019.12.15.09.58.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Dec 2019 09:58:46 -0800 (PST)
From:   Aditya Pakki <pakki001@umn.edu>
To:     pakki001@umn.edu
Cc:     kjlu@umn.edu, "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Richard Fontana <rfontana@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] hdlcdrv: replace assertion with recovery code
Date:   Sun, 15 Dec 2019 11:58:41 -0600
Message-Id: <20191215175842.30767-1-pakki001@umn.edu>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In hdlcdrv_register, failure to register the driver causes a crash.
However, by returning the error to the caller in case ops is NULL
can avoid the crash. The patch fixes this issue.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
---
 drivers/net/hamradio/hdlcdrv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/hamradio/hdlcdrv.c b/drivers/net/hamradio/hdlcdrv.c
index df495b5595f5..38e5d1e54800 100644
--- a/drivers/net/hamradio/hdlcdrv.c
+++ b/drivers/net/hamradio/hdlcdrv.c
@@ -687,7 +687,8 @@ struct net_device *hdlcdrv_register(const struct hdlcdrv_ops *ops,
 	struct hdlcdrv_state *s;
 	int err;
 
-	BUG_ON(ops == NULL);
+	if (!ops)
+		return ERR_PTR(-EINVAL);
 
 	if (privsize < sizeof(struct hdlcdrv_state))
 		privsize = sizeof(struct hdlcdrv_state);
-- 
2.20.1

