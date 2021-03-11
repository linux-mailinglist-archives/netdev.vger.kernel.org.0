Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 253DD336B24
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 05:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbhCKE20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 23:28:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbhCKE2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 23:28:01 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7353FC061574;
        Wed, 10 Mar 2021 20:28:01 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id 73so251901qtg.13;
        Wed, 10 Mar 2021 20:28:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EjES33pghkplwmPotcH24a/bCQBQOuZ6RX89GB25dlU=;
        b=Koyj1Zk7sbi7mVjTgbvqs9TiqOhPIiHI/qcvdsEGyo8VhIddw0zKe5lNZYgkEEx9Mh
         woWFsSfsYzUmFXIBd+sWNFXegzpxn8vV0Q+9OcBl1xy4J7WPrdrVviqnZFOXXC0kDSUX
         otE+FZGKhbzkBRAM/kc/lNiKKlaCnQe/jG8qvw0Ac5YmtQ9tNaqEzJfCuFJYx9UvczgT
         XfPAblr3jUIMculciAa0UTO+WU+w3+c1xps4gO/JsLZ0G0/fCWA67c+DeYfAFBe3csTJ
         XXucn/IQ8XVIP9Tm9AsqrgudhsiXKElgzNr4J/sdc9w8EKwYXfJ7aLY9ry2+pJJqQr9P
         pdZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EjES33pghkplwmPotcH24a/bCQBQOuZ6RX89GB25dlU=;
        b=cD/beNddz2lQA0KOgURqI1SuSDZVKbkAPpIL+PkWbx49CLVNYboIeTrY6GtzRH9kt1
         0Tz1UfoR8ESFKmVhg4Ze24jVHWjLtKApVn+fMjekh9J3iubyFqtDv0fVxe3575EJxUHY
         tET4Q6mGBhzfl+R8GsYKNoE+I7Yu0dUoq7eqVsvPYWeI1LvK7V+IKaTp5UAKJ/gwVm04
         zfjpvu2cByVIUB7ls759ogL76rfg0Fw70Ovaav6Y3dIAUhqPfIzqjIGj358/D161lUo9
         xNa5Nf2cDxPBYVSK4zYpEugZX3H0rzqoqMtszzQ64LgMoQ14qAMSMeTv4iJywsCJ6vOy
         X5og==
X-Gm-Message-State: AOAM532NLslj0g9+/HmQR+Hcl5j0IRmJ0B3fgXZDMuiuDJ36jI3lQiYl
        vDA5N1Cqz9DPylv/Y49qMu4=
X-Google-Smtp-Source: ABdhPJzYKwpvnDH9e/jr7oq+CIiwYhN7lvlFm/55ul1htJ9mgJjm765Sbrr2/GgpixvIU232bPoicQ==
X-Received: by 2002:a05:622a:42:: with SMTP id y2mr5699882qtw.11.1615436880721;
        Wed, 10 Mar 2021 20:28:00 -0800 (PST)
Received: from tong-desktop.local ([2601:5c0:c200:27c6:615f:1cdf:698f:e42f])
        by smtp.googlemail.com with ESMTPSA id 131sm1171582qkl.74.2021.03.10.20.28.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 20:28:00 -0800 (PST)
From:   Tong Zhang <ztong0001@gmail.com>
To:     Karsten Keil <isdn@linux-pingi.de>,
        Tong Zhang <ztong0001@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] isdn: remove extra spaces in the header file
Date:   Wed, 10 Mar 2021 23:27:55 -0500
Message-Id: <20210311042756.2062322-1-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fix some coding style issues in the isdn header

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
---
 drivers/isdn/hardware/mISDN/iohelper.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/iohelper.h b/drivers/isdn/hardware/mISDN/iohelper.h
index b2b2bde8edba..c81f7aba4b57 100644
--- a/drivers/isdn/hardware/mISDN/iohelper.h
+++ b/drivers/isdn/hardware/mISDN/iohelper.h
@@ -13,14 +13,14 @@
 #ifndef _IOHELPER_H
 #define _IOHELPER_H
 
-typedef	u8	(read_reg_func)(void *hwp, u8 offset);
-			       typedef	void	(write_reg_func)(void *hwp, u8 offset, u8 value);
-			       typedef	void	(fifo_func)(void *hwp, u8 offset, u8 *datap, int size);
+typedef u8 (read_reg_func)(void *hwp, u8 offset);
+typedef void (write_reg_func)(void *hwp, u8 offset, u8 value);
+typedef void (fifo_func)(void *hwp, u8 offset, u8 *datap, int size);
 
-			       struct _ioport {
-				       u32	port;
-				       u32	ale;
-			       };
+struct _ioport {
+	u32 port;
+	u32 ale;
+};
 
 #define IOFUNC_IO(name, hws, ap)					\
 	static u8 Read##name##_IO(void *p, u8 off) {			\
-- 
2.25.1

