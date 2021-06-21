Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 526423AEA69
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 15:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbhFUNwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 09:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbhFUNwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 09:52:53 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E55D0C061574;
        Mon, 21 Jun 2021 06:50:38 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id t32so2342770pfg.2;
        Mon, 21 Jun 2021 06:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dsT/DFkU4ugOnwiedTB/H/+aCFKE/gHvtAJo8gJ/4xU=;
        b=K3dPJFNfKnJZ9ImpJZQhUeZnOL6fNuVlMCtBJDlCFZ5UoW/3i6WdJeQdLzp11OK2P6
         5xHgQK/vQCIClkykiMXyXqCP3sESForvaOgw/drcxGFmXvrWVfXlclE7wHDoD9lhwqod
         w+0qART18gMaYAiYQ8NQHhVLOmPkhe20a3w0/MhVwqXKigSpR97C1Qfc2mD8YBLt8jPR
         6w7E4FOrt7D1gQ9kEXeBKCw0/Ah+kufyCDyaVkap4RPcE9YJHvYWknRsVIN67rwtDs4X
         kFxnCIiLOlYHOCWLLmgA21LMpHLphQ0zoOI2aECsqUJ3ViF4uXg7b5aMbdjr4arqZxw9
         bclw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dsT/DFkU4ugOnwiedTB/H/+aCFKE/gHvtAJo8gJ/4xU=;
        b=mc92tw8FX12Ut9C1X09CEJu2a/AbpKViq8pDn2Izv1iEYIiUKUAT2W9OpHkN+Owfuk
         3RXRHllSO9CfXac1y6vaWlDEOdmIkqL/nZisxrbg+1cQxAh6ZU2WhDokFeN0kFG9G9QZ
         nIwDXT+NogcuExu7vhVTdJaymSGdpF5yQOjReDhqQBH8TKK/ApbDUEa7ho/MnGE8ry7c
         o8DAar2Z/RMyZXh1NiJMyP/sSKsa/+VfWynHXnt/Qyh+8Zk6LZet2nBIS8J0rpAezANP
         d0ZfouM0NlS2KjrgBLu1LL8fECQmdFShw8TLdz+bfl1tGY/Y9BPkRcPnw2In/CmdvXXx
         7Uww==
X-Gm-Message-State: AOAM531RxrG6y5V/NCvSMaPztK7FT13Msv8ZqhaLtAiQdCgNCH/4nQAO
        t6ZsDRtlLD6l3fUXAV73XJg=
X-Google-Smtp-Source: ABdhPJw6Tgz/lB1hCgsHP0sq40v5fxcqZ5xkjpB/b36/FOB5gK+DiNaLs7bScNm/q8BVczc7ZhZF2A==
X-Received: by 2002:a62:f947:0:b029:2e9:c502:7939 with SMTP id g7-20020a62f9470000b02902e9c5027939mr19696390pfm.34.1624283438541;
        Mon, 21 Jun 2021 06:50:38 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f13sm1147160pfe.149.2021.06.21.06.50.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 06:50:38 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     linux-staging@lists.linux.dev
Cc:     netdev@vger.kernel.org,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com (supporter:QLOGIC QLGE 10Gb ETHERNET
        DRIVER), Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC 09/19] staging: qlge: remove the TODO item of reorder struct
Date:   Mon, 21 Jun 2021 21:48:52 +0800
Message-Id: <20210621134902.83587-10-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621134902.83587-1-coiby.xu@gmail.com>
References: <20210621134902.83587-1-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct qlge_cq has one hole, but for the sake of readability (irq is one
of the Misc. handler elements, don't move it from after 'irq' to after
'cnsmr_idx' ), keep it untouched. Then, there is no struct that need
reordering according to pahole.

Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
 drivers/staging/qlge/TODO | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/qlge/TODO b/drivers/staging/qlge/TODO
index cc5f8cf7608d..2c4cc586a4bf 100644
--- a/drivers/staging/qlge/TODO
+++ b/drivers/staging/qlge/TODO
@@ -6,7 +6,6 @@
   split cases.
 * the driver has a habit of using runtime checks where compile time checks are
   possible (ex. ql_free_rx_buffers(), ql_alloc_rx_buffers())
-* reorder struct members to avoid holes if it doesn't impact performance
 * avoid legacy/deprecated apis (ex. replace pci_dma_*, replace pci_enable_msi,
   use pci_iomap)
 * some "while" loops could be rewritten with simple "for", ex.
-- 
2.32.0

