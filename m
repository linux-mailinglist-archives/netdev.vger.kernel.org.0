Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07EDE6CF54F
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 23:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbjC2VWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 17:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbjC2VVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 17:21:50 -0400
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D4E558E;
        Wed, 29 Mar 2023 14:21:49 -0700 (PDT)
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-17ac5ee3f9cso17681114fac.12;
        Wed, 29 Mar 2023 14:21:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680124909;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D6kdJkdEvlZGQb1vCK3qYJWmWN2WbnFemR8/3BecZeY=;
        b=BGL1+h1zAA/NzWp+Iuw9NVD9jKTcIMeSSZQQD3ZbfGKfmYl9V7C7vgotO06xfttpr+
         Pphta7ltgRoylNsGK7+kTRhVm+pS86phvGxDXFUXwW/ZnI7qYgzXERXs/WVPY5QbJKXE
         vVbkt9bdn8ktBKeVC9E/weQG0zoyRULcSTwpEIbRvdQxSAJ9WjOyqZAzxqsv9joViwPR
         S0szwF+2K+Z7gIuixA0KZSTOo0PwdUyJYDSdii3IH7fpnMYDH1Ga7vyjVypEZsOTLk/R
         bOYB2U9el6aoZ8cA5Cg461g4GrC9fibm9DyQ0f6Q0GwjWTWo6Tgp5E3nzecDfaU1KuQs
         qkJA==
X-Gm-Message-State: AAQBX9fbSR/sTM0Cevx2TrB341C+mw/YidKEQQO0UC3VIGv0WiMhGUYi
        srHNV0g4vozD6Kt9VR91LQ==
X-Google-Smtp-Source: AKy350Yz8wBQUIa2vxnrxVjt+nPqC1UmY+M1RkG0ncdyC4Riz1moWMsQ9Ah3S0EOekgAOjxhUNzThA==
X-Received: by 2002:a05:6870:3284:b0:17a:f8b1:8bae with SMTP id q4-20020a056870328400b0017af8b18baemr11963271oac.37.1680124908972;
        Wed, 29 Mar 2023 14:21:48 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id z26-20020a056830129a00b006a1508d348dsm2892795otp.22.2023.03.29.14.21.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 14:21:48 -0700 (PDT)
Received: (nullmailer pid 86895 invoked by uid 1000);
        Wed, 29 Mar 2023 21:21:39 -0000
From:   Rob Herring <robh@kernel.org>
Date:   Wed, 29 Mar 2023 16:20:44 -0500
Subject: [PATCH 3/5] net: rfkill-gpio: Add explicit include for of.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230329-acpi-header-cleanup-v1-3-8dc5cd3c610e@kernel.org>
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
X-Spam-Status: No, score=0.8 required=5.0 tests=FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With linux/acpi.h no longer implicitly including of.h, add an explicit
include of of.h to fix the following error:

net/rfkill/rfkill-gpio.c:181:21: error: implicit declaration of function 'of_match_ptr' is invalid in C99 [-Werror,-Wimplicit-function-declaration]

Signed-off-by: Rob Herring <robh@kernel.org>
---
 net/rfkill/rfkill-gpio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
index 786dbfdad772..e9d1b2f2ff0a 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 #include <linux/mod_devicetable.h>
 #include <linux/rfkill.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/clk.h>
 #include <linux/slab.h>

-- 
2.39.2

