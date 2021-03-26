Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC9234B2AC
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbhCZXRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbhCZXRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 19:17:03 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67ECEC0613AA;
        Fri, 26 Mar 2021 16:17:03 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id q26so6978238qkm.6;
        Fri, 26 Mar 2021 16:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TnZft1bM0JMPpkTaiyM02YRpy0hlthAHrUT+3UG4R1Y=;
        b=S57ZXfhr0PviagZCVjhphhKRuHI26ns9fdqD8eFoZKlRB2tt47W2lW3FMmNvPVd/jG
         UmpQZT5auMoOsrWT3lU7nYv22DvqqWblM1coI9C5/iqb10Vd/mLCXdT8FMq044rKi0lS
         xrDKnZTQgK+/GHmqxUAXYIdq6Hnv37lYcSn8nQrflcUVwiZsOInL8cGB6gvkdPPZOBFD
         jsREl9dryd7sYsRC08uaaGqg6svRsTIDX5c4PxgRDiOo4sbSWP0WmibRw0TAt5x6y/Yt
         Y8yryoPOfMrD2qwtC77GFXMDxFeSkKCvSRHd6CdVTqw5QmYwfzCqI8B8LyOvXSWP9sma
         h2gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TnZft1bM0JMPpkTaiyM02YRpy0hlthAHrUT+3UG4R1Y=;
        b=qRDaJ1JxPOZdP7mEZmGfk+tZqzbsPnQqtfZQdP+I6a7rYdz1/5MrntKuL5HmDJSP1K
         92NyPNVjvCZbtCXI/qK0gftTghCZJ7M8q3R26nTqqTav+jE6D4dgrt+sPtE8l15Fm35V
         RaHo57dqXdD2N2qfOsdqRQa/TDa+Hvp6Zk4gBXuPrmJyoqKArbeLs2fMLE5QRRz3TZyb
         qLNp1Sq8bd3V8CTyNpCaYCq7tus+h9r9T0uUa9whaqfivzDz9+ZeI/BwrZcETRnKMwkb
         SCUtyOkaItmWOTi8fLwEUG7T/y96JOnkw2dlRWZ1FEuZ7ESwSyRtbcsybyys1xIfarqy
         KIVQ==
X-Gm-Message-State: AOAM531wdmadw0/kcJRrKuMd4W/+4Ny4AM3O7jYi2KcOop+Nvam3gIZj
        nLY0r7gTTYakw/9YOVjIz2x2Zppcey7X8EbU
X-Google-Smtp-Source: ABdhPJxQerVupiU2SEG6G2YGJMZ/hy1IeDB/jqL3nASn4YQnk/5LWLcfwV9XesU70D3HSzrVLWDptg==
X-Received: by 2002:a37:c13:: with SMTP id 19mr15233460qkm.210.1616800622744;
        Fri, 26 Mar 2021 16:17:02 -0700 (PDT)
Received: from localhost.localdomain ([156.146.58.30])
        by smtp.gmail.com with ESMTPSA id w78sm7960414qkb.11.2021.03.26.16.16.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 16:17:02 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, rdunlap@infradead.org
Subject: [PATCH] netfilter: nf_conntrack_acct.c: A typo fix
Date:   Sat, 27 Mar 2021 04:42:49 +0530
Message-Id: <20210326231608.24407-14-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1616797633.git.unixbhaskar@gmail.com>
References: <cover.1616797633.git.unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/Accouting/Accounting/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 net/netfilter/nf_conntrack_acct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_acct.c b/net/netfilter/nf_conntrack_acct.c
index 2ccda8ace796..91bc8df3e4b0 100644
--- a/net/netfilter/nf_conntrack_acct.c
+++ b/net/netfilter/nf_conntrack_acct.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* Accouting handling for netfilter. */
+/* Accounting handling for netfilter. */

 /*
  * (C) 2008 Krzysztof Piotr Oledzki <ole@ans.pl>
--
2.26.2

