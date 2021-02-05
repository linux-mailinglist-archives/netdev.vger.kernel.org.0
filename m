Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58C4731088E
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 10:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbhBEJ6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 04:58:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbhBEJz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 04:55:57 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FBFFC06178C;
        Fri,  5 Feb 2021 01:55:16 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id 7so7020648wrz.0;
        Fri, 05 Feb 2021 01:55:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=MT0BlZZFXQ7Pukf17++wQpN4EZiEO2XNbV+qknkfsyA=;
        b=YN/bcnZoNO4KfXVM+0sV8qqwBK2gJ64YbALf1RXWAcy8Uqxl1TNzBBX9oB56NN1h+B
         bK0TJMqQT8L/+E4PVEhOvlZz3zDdUOohqMQGFcprGGpRPHTRvzJOOD86nPiyi/y7Y7/r
         qDqFbPAYlARf0pcr+Mw2IORvdqwd8XFb8I0p+YwjvLzEI0UzC5WEW67HvWcQD3MxBev6
         Riya5RK2gOpV+GiajE+stCFXjiQ0gi6aN3gmcu6QCn10xUH+jld/WyCqwLawdqjSFu2m
         CZUl3oQvJKV0o2/OGIARU9+k+/79YSUnsQa+ENMBDWdTfP2PNvZl60H1JGkQ8AycLLNx
         TAvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=MT0BlZZFXQ7Pukf17++wQpN4EZiEO2XNbV+qknkfsyA=;
        b=dZhugUt5/OYvjYRJQ6K8gM4MQC+pMBAlWKaXKgx1JudlSCTGIBegjXaU71SuAdkr5J
         DxyONMlOy0eZZwCn1541QccZCzz4N7I3NETsSwnXssHo+BRUm3n7MKVFoYsM45FberDF
         rcmSz1FSKjX4fHQOeHIGVbQKXkV4/y+hYSuoTwKAQuH4df0qJ2psjavIHRrTg/adxDEE
         caN5BXZkPtmphW1VQ8nkqbboxM5rCrYMMItnDXLDBbn6DJzsRBkNyzB2PICcbn6o01ad
         8Ka/WLvpIoBdkoLPhR71AUgGKb/Dzbrk1kb7d/POyc+Eo8GG3waEnHdGqlsi+A8Y18f0
         oQow==
X-Gm-Message-State: AOAM531DrprtiLiABqoX1gCYeuFiWntYECtJqWpl57MSU+ReO85egIcx
        Kutdt5CeuyJAEw8tQruXqY4=
X-Google-Smtp-Source: ABdhPJx1/Me3l7tCNW11yyIC3uDqu69f7nvNS8wM0zQOOmPh5Fu5W6GNCNrDtAO8PGTekqBHbSuz0Q==
X-Received: by 2002:adf:efc8:: with SMTP id i8mr4101524wrp.84.1612518914805;
        Fri, 05 Feb 2021 01:55:14 -0800 (PST)
Received: from felia.fritz.box ([2001:16b8:2ded:6500:7c12:49b0:591a:b2bd])
        by smtp.gmail.com with ESMTPSA id u142sm8690977wmu.3.2021.02.05.01.55.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 01:55:14 -0800 (PST)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Cc:     Leon Romanovsky <leon@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-doc@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] net/mlx5: docs: correct section reference in table of contents
Date:   Fri,  5 Feb 2021 10:55:06 +0100
Message-Id: <20210205095506.29146-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 142d93d12dc1 ("net/mlx5: Add devlink subfunction port
documentation") refers to a section 'mlx5 port function' in the table of
contents, but includes a section 'mlx5 function attributes' instead.

Hence, make htmldocs warns:

  mlx5.rst:16: WARNING: Unknown target name: "mlx5 port function".

Correct the section reference in table of contents to the actual name of
section in the documentation.

Also, tune another section underline while visiting this document.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
Saeed, please pick this patch for your -next tree on top of the commit above.

 .../networking/device_drivers/ethernet/mellanox/mlx5.rst      | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
index a1b32fcd0d76..1b7e32d8a61b 100644
--- a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
+++ b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
@@ -13,12 +13,12 @@ Contents
 - `Devlink info`_
 - `Devlink parameters`_
 - `mlx5 subfunction`_
-- `mlx5 port function`_
+- `mlx5 function attributes`_
 - `Devlink health reporters`_
 - `mlx5 tracepoints`_
 
 Enabling the driver and kconfig options
-================================================
+=======================================
 
 | mlx5 core is modular and most of the major mlx5 core driver features can be selected (compiled in/out)
 | at build time via kernel Kconfig flags.
-- 
2.17.1

