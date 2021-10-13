Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 093C142CE32
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 00:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbhJMWen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 18:34:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbhJMWei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 18:34:38 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A63BEC061746
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 15:32:34 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id lk8-20020a17090b33c800b001a0a284fcc2so5525772pjb.2
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 15:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2sn0l15EeXVjYYIzqdi92hRykDGSnNV5xCLLrC1tcLE=;
        b=Kh2aSOAmd2QgPUsue3SnT7fnE66zH9AHXjkYvSowtwgpYlQP8Zv8BclxcPUV2KFJsD
         O7oo01yX9nYGgqbhYq+ww6AscwkRFvH7oQetB5XGZWY3CRNC/+IhxCnYyxAZ1OGBxnWg
         BiTsUeHKd0kyYR9wrCq23iwu7WnhtQX/8vZIEn6X/Rgg4/dDrmPjyXaSVdKl3EFVlaiP
         M5SSsFAS4CKNBAll45b+XQuHWarjTMW91Ko4zoHIAKjR8hVRD8luyiCAX0CTBoZ6di3l
         Fss62GBxaUyhug+5slC4ag37lc2ZVL+tjuRlewldW4ivRIeP9kDTCIyZ1bI78MWg8Z6h
         65BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2sn0l15EeXVjYYIzqdi92hRykDGSnNV5xCLLrC1tcLE=;
        b=77dRMNXmKEQhuQ1VJ9OicWLDSsWXbYbxNzN0WWUYixczi8ZpDzyACwI3g074/y7OtP
         LL8o32LXMLB4LoiG6Zqe6UBkTo4IrDEy3AcxCFWc+ag7zra/5tDQqKaoTcCLiJ/TSmVD
         DuuAK9E8R2NhhxxZNQlfCFEb0YvbH+xskN1Kltc3ght/jmZ0gPwa/BZl11btiShNh7ba
         68X0kv2ial8wsA3ab2pZ9yeGTTVPlPewRdvJ27xUlh5AA9SfGWz33HhIGSHyo7pxvuj/
         /h32K0J2KdtjhFouOQ96UKdClOSsOPAAlcekd+ZtgGE3WU2BdZu45yBeXQunSi63nuDu
         fxVw==
X-Gm-Message-State: AOAM531bybk4RX/rwP9JsYDfK4TOIg5B0l+x0KqiyYD9rf8XPlB5pLNo
        Jlf86p4JPNIeg9bP/3E1+nqqCK8MaKc=
X-Google-Smtp-Source: ABdhPJzm6oaScbf6gzJrBMLHzKVrgjBIr0VrkVu9nj3TeAlhCj5RB6AXBe+LHQCNF7pyxV1iQlUtrw==
X-Received: by 2002:a17:902:8a83:b0:13d:9572:86c2 with SMTP id p3-20020a1709028a8300b0013d957286c2mr1775156plo.48.1634164354019;
        Wed, 13 Oct 2021 15:32:34 -0700 (PDT)
Received: from localhost.localdomain ([50.39.163.188])
        by smtp.gmail.com with ESMTPSA id i2sm6546091pjt.19.2021.10.13.15.32.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 15:32:33 -0700 (PDT)
From:   James Prestwood <prestwoj@gmail.com>
To:     netdev@vger.kernel.org
Cc:     James Prestwood <prestwoj@gmail.com>
Subject: [PATCH 4/4] doc: networking: document ndisc_evict_nocarrier
Date:   Wed, 13 Oct 2021 15:27:10 -0700
Message-Id: <20211013222710.4162634-4-prestwoj@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211013222710.4162634-1-prestwoj@gmail.com>
References: <20211013222710.4162634-1-prestwoj@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: James Prestwood <prestwoj@gmail.com>
---
 Documentation/networking/ip-sysctl.rst | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 174d9d3ee5c2..7bac67a2f6d7 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -2258,6 +2258,15 @@ ndisc_tclass - INTEGER
 
 	* 0 - (default)
 
+ndisc_evict_nocarrier - BOOLEAN
+	Clears the neighbor discovery table on NOCARRIER events. This option is
+	important for wireless devices where the neighbor discovery cache should
+	not be cleared when roaming between access points on the same network.
+	In most cases this should remain as the default (1).
+
+	- 1 - (default): Clear neighbor discover cache on NOCARRIER events.
+	- 0 - Do not clear neighbor discovery cache on NOCARRIER events.
+
 mldv1_unsolicited_report_interval - INTEGER
 	The interval in milliseconds in which the next unsolicited
 	MLDv1 report retransmit will take place.
-- 
2.31.1

