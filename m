Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53D82483679
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 18:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbiACR4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 12:56:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233928AbiACR4n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 12:56:43 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B026C061785
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 09:56:43 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id r17so71290182wrc.3
        for <netdev@vger.kernel.org>; Mon, 03 Jan 2022 09:56:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=neH7i+26OYLpeC5cMlHViFNMwrfPO3xPJ5Z7DAt5pN8=;
        b=XvTHDJevsy0ZSrMi+se2sklxBwlITB/hybQLSG/lMV6WXD0xQn+yILwcirk/NVHH8N
         y5cSTYrKo/Z515VeTJsDn3ON6gufP4KRJNeoc3luWerqUVvGFkKB06JcyTcrTCIl9l/M
         ygPKlJgUlChyH36b8GV0ox/Isxi8z+lV1ckPQPQwDphX+q42mcFH3qe18mDTe+OGrF2+
         QyVmUvkcCSigenymoDPRF6E8uDgEnoyqfXlM77ZRQn26WSGFn9RyGSrbmDd1zy/Dm7LT
         0Y5Wfi/pkxGViP79Io2eyNB5PH2dc04N5zhpKGpYuXUmB0YGFnVUWaNDI0AXO5xtoZjW
         vcVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=neH7i+26OYLpeC5cMlHViFNMwrfPO3xPJ5Z7DAt5pN8=;
        b=m/dFQ4+Kdn3jQWJ1XDwXoIStp1F4tOndGWXmRyNH8SvN8KSFrYHuih0m4ZmVnVJMSM
         aJis+K9AicJLo40vbWyStmHNQSVzsHhuEdQyTWuafTcrZ8LNOnLDGLzV4rzLU6WJuLtj
         1LJtRW+bMFuNW48UhM+qN1R4bYyluas/LelInR8FTLvsB9tInNQgObSNnhXBjeu3rAtQ
         p6e2gtsv/kpXL0EsnIjVjSeNswF8oAXiUMeGUpEgECwZEIWQq+Oxn/Qw0mz5ico7LNAJ
         vfCez4S8tBceZM5s/9fy/d8VSDFN8HJ2kU3uTQcaoxOxI/iWvNYdu1ZWr+KgE+Zew4/l
         047w==
X-Gm-Message-State: AOAM532ec97kG5A8YfKawijoRu3oqfSjeAnMwZWyD7fxi5eU93Ou9jFG
        c+4lSl74YSyLV9ebc1Q2O225IQ==
X-Google-Smtp-Source: ABdhPJw7NRuoQzYialN/ofxRojlC+rMlNFgTAaoktigERArvcxUcZfxMwsO4ZIqBe2qOY/2d56FPug==
X-Received: by 2002:a05:6000:2a4:: with SMTP id l4mr40910111wry.460.1641232601515;
        Mon, 03 Jan 2022 09:56:41 -0800 (PST)
Received: from localhost.localdomain ([2001:861:44c0:66c0:7c9d:a967:38e2:5220])
        by smtp.gmail.com with ESMTPSA id f13sm35763228wri.51.2022.01.03.09.56.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 09:56:40 -0800 (PST)
From:   Neil Armstrong <narmstrong@baylibre.com>
To:     davem@davemloft.net, devicetree@vger.kernel.org
Cc:     Neil Armstrong <narmstrong@baylibre.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-oxnas@groups.io,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/3] dt-bindings: net: oxnas-dwmac: Add bindings for OX810SE
Date:   Mon,  3 Jan 2022 18:56:36 +0100
Message-Id: <20220103175638.89625-2-narmstrong@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220103175638.89625-1-narmstrong@baylibre.com>
References: <20220103175638.89625-1-narmstrong@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add SoC specific bindings for OX810SE support.

Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
---
 Documentation/devicetree/bindings/net/oxnas-dwmac.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/oxnas-dwmac.txt b/Documentation/devicetree/bindings/net/oxnas-dwmac.txt
index d7117a22fd87..27db496f1ce8 100644
--- a/Documentation/devicetree/bindings/net/oxnas-dwmac.txt
+++ b/Documentation/devicetree/bindings/net/oxnas-dwmac.txt
@@ -9,6 +9,9 @@ Required properties on all platforms:
 - compatible:	For the OX820 SoC, it should be :
 		- "oxsemi,ox820-dwmac" to select glue
 		- "snps,dwmac-3.512" to select IP version.
+		For the OX810SE SoC, it should be :
+		- "oxsemi,ox810se-dwmac" to select glue
+		- "snps,dwmac-3.512" to select IP version.
 
 - clocks: Should contain phandles to the following clocks
 - clock-names:	Should contain the following:
-- 
2.25.1

