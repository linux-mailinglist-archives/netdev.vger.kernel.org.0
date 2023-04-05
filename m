Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7486D8846
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 22:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233498AbjDEU1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 16:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjDEU1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 16:27:24 -0400
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AFA95B83;
        Wed,  5 Apr 2023 13:27:23 -0700 (PDT)
Received: by mail-oo1-f46.google.com with SMTP id n7-20020a4ae1c7000000b0053b61145406so5856436oot.11;
        Wed, 05 Apr 2023 13:27:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680726442;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JngcAWKJpT67v6W9zBVTC6410UY98dd8Phb7Pw/m5bk=;
        b=wNHMU9LgcCEidZ23az8F7cdCsBhwj16P2mRuxm0rrLaxYrwknCmPzj9h2CPMhflaJW
         9gzzcdjPnWQ8nqnzw1f9YhwzDekqcZLtm+LskcMPAQt5ptUuvoVQV+iEpmGA+C2DnLEj
         XT15oakHJ/I7wZXcOODn4jNmo0pp6+Uw4qNqE7iQZzABCdc8p3byRtFdJgCmFG2CCVVI
         4nRAHBohnRnPKdwDz7IkcEaYjAPKtJ8VFp2e0GG8VavTQIbogZogzDviUK+OZxLXd0vj
         2VDdohCesMA5w0Fl4Z4afhfQvIo+b1iRqRMx85ptzYQ1uxqUp88kGjAQZ767M2x8Qs+r
         DbjQ==
X-Gm-Message-State: AAQBX9cUNTDVca2Vvf9avpdqhEXOL2ucVYY7SUDepQugWYYpEeS/KGGh
        Z/P26O5GpiPkfod/eQcyiw==
X-Google-Smtp-Source: AKy350bxPH3JtSAHtsmH6xOdwm/kCdOsqgg6Vx/HDHP8eFzkwoqWktAvfdJhC4LlACzT9ZpLP9IJfQ==
X-Received: by 2002:a4a:3708:0:b0:541:3ce:43fe with SMTP id r8-20020a4a3708000000b0054103ce43femr3682373oor.6.1680726442233;
        Wed, 05 Apr 2023 13:27:22 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id y2-20020a4ad642000000b0051134f333d3sm7145560oos.16.2023.04.05.13.27.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 13:27:21 -0700 (PDT)
Received: (nullmailer pid 425888 invoked by uid 1000);
        Wed, 05 Apr 2023 20:27:17 -0000
From:   Rob Herring <robh@kernel.org>
Date:   Wed, 05 Apr 2023 15:27:19 -0500
Subject: [PATCH v2 05/10] ata: pata_macio: Add explicit include of
 irqdomain.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230329-acpi-header-cleanup-v2-5-c902e581923b@kernel.org>
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

With linux/acpi.h no longer including irqdomain.h, add an explicit
include of irqdomain.h to fix the following error:

drivers/ata/pata_macio.c:1172:23: error: implicit declaration of function 'irq_create_mapping' [-Werror=implicit-function-declaration]

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Rob Herring <robh@kernel.org>
---
v2: New patch
---
 drivers/ata/pata_macio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ata/pata_macio.c b/drivers/ata/pata_macio.c
index 9ccaac9e2bc3..335e339a7ada 100644
--- a/drivers/ata/pata_macio.c
+++ b/drivers/ata/pata_macio.c
@@ -21,6 +21,7 @@
 #include <linux/adb.h>
 #include <linux/pmu.h>
 #include <linux/scatterlist.h>
+#include <linux/irqdomain.h>
 #include <linux/of.h>
 #include <linux/gfp.h>
 #include <linux/pci.h>

-- 
2.39.2

