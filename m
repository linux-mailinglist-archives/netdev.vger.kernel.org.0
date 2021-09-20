Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 387AB410EC3
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 05:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234515AbhITDMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 23:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231892AbhITDM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Sep 2021 23:12:29 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 192B1C0617BD;
        Sun, 19 Sep 2021 20:10:23 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id y8so14897803pfa.7;
        Sun, 19 Sep 2021 20:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kcXtoLmYt2phW1mwUUg+pkx0ARAiF/TyvXAFksE2SBQ=;
        b=pFlrtsqNO9qXwFt7kVRJc3jd1jIT/rtb8ePyXwe1f5FtWfdxdXDUNIrPR50+7rYSyo
         MfoiSV6RnhAsp7qzYXl7Ld1REg38NbZNBCfcbEfgH/KgDw5hE2i1MGbE0eQj6e7+XNhq
         f1m9hWdjFYTOYFV7Y8dAkfTk3HT+8WQLcRfJOBfHZ8sIsdRvzVUepchC03JmcJ+b86zm
         E7rM5LxE6urcvQBRCMITMWiuzvFDi62VwQUhhFqi5FfFd5xHsLdE8ARSPXmokNuKqXfO
         d5bN4p6nDH/RkpJUfoqQZchoFoHz9aW8tA8Mwkpc2NvpOmsSxVtvNHMDHmTETLoyhTQl
         TwGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kcXtoLmYt2phW1mwUUg+pkx0ARAiF/TyvXAFksE2SBQ=;
        b=xBTmMptq3rdLWnuD/zKE1pqRmh/RDGiyjFlGfZSU7jo2Ltn8nwCIVgDYLmT1mOupZJ
         qSFSfaW/Ob5N4VMu4BOF+zUdobGkGl0zu5VQYpFsMcYVBSNgMI88OSKoOsdtq3fphrs1
         Pwauohyl6maos8Yv7KOD0epo0SJi1Iyz3GJcr+zsvdVhs5ew55IVpxFdPZfItfEpHVKm
         kuYVAT6G6QYk7D7RAmoW/gQbf1iTkyQTzAYq3b3c9eICYh2jePuPV2jB2+mkZQCLlKtn
         PbBEa6F+3T/IW3ReZeE5yKAzYn1bQRH0XK+F24aE+qWxxTrqGk97cQCfBz2c57grLdBa
         3T6g==
X-Gm-Message-State: AOAM530/SX2DfVaT3wReLpxQ4vF1lxxfEo3rDrlJ3k9tc268sOfeA3/r
        dTY00NPQ8O/CAhWApWJibe5bSWSDPeVuS+Zi
X-Google-Smtp-Source: ABdhPJy+NEw+sEBgIWaA+ZDckq/1cv/4xFeVi9rF+KOct7Jo17tYOoW1t+YKJqTU2FMS6+04RcQxJg==
X-Received: by 2002:a63:dd51:: with SMTP id g17mr21385975pgj.47.1632107422430;
        Sun, 19 Sep 2021 20:10:22 -0700 (PDT)
Received: from skynet-linux.local ([106.201.127.154])
        by smtp.googlemail.com with ESMTPSA id l11sm16295065pjg.22.2021.09.19.20.10.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Sep 2021 20:10:22 -0700 (PDT)
From:   Sireesh Kodali <sireeshkodali1@gmail.com>
To:     phone-devel@vger.kernel.org, ~postmarketos/upstreaming@lists.sr.ht,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, elder@kernel.org
Cc:     Sireesh Kodali <sireeshkodali1@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS)
Subject: [RFC PATCH 17/17] dt-bindings: net: qcom,ipa: Add support for MSM8953 and MSM8996 IPA
Date:   Mon, 20 Sep 2021 08:38:11 +0530
Message-Id: <20210920030811.57273-18-sireeshkodali1@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920030811.57273-1-sireeshkodali1@gmail.com>
References: <20210920030811.57273-1-sireeshkodali1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MSM8996 uses IPA v2.5 and MSM8953 uses IPA v2.6l

Signed-off-by: Sireesh Kodali <sireeshkodali1@gmail.com>
---
 Documentation/devicetree/bindings/net/qcom,ipa.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/qcom,ipa.yaml b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
index b8a0b392b24e..e857827bfa54 100644
--- a/Documentation/devicetree/bindings/net/qcom,ipa.yaml
+++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
@@ -44,6 +44,8 @@ description:
 properties:
   compatible:
     enum:
+      - qcom,msm8953-ipa
+      - qcom,msm8996-ipa
       - qcom,msm8998-ipa
       - qcom,sc7180-ipa
       - qcom,sc7280-ipa
-- 
2.33.0

