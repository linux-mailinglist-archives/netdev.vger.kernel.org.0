Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDE3373265
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 00:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233227AbhEDWas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 18:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233165AbhEDWal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 18:30:41 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A238C061761;
        Tue,  4 May 2021 15:29:44 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id i24so12268571edy.8;
        Tue, 04 May 2021 15:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ffA750f2MevOaBc6ScKeZYtWjDObG1Cn21hSXSP5XoE=;
        b=LP4Qu59OMAK4oko/pxoEEF7o2BUnML4j3WODAnv1SJ9hikLWsB/3g14f0kOcZDjwLt
         +ZwtS7YPBX637bcIzenB1BFcaQujLsh3p3D2OVySx8Bpm/r1ESRuTXA70Fne7Ipbal0W
         FKZBO+KmrLZiYCTo9YqBo22ZvVWPBVf/bFY2jMZQ4DDtWNn9esBUM1II7TJ8C0/cwGTY
         XGlEQ5U0NKOkl5T43BYZuPmDmLpOM08l78eLwGIHV1loMjE/8goD3g6llBHJabteldhb
         Ac/IEyv4dYTiij6gd+xS/AxO+dOYAfJu1+ne9dY78vGp4aXTcRhwkyZHLzpaHhrrQuS3
         b/3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ffA750f2MevOaBc6ScKeZYtWjDObG1Cn21hSXSP5XoE=;
        b=Ytdf3ki3Z893sVz00uaP2BrfscL81sFEFgnf39RgX74GYGUf5tlxdiWsJ8doOrHCv9
         OCm7a+9hgp6+jqhPF2TwzkrgnCRF9j1mfR5LMyo5XYAr+HsAWeNQBZe6rvKYmOHVSCKG
         gCew/P/TG8xfkoTSxD+dUb/0y8hmNJ/SOy2RA+ITz3/cdZnUyKnT+K/l84YKrybpVNae
         Yx0HF6yDYqiH9846kjILYiXVS2iU0/57gHf0hcrY1u/smLwopM4YS2BO3LG7IjOGv23S
         QTs8kgeqig4RYv1x0TW4hNmrQ5+1xm9bRjDoS7+YYSWwzu2xmXRUu/17tCLSAfqOfQ7M
         OoPQ==
X-Gm-Message-State: AOAM5333yUrj6+OfUGuxjSv6bVTeGAfGKXGJ6zXhAsPjJDvBZX0Ya+HR
        y9z7Hv8FaWekGZL2ohxsTVY=
X-Google-Smtp-Source: ABdhPJyuk5osEZmL0qIvAB4XzQPl+ojOKSgJFh86CP+0OugFsSrTixLr5AqS18qi3zGbvyO09nYOsg==
X-Received: by 2002:aa7:c2d2:: with SMTP id m18mr27785539edp.96.1620167383174;
        Tue, 04 May 2021 15:29:43 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id q12sm2052946ejy.91.2021.05.04.15.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 15:29:42 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v3 09/20] devicetree: net: dsa: qca8k: Document new compatible qca8327
Date:   Wed,  5 May 2021 00:29:03 +0200
Message-Id: <20210504222915.17206-9-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210504222915.17206-1-ansuelsmth@gmail.com>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for qca8327 in the compatible list.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/qca8k.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
index ccbc6d89325d..1daf68e7ae19 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
@@ -3,6 +3,7 @@
 Required properties:
 
 - compatible: should be one of:
+    "qca,qca8327"
     "qca,qca8334"
     "qca,qca8337"
 
-- 
2.30.2

