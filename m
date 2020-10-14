Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A08F228DAF0
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 10:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728865AbgJNIOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 04:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728671AbgJNIOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 04:14:39 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE266C045864;
        Tue, 13 Oct 2020 22:46:06 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id j8so965806pjy.5;
        Tue, 13 Oct 2020 22:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7Rp+G8DZZhkfAL9cWtudlZ9LPgIaBKBM+aO/cPwol6M=;
        b=EjuzKISfcRwMWyuJ84hl/XIJfHvlfJtu96k58Vd9ubhMhpEFiRfC9GsSebnHufk/uy
         a3EU7kZEMPLz25Z7fhNUxlaSI/z4kUMYu9ne6sL/z8Esf0JI12kYuW2kU2rkz2oPmqkZ
         wtJKtf40mq/DV5UlnLh0HBPZ7cyJRIk052ARvv3ibKMrSl9L/Zup6T1mYQ0RPmPSRcZA
         9yKsABLLcLSq30LFCmvB/XFxV+iM5tyAdA+HwBHyF8i87+yMbLyER/ht4R2co0j7MiHE
         fFLCUShHi0Ymuh6AwORttGuCm0sPcb40atx8eHYk8yTR/arA9J6j0emw0Qq2MKLa/pq9
         Tecg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7Rp+G8DZZhkfAL9cWtudlZ9LPgIaBKBM+aO/cPwol6M=;
        b=VmRQv824paPnnKjFoWhZkQg6KIg/YqaFfKmfOE23sWi+2h2FrHtYjOf7pqastqAg3z
         lJBUOCJGq5npLeCGqUNWwN++lgtkjKUfj/85ChaG7lZ/nn+cl7FEhzve84u30oz9S4gb
         u4o8KYddqNWtj2QWhkP/FWah1NccSFwMc50u7r6Zxv5eDBXv3qMTr61YICiD4PUEvmNs
         Fz40Q3lKctNQp6iBmFqp7y1TQzq5Q2duAp79hFFrbKHLNUGMZkUjs32+zwQ675PU/srQ
         MEfgs8N3cQHoKh4s/TD0lVkiZViR9VFRf2c6+FqJkcQDQzuxvNRg0vuO9drCXyQ2EtD8
         A20A==
X-Gm-Message-State: AOAM5309t1bLiJVxAGFbm6YP5oToru01FVEF/4w0lU/egxuWhw5ahAbc
        L/xWVGmD9LloXMJtO1MPQmE=
X-Google-Smtp-Source: ABdhPJxIt969XM2Lx9QtYISAlFDV3pi3XqyjKgkyokQT7WD3SyoIh5WPzQAIxlulAvwbLXckBylbew==
X-Received: by 2002:a17:90b:3841:: with SMTP id nl1mr1978234pjb.69.1602654366301;
        Tue, 13 Oct 2020 22:46:06 -0700 (PDT)
Received: from HVD6JC2.Broadcom.net ([192.19.252.250])
        by smtp.gmail.com with ESMTPSA id w187sm1620996pfb.93.2020.10.13.22.46.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2020 22:46:05 -0700 (PDT)
From:   Amitesh Chandra <amitesh.chandra@gmail.com>
To:     davem@davemloft.net, robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     amitesh.chandra@broadcom.com, ravi.nagarajan@broadcom.com,
        cheneyni@google.com
Subject: [PATCH 2/3] dt-bindings: net: bluetooth: Add broadcom BCM4389 support
Date:   Wed, 14 Oct 2020 11:15:43 +0530
Message-Id: <20201014054543.2457-1-amitesh.chandra@gmail.com>
X-Mailer: git-send-email 2.28.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amitesh Chandra <amitesh.chandra@broadcom.com>

Add bindings for BCM4389 bluetooth controller.

Signed-off-by: Amitesh Chandra <amitesh.chandra@broadcom.com>
---
 Documentation/devicetree/bindings/net/broadcom-bluetooth.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt b/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt
index 4fa00e2..ae48e42 100644
--- a/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt
+++ b/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt
@@ -14,6 +14,7 @@ Required properties:
    * "brcm,bcm4330-bt"
    * "brcm,bcm43438-bt"
    * "brcm,bcm4345c5"
+   * "brcm,bcm4389-bt"
 
 Optional properties:
 
-- 
2.7.4

