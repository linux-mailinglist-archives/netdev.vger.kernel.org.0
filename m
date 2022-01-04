Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E60C48399F
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 02:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbiADBJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 20:09:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231493AbiADBJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 20:09:37 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A62C8C061761
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 17:09:37 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id y9so2825972pgr.11
        for <netdev@vger.kernel.org>; Mon, 03 Jan 2022 17:09:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=SmwDPVQJK27U8+rXr3U+rdj1GanWwhnhi+Q33MCEz48=;
        b=hMtPppQpY5N38+6NcsYDtqqMBy5ZcoAvwknELIoIyGa1jWVUNNOvN8787T7PzROcUh
         7Kk+2Ty1ppSaspiVnNSfGm/tRSGQRkhcQxQzIKDweJfm7aFDUNhMuqsp0RQAGUX7JU8S
         u84JBIfwLw9RIYR+tUZ+XBXrIFAd/Po33NhbA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SmwDPVQJK27U8+rXr3U+rdj1GanWwhnhi+Q33MCEz48=;
        b=DHrJwsNOijGvjzJyz5XZqsEYj+yix5bwXf9Yd55zFvkTSwVEd5YScC7lb4vaztRU0w
         IVBUKpuMlnNHMbnuy47aPC0Yo3YA+fkC9QH7nxHt2embNumxWhGvlmVwRTkBESrSnKIn
         3lnAy/WiYeZGnp5OUsPH1MwjRnCMZ7uKn3R0hu3ENj5lElV3r7WvPtfOabqTT+jx3WzY
         M2LM9PxIJ0w+BFTj2YmDwnKUMFMmwVtLtjO4NDEULYkoZez/8MMdeP8jtJBFOFOLABjO
         /lMzVZ67Bx5pmcl3aUtc4WapvCZkv1tlpH8w6e8V1YzDN/0N09HvO/0hPqo0h74WRhdO
         rW2g==
X-Gm-Message-State: AOAM530BhUZtanqSZ5W5JvdJ/b4taI3XOMW5NsPb8an9+UBkKEtrsY3l
        itbodVZ+QslBkD0PZ34ffQVuKYH8ztrB5g==
X-Google-Smtp-Source: ABdhPJwtoUFuBT0Wr9k74bUqAfsRo3zMz34566i95x6nSYZdySJ9sdm37LJ9ggr7jswrsShPPB/UMg==
X-Received: by 2002:a05:6a00:cca:b0:4ba:f5cc:538c with SMTP id b10-20020a056a000cca00b004baf5cc538cmr48419594pfv.60.1641258577145;
        Mon, 03 Jan 2022 17:09:37 -0800 (PST)
Received: from cab09-qa-09.fungible.local ([12.190.10.11])
        by smtp.gmail.com with ESMTPSA id v10sm39208654pjr.11.2022.01.03.17.09.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 17:09:36 -0800 (PST)
From:   Dimitris Michailidis <d.michailidis@fungible.com>
X-Google-Original-From: Dimitris Michailidis <dmichail@fungible.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, d.michailidis@fungible.com
Subject: [PATCH net-next v3 1/8] PCI: add Fungible vendor ID to pci_ids.h
Date:   Mon,  3 Jan 2022 17:09:26 -0800
Message-Id: <20220104010933.1770777-2-dmichail@fungible.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220104010933.1770777-1-dmichail@fungible.com>
References: <20220104010933.1770777-1-dmichail@fungible.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>
---
 include/linux/pci_ids.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 011f2f1ea5bb..c4299dbade98 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2578,6 +2578,8 @@
 
 #define PCI_VENDOR_ID_HYGON		0x1d94
 
+#define PCI_VENDOR_ID_FUNGIBLE		0x1dad
+
 #define PCI_VENDOR_ID_HXT		0x1dbf
 
 #define PCI_VENDOR_ID_TEKRAM		0x1de1
-- 
2.25.1

