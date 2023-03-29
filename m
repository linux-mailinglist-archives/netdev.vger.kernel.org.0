Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 541B66CF546
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 23:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjC2VWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 17:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbjC2VVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 17:21:47 -0400
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED5019A1;
        Wed, 29 Mar 2023 14:21:43 -0700 (PDT)
Received: by mail-ot1-f44.google.com with SMTP id cm7-20020a056830650700b006a11f365d13so7668014otb.0;
        Wed, 29 Mar 2023 14:21:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680124903;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kTc/gK9GmP1rEeyJeskNOO/tBqpZ4qwY5m/PbyMALU8=;
        b=6chlyWDT3cRgughqrwOB33jgJalt+fmIT9dgv/WwW82eeRnrdd0HoJjok1HdH+Xuam
         D46u548U/W7WTvicSBVMqAijYxYheuI0nbStOfo/6SKeFvX8cZmSC5wWTdD1AjFFCbPg
         Ke9Mt4mrzFaHq1aMO3YkqaO7Rg0lxrufdjGETxqwqRXL0BGfab6tQzj3wN6roz0lGc1Q
         IdDzBMPAOY27FNXy5zq0E+plzuX4Cuodzwl+lCrKe3kBmtmxPVe4ZFcwZ2rZcyXFnsfK
         lriCzslYdsDml8TPhH7jXVW/sC3TNPQD3d8Tr6hYrRsC6vme/yvxg/2L7R+JYuugIfHY
         8kwg==
X-Gm-Message-State: AO0yUKW1/56LMILzXzKRYNoa7sduzP0quDiE1Q3u4kijEgGeC9GefwZv
        yjQAZak5rZmkKcvR2Ayztg==
X-Google-Smtp-Source: AK7set+ImQpMRKobWrA54g0Rd55UmfWERJrl2wg/MsdZOQM+xtCfqAdTFVRvw6llUMom53yDtU8M2w==
X-Received: by 2002:a05:6830:1bed:b0:69f:8fe4:38b9 with SMTP id k13-20020a0568301bed00b0069f8fe438b9mr10389551otb.21.1680124902837;
        Wed, 29 Mar 2023 14:21:42 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id t16-20020a0568301e3000b0069f9209c84dsm9588548otr.60.2023.03.29.14.21.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 14:21:42 -0700 (PDT)
Received: (nullmailer pid 86897 invoked by uid 1000);
        Wed, 29 Mar 2023 21:21:39 -0000
From:   Rob Herring <robh@kernel.org>
Date:   Wed, 29 Mar 2023 16:20:45 -0500
Subject: [PATCH 4/5] serial: 8250_tegra: Add explicit include for of.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230329-acpi-header-cleanup-v1-4-8dc5cd3c610e@kernel.org>
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

drivers/tty/serial/8250/8250_tegra.c:68:15: error: implicit declaration of function 'of_alias_get_id' [-Werror=implicit-function-declaration]

Signed-off-by: Rob Herring <robh@kernel.org>
---
 drivers/tty/serial/8250/8250_tegra.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/8250/8250_tegra.c b/drivers/tty/serial/8250/8250_tegra.c
index e7cddeec9d8e..2509e7f74ccf 100644
--- a/drivers/tty/serial/8250/8250_tegra.c
+++ b/drivers/tty/serial/8250/8250_tegra.c
@@ -11,6 +11,7 @@
 #include <linux/delay.h>
 #include <linux/io.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/reset.h>
 #include <linux/slab.h>
 

-- 
2.39.2

