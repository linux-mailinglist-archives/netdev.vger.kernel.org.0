Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5E0339EF8
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 16:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233923AbhCMPno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 10:43:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233486AbhCMPnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 10:43:14 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1CB2C061574
        for <netdev@vger.kernel.org>; Sat, 13 Mar 2021 07:43:14 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id a8so6782066plp.13
        for <netdev@vger.kernel.org>; Sat, 13 Mar 2021 07:43:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition;
        bh=S9+2IFN1dv7+M9NnZ3JAWoiEoZQsQf5Cgay5lNY5ss4=;
        b=EdAIZ1rSyAIN0KPtnR1q5aTQQOrttbodDcHiVcuwlbd69DbfHS0LKESutgFTUQtaEo
         7nRHAHZpckouso2nvbutiSS6/CkRm4+OLLyK4zbIELVjSaXGAfZcea0+2C+GGOZRBjcd
         HbDFzvuNe446nBWozfTVyu2hyQMp8xgAEQ6oswJXWilonfjBRorfv3hj0izBERsR2BkM
         7E4l0i6hoIgEXriaXasNOASxsvSIAkhWPMTnGEHi1z7qBNBle+Ag7WxB83BY9yBhIgtz
         Wa/8NqGjIj2OhDNelUrhzksxusufd++91ZVmjtJpuw6zrcYtwrQzXhP8WA8T9O6h+LWc
         e4Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=S9+2IFN1dv7+M9NnZ3JAWoiEoZQsQf5Cgay5lNY5ss4=;
        b=tOIPlg2B0kTR1OkaH/BbWW4iYsdsn1oFDl2H4xfKWCvzi1fCSldhipwWgAAGXm1Wrz
         8lpg9yg1vLjAoCO5pM+dPwJNDQYr3DN6cIkwnqqp6Xg63piqAj+/wxyPuzQMlypwpu4H
         0ejb60DVzXtaAdiYxfIVijEc9lXg5SVz4LaM6BtW6cyOnu1RIjmQA7/45jsvlwKwe3AC
         c44vhOe6+B3P7miEn91mb7hzQ5MBbAsKudLhAOxH5AxH1ir1aafCi0exLtRxYITIL/ol
         lQ/m3FGMMPeEXpq2QZcHVPpiyb/TqjPT582OGe/yHhGK3VSljMDjTxTTi37o1MWYsRDL
         i0zQ==
X-Gm-Message-State: AOAM53337/PShbiylc5WJ7tws2CpHWKpYU2sSQ0vg1j1q2tyhGDBPPy0
        VY6S8rMxoHYpisdX7EeYdYi+N3YOfzliVQ==
X-Google-Smtp-Source: ABdhPJyyTZEy7YgjjrCGntMHPv6uYcSRm+vgHAEjqucxhPvzEZzacUi7V7aMt3rgaFdz+CXPWnv90Q==
X-Received: by 2002:a17:90a:8591:: with SMTP id m17mr4154041pjn.143.1615650193691;
        Sat, 13 Mar 2021 07:43:13 -0800 (PST)
Received: from client-VirtualBox ([223.186.9.86])
        by smtp.gmail.com with ESMTPSA id v26sm8462514pff.195.2021.03.13.07.43.12
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Mar 2021 07:43:13 -0800 (PST)
Date:   Sat, 13 Mar 2021 21:13:05 +0530
From:   Chinmayi Shetty <chinmayishetty359@gmail.com>
To:     netdev@vger.kernel.org
Subject: [PATCH] Net: gtp: Fixed missing blank line after declaration
Message-ID: <20210313154305.tuwdfauo2tro6b3u@client-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Chinmayi Shetty <chinmayishetty359@gmail.com>
---
 drivers/net/gtp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index efe5247d8c42..79998f4394e5 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -437,7 +437,7 @@ static inline void gtp1_push_header(struct sk_buff *skb, struct pdp_ctx *pctx)
 	gtp1->length	= htons(payload_len);
 	gtp1->tid	= htonl(pctx->u.v1.o_tei);
 
-	/* TODO: Suppport for extension header, sequence number and N-PDU.
+	/* TODO: Support for extension header, sequence number and N-PDU.
 	 *	 Update the length field if any of them is available.
 	 */
 }
-- 
2.25.1

