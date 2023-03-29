Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 107586CF54C
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 23:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbjC2VWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 17:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbjC2VVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 17:21:49 -0400
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20C1F1FD2;
        Wed, 29 Mar 2023 14:21:48 -0700 (PDT)
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-177b78067ffso17698197fac.7;
        Wed, 29 Mar 2023 14:21:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680124907;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IXNpMlIrMI4hrwmIfNojDL6fBE+dcZw7V7KtUFtbAVU=;
        b=BFNAsqzoRwvPwl70atBgXzz4mok4p6VIQcQzSvuWqsLddlFOTM1QwwJ1lf974CkM1y
         g8C/IrS/FQ7UlprkUFEYv7qZgl6bM4K+aYvef7DNKjGYRPXXNu5365SnwU3e/WuGd37I
         MyELQ17LOh9MQhivgXz0ofIjq+BmlvRLbd/EuyLB2yDHDlQ7R3dFLYmGUpDE46i9jllg
         ZpEtYbYrBUWhXq+xtqUOhTutZf31PvfoWY63RF7bjj4WsmJGAHctz8jnBhJ6gE8784di
         hzTYfF+77Ivc2mN50sq1HeibanvXpq5X9UrKFQhvE+8Muh9XMPWeM+8O1Hb10b2kpMmV
         +9eQ==
X-Gm-Message-State: AO0yUKVvTa2K1nTxbplLGzPMOVA95WXDpXDOAmcLQWHxhTMjg/98zJip
        OV5knpFA8mZCcyY3wXRxRw==
X-Google-Smtp-Source: AKy350aTCWxV4oo/omjSqtMSrN/g7rN22T8lJIZrRhsZAbjj9smwXQX9C4/AOBFxX+S5/Qg9cm2ANg==
X-Received: by 2002:a05:6870:1693:b0:172:7fc0:9188 with SMTP id j19-20020a056870169300b001727fc09188mr11799906oae.35.1680124907393;
        Wed, 29 Mar 2023 14:21:47 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id k29-20020a05687022dd00b0017e7052ed84sm8402484oaf.41.2023.03.29.14.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 14:21:46 -0700 (PDT)
Received: (nullmailer pid 86893 invoked by uid 1000);
        Wed, 29 Mar 2023 21:21:39 -0000
From:   Rob Herring <robh@kernel.org>
Date:   Wed, 29 Mar 2023 16:20:43 -0500
Subject: [PATCH 2/5] staging: iio: resolver: ad2s1210: Add explicit include
 for of.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230329-acpi-header-cleanup-v1-2-8dc5cd3c610e@kernel.org>
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

drivers/staging/iio/resolver/ad2s1210.c:706:21: error: implicit declaration of function 'of_match_ptr' is invalid in C99 [-Werror,-Wimplicit-function-declaration]

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

