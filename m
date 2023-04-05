Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9B0B6D886D
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 22:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232516AbjDEU2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 16:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234149AbjDEU1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 16:27:32 -0400
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 626FB7AB3;
        Wed,  5 Apr 2023 13:27:29 -0700 (PDT)
Received: by mail-oo1-f46.google.com with SMTP id n7-20020a4ae1c7000000b0053b61145406so5856494oot.11;
        Wed, 05 Apr 2023 13:27:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680726449;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GAqWU+48WoaNwVsMQUW3yn78CcKWsUQ7YyWgh3fTfc8=;
        b=lul/71MgwuOto4d7ig/tFKcvDoW/R6QYfbMVYITcvk398F3bnpsNtrfVqNbOgwa6Mu
         rbORTxRWdZQWPusXaFzsTdxonDPBQihl+cNXkZjgKDxlWx+XHxJ9Op/M7m+2V5cevP06
         +GRhXNoVwVuqaT7egMpunJ+bqnJbNuE++q/LVik7WgHafMKE5Y1RRHpaUE2ixmi8eWNf
         +LHJ+0ZWcEmiKRiSQxHwXw3HkdXJpG4FJszFxPcmtSswRhYmQuEW6r2os4jJjDMkzBSU
         ix8pVm17GtGQJQkHubsDsoUvAl4Sp0IYWXcIeGVAZkzNcYV3MjaHCq4oD7jFT841Kg9g
         7YNA==
X-Gm-Message-State: AAQBX9c83hhfltEWHJvoDmpV0YOZjclHmtWf9gQCkZoDsT1hKJUfbKjq
        K3yWc9avb9a7bn5jeBLh4rQbIl7pmg==
X-Google-Smtp-Source: AKy350YDcJ1CZzHlV2kqdYr697ExgpShFdyPyAcvheTe5bMbxgbese/Ryv3UqrMfOdlmbR/018pfjA==
X-Received: by 2002:a4a:abca:0:b0:53b:77e0:b7f4 with SMTP id o10-20020a4aabca000000b0053b77e0b7f4mr3417660oon.2.1680726448953;
        Wed, 05 Apr 2023 13:27:28 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id 64-20020a4a0943000000b005315e8ca468sm7021809ooa.17.2023.04.05.13.27.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 13:27:28 -0700 (PDT)
Received: (nullmailer pid 425892 invoked by uid 1000);
        Wed, 05 Apr 2023 20:27:17 -0000
From:   Rob Herring <robh@kernel.org>
Date:   Wed, 05 Apr 2023 15:27:21 -0500
Subject: [PATCH v2 07/10] virtio-mmio: Add explicit include for of.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230329-acpi-header-cleanup-v2-7-c902e581923b@kernel.org>
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

drivers/virtio/virtio_mmio.c:492:13: error: implicit declaration of function 'of_property_read_bool'; did you mean 'fwnode_property_read_bool'? [-Werror=implicit-function-declaration]

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Rob Herring <robh@kernel.org>
---
v2: New patch
---
 drivers/virtio/virtio_mmio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index 3ff746e3f24a..4b5e883055ee 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -61,6 +61,7 @@
 #include <linux/io.h>
 #include <linux/list.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/pm.h>
 #include <linux/slab.h>

-- 
2.39.2

