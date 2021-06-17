Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFFE3AB802
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 17:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233527AbhFQP6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 11:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233520AbhFQP6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 11:58:17 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3877C06175F
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 08:56:08 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id u24so4663211edy.11
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 08:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Mx5zFYmCI2OhkMi/ePBLU4lD0MHhdDHE9/mvFw3mR1c=;
        b=K8eby5jroJcRFtSPGEiKuOD6m9qGKTDXobgVL4wk7OuUpJ7scLcMNuVxkL5mgFZVES
         ChiTew9z0rZ3H8fLTPuzPXrxuI4H0UbAl1TFYnTMxssa3jqCGZVgdtlcCRqV3vqmFbdg
         sOl/MumUXEHhi7TKRiT+LZ7kZLBw9y2NF3zYyldKbmQtLx35JqAtRnERXbyoi3R50WWH
         QTR9QQ1usUM+xKObpn1JVkh3f2kAOKmyvyIxC0uXESmlmx8+uxCW56NNDpvanzLqntDd
         gb6kCkzg0jVpOSnqXr5wND/DqtPPe7QjuK9sag7ZHELpsH7R5NKyD+PtclnI7PJbsbua
         IXvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Mx5zFYmCI2OhkMi/ePBLU4lD0MHhdDHE9/mvFw3mR1c=;
        b=tN6Q440qUo9tb0k8/S8VTvKsAfRyr9NFdWqyKASOTLqiQk1sxbZx/fu4XgDeJeDIem
         UmHETaPU8TiVHYbYisU2tTFDkyHHbV7eGdJyCMg4fuQQRi+I3V3P4eZpK57Jd6C8CHzz
         9zXCofxV28ZKT1H3zg80tDlJhjfb41cwtGj5kukH2TsTwPanXvqB1rEhW6PswyiwsKHh
         bjurHZIV7vHTq/60+frxkfeujkLYo6/SAirOVM/zJCneP7GNVKy3c7zhXkGmmXFkLNmc
         sxC092tA35IjQJdDCDHX7vRG/f9dV0fw4I1Vy4grA44W0QKpQKp9TdyqoxiyDGnxjPmf
         EtBQ==
X-Gm-Message-State: AOAM531/6ggMboRt6JpFZ3sx3u3+EncMqSE/bLgafTJrKuNDp+4fkGjm
        BLTsE7CRbMHsXPTBQkm4miU=
X-Google-Smtp-Source: ABdhPJxKo8F/HVe/1Zaa5X8pUXwzTQ69JVZ+xMNEwFIKWVU/7bLvCkFbP7ogKsIEsw9l5CMdV0gYOA==
X-Received: by 2002:a05:6402:268f:: with SMTP id w15mr7553606edd.228.1623945367254;
        Thu, 17 Jun 2021 08:56:07 -0700 (PDT)
Received: from yoga-910.localhost ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id x13sm4097220ejj.21.2021.06.17.08.56.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 08:56:06 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     rjw@rjwysocki.net, calvin.johnson@oss.nxp.com,
        grant.likely@arm.com, lenb@kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH net-next 1/2] Documentation: ACPI: DSD: include phy.rst in the toctree
Date:   Thu, 17 Jun 2021 18:55:51 +0300
Message-Id: <20210617155552.1776011-2-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210617155552.1776011-1-ciorneiioana@gmail.com>
References: <20210617155552.1776011-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Include the new phy.rst into the index of the ACPI support
documentation.

Fixes: e71305acd81c ("Documentation: ACPI: DSD: Document MDIO PHY")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 Documentation/firmware-guide/acpi/index.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/firmware-guide/acpi/index.rst b/Documentation/firmware-guide/acpi/index.rst
index f72b5f1769fb..a99ee402b212 100644
--- a/Documentation/firmware-guide/acpi/index.rst
+++ b/Documentation/firmware-guide/acpi/index.rst
@@ -11,6 +11,7 @@ ACPI Support
    dsd/graph
    dsd/data-node-references
    dsd/leds
+   dsd/phy
    enumeration
    osi
    method-customizing
-- 
2.31.1

