Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0FA4C500A
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 21:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237632AbiBYUtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 15:49:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237924AbiBYUru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 15:47:50 -0500
Received: from mail.z3ntu.xyz (mail.z3ntu.xyz [128.199.32.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C7D22502E;
        Fri, 25 Feb 2022 12:47:17 -0800 (PST)
Received: from g550jk.localnet (ip-213-127-118-180.ip.prioritytelecom.net [213.127.118.180])
        by mail.z3ntu.xyz (Postfix) with ESMTPSA id 21F40C85A1;
        Fri, 25 Feb 2022 20:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=z3ntu.xyz; s=z3ntu;
        t=1645822036; bh=DPMNliML3ukNNsPck65ZNcLxh30N28NKU6yWkFqvS2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Prss4QVVwnNIJUOR/RLiPzTLs5wIOGNLszoBL6kxYRbqzxUYMQdukkVbcpOEds7Yj
         ZpwsAnV2LwHqwbn61bFDe1Ka5xQLotocuoSheyROECiUJqy2VoKZYqIIONrZV0Ym59
         XuvbR6YdMgsatLAzZXJrLKHG1vuXIMmaGWdwd6/A=
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
Date:   Fri, 25 Feb 2022 21:47:15 +0100
Message-ID: <4690803.GXAFRqVoOG@g550jk>
In-Reply-To: <20220225204138.935022-1-luca@z3ntu.xyz>
References: <20220225204138.935022-1-luca@z3ntu.xyz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        PDS_OTHER_BAD_TLD,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Freitag, 25. Februar 2022 21:41:37 CET Luca Weiss wrote:
> Document the compatible string for BCM43430A0 bluetooth used in lg-lenok
> and BCM43430A1 used in asus-sparrow.
> 
> Signed-off-by: Luca Weiss <luca@z3ntu.xyz>

The previous version with just BCM43430A0 the patch collected the following 
tags:

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Rob Herring <robh@kernel.org>

Not sure if with the changes I can keep them.

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




