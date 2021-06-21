Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87C853AEA6C
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 15:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbhFUNxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 09:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbhFUNxC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 09:53:02 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18204C061574;
        Mon, 21 Jun 2021 06:50:48 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id x21-20020a17090aa395b029016e25313bfcso21377pjp.2;
        Mon, 21 Jun 2021 06:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0mYZSPKTpWCjYpalvYE2jEBITq0KmYxfwhSJMx4IyFU=;
        b=KSxiYOtMd5eVo3XoXGvB1wIDNFa3/+K+/9GQn5OWFCgdWXTIBzoE0frECCZdB3bFSN
         E6J+B3SI9PzgePBducLKDMtsQ5fdbuE7+6MBBQ99b/Xe0zpG+NolavSk/5+M7E6P6D+7
         ek1dk1xjf7kF3EEHtrVtoWK8/m4Zg2ccPJZgQl1P/0hIyYPbMBqHLis9oq//I+XgR0DZ
         57x2LPLwpnncFY4bQ2oRAefVerf4EgqO0ybIv/NeTiotSyLn1HI1SQ9reUaQqP9ulahu
         W0egIP/HhUgSY46/YsdqKRS3gfCG/Ak9s319H73GOxZ4+vHrd9exdjsTlMN6AmWgQD7h
         h0cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0mYZSPKTpWCjYpalvYE2jEBITq0KmYxfwhSJMx4IyFU=;
        b=pCXFbcOq5EoKAMJySCPIPBvQayp9S/wYcugiVbEImVVN2rOpKXTU/qY+djOT9KTdYy
         8pFg5ZPg2g2VqYUWDnHgyeBGqIC8xTLq8pHME5pgFmRPDjTCDfQr5JyE1ixtWSWSPyr9
         /kFgshPyaqZok8L1wNzFdb4KI0WNNLnHoRN/qZ67t4jKit1mmhO7hLz4OoOQClnVeVeu
         s5OA1jlGeiED4reXWr//+psXDXvybFZATa7RcluT2fgXEbM/vMBuz1xdeYjlTS9Sof1G
         H2JD5rupF+GU70aafSXU9wrLQ7mX218DT0x2+w4YKAduZy8qc4FyimgONNtq9m3/CEP4
         l85w==
X-Gm-Message-State: AOAM533S4kivhw3PiY2gc/sUNGPjDa+6p/PzAPRYLaYyy8yuK5yTVOT1
        B13l+QYiZb+gK0bIRsKd5wA=
X-Google-Smtp-Source: ABdhPJzmjRCxXPd5Y2US1enITpczMMJEqXsf/QB7GL1eAze9xbXlZQi4mbwKC2CG8TOcHP0sU9oDsg==
X-Received: by 2002:a17:902:14b:b029:119:ef6b:8039 with SMTP id 69-20020a170902014bb0290119ef6b8039mr17948896plb.84.1624283447704;
        Mon, 21 Jun 2021 06:50:47 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b20sm16914967pgm.30.2021.06.21.06.50.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 06:50:47 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     linux-staging@lists.linux.dev
Cc:     netdev@vger.kernel.org,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com (supporter:QLOGIC QLGE 10Gb ETHERNET
        DRIVER), Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC 10/19] staging: qlge: remove the TODO item of avoid legacy/deprecated apis
Date:   Mon, 21 Jun 2021 21:48:53 +0800
Message-Id: <20210621134902.83587-11-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621134902.83587-1-coiby.xu@gmail.com>
References: <20210621134902.83587-1-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following commits have finished the job,
- commit e955a071b9b3e6b634b7ceda64025bfbd6529dcc  ("staging: qlge:
  replace deprecated apis pci_dma_*")
- commit 50b483a1457abd6fe27117f0507297e107ef42b2 ("qlge: Use
  pci_enable_msix_range() instead of pci_enable_msix()")

Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
 drivers/staging/qlge/TODO | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/qlge/TODO b/drivers/staging/qlge/TODO
index 2c4cc586a4bf..8bb6779a5bb4 100644
--- a/drivers/staging/qlge/TODO
+++ b/drivers/staging/qlge/TODO
@@ -6,8 +6,6 @@
   split cases.
 * the driver has a habit of using runtime checks where compile time checks are
   possible (ex. ql_free_rx_buffers(), ql_alloc_rx_buffers())
-* avoid legacy/deprecated apis (ex. replace pci_dma_*, replace pci_enable_msi,
-  use pci_iomap)
 * some "while" loops could be rewritten with simple "for", ex.
   ql_wait_reg_rdy(), ql_start_rx_ring())
 * remove duplicate and useless comments
-- 
2.32.0

