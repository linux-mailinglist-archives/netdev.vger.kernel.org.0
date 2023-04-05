Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 304006D8886
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 22:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234702AbjDEU27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 16:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234484AbjDEU14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 16:27:56 -0400
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 113177D86;
        Wed,  5 Apr 2023 13:27:35 -0700 (PDT)
Received: by mail-oi1-f178.google.com with SMTP id w13so16192369oik.2;
        Wed, 05 Apr 2023 13:27:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680726454;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M3RPX6uXfMIMJJoqXF0tDH6hb5w2/i4ololX+IM3luY=;
        b=eRvPGSDPk0eYcbCBoUZioqpkzlgwsr9Gd9JlALmAh7TsefW2MY4+6RERgH5Ws3hBfm
         xkIRDHB75IQvmeX4AnYf8Fo5nOvRGyAieYph0NNMVCnoI2Sd/UPS4TC1AFssr6V+NDei
         cGZRdtHSUlar65kQWvPyTGmz8Ooia2zZ3uHEbi8yg1k/v6uWvDAbVxcv/yi9zjCM/On+
         y+ZJ830tDbrnPbFN2c/BoTEW2IgA18NOUvFXXtzVF8AqMETDMRR+x69S/nFXH+YENVPo
         DHA3x3OGzvG91rr6nqyH99OaACBYUl+gzGytuLG27EigBW4bc6BjnbQVVsCKlJ1OfON5
         0iYQ==
X-Gm-Message-State: AAQBX9fA3UAvWtYnYG4XJJlNIzOa2mA7Pp43kzHKJpnNJ4smSNaPnjoO
        HWQjDfyueCwLs2imZtAacw==
X-Google-Smtp-Source: AKy350bI8AMWkdrGldN0+D8908pDqGR1ET11ahdL00A7ibOfslvb7UH0SkDNaAc8yDfybKU8oRjiXg==
X-Received: by 2002:aca:bf05:0:b0:389:7fcc:75f0 with SMTP id p5-20020acabf05000000b003897fcc75f0mr1690469oif.25.1680726454290;
        Wed, 05 Apr 2023 13:27:34 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id u1-20020a4a9e81000000b0053b909a5229sm7112025ook.4.2023.04.05.13.27.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 13:27:33 -0700 (PDT)
Received: (nullmailer pid 425882 invoked by uid 1000);
        Wed, 05 Apr 2023 20:27:17 -0000
From:   Rob Herring <robh@kernel.org>
Date:   Wed, 05 Apr 2023 15:27:16 -0500
Subject: [PATCH v2 02/10] staging: iio: resolver: ad2s1210: Add explicit
 include for of.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230329-acpi-header-cleanup-v2-2-c902e581923b@kernel.org>
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
        Jacob Keller <jacob.e.keller@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
X-Mailer: b4 0.13-dev
X-Spam-Status: No, score=0.8 required=5.0 tests=FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With linux/acpi.h no longer implicitly including of.h, add an explicit
include of of.h to fix the following error:

drivers/staging/iio/resolver/ad2s1210.c:706:21: error: implicit declaration of function 'of_match_ptr' is invalid in C99 [-Werror,-Wimplicit-function-declaration]

Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Rob Herring <robh@kernel.org>
---
 drivers/staging/iio/resolver/ad2s1210.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/iio/resolver/ad2s1210.c b/drivers/staging/iio/resolver/ad2s1210.c
index e4cf42438487..eb364639fa58 100644
--- a/drivers/staging/iio/resolver/ad2s1210.c
+++ b/drivers/staging/iio/resolver/ad2s1210.c
@@ -7,6 +7,7 @@
 #include <linux/types.h>
 #include <linux/mutex.h>
 #include <linux/device.h>
+#include <linux/of.h>
 #include <linux/spi/spi.h>
 #include <linux/slab.h>
 #include <linux/sysfs.h>

-- 
2.39.2

