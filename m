Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 805C32E0538
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 05:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbgLVECG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 23:02:06 -0500
Received: from mail-oi1-f170.google.com ([209.85.167.170]:46724 "EHLO
        mail-oi1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbgLVECF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 23:02:05 -0500
Received: by mail-oi1-f170.google.com with SMTP id q205so13456681oig.13;
        Mon, 21 Dec 2020 20:01:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ww/zGSC3PEvJtOMfeswjOnuHgN6OVeMi/BWgMwdkPTo=;
        b=hElIWTZdJ8sVsA+XmjNtsQ2kkuIgUPheD/72KGd2nBXzf+9vsZlpr06ATL/Id6ui+y
         Tez2LM0JpwsQu+33OxKTHBDK/ji/jRQ2f/WGURQBuwn4o37ti2JqvQIgXAknXSKlZzQD
         hoc9BK9qDEZ09BpprpvwRrNa2qo2STrJq6jOVqVwTFT2ia+03sWr3wT6g37zvKc3JktM
         c5XVYOAJ3fODTD8HQoBcuwYR3iPjfE5Wft4HLnorLvYwmXDJeilkiwZ3i0YFUS6NF0/V
         NvJNtIQceh9Yr5JlK7e2BUCJZ/qqu5PqG832Ot1j0PvyKGIzwoc192E68M1ZAA50EQsV
         vv8w==
X-Gm-Message-State: AOAM533hv0jweev83OWEnlncWTIMTp6+yNSg8R8feoRsOciAXcDll38g
        G9JuE+KAvbv3QYPqSlQZkawwcDBr6g==
X-Google-Smtp-Source: ABdhPJzOtBcRwErYwDAgOk1doNr8YVJw5jAmYzxYzVn64tH9uQ/u9mYsaRCyBaZGXlaREOglFnnkxQ==
X-Received: by 2002:aca:1004:: with SMTP id 4mr13331771oiq.4.1608609684079;
        Mon, 21 Dec 2020 20:01:24 -0800 (PST)
Received: from xps15.herring.priv ([64.188.179.253])
        by smtp.googlemail.com with ESMTPSA id y65sm3741695oie.39.2020.12.21.20.01.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 20:01:23 -0800 (PST)
From:   Rob Herring <robh@kernel.org>
To:     devicetree@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alex Elder <elder@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH] dt-bindings: net: qcom,ipa: Drop unnecessary type ref on 'memory-region'
Date:   Mon, 21 Dec 2020 21:01:21 -0700
Message-Id: <20201222040121.1314370-1-robh@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'memory-region' is a common property, so it doesn't need a type ref here.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Alex Elder <elder@kernel.org>
Cc: netdev@vger.kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
---
I'll take this via the DT tree.

 Documentation/devicetree/bindings/net/qcom,ipa.yaml | 1 -
 1 file changed, 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/qcom,ipa.yaml b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
index d0cbbcf1b0e5..8a2d12644675 100644
--- a/Documentation/devicetree/bindings/net/qcom,ipa.yaml
+++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
@@ -121,7 +121,6 @@ properties:
       receive and act on notifications of modem up/down events.
 
   memory-region:
-    $ref: /schemas/types.yaml#/definitions/phandle-array
     maxItems: 1
     description:
       If present, a phandle for a reserved memory area that holds
-- 
2.27.0

