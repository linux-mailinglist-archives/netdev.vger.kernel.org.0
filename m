Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED73285A3
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 20:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731329AbfEWSJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 14:09:26 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35154 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731169AbfEWSJZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 14:09:25 -0400
Received: by mail-wr1-f65.google.com with SMTP id m3so7292916wrv.2;
        Thu, 23 May 2019 11:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=z1bHAtbIn7rSn47PzmH0efg4xnX6wgVivQeyJp4q2b0=;
        b=BfW+Ptbz0yweHlXl4q8XNk3KTCoeAneQn1AcFc1LH9Jftou1T+9hajJIXqeiIOOvhx
         A9FrPd+LKczQZEamBkt9TEL69XEBU6uk9eUccMCbM0WwWtvB8jkdfYTcgmeeJp0uLWLH
         hbdZBTtzDfpS9lzZfxAq+CSYfQztc+LxtEwGZUKDcsW82prkYF+h+p90WCGuKgT1nCJC
         VoI0jXoqRCXxtQX5d1sLTocYlpKVGMNrZZPNeTjaNRplBrWp3rdwZlkWuG8yRWnPW+NA
         VXpVLYFXdrY3e+mQT6bUWxTfYHsQLorEVFPcjodVi45qGBWXdUAN6KeTYmjEfIcuz0N3
         kgNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z1bHAtbIn7rSn47PzmH0efg4xnX6wgVivQeyJp4q2b0=;
        b=LsC/QIX72s5EXGxvlrvBc3xcmK9IFzw26Tn/yHgBJJuggz0TBrCTczkmDGveXJdLYx
         scKy8wLoh/iKgggBmOf9TYR/xdSIcBqFAeVwJFGvOOrkAfXEGbv1M0z7g/q2+jIu9+zt
         gdKFjU27wsQGNFEr1xNynfRMXJZ53jphzZHhrLsO8xIvkEN9xUFM2mG3Rfoj4kH2DG+U
         d98fIo82UHDvYBYYL2IwMHsxcVtlHH493+CqE3S15G1J38KMxBws1zcbWWKL3Oxz25Kl
         9UkR5/45g8WVvr4DlCB6yofp92afoXmwHYjSSPvNjiNRkkTV8pVmY0/8ZrLKM91ZWhZa
         ayUQ==
X-Gm-Message-State: APjAAAVePzxa03ToXsu4vD5xYwGypZgTsz47RJ13syf1VqL+K3o3hCl2
        FGFMfNa0DJMhfferzz5MHpoESD5T
X-Google-Smtp-Source: APXvYqw2taeMm2hx3sf4eipJMUoRMrxDqWF1PlN1DCdkzDGCEN6JLPU395wC4e7PGcmnf6yrLUyUng==
X-Received: by 2002:adf:83c5:: with SMTP id 63mr30194086wre.33.1558634962910;
        Thu, 23 May 2019 11:09:22 -0700 (PDT)
Received: from ?IPv6:2003:ea:8be9:7a00:3cd1:e8fe:d810:b3f0? (p200300EA8BE97A003CD1E8FED810B3F0.dip0.t-ipconnect.de. [2003:ea:8be9:7a00:3cd1:e8fe:d810:b3f0])
        by smtp.googlemail.com with ESMTPSA id u2sm42511817wra.82.2019.05.23.11.09.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 11:09:22 -0700 (PDT)
Subject: [PATCH net-next v2 2/3] dt-bindings: net: document new usxgmii phy
 mode
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Madalin-cristian Bucur <madalin.bucur@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
References: <9d284f4d-93ee-fb27-e386-80825f92adc8@gmail.com>
Message-ID: <60079a09-670b-268e-9ad5-014a427b60bf@gmail.com>
Date:   Thu, 23 May 2019 20:07:56 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <9d284f4d-93ee-fb27-e386-80825f92adc8@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new interface mode USXGMII to binding documentation.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
v2:
- binding documentation change added to the series
---
 Documentation/devicetree/bindings/net/ethernet.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet.txt b/Documentation/devicetree/bindings/net/ethernet.txt
index e88c3641d..5475682bf 100644
--- a/Documentation/devicetree/bindings/net/ethernet.txt
+++ b/Documentation/devicetree/bindings/net/ethernet.txt
@@ -43,6 +43,7 @@ Documentation/devicetree/bindings/phy/phy-bindings.txt.
   * "rxaui"
   * "xaui"
   * "10gbase-kr" (10GBASE-KR, XFI, SFI)
+  * "usxgmii"
 - phy-connection-type: the same as "phy-mode" property but described in the
   Devicetree Specification;
 - phy-handle: phandle, specifies a reference to a node representing a PHY
-- 
2.21.0


