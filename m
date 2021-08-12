Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67BA83EA0A9
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 10:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235313AbhHLIix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 04:38:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235247AbhHLIit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 04:38:49 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBDA2C0613D5;
        Thu, 12 Aug 2021 01:38:23 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id h13so7141070wrp.1;
        Thu, 12 Aug 2021 01:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zG8CdNNvqHHVEI+imY7GJhpyF+5b/m1TaPLnVkRpMPY=;
        b=qbLEoN3MSHi8qfD22ELdZb4rTK6zzCXx8cdPw71/EQl3l5hpR4rQ91CUK3YO9nJ/uk
         CE3esjlMICSTQNlzZfhDYMb/k0PgWI37rIxt9H7m9IW/0I1SQKRpNya9D6emH83q9Bcl
         T8irvdGvFzWVoXP4pA+U8r8dIMcaG4xjFufbZqJUSvx+BYhXobU1hCshHIm5EkuvQT3c
         mIVpQkNH5SK5HNzQqbOgyiKh+VIC0n1Sjs9YBhkwzCCTTXmnXaCWpN30uq4PiihDLAS/
         GMMx09ckNMBUQx8o3/AdakPIQWiqbC2CblbTihQTr9M46dI2egGUt2Xa/aXUXCgZBZbY
         rkgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zG8CdNNvqHHVEI+imY7GJhpyF+5b/m1TaPLnVkRpMPY=;
        b=SicbB0KKXWPeLXCgP1HaMl07aFXiqRdfn/J/LAQSgwEC2IEs/gDAedW9odIZRtsQck
         g76G17ASK7zATVnGzQCZYZpLOYi8xEVDGd35o6fVOCLOkhKU1T7TAzXvCyNWmV+4I5My
         yAx2qlP48DKK6fhWgtDVnLqXLVDXK3FaRwQ+Qoogyb/oMYTaGvTgF64qF2/xmj8iKFeU
         Q78pCzXCGscGzAmH9lBQ7uXZBRDK5kINPRhS855Nno2q0OJ63vTHv7QxCKYVf/lR0SyN
         YJQRMyOnhOFJ3VfjRwaynjuf9/bHT7d8D6ueJQvBS7lAvnxsRY0qey136MayQ21mV9ER
         Sb1g==
X-Gm-Message-State: AOAM533ryj0lIyIY1012C0AYLP74hWiAaD+ZsDhxD4rTk9r4VRSawPO1
        bJF67Ml9LsxdzhNs1XJr0Ls=
X-Google-Smtp-Source: ABdhPJzYq2upS6IKKGECmqHjZlXKawReQsLlpqMrQ8Prfrat+xhWGZ9N/lpHvAwlZyqGGDiUlAns1A==
X-Received: by 2002:a5d:58da:: with SMTP id o26mr2778639wrf.140.1628757502050;
        Thu, 12 Aug 2021 01:38:22 -0700 (PDT)
Received: from felia.fritz.box ([2001:16b8:2d76:9600:40d6:1b8e:9bb5:afdf])
        by smtp.gmail.com with ESMTPSA id 9sm1830324wmf.34.2021.08.12.01.38.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 01:38:21 -0700 (PDT)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Madalin Bucur <madalin.bucur@nxp.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH 1/3] net: Kconfig: remove obsolete reference to config MICROBLAZE_64K_PAGES
Date:   Thu, 12 Aug 2021 10:38:04 +0200
Message-Id: <20210812083806.28434-2-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210812083806.28434-1-lukas.bulwahn@gmail.com>
References: <20210812083806.28434-1-lukas.bulwahn@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 05cdf457477d ("microblaze: Remove noMMU code") removes config
MICROBLAZE_64K_PAGES in arch/microblaze/Kconfig. However, there is still
a reference to MICROBLAZE_64K_PAGES in the config VMXNET3 in
./drivers/net/Kconfig.

Remove this obsolete reference to config MICROBLAZE_64K_PAGES.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
 drivers/net/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 995c613086aa..f37b1c56f7c4 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -551,8 +551,8 @@ config VMXNET3
 	tristate "VMware VMXNET3 ethernet driver"
 	depends on PCI && INET
 	depends on !(PAGE_SIZE_64KB || ARM64_64K_PAGES || \
-		     IA64_PAGE_SIZE_64KB || MICROBLAZE_64K_PAGES || \
-		     PARISC_PAGE_SIZE_64KB || PPC_64K_PAGES)
+		     IA64_PAGE_SIZE_64KB || PARISC_PAGE_SIZE_64KB || \
+		     PPC_64K_PAGES)
 	help
 	  This driver supports VMware's vmxnet3 virtual ethernet NIC.
 	  To compile this driver as a module, choose M here: the
-- 
2.17.1

