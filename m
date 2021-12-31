Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0124822E5
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 10:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbhLaJIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 04:08:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbhLaJIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 04:08:37 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B23C5C061574
        for <netdev@vger.kernel.org>; Fri, 31 Dec 2021 01:08:37 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id i8so14853492pgt.13
        for <netdev@vger.kernel.org>; Fri, 31 Dec 2021 01:08:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=SmwDPVQJK27U8+rXr3U+rdj1GanWwhnhi+Q33MCEz48=;
        b=HZ6ozezFYfr0TUkqvUHWkTdsp8JgddW3qoM04KVGKSS0msk73Xc26dCVqnxEAVanaJ
         ahQ9BnPSy0Wx9jPpYC5g5KPFbmI6pAgHETwcOQJmB30o/3skBwXH8IYVms933kRDHvI8
         hB4JwpoENsb9l0bgu4uJoARXNQLinnGwpS1q8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SmwDPVQJK27U8+rXr3U+rdj1GanWwhnhi+Q33MCEz48=;
        b=u2UFqpjXeJGMZD/wtP4FCKA0TaukHC4aBL3snj/4RpZ6TX9VK7HJ9xGRe5PHfNVi3d
         RUtZ1oMtn+Yajgom+PfbTxdpmBJKK8Z4q9JzMOM8IjS/kYhqEhXr1BrBs7SkxTSrSFQ0
         JLvA6O7YWwtH6ETIOXiBvz3rLRvQ14/HbSSFbhWPlXgF2761putmJV8sqY+Mg9FVGcpS
         gwFPjvicntH71CN0LgmKZpGjHHFDfH3aAmk31NlcKJpmZJIZFVVkve96k7TAen3j1xbj
         AJOnMM+3SLsYvkdg2PAPytyyDJ7ZSzy13o6+BFPcnV5PxJ5aPxwXrfhunZfuR16ks6y7
         HIRw==
X-Gm-Message-State: AOAM531SxKp3Cs2qnzqUkHXrUmAmRg3HenLB5xrAxU5Q/r2z1924arv2
        KsRC0ozwsSmK6/sumoAL15G+BQ==
X-Google-Smtp-Source: ABdhPJwjBvZKrnohAoGZAd/IVIE0o32BLAN0KLu/KcYk3nK05shGCrzcXARFlpAxlsOz/GG09JifdQ==
X-Received: by 2002:a63:4f22:: with SMTP id d34mr30336881pgb.12.1640941716537;
        Fri, 31 Dec 2021 01:08:36 -0800 (PST)
Received: from cab09-qa-09.fungible.local ([12.190.10.11])
        by smtp.gmail.com with ESMTPSA id t31sm19875192pfg.184.2021.12.31.01.08.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Dec 2021 01:08:36 -0800 (PST)
From:   Dimitris Michailidis <d.michailidis@fungible.com>
X-Google-Original-From: Dimitris Michailidis <dmichail@fungible.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, d.michailidis@fungible.com
Subject: [PATCH net-next v2 1/8] PCI: add Fungible vendor ID to pci_ids.h
Date:   Fri, 31 Dec 2021 01:08:26 -0800
Message-Id: <20211231090833.98977-2-dmichail@fungible.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211231090833.98977-1-dmichail@fungible.com>
References: <20211231090833.98977-1-dmichail@fungible.com>
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

