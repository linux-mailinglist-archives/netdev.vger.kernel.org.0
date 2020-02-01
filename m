Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB0314F7D1
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 13:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgBAMoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 07:44:05 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35457 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726469AbgBAMoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Feb 2020 07:44:05 -0500
Received: by mail-wr1-f66.google.com with SMTP id w12so960016wrt.2;
        Sat, 01 Feb 2020 04:44:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=KPa4daZ7BK/PhoZPQYjuPJ3LO3kRFWJEkZ0HGJmd2Ig=;
        b=hxszsal9DEfTE+OeaXLUu5ymD0Nw+eJVWyzfUGzFq6YhsPNz9vEEzCt3Zm9wBVoVYX
         sdbEADhbdKEvXcLnMdP46uDXPkYG/e8nUyc2XaPvGg8jiV/+PgsDx5rC7tBUkGdaOlEK
         DSmBKPf7OlnSLUt6bGPX/h9gqCoFzISLsqEDIuRjxrGyQYjpY73gq/YxLQoaacFQVBDb
         2pc2HGtk4gw1oh9NQZhAF2yufHDVu5ln+rSuzjAKVEipzb0iaAPE7qWqTn1nxCTW7drS
         gg6oz/+X9eUWmzuBAjlCaP6uFUYaa84f0BeK/N9cjTMURFiaY0czGDmRRKchzw7M1FBb
         T2hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KPa4daZ7BK/PhoZPQYjuPJ3LO3kRFWJEkZ0HGJmd2Ig=;
        b=rwL6LJ52sA/POz2SRMgbp9WQ0nzbuOPfT++qv/Un97v9Y9Fc5EVkaZ19XV569FC1V7
         Vn7vuMbzxb9Z0eYPF8ArF64VdirujCVqwPbqT2pGgbGuBCsQJTvgmKRkaJ0jaPzDRcgo
         8zSLPP5SfHnf9EnVZxo/1sbML/jK+/z/GnAj+3PJlKme2eQlgtCQbnjeVkkXGawSTKsk
         XDPsxqOsKyQpG3kuC3AVVHD7lATHaOW41+ohhpit0NZw2XjGWIOTbAmAYhG1K1QNRChk
         iRXl5fozAakjchdqCZecjVD3tuRxzy59ls92TKPP7hrbKkZWGDjBfb4KrdFxjZhgI+Tw
         6MMg==
X-Gm-Message-State: APjAAAXBt6PUK2DOzRQ/SBVJpaMl8LUN2w9lGGDWfAszyZj0irS1K+nO
        MOANQzqX4JyLH0XdJMx4UVXt1MTr
X-Google-Smtp-Source: APXvYqyHhsFxF+E4LbybT8yBArlt0x9wBEaFtdexXHjkCYu0bSLcVtIaC35uGSf/KDpbgC2mhQLu+w==
X-Received: by 2002:a5d:474d:: with SMTP id o13mr4364573wrs.309.1580561042997;
        Sat, 01 Feb 2020 04:44:02 -0800 (PST)
Received: from felia.fritz.box ([2001:16b8:2d5f:200:619d:5ce8:4d82:51eb])
        by smtp.gmail.com with ESMTPSA id b13sm1724451wrq.48.2020.02.01.04.44.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Feb 2020 04:44:02 -0800 (PST)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Karsten Keil <isdn@linux-pingi.de>, Arnd Bergmann <arnd@arndb.de>
Cc:     isdn4linux@listserv.isdn4linux.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] MAINTAINERS: correct entries for ISDN/mISDN section
Date:   Sat,  1 Feb 2020 13:43:01 +0100
Message-Id: <20200201124301.21148-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 6d97985072dc ("isdn: move capi drivers to staging") cleaned up the
isdn drivers and split the MAINTAINERS section for ISDN, but missed to add
the terminal slash for the two directories mISDN and hardware. Hence, all
files in those directories were not part of the new ISDN/mISDN SUBSYSTEM,
but were considered to be part of "THE REST".

Rectify the situation, and while at it, also complete the section with two
further build files that belong to that subsystem.

This was identified with a small script that finds all files belonging to
"THE REST" according to the current MAINTAINERS file, and I investigated
upon its output.

Fixes: 6d97985072dc ("isdn: move capi drivers to staging")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
Arnd, please ack or even pick it.
It is no functional change, so I guess you could simply pick in your own
tree for minor fixes.

 MAINTAINERS | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1f77fb8cdde3..b6a0c4fa8cfd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8908,8 +8908,10 @@ L:	isdn4linux@listserv.isdn4linux.de (subscribers-only)
 L:	netdev@vger.kernel.org
 W:	http://www.isdn4linux.de
 S:	Maintained
-F:	drivers/isdn/mISDN
-F:	drivers/isdn/hardware
+F:	drivers/isdn/mISDN/
+F:	drivers/isdn/hardware/
+F:	drivers/isdn/Kconfig
+F:	drivers/isdn/Makefile
 
 ISDN/CMTP OVER BLUETOOTH
 M:	Karsten Keil <isdn@linux-pingi.de>
-- 
2.17.1

