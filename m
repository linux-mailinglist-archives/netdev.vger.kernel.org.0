Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C80E6CF550
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 23:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbjC2VWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 17:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbjC2VVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 17:21:47 -0400
Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4F13591;
        Wed, 29 Mar 2023 14:21:45 -0700 (PDT)
Received: by mail-oo1-f44.google.com with SMTP id o15-20020a4ae58f000000b00538c0ec9567so2677230oov.1;
        Wed, 29 Mar 2023 14:21:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680124904;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=37Xl94wcW5o8GgPxt4yvsEyDEY9V4plxLsoIYPVLn9U=;
        b=QF/udCgzylliagzBU+2PetUErv9u5VXOcuD4b5l/jdjOspM297JNnjeS6SYXLXzTnA
         2KSwbuykjJ1pPfkBLgIEZ0LxyxJY6AzyK6Azh9FHtWFhXfueXc56EEpk5QFbsQwGbeTz
         6JL6scLqPZ0PKWLeWaQL9C7UeTlZh/SYVmSS4QlW2PZunmTXg703SvrSc+EO3y6HFHQ2
         FOFs/rtkdd87tgizBguempBmbCOYBhcGtIgZV0mVPxm9loBUmjZp/ZZYzU68mV8gCVa2
         2uI7gf2Xv8nGxLVJ540pUsr9j1ymm31nuksb8+O3TZlp9FBaQYnZ60ySyUB1/lkJ4YNy
         mpMQ==
X-Gm-Message-State: AO0yUKXM88vjum8EtFj/jmyBQwOgIw9aC7tKL5x6UIjTT4jWOeyZRtpJ
        afvyPDxTQH+yHA7+HVxYHA==
X-Google-Smtp-Source: AK7set++w7Qvp7fi2DIzI+DP77MwWEUdgIW4IIMfm5HQ31TJqVwIb2TPyVmM9Cf/Vqup9kOVESVp/Q==
X-Received: by 2002:a4a:2ccf:0:b0:52b:bab5:eba2 with SMTP id o198-20020a4a2ccf000000b0052bbab5eba2mr9319519ooo.0.1680124904322;
        Wed, 29 Mar 2023 14:21:44 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id c3-20020aca1c03000000b0038901ece6e9sm4982583oic.12.2023.03.29.14.21.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 14:21:44 -0700 (PDT)
Received: (nullmailer pid 86891 invoked by uid 1000);
        Wed, 29 Mar 2023 21:21:39 -0000
From:   Rob Herring <robh@kernel.org>
Date:   Wed, 29 Mar 2023 16:20:42 -0500
Subject: [PATCH 1/5] iio: adc: ad7292: Add explicit include for of.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230329-acpi-header-cleanup-v1-1-8dc5cd3c610e@kernel.org>
References: <20230329-acpi-header-cleanup-v1-0-8dc5cd3c610e@kernel.org>
In-Reply-To: <20230329-acpi-header-cleanup-v1-0-8dc5cd3c610e@kernel.org>
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
        devicetree@vger.kernel.org
X-Mailer: b4 0.13-dev
X-Spam-Status: No, score=0.7 required=5.0 tests=FREEMAIL_ENVFROM_END_DIGIT,
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

drivers/iio/adc/ad7292.c:307:9: error: implicit declaration of function 'for_each_available_child_of_node'; did you mean 'fwnode_for_each_available_child_node'? [-Werror=implicit-function-declaration]

Signed-off-by: Rob Herring <robh@kernel.org>
---
 drivers/iio/adc/ad7292.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/adc/ad7292.c b/drivers/iio/adc/ad7292.c
index a2f9fda25ff3..cccacec5db6d 100644
--- a/drivers/iio/adc/ad7292.c
+++ b/drivers/iio/adc/ad7292.c
@@ -8,6 +8,7 @@
 #include <linux/bitfield.h>
 #include <linux/device.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/regulator/consumer.h>
 #include <linux/spi/spi.h>
 

-- 
2.39.2

