Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4C1610D01
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 11:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbiJ1JXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 05:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiJ1JXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 05:23:45 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD7AF1C6BE2;
        Fri, 28 Oct 2022 02:23:43 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 5CDF2100004;
        Fri, 28 Oct 2022 09:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1666949022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yUTicOKbv8RLfweIGmVZD1Tj8qID+/JKOtCLRTZ7HEw=;
        b=GgLB/cY0PTTTpDraZEpGuHtzKP09501pylMj5lbIDeb4S2DiIuv28h/SJGwaaYV/f3MdE3
        xRC6d20K9gUgEk/NMw2ad+5IP7bOJ2IF4ilUMYnNhswVDAhrmDwsaQ9EiQkGKn16nBifN8
        V4FGhr5VzLLPQ5+ct5fIBPo/y/kR9wWOPzipZJHEEoF9VKaYKyfkOhj5im+qnz9NzA6UzY
        h05VUASaLn8LxzCF3A1+v20MNdXLqiAdN2Ddw/pl5X7zDNW/UxtmACDnEkJ9xzXZQj/M1j
        PRhklCb2J2YuXQLzu/1IEYXxBoUybzxl/VIx6MkTl3/ACotgnObmqKOh+Go3Sw==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        devicetree@vger.kernel.org
Cc:     Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Robert Marko <robert.marko@sartura.hr>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Michael Walle <michael@walle.cc>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 1/5] dt-bindings: vendor-prefixes: Add ONIE
Date:   Fri, 28 Oct 2022 11:23:33 +0200
Message-Id: <20221028092337.822840-2-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221028092337.822840-1-miquel.raynal@bootlin.com>
References: <20221028092337.822840-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As described on their website (see link below),

   "The Open Network Install Environment (ONIE) is an open source
    initiative that defines an open “install environment” for modern
    networking hardware."

It is not a proper corporation per-se but rather more a group which
tries to spread the use of open source standards in the networking
hardware world.

Link: https://opencomputeproject.github.io/onie/
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---

Please note ONIE is not a "company" but rather more an open source
group. I don't know if there will be other uses of this prefix but I
figured out it would be best to describe it to avoid warnings, but I'm
open to other solutions otherwise.

 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 6e323a380294..65a74026cf2b 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -927,6 +927,8 @@ patternProperties:
     description: One Laptop Per Child
   "^oneplus,.*":
     description: OnePlus Technology (Shenzhen) Co., Ltd.
+  "^onie,.*":
+    description: Open Network Install Environment group
   "^onion,.*":
     description: Onion Corporation
   "^onnn,.*":
-- 
2.34.1

