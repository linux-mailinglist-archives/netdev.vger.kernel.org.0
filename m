Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AEEE6D8856
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 22:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234347AbjDEU1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 16:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231804AbjDEU1Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 16:27:25 -0400
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9087F6A4E;
        Wed,  5 Apr 2023 13:27:24 -0700 (PDT)
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-17e140619fdso39908039fac.11;
        Wed, 05 Apr 2023 13:27:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680726444;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yg1K4foqDaidaPo4/5C6TY3pSXqX5fHqLYuPmpMmEgg=;
        b=BYa0WEarrsDeVoxsCZAbMJe53T4FjZgjm7/eseO9AduGQyxtKk1kk83suhMUUpDsEV
         IUW7EqrNdikKRDGKMz8tQmAKiURxg1SP34d19kQTPLHELHHb7AlzlgpLbTMBs71l2bB+
         pOf4dPAFgHEZB9kgDjWc7IOUorbz2AZXswFXjpWrS1dzsWnK7rqEQ04a4sGjlaUbWDYe
         nva86QTMH+EEWzDOC4g4WxVUdABCj3xeooC5DgKYDkqaS4VFZCnNnFkua51CjYBqeyiq
         gXgMkPAUufe0XdbhJIP6bzqKtsiGLvL+HR4dk7if26FJHcmODsoWfyslLvra7ovTO/id
         mOEw==
X-Gm-Message-State: AAQBX9dx6yOuPhIf/Jv2OJNiXlcceGH4Vu1ifGxDErSgsbhUk5LMppbb
        gNrsssk0WWJSVHFSslhynw==
X-Google-Smtp-Source: AKy350bTANSJNYjcjMqwec2FcT3JaHREFNy2cg8JiUp8B+fT5fTAH8S+FermWNwrA9+XTX/0poqDFg==
X-Received: by 2002:a05:6870:9614:b0:177:9ece:6b32 with SMTP id d20-20020a056870961400b001779ece6b32mr4080421oaq.34.1680726443848;
        Wed, 05 Apr 2023 13:27:23 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id us16-20020a056870df9000b00177b33ce85bsm6324810oab.30.2023.04.05.13.27.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 13:27:23 -0700 (PDT)
Received: (nullmailer pid 425880 invoked by uid 1000);
        Wed, 05 Apr 2023 20:27:17 -0000
From:   Rob Herring <robh@kernel.org>
Date:   Wed, 05 Apr 2023 15:27:15 -0500
Subject: [PATCH v2 01/10] iio: adc: ad7292: Add explicit include for of.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230329-acpi-header-cleanup-v2-1-c902e581923b@kernel.org>
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

Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Marcelo Schmitt <marcelo.schmitt1@gmail.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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

