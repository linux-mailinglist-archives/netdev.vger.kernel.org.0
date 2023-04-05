Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7781D6D887D
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 22:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234679AbjDEU2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 16:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233419AbjDEU1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 16:27:55 -0400
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F0FA7DAD;
        Wed,  5 Apr 2023 13:27:33 -0700 (PDT)
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-17997ccf711so39964032fac.0;
        Wed, 05 Apr 2023 13:27:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680726452;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6TsRE4TQ/f8Cdh7WoRAUoCQ/ygs9RmxZbH2hBLQ+0B0=;
        b=IQE5xp2kvQOjiP7FAHC7Tj9VaUqF1SmKgt17RCjAMh9+Tm0JRZttIg1MQ+DWFKLMMz
         8eqNtUsC8OXnZHbvRcBULv4ivxLdQIGVd/dvD+HapSKOCu0ygG3fYs3atcSUqafWvwWG
         P+NsXeSJZmN2xSlRd/At5JhRU2hJLKuecewUq9k2YG7V7dsLMB8Vst7RZ2sFBzysxxcl
         dOsViVDINsayhP+/PGgow64vHaGVV4yYnFYROLKi8XGBR/L4S3NjBYcqrujCfKUUKmij
         S3RMRwi1ElMALgo0y9tqjwYRJHEkFa/fEpu82UfJw56dJYre7L7P4PNtnWtY5bEt8lcx
         eoMA==
X-Gm-Message-State: AAQBX9engr+t3DjVPop6nFWWQeISv2i5yqqVyrd1KZpKpxLoI/DH08ST
        fzoODIVKKeWnq/GFSkn5Pw==
X-Google-Smtp-Source: AKy350YpAV4Ot9iJZkIzmYiWr5uOjLPTxFWn3uKDFPsohB5jBkFe6vSXLe2T2ZW1wyGq+/LUiLg3xw==
X-Received: by 2002:a05:6870:d389:b0:17a:c2be:33c with SMTP id k9-20020a056870d38900b0017ac2be033cmr4333581oag.4.1680726452615;
        Wed, 05 Apr 2023 13:27:32 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id yx16-20020a056871251000b001762d1bf6a9sm6184930oab.45.2023.04.05.13.27.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 13:27:32 -0700 (PDT)
Received: (nullmailer pid 425896 invoked by uid 1000);
        Wed, 05 Apr 2023 20:27:17 -0000
From:   Rob Herring <robh@kernel.org>
Date:   Wed, 05 Apr 2023 15:27:23 -0500
Subject: [PATCH v2 09/10] fpga: lattice-sysconfig-spi: Add explicit include
 for of.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230329-acpi-header-cleanup-v2-9-c902e581923b@kernel.org>
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
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With linux/acpi.h (in spi/spi.h) no longer implicitly including of.h,
add an explicit include of of.h to fix the following errors:

drivers/fpga/lattice-sysconfig-spi.c:146:35: error: implicit declaration of function 'of_match_ptr' [-Werror=implicit-function-declaration]

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Rob Herring <robh@kernel.org>
---
v2: New patch
---
 drivers/fpga/lattice-sysconfig-spi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/fpga/lattice-sysconfig-spi.c b/drivers/fpga/lattice-sysconfig-spi.c
index 2702b26b7f55..44691cfcf50a 100644
--- a/drivers/fpga/lattice-sysconfig-spi.c
+++ b/drivers/fpga/lattice-sysconfig-spi.c
@@ -3,6 +3,7 @@
  * Lattice FPGA programming over slave SPI sysCONFIG interface.
  */
 
+#include <linux/of.h>
 #include <linux/spi/spi.h>
 
 #include "lattice-sysconfig.h"

-- 
2.39.2

