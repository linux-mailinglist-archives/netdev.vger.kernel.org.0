Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 102956D8874
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 22:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234567AbjDEU2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 16:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234305AbjDEU1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 16:27:38 -0400
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B113A7A9F;
        Wed,  5 Apr 2023 13:27:31 -0700 (PDT)
Received: by mail-ot1-f43.google.com with SMTP id x8-20020a9d3788000000b0069f922cd5ceso19685632otb.12;
        Wed, 05 Apr 2023 13:27:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680726451;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JEWSD1fDMkPcJVVJWl/niMBCZ1+LVTX0zVxuNNm1m3A=;
        b=tgYmdyf87EhXuCw4Afkrg7PNPyMg7GFktqIz9RZg1IW3rOH669LTmUSIn5RZpIzRA+
         I0r6bF0er6vzx8fcElarE6rcbaXNxx/WMFUcXgvYVR7lTCyUmXqLfIeaNE6mNBo3NTco
         qFkllL8XZjKOyf1xy0Zf/XtxXxvwtQUDPHHLoIODWZwzMmSXhakfi6GWSP4vU7BA1J+g
         /ueQp0R5i/SspKNMCgund8pubr5lD+0rz6L9zNIl3+fGOedircuxFJ0FKUD5XyeTRCLD
         zRZDG11/rl5Xiq3iUH8dLPl1S/TGodneMYEH7ie3y8ge/n8Nh6YQ/qEupw5ZRxY4NPEg
         6+Ag==
X-Gm-Message-State: AAQBX9e/rOe3/XGRW9kKPygOyeSGcR7ZDUrgmf9Esu5J3Gbjq3dKo+4J
        OLf+nTXXvaw/SbubFDLnNA==
X-Google-Smtp-Source: AKy350ZaKRbNw5BVz8JUbstjxm9/rqgC8dw7YeQcDPRMSjLceOYL23HZjUhfc7B3LKhXZbj89AVs5g==
X-Received: by 2002:a9d:1b4d:0:b0:6a1:6a4b:bbb3 with SMTP id l71-20020a9d1b4d000000b006a16a4bbbb3mr1662878otl.14.1680726450887;
        Wed, 05 Apr 2023 13:27:30 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id x9-20020a05683000c900b006a30260ccfdsm5958075oto.11.2023.04.05.13.27.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 13:27:30 -0700 (PDT)
Received: (nullmailer pid 425884 invoked by uid 1000);
        Wed, 05 Apr 2023 20:27:17 -0000
From:   Rob Herring <robh@kernel.org>
Date:   Wed, 05 Apr 2023 15:27:17 -0500
Subject: [PATCH v2 03/10] net: rfkill-gpio: Add explicit include for of.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230329-acpi-header-cleanup-v2-3-c902e581923b@kernel.org>
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

net/rfkill/rfkill-gpio.c:181:21: error: implicit declaration of function 'of_match_ptr' is invalid in C99 [-Werror,-Wimplicit-function-declaration]

Acked-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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

