Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA1DB6D885A
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 22:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234417AbjDEU1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 16:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234036AbjDEU1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 16:27:31 -0400
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D14C97A9C;
        Wed,  5 Apr 2023 13:27:27 -0700 (PDT)
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-17aa62d0a4aso39939102fac.4;
        Wed, 05 Apr 2023 13:27:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680726447;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ss3eyTYzV+NDnZ/RRPgeqCBfe4RqOY1p2vYz5xDTCAs=;
        b=bl+x/6ryYP1cvdIADVuFKP8tr+8Y2a76nEm6jsZYczBJr5Qeki87HXBx+JaxHSwtcw
         etMvlIb4LaOAAiDIZ9A1dgvRu6tezehkBC/F0r+Q8Kb3NKQp9fTlnqkFUJ7BX1aa3KTf
         xGuBzDcr+TSbC0UEQqSQ2E45/QvxyaUqng5EOHEqSs9w+vPfTVdEV4UOZWx9YVGhPx0w
         2VgITx2wp03Ysr/RIStoXoP066T4cka7lCXiHySfVUVwbpJol4FxOM6ueAJlrluEfSLC
         zshxH1ZxidBGwSbGGA8euCnPIB/tOnwIFqeh07mKZO+CjQj3PFarOWeOYIMl82WYlWdM
         9kPA==
X-Gm-Message-State: AAQBX9d7+lxCZbFxR0PWy+dGCRe2bA2K7nSQ+BUy3kM+QMRIU6BRMknw
        W4uIhLgB7cpkdXXBnE2u/Ems67selQ==
X-Google-Smtp-Source: AKy350byKnZ7HGg+9UhH/DUxW8WMI92F9u//OjQV6Eipkm7DuSgX0udFN2fvk1TbAiYF5BLTyiUVoQ==
X-Received: by 2002:a05:6870:e74e:b0:183:cc50:f85e with SMTP id t14-20020a056870e74e00b00183cc50f85emr2138351oak.56.1680726447003;
        Wed, 05 Apr 2023 13:27:27 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id ur1-20020a056870df4100b0017b0e3a5af0sm6257600oab.24.2023.04.05.13.27.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 13:27:26 -0700 (PDT)
Received: (nullmailer pid 425886 invoked by uid 1000);
        Wed, 05 Apr 2023 20:27:17 -0000
From:   Rob Herring <robh@kernel.org>
Date:   Wed, 05 Apr 2023 15:27:18 -0500
Subject: [PATCH v2 04/10] serial: 8250_tegra: Add explicit include for of.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230329-acpi-header-cleanup-v2-4-c902e581923b@kernel.org>
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

drivers/tty/serial/8250/8250_tegra.c:68:15: error: implicit declaration of function 'of_alias_get_id' [-Werror=implicit-function-declaration]

Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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

