Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF089370F95
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 01:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232696AbhEBXIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 19:08:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232543AbhEBXIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 19:08:14 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E15BC06174A;
        Sun,  2 May 2021 16:07:21 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id di13so4288779edb.2;
        Sun, 02 May 2021 16:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ffA750f2MevOaBc6ScKeZYtWjDObG1Cn21hSXSP5XoE=;
        b=salxQnBfHfZ+8lBNl3knCOIkFoS41jgGlkiEo/DHXN58/416RtTB0vnOk9JoKw2V1y
         9vUwMuef5yk7gh/A32wLYy2sO6xl24yL+siL3eb23HK5Zts5dzmPkaJ7kx1m8Abnpgdo
         499G5hGINcdsPhfzZ5DI/M70DPVTcrzwW+Br5RJ9fQvqisMB6/IQB+onhUDVLPL35gW3
         QwNADvYm45IRbFHZoxjuREyoyEH4rS1bLWbP/OHtczIBk17pDSVHUOf3aRFRCCQZt8qq
         2Gn8wOUsqJrUOG0TFuRoU0KQsheUr0fnNk67DZxT5wTbwyTAckl6uZYRx4Ag2WcqNRiY
         l/sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ffA750f2MevOaBc6ScKeZYtWjDObG1Cn21hSXSP5XoE=;
        b=oz7TxxvucVqpwKXwRtE73MCWhtegRChspukrpu5Gak77s07nMBNjS1Su9q1zNHcSCQ
         lLe6pY36Nrh7X37hav7Mp9goq2jE8NDEvPm4VE3grswh7seTEC82BpsTbj889Sw2BWls
         3/t3ZngPD5KIbARFVvVVCYsc53SrFOhPrZqTAGMp7G9KcOEoT0On3Zz0hw4A3l1XXjXc
         amUsZVFMKCZ4/6jeZ3iTmH2VuI5EQBglRv7+3Zq5WqI1X19Mf2lvJPF4q47KMF8YIYT1
         IwIoTXGCUyuaznBB+ux+fMZMNaOXqg4XrTt+WHlVmSG/KGe8doXs2oAAPcaA+Eg1N1K0
         JCQw==
X-Gm-Message-State: AOAM532OlmQGRFiuwxvEN0iRXvmqGVg+zfZJYuTejLw6riymWsMCrpqM
        eZhjvFYbn1ap5gHYANF86/w=
X-Google-Smtp-Source: ABdhPJwrOzaho1ueCwq0iqPs4ck2EyxStsADytmvBZ6EnTiKqhreT2U2RRFgJGj2AantgbdSx+xWcA==
X-Received: by 2002:a05:6402:16db:: with SMTP id r27mr16300790edx.375.1619996840252;
        Sun, 02 May 2021 16:07:20 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id z17sm10003874ejc.69.2021.05.02.16.07.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 May 2021 16:07:20 -0700 (PDT)
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
Subject: [RFC PATCH net-next v2 06/17] devicetree: net: dsa: qca8k: Document new compatible qca8327
Date:   Mon,  3 May 2021 01:06:58 +0200
Message-Id: <20210502230710.30676-6-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502230710.30676-1-ansuelsmth@gmail.com>
References: <20210502230710.30676-1-ansuelsmth@gmail.com>
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

