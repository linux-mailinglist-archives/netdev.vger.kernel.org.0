Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8F6250D205
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 15:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234357AbiDXNYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 09:24:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234802AbiDXNYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 09:24:02 -0400
X-Greylist: delayed 323 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 24 Apr 2022 06:21:01 PDT
Received: from ixit.cz (ip-94-112-206-30.net.upcbroadband.cz [94.112.206.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E0C327CD7
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 06:21:01 -0700 (PDT)
Received: from localhost.localdomain (unknown [185.14.232.186])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ixit.cz (Postfix) with ESMTPSA id 4E2392007F;
        Sun, 24 Apr 2022 15:15:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ixit.cz; s=dkim;
        t=1650806133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=zPQBmF6RCri6FaOeXB4uCyYG7fLRcwk0ijBNbmDhGyI=;
        b=FW803gmT7/vhnipM26391eda+F4hv/rsvEAPtF+UiR8BmsjvZHJlYqmVsalxuvuPiFgYkV
        fjSOP5TvQkclAlXIUTS4W2ABpWlC/++Avi/M0sspYsOaspNOmvQ/K9jXChl3xZ6zZsjJwt
        5LL84YgU2PpCdOihkNndpqFGmkpc3MA=
From:   David Heidelberg <david@ixit.cz>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Alex Elder <elder@kernel.org>
Cc:     David Heidelberg <david@ixit.cz>, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] dt-bindings: net: qcom,ipa: fix example for upcomming smp2p conversion
Date:   Sun, 24 Apr 2022 15:15:19 +0200
Message-Id: <20220424131522.14185-1-david@ixit.cz>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RDNS_DYNAMIC,SPF_HELO_PASS,
        SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Example of mpss was missing required properties.

Signed-off-by: David Heidelberg <david@ixit.cz>
---
 Documentation/devicetree/bindings/net/qcom,ipa.yaml | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/qcom,ipa.yaml b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
index 58ecc62adfaa..852658b4d05c 100644
--- a/Documentation/devicetree/bindings/net/qcom,ipa.yaml
+++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
@@ -182,6 +182,11 @@ examples:
 
         smp2p-mpss {
                 compatible = "qcom,smp2p";
+                mboxes = <&apss_shared 14>;
+                qcom,smem = <435>, <428>;
+                qcom,local-pid = <0>;
+                qcom,remote-pid = <1>;
+
                 ipa_smp2p_out: ipa-ap-to-modem {
                         qcom,entry-name = "ipa";
                         #qcom,smem-state-cells = <1>;
-- 
2.35.1

