Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE5B338B06
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 12:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233778AbhCLLIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 06:08:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233864AbhCLLIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 06:08:10 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6211DC061761
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 03:08:10 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id u5-20020a7bcb050000b029010e9316b9d5so11978484wmj.2
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 03:08:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uhFSV6Hqzt9zCZfztk/Zxp+QtBdpm5r07mTFNAPSF1U=;
        b=pnyGgcuHAR6LtC2mCsQxH2xirFJ+yIbnNAkBIXgauwReKVyo8iVuN1BjI123xgGw52
         Vaxnzti2nlyxKn/ao0jLzrRE/6fmKeSN123EXSi5zVgQV7P1faQVwYhCs9UKv8OAg461
         sEmMWlJFpcFBFpD8JFq/5VPMz6wvRpTzFUvQc/JK9EXBTAW4VuyUs7iGOfciUS3AbYqg
         qsVgljqtY5y/QCbDrTTFqU6IVNXLdb2R5bgVW+olqgj1/fNnr6CS4Y90awS/hQ03Ax6c
         AwGVtHq3/9w1sTgXG2EwhGUrnv6X1AT+gmSO5eZikfISeQ7S7xK8AzXNkH7OS2OifI5P
         4HCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uhFSV6Hqzt9zCZfztk/Zxp+QtBdpm5r07mTFNAPSF1U=;
        b=mFUYT40X0u++ZwayIRCx0lVwlSt7gBsYHxvFxxalrldTsgkYeiGzcoj8eM6NTzu8M4
         7NLQ3Ql0IT3ncKYmhPDlNGoHTI4v+NJN6wgaO+3jn/Mg/61FOi+wyPWHONJ8xHRy8RRX
         c1Xt0PCbiJka/hqqw0vtWEwS1Kci24FsDyMTneL1Y1bWbnYeM7QKoCcJ/ZXFvd8s82RC
         fpjoJR74HeyajHOWeMItqVJsrFRtU/ncPWNVdJYw3Cfk4bBjAv6Ug3GvpQjKh6R+Ny6E
         Id4XdnpHJjIklNwPmFhYBHs+H2I/8KzbNrdRs/dYA+rNsQiyiCIE7C+z7ZpCLJGGdHDb
         KevA==
X-Gm-Message-State: AOAM533F/GsgUVqCejxJf9euB9Tohf6o2sHmUum4lJ+SwIThtJ7bjqIT
        zhXkbnmEB+S7MTV4hyFcZoxV+A==
X-Google-Smtp-Source: ABdhPJymQLUPe88ARxMqS3lNbvJKlMF+5InpRKJqPr8+V1noWl0rIrIx564WlJPSci0PPS+w5zd0VQ==
X-Received: by 2002:a7b:c759:: with SMTP id w25mr12404907wmk.139.1615547289092;
        Fri, 12 Mar 2021 03:08:09 -0800 (PST)
Received: from dell.default ([91.110.221.204])
        by smtp.gmail.com with ESMTPSA id f126sm1813003wmf.17.2021.03.12.03.08.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 03:08:08 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH 08/10] of: of_net: Demote non-conforming kernel-doc header
Date:   Fri, 12 Mar 2021 11:07:56 +0000
Message-Id: <20210312110758.2220959-9-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210312110758.2220959-1-lee.jones@linaro.org>
References: <20210312110758.2220959-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/of/of_net.c:104: warning: Function parameter or member 'np' not described in 'of_get_mac_address'
 drivers/of/of_net.c:104: warning: expecting prototype for mac(). Prototype was for of_get_mac_address() instead

Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Frank Rowand <frowand.list@gmail.com>
Cc: netdev@vger.kernel.org
Cc: devicetree@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/of/of_net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/of_net.c b/drivers/of/of_net.c
index 6e411821583e4..9b41a343e88ab 100644
--- a/drivers/of/of_net.c
+++ b/drivers/of/of_net.c
@@ -78,7 +78,7 @@ static const void *of_get_mac_addr_nvmem(struct device_node *np)
 	return mac;
 }
 
-/**
+/*
  * Search the device tree for the best MAC address to use.  'mac-address' is
  * checked first, because that is supposed to contain to "most recent" MAC
  * address. If that isn't set, then 'local-mac-address' is checked next,
-- 
2.27.0

