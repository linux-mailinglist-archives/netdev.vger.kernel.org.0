Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3B3B483C04
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 07:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233041AbiADGrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 01:47:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233028AbiADGrB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 01:47:01 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72679C061761
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 22:47:01 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id 8so31410333pfo.4
        for <netdev@vger.kernel.org>; Mon, 03 Jan 2022 22:47:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=SmwDPVQJK27U8+rXr3U+rdj1GanWwhnhi+Q33MCEz48=;
        b=E+j+oRsj43ypLqb/27JzS7yxEXP3S+Dg2ZwnztcITRPDIVu9sHo+3MwmlutCOYgDX7
         8OX3WvrkoBp9/FUhskKM2C80q0rpuXDyBu4Eo7/dK6XAqXRRrmH0sobzLi1/4O3A5FaN
         8odv+25pmQjVvr44dl+zcHcMyUnVLtX0p8K2Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SmwDPVQJK27U8+rXr3U+rdj1GanWwhnhi+Q33MCEz48=;
        b=Xp3m2URB751vd9hx3fFGCPT5jSkzL/6o0TADYv/Sn+yHTb9IRkTAgWTGWqivjRUISt
         dzaXCDaxd8sM4mvF6746hIheRMs7B2BSNC5obOW6Y4eOprsBCc091hT/doJHD45H0He1
         iLlxSj2HrfMGYGUCysY6UbJ8X4VLIE7M39HSgkou+ZwGewoZDbw83loyzvxhyWDBO21t
         +TvzngSSUSOBGZDa4BlYg5/HXc2JWt2LOYsne3Adr7DBX0ugA2Ruvo6z5Yb4keeoSY8J
         kZvXSIbH4+RUcK4KurEiQED5sm3/7N2YzEaXZmibh7mSArGMvRA3YgRawwg5E7hvQJU9
         gyaQ==
X-Gm-Message-State: AOAM532jWoefwUxdL1WZDMq8EtHQ6LDoqSdmxz5bSDkT8nh+S5LCHQxz
        CUaYPfm2SkCIN72UToHR0AMBqw==
X-Google-Smtp-Source: ABdhPJxW9BafqsHx+aCi4xG9J+GZzFeI8LD1uLY3nuVbvDA2OCKNWTAzpFqpTtxZrDO25eyS/kbxnA==
X-Received: by 2002:a05:6a00:2356:b0:4ba:f28c:63da with SMTP id j22-20020a056a00235600b004baf28c63damr49252996pfj.50.1641278821038;
        Mon, 03 Jan 2022 22:47:01 -0800 (PST)
Received: from cab09-qa-09.fungible.local ([12.190.10.11])
        by smtp.gmail.com with ESMTPSA id 93sm40424090pjo.26.2022.01.03.22.46.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 22:47:00 -0800 (PST)
From:   Dimitris Michailidis <d.michailidis@fungible.com>
X-Google-Original-From: Dimitris Michailidis <dmichail@fungible.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, d.michailidis@fungible.com
Subject: [PATCH net-next v4 1/8] PCI: add Fungible vendor ID to pci_ids.h
Date:   Mon,  3 Jan 2022 22:46:50 -0800
Message-Id: <20220104064657.2095041-2-dmichail@fungible.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220104064657.2095041-1-dmichail@fungible.com>
References: <20220104064657.2095041-1-dmichail@fungible.com>
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

