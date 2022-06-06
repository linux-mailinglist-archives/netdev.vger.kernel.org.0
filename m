Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70E1853E628
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232695AbiFFJTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 05:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232675AbiFFJTp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 05:19:45 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E661936167
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 02:19:43 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id fd25so17949638edb.3
        for <netdev@vger.kernel.org>; Mon, 06 Jun 2022 02:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=timesys-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WfatQurfzUyeIwaygR9NoamRL0upxmFP0qhzi6td6wk=;
        b=uuZAygrqpoeeHrb0YGxhf76lo4YUB10rQmgUBEW4lc4xQi4X7h3rLsl2pa2xTFe+Wl
         sQqClYNrZk7m2NBtwX2pEf7PtCiYp8EOYM5IK+Hg+/Jj8/EpasMZeQbk+dD6VPgAXO0y
         NquOZEhu4iop5klVRxZyksXvGs8Rkfbwjv4ZopIJ1Z6XHFeAFvBLb8EfykoMgoc1TG7i
         4EhtHMnLFTg/GDnZ7vI9ovi5mjTo+PicC3zb5EmQCqcIBwmgWC2mTVn+/2Gj7fcsO2kr
         ZDiJh90dWx67QvMKwDp+rJ6zu1ARNayyu72WsuVSnV/wVVWBZQ6lUEbIz8dn9R+yhmb7
         E91g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WfatQurfzUyeIwaygR9NoamRL0upxmFP0qhzi6td6wk=;
        b=GyMb94HBSu40t4du9bTYuJ8Dpc/TwAIzgIgEIDL+fQFPKvQ2i3BJVOq3SurRTVkLp9
         dEWZryFTB0+nL18nBp+FX4O/WVhzWexTu4v0YpsPzQySTLzHkr1o3tZKQ+AuCbc7lCNY
         mChPumxh4JOuLivNnknEXW99hc8vBICpUisQmvNOodPG66+LkAweOQzBo+RLL5/3k+Q1
         CT/V4I5Atjel/s/zKWv5qZcGtXiMYyqXonXbzKfm3T5jBQNcUqigqskamjDut32EKbOq
         7R/JKdAnrEWA5HMomRDd5klwRM+qZCF4Wh4bbmJX2itZDCvBCEsSYqfhhVRzIpfujtkh
         +L7A==
X-Gm-Message-State: AOAM533NcTR2YhM9rMKtb+uvfmSbEr24/6M2mizqGbrE3vPO5AEcmDBT
        zYPouVTGo4xANMRIn600BDrHO0cT8WchMxoP
X-Google-Smtp-Source: ABdhPJyVoMdLyZT2U16Z1hyr4dfV1YB0084qGD0TaXvToMlrfXWEKvJhMnCDSPR/wHhoRP9VZqCAIA==
X-Received: by 2002:aa7:d441:0:b0:431:486b:2573 with SMTP id q1-20020aa7d441000000b00431486b2573mr7915018edr.60.1654507182529;
        Mon, 06 Jun 2022 02:19:42 -0700 (PDT)
Received: from localhost.localdomain (host-95-233-234-242.retail.telecomitalia.it. [95.233.234.242])
        by smtp.gmail.com with ESMTPSA id hz14-20020a1709072cee00b00708e906faecsm5626503ejc.124.2022.06.06.02.19.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 02:19:42 -0700 (PDT)
From:   Angelo Dureghello <angelo.dureghello@timesys.com>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     rmk+kernel@armlinux.org.uk, netdev@vger.kernel.org,
        Angelo Dureghello <angelo.dureghello@timesys.com>
Subject: [PATCH] Documentation/bindings: net: fix sfp mod-def0 signal
Date:   Mon,  6 Jun 2022 11:18:52 +0200
Message-Id: <20220606091852.955435-1-angelo.dureghello@timesys.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Checked both by driver code and functionally, module plug works
when gpio is set as GPIO_ACTIVE_LOW.

Signed-off-by: Angelo Dureghello <angelo.dureghello@timesys.com>
---
 Documentation/devicetree/bindings/net/sff,sfp.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/sff,sfp.txt b/Documentation/devicetree/bindings/net/sff,sfp.txt
index 832139919f20..101a025a0c0f 100644
--- a/Documentation/devicetree/bindings/net/sff,sfp.txt
+++ b/Documentation/devicetree/bindings/net/sff,sfp.txt
@@ -13,7 +13,7 @@ Required properties:
 Optional Properties:
 
 - mod-def0-gpios : GPIO phandle and a specifier of the MOD-DEF0 (AKA Mod_ABS)
-  module presence input gpio signal, active (module absent) high. Must
+  module presence input gpio signal, active (module absent) low. Must
   not be present for SFF modules
 
 - los-gpios : GPIO phandle and a specifier of the Receiver Loss of Signal
-- 
2.36.1

