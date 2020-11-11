Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91E882AFA95
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 22:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727739AbgKKVgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 16:36:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727238AbgKKVgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 16:36:24 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAF28C0613D1;
        Wed, 11 Nov 2020 13:36:23 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id s2so1650396plr.9;
        Wed, 11 Nov 2020 13:36:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TuIWEKHfoc1+Oar3jiYPK/6gE0dULFhfw6x7KSeby7M=;
        b=Gtx0/j3xLAcFbBKJlW4/LZoLu2SoY7QK8+mzI5+o1q8Ci1cfpGqd97LDcn7fbBAAK3
         W8ktagV7asRNm5FlxZcN0SL+kapEXQWNR7JimsO4LKXYmovhznPn0KXaMS50Osztudch
         44U/LqZyjbJSiyXGngnQLiihQ8lD3pX97HXYuNdbTkagtwCLy4MIyp5UP1aJuw2UVGfz
         fxm6ZhjUvnJXgseiNN1PINleLqTAeipfg8yUw9fv81fpl1luD6TtVy1NkcNmAFTPxoj2
         dQ7e14bT0r/U+M6QMldeghKmCziHZUztFwkkx4Gf7TQNw03sC7Ka8clh8SCTSKLck1bp
         5L0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TuIWEKHfoc1+Oar3jiYPK/6gE0dULFhfw6x7KSeby7M=;
        b=JMaL+0XMufgV31u3INYFIWGNSx/Kyb+nlpYegLb0FbhLDQYk/r5ERv5UGq+d8WPgwk
         ojIFoj4y5DGRWrs/v9MNXVsl6aJGdHP7muLuXHoEFvQn22SgNvqdrxYOQyBVH9UeoqfQ
         NDyO8LTZRO988b/EwwKN5fERT3WtDY/BzqutRzGumC4THs5dm9AQ0EtNOW5l7PRalIJA
         4LgAOOdFxfbKDy7FcsGlaA2A++VC/hMVxMVwFGZ8z2ST5RiABRjMf9uCIjcScY8ZG5IE
         gcHN8IH1vRcgl7FLX15aKWC9M6tg3ayjFuyXNXRNyBTsJRiadnGyuJu5gAktWYwnc2CF
         B+1g==
X-Gm-Message-State: AOAM5325OrX7QZyawCd87Zyxprk/kI43k/tIaTVpzXVAa+ZvHskp4vjH
        aRBdcfnApvV9aAg+Ctho0uHWMFD+R/Q=
X-Google-Smtp-Source: ABdhPJx5qhVnEGEEPCngW/VXN0kg4ISOHnIhlJ0rW8GF+wT45bUM8cKAyXfGl89s+spifyKa8BKA7Q==
X-Received: by 2002:a17:902:82c3:b029:d6:c377:c87d with SMTP id u3-20020a17090282c3b02900d6c377c87dmr22639481plz.37.1605130583538;
        Wed, 11 Nov 2020 13:36:23 -0800 (PST)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:b2ab:a08f:30f:70b8])
        by smtp.gmail.com with ESMTPSA id b29sm3747792pff.194.2020.11.11.13.36.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 13:36:22 -0800 (PST)
From:   Xie He <xie.he.0141@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin Schiller <ms@dev.tdt.de>
Cc:     Xie He <xie.he.0141@gmail.com>,
        Andrew Hendry <andrew.hendry@gmail.com>
Subject: [PATCH net-next RFC] MAINTAINERS: Add Martin Schiller as a maintainer for the X.25 stack
Date:   Wed, 11 Nov 2020 13:36:08 -0800
Message-Id: <20201111213608.27846-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Martin Schiller, would you like to be a maintainer for the X.25 stack?

As we know the linux-x25 mail list has stopped working for a long time.
Adding you as a maintainer may make you be Cc'd for new patches so that
you can review them.

The original maintainer of X.25 network layer (Andrew Hendry) has stopped
sending emails to the netdev mail list since 2013. So there is practically
no maintainer for X.25 code currently.

Cc: Martin Schiller <ms@dev.tdt.de>
Cc: Andrew Hendry <andrew.hendry@gmail.com>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 MAINTAINERS | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2a0fde12b650..9ebcb0708d5d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9832,13 +9832,6 @@ S:	Maintained
 F:	arch/mips/lantiq
 F:	drivers/soc/lantiq
 
-LAPB module
-L:	linux-x25@vger.kernel.org
-S:	Orphan
-F:	Documentation/networking/lapb-module.rst
-F:	include/*/lapb.h
-F:	net/lapb/
-
 LASI 53c700 driver for PARISC
 M:	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
 L:	linux-scsi@vger.kernel.org
@@ -18979,12 +18972,19 @@ L:	linux-kernel@vger.kernel.org
 S:	Maintained
 N:	axp[128]
 
-X.25 NETWORK LAYER
-M:	Andrew Hendry <andrew.hendry@gmail.com>
+X.25 STACK
+M:	Martin Schiller <ms@dev.tdt.de>
 L:	linux-x25@vger.kernel.org
-S:	Odd Fixes
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	Documentation/networking/lapb-module.txt
 F:	Documentation/networking/x25*
+F:	drivers/net/wan/hdlc_x25.c
+F:	drivers/net/wan/lapbether.c
+F:	include/*/lapb.h
 F:	include/net/x25*
+F:	include/uapi/linux/x25.h
+F:	net/lapb/
 F:	net/x25/
 
 X86 ARCHITECTURE (32-BIT AND 64-BIT)
-- 
2.27.0

