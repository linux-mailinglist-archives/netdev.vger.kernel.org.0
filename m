Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3DE16D8891
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 22:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234717AbjDEU31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 16:29:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234366AbjDEU2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 16:28:31 -0400
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F28F7EF4;
        Wed,  5 Apr 2023 13:27:36 -0700 (PDT)
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-177b78067ffso39945997fac.7;
        Wed, 05 Apr 2023 13:27:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680726456;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+WBV14RF3ai1fds2jyNkKU2Kc0Or0jrKGIWjLAOfy4c=;
        b=KnDQD5LCkx1ndilaK1qw7VY/YkSs1RLsCALysFaxM+9xmSO72ZICfnCF0ZUdJrsf0+
         LtDf9zZ0uGx6hO+7TU/6aydM1KGVCp0YFWx4acvnbvJFaOUmaN6FpVZAoC0s3n81PNtf
         sdUYeu7Nw1dJsIFOKoKNSR+NjczfYYuk5t8dxORNz6s+i0AuD53ytf9CjzF4cEFLjcAu
         l/XQmsdeKV1byw5D0S9DMEXFJv9pfn98pN6e8rJAHzGmQQlvbAJNG98X0Wocku45vmn4
         l9laLk0TMMyzvGl26Dfbn8Bc+bgYn1Bpb/LDoS2Oo4jf0sNx+lYaYu8Go8DWLR6uT0v2
         x9Sw==
X-Gm-Message-State: AAQBX9c1VuQIcuYpwSJGtE9VHep8obRme42okfGTr6SrAChykug3tSpl
        SBAiCDagjSnjkM2+ixQfpg==
X-Google-Smtp-Source: AKy350aiKxsG+dePauZBrcR87GqsUUk+nMQbPX4th5YujgeuvnV5mcO/3hIgE2jvhfcX3KA3u1DgQg==
X-Received: by 2002:a05:6870:ac07:b0:17a:ae34:12e6 with SMTP id kw7-20020a056870ac0700b0017aae3412e6mr2034130oab.10.1680726456030;
        Wed, 05 Apr 2023 13:27:36 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id an1-20020a056871b18100b00177c314a358sm6332319oac.22.2023.04.05.13.27.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 13:27:35 -0700 (PDT)
Received: (nullmailer pid 425894 invoked by uid 1000);
        Wed, 05 Apr 2023 20:27:17 -0000
From:   Rob Herring <robh@kernel.org>
Date:   Wed, 05 Apr 2023 15:27:22 -0500
Subject: [PATCH v2 08/10] tpm: atmel: Add explicit include for of.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230329-acpi-header-cleanup-v2-8-c902e581923b@kernel.org>
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

With linux/acpi.h (in linux/tpm.h) no longer implicitly including of.h,
add an explicit include of of.h to fix the following errors:

drivers/char/tpm/tpm_atmel.h:50:14: error: implicit declaration of function 'of_find_node_by_name'; did you mean 'bus_find_device_by_name'? [-Werror=implicit-function-declaration]
drivers/char/tpm/tpm_atmel.h:50:12: error: assignment to 'struct device_node *' from 'int' makes pointer from integer without a cast [-Werror=int-conversion]
drivers/char/tpm/tpm_atmel.h:55:14: error: implicit declaration of function 'of_device_is_compatible'; did you mean 'fwnode_device_is_compatible'? [-Werror=implicit-function-declaration]
...

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Rob Herring <robh@kernel.org>
---
v2: New patch
---
 drivers/char/tpm/tpm_atmel.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_atmel.h b/drivers/char/tpm/tpm_atmel.h
index ba37e77e8af3..7ac3f69dcf0f 100644
--- a/drivers/char/tpm/tpm_atmel.h
+++ b/drivers/char/tpm/tpm_atmel.h
@@ -26,7 +26,7 @@ struct tpm_atmel_priv {
 
 #ifdef CONFIG_PPC64
 
-#include <asm/prom.h>
+#include <linux/of.h>
 
 #define atmel_getb(priv, offset) readb(priv->iobase + offset)
 #define atmel_putb(val, priv, offset) writeb(val, priv->iobase + offset)

-- 
2.39.2

