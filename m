Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61DD73031F2
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 03:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730860AbhAYQra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 11:47:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43227 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730871AbhAYQrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 11:47:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611593138;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=L83MYPgs4J2VwvcROYLbVnXEo5PX6k5Ym5D1jARCBQ8=;
        b=LwqCutckxiCER+dAuaBDzLLo0e7mpdNBUyYaNM4I8bvNGcQ3q40Y7jqZJo475SoDIVrUBT
        TpvPiAN5JPs0MZXueLSaGbd35VVb0qIDRz9e6SFcqynxtiOqaJNE/+750LWxYHICMqTS/p
        hvtTNMyhvLjsG1GPQNJAX32vH4Q5d8Q=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30--Q866o3-OFu9GZQ7hRAbwg-1; Mon, 25 Jan 2021 11:45:35 -0500
X-MC-Unique: -Q866o3-OFu9GZQ7hRAbwg-1
Received: by mail-qv1-f71.google.com with SMTP id j4so2866542qvi.8
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 08:45:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=L83MYPgs4J2VwvcROYLbVnXEo5PX6k5Ym5D1jARCBQ8=;
        b=NCe0lWnRXFf+1e7P4pi0o30uuGt60vYkG96UTIrW+XnlI1SkJcKdaGUAumHZ5iDqF3
         hos/delCWMEUPgISoCZOqmfTf/GiBzB8QOofaw0JvRkFWWF/hi4/dicXtk3+25Rt0R9Z
         b9nb9PiXwv1GkDKDzV7Bc1iY3+JSn7BUIWNS0eV6zrkMthpfHHPu5vQyZFS0jY/UHUxI
         KU15aQLVN17Ea+xvubyD3tCF1qO3zoDs3e28Q9Lp2QeLr3OWCYOJT7ah19goa5WecVwv
         flmprfMk1lq90aDHcy2HmczqnvCWarB4BTNSLsa8yhV+D0r+cT28XRBbxER3wYr8F1/j
         FF8A==
X-Gm-Message-State: AOAM532ip925iwWAkCEs4UBm4Nzyn6lP+99HLxNZCHT4667w7WxioJ3U
        MXSrPVYQ0LW1CQaR0DQ/HtvgFhitbjkAgDhu3TeGnwgWVZPKbVzdrHlLQAf4dyLnIUCK35TS2Pe
        kXPt/lTOwSKjg0U5W
X-Received: by 2002:a0c:b4a8:: with SMTP id c40mr1586080qve.60.1611593135160;
        Mon, 25 Jan 2021 08:45:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx9l+q5LUi2NmCnhljUwgezyQmGQ8e1AZtJkI9MpfC9tuDiC1/GVJ0StQQ2VZwdI88MJdlTcw==
X-Received: by 2002:a0c:b4a8:: with SMTP id c40mr1586073qve.60.1611593134967;
        Mon, 25 Jan 2021 08:45:34 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id w42sm11941262qtw.22.2021.01.25.08.45.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 08:45:34 -0800 (PST)
From:   trix@redhat.com
To:     richardcochran@gmail.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] net: phy: remove h from printk format specifier
Date:   Mon, 25 Jan 2021 08:45:28 -0800
Message-Id: <20210125164528.2101360-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

This change fixes the checkpatch warning described in this commit
commit cbacb5ab0aa0 ("docs: printk-formats: Stop encouraging use of
  unnecessary %h[xudi] and %hh[xudi]")

Standard integer promotion is already done and %hx and %hhx is useless
so do not encourage the use of %hh[xudi] or %h[xudi].

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/phy/dp83640.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
index 0d79f68f301c..1bc68a3bffa2 100644
--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -186,7 +186,7 @@ static void dp83640_gpio_defaults(struct ptp_pin_desc *pd)
 
 	for (i = 0; i < GPIO_TABLE_SIZE; i++) {
 		if (gpio_tab[i] < 1 || gpio_tab[i] > DP83640_N_PINS) {
-			pr_err("gpio_tab[%d]=%hu out of range", i, gpio_tab[i]);
+			pr_err("gpio_tab[%d]=%u out of range", i, gpio_tab[i]);
 			return;
 		}
 	}
-- 
2.27.0

