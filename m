Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBAA6D8845
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 22:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbjDEU1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 16:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233498AbjDEU1W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 16:27:22 -0400
Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8744B4C31;
        Wed,  5 Apr 2023 13:27:21 -0700 (PDT)
Received: by mail-oo1-f53.google.com with SMTP id l7-20020a4abe07000000b0053e1205c84bso5501160oop.9;
        Wed, 05 Apr 2023 13:27:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680726441;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZTd63roJHw5mw81KozXO6U7HxEiOyCu7wEaX62Cvsk0=;
        b=zIyp0XMrX9lNjeNnkgfp0G+yO5uzO3q02Ofy4TlkNgRiibFv/c/J8PE+xXWngi/M9/
         FECqI4o+Rd+iApzYHhW/EHgqIikDE4dcsa1NVCW9QovhTgz78w3nQ4PnSLqECo/BhP4C
         6z9oaVyRYoTB8H5Mlp7HiSFJcefCWt6sO3YMvOOMog3622MWI07zoL4K7hGbyp8hfSWw
         Sem9noMLSp864G8qzxh93FPHJ5yzNb5XYl37gj/igx033iNPB8GGulSXUbumEJlFeA+g
         m4Hy/LameokPRCKw3OkNn9KhuUBuccm4JXjwmINRb9DHambifLOUDfRIy//b496NixmT
         p6sQ==
X-Gm-Message-State: AAQBX9cWqMIEGC2KbuXc3domQ5c9H20ayW6xqOiqfoeRuj9NHaGW69YU
        1HX/R7awocLwcFJUDyoTnA==
X-Google-Smtp-Source: AKy350bDkD0JNoIZyIKw2Up57YVo9+K3U0A02eldxdq99WmvxpM4xVMH9LB8cYU9pwfCYpADQ4amIA==
X-Received: by 2002:a4a:2cd4:0:b0:536:584c:eb1f with SMTP id o203-20020a4a2cd4000000b00536584ceb1fmr3187633ooo.2.1680726440668;
        Wed, 05 Apr 2023 13:27:20 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id f1-20020a4ab001000000b0051aa196ac82sm7103369oon.14.2023.04.05.13.27.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 13:27:20 -0700 (PDT)
Received: (nullmailer pid 425890 invoked by uid 1000);
        Wed, 05 Apr 2023 20:27:17 -0000
From:   Rob Herring <robh@kernel.org>
Date:   Wed, 05 Apr 2023 15:27:20 -0500
Subject: [PATCH v2 06/10] pata: ixp4xx: Add explicit include for of.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230329-acpi-header-cleanup-v2-6-c902e581923b@kernel.org>
References: <20230329-acpi-header-cleanup-v2-0-c902e581923b@kernel.org>
In-Reply-To: <20230329-acpi-header-cleanup-v2-0-c902e581923b@kernel.org>
To:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Marcelo Schmitt <marcelo.schmitt1@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Marc Zyngier <maz@kernel.org>
Cc:     linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Jacob Keller <jacob.e.keller@intel.com>
X-Mailer: b4 0.13-dev
X-Spam-Status: No, score=0.8 required=5.0 tests=FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With linux/acpi.h no longer implicitly including of.h, add an explicit
include of of.h to fix the following error:

drivers/ata/pata_ixp4xx_cf.c:258:15: error: implicit declaration of function 'of_property_read_u32_index'; did you mean 'fwnode_property_read_u32_array'? [-Werror=implicit-function-declaration]

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Rob Herring <robh@kernel.org>
---
v2: New patch
---
 drivers/ata/pata_ixp4xx_cf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ata/pata_ixp4xx_cf.c b/drivers/ata/pata_ixp4xx_cf.c
index e225913a619d..113087665832 100644
--- a/drivers/ata/pata_ixp4xx_cf.c
+++ b/drivers/ata/pata_ixp4xx_cf.c
@@ -17,6 +17,7 @@
 #include <linux/module.h>
 #include <linux/libata.h>
 #include <linux/irq.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
 #include <scsi/scsi_host.h>

-- 
2.39.2

