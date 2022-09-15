Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2E95BA135
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 21:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiIOT0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 15:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiIOTZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 15:25:54 -0400
Received: from mail.z3ntu.xyz (mail.z3ntu.xyz [128.199.32.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC5EC38479;
        Thu, 15 Sep 2022 12:25:51 -0700 (PDT)
Received: from g550jk.localnet (31-151-115-246.dynamic.upc.nl [31.151.115.246])
        by mail.z3ntu.xyz (Postfix) with ESMTPSA id 9A3F3C17AF;
        Thu, 15 Sep 2022 19:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=z3ntu.xyz; s=z3ntu;
        t=1663269949; bh=pG6rNu+xBVtdF6lIbK5/MTm5x53xJnK8SaUNXzXLpiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=ZnuEvWhUqWz1yGuHuWH7Ym9xDE/mlMVABda1gLNAb1Oh2veqg7RICtgi15aakUegp
         edoR2gF/bHDa6rx8r17gvs3NQYnQ3i6prEPOkfu17ysAJeP9fAcc3FwRD8IDZuSBU7
         ei/DPpTER44TZPojnpMgR/Gz/5EVeBHve19SkPcI=
From:   Luca Weiss <luca@z3ntu.xyz>
To:     linux-arm-msm@vger.kernel.org
Cc:     ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        marcel@holtmann.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] dt-bindings: bluetooth: broadcom: add BCM43430A0 & BCM43430A1
Date:   Thu, 15 Sep 2022 21:25:49 +0200
Message-ID: <2956343.mvXUDI8C0e@g550jk>
In-Reply-To: <20220225204138.935022-1-luca@z3ntu.xyz>
References: <20220225204138.935022-1-luca@z3ntu.xyz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        PDS_OTHER_BAD_TLD,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

On Freitag, 25. Februar 2022 21:41:37 CEST Luca Weiss wrote:
> Document the compatible string for BCM43430A0 bluetooth used in lg-lenok
> and BCM43430A1 used in asus-sparrow.
> 
> Signed-off-by: Luca Weiss <luca@z3ntu.xyz>

Can someone please apply this patch? It still seems to apply without fuzz.

Regards
Luca

> ---
> Changes in v2:
> - add bcm43430a1 too, adjust commit message to reflect that
> 
>  Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
> b/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml index
> 5aac094fd217..dd035ca639d4 100644
> --- a/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
> +++ b/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
> @@ -19,6 +19,8 @@ properties:
>        - brcm,bcm4329-bt
>        - brcm,bcm4330-bt
>        - brcm,bcm4334-bt
> +      - brcm,bcm43430a0-bt
> +      - brcm,bcm43430a1-bt
>        - brcm,bcm43438-bt
>        - brcm,bcm4345c5
>        - brcm,bcm43540-bt




