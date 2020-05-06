Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE111C7B42
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 22:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728392AbgEFU3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 16:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727792AbgEFU3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 16:29:20 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 448B4C061A0F;
        Wed,  6 May 2020 13:29:20 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id i15so3308528wrx.10;
        Wed, 06 May 2020 13:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=YY2elGBAStJd1cDwzd/T4Q8r37Cpy+f5uoWKTJObO0I=;
        b=UsoIvg5zIyPu1caKoHOWZEqT0A6sfJNLUyL6np7oKUOixM8OefjmkOoGk9XFMADp7f
         txlh7clckd657zEbTf+sftvIbUj9uv+C+sXIq2gPgj90XiSWORaqWvOQwSGG3jG8T7hh
         UVN27RTjTPw3ij8hNRLtpmfwd4U556w6VhxPAsKdjBC4Ux2umVhkVHumbUN0u3IhWx3z
         9hqAx3B49nUXjfkmnkR6nGZu/jj23FlcSyW8pqpfxk1NZ5fjz2I79p8QGXnGhEJ1UygN
         JaxqnsS+1h0asDA8G0Z0SyuGqvsrSFo3en2WJgAynsZMB6VmHek5Mde2l30l45+eEHFI
         c7sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=YY2elGBAStJd1cDwzd/T4Q8r37Cpy+f5uoWKTJObO0I=;
        b=fWAaKvBfj7EQkOuxsuwl4kqTn/fkN2ntw1uEgbJxJ/+0gxp7x272+yme3ehuWjVhlD
         FwbRGDiePub0+aJDULfXzltY5yZoZlU4GdP73FvR9NVRqmDTf9AD9N5lUZM2cAkMVMMQ
         4iw2Rdz5NuVQbEVOehbDbWpcITS+iPCtbrHgoGlAnL7uIqJefzI/hx0rL+TmBTDOxjjq
         Qvlu3J3yUl/veFl3C9Lq4i0AprlELuHBiXZc66ocoPGeEcFEbpWcVvECDT1SyMDWFgPJ
         U3VM8/XwrPGCHMlfHO8lA/UEuY9+tDvquYg9lth62ZXnS44n+tgG4hAOiTsZ9w9Uc20H
         yXhQ==
X-Gm-Message-State: AGi0Pua1e0/a2Jbt2VStPehfs/8ef873GnSZ3BeSXESaYuTcJFDdrHJM
        l1fpqHyT+PldCk/ZqLUfDaA=
X-Google-Smtp-Source: APiQypKAIwVRtIRTEGUw6cgpjFr3jvuaFYUNjgxVqZqZCV23smVyUDku3093jGNSleC7trbTSQAHAA==
X-Received: by 2002:adf:f004:: with SMTP id j4mr11248973wro.123.1588796958987;
        Wed, 06 May 2020 13:29:18 -0700 (PDT)
Received: from felia.fritz.box ([2001:16b8:2df1:2500:444f:2681:799e:cf0b])
        by smtp.gmail.com with ESMTPSA id f7sm4165550wrt.10.2020.05.06.13.29.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 13:29:18 -0700 (PDT)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Joe Perches <joe@perches.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] MAINTAINERS: put DYNAMIC INTERRUPT MODERATION in proper order
Date:   Wed,  6 May 2020 22:29:06 +0200
Message-Id: <20200506202906.23297-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 9b038086f06b ("docs: networking: convert DIM to RST") added a new
file entry to DYNAMIC INTERRUPT MODERATION to the end, and not following
alphabetical order.

So, ./scripts/checkpatch.pl -f MAINTAINERS complains:

  WARNING: Misordered MAINTAINERS entry - list file patterns in alphabetic
  order
  #5966: FILE: MAINTAINERS:5966:
  +F:      lib/dim/
  +F:      Documentation/networking/net_dim.rst

Reorder the file entries to keep MAINTAINERS nicely ordered.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
Jakub, please pick this minor non-urgent patch.

applies cleanly on next-20200505

 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b103ff039077..92dced585e54 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5957,9 +5957,9 @@ F:	lib/dynamic_debug.c
 DYNAMIC INTERRUPT MODERATION
 M:	Tal Gilboa <talgi@mellanox.com>
 S:	Maintained
+F:	Documentation/networking/net_dim.rst
 F:	include/linux/dim.h
 F:	lib/dim/
-F:	Documentation/networking/net_dim.rst
 
 DZ DECSTATION DZ11 SERIAL DRIVER
 M:	"Maciej W. Rozycki" <macro@linux-mips.org>
-- 
2.17.1

