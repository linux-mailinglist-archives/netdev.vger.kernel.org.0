Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56B89563B03
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 22:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbiGAUOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 16:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231995AbiGAUOY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 16:14:24 -0400
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E9AD53EC7;
        Fri,  1 Jul 2022 13:13:48 -0700 (PDT)
Received: by mail-io1-f41.google.com with SMTP id p69so3265270iod.10;
        Fri, 01 Jul 2022 13:13:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DNuTvSAhKqaeh8an0UHIXFque8gigbNFefwCGJLX870=;
        b=7of5dhCcjLlFkNyE0XRR0hgYW755WHhgKc02gobJoYKhkcS9QDQIPbl9yS6dVlPIu4
         kCdP2bakGwyEIHETu95sTTFY4CB57auR+t/R4Kl4spe1PCwBR2mz4yH7Ag37wwN0uM0E
         6U/gNl5grpMi40+2jRYJ6XIJ+mi1KL63Tk6UYnTKJ+RD/Jvz9stel96UdO3vC5S4EKpW
         h77WpouNOV/IFoUxoyfpn7jth5Ya0O1E/1+D3pAQDRLpnqEg0WBy4ebKsnuxUgp1M1uh
         DtxA5CwKl74usTvbKYFt3uLRocpKF/1wunvuWqLmKK/nwtdcHM+ue8ZfAqS37gIzhswt
         MGhg==
X-Gm-Message-State: AJIora8I9FvVzbwj36VnPPP4hQa6l6e4LDtpZ2o7Vbh5GlzzTSuNr0GZ
        Z3dui3afAENvaqaLaz2TSQ==
X-Google-Smtp-Source: AGRyM1vIBtg3Ypbd9CpVxhbsSFzEWn0sS5SvHIidEptWRxBhklVI/Yccx6FHkpkREi2quKrUGor8Ow==
X-Received: by 2002:a05:6638:1415:b0:33c:cc68:993d with SMTP id k21-20020a056638141500b0033ccc68993dmr9593137jad.243.1656706427745;
        Fri, 01 Jul 2022 13:13:47 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id n41-20020a056602342900b00669536b0d71sm10613290ioz.14.2022.07.01.13.13.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 13:13:47 -0700 (PDT)
Received: (nullmailer pid 1443679 invoked by uid 1000);
        Fri, 01 Jul 2022 20:13:45 -0000
Date:   Fri, 1 Jul 2022 14:13:45 -0600
From:   Rob Herring <robh@kernel.org>
To:     Hakan Jansson <hakan.jansson@infineon.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v2 2/5] dt-bindings: net: broadcom-bluetooth: Add
 conditional constraints
Message-ID: <20220701201345.GA1443626-robh@kernel.org>
References: <cover.1656583541.git.hakan.jansson@infineon.com>
 <3591c206eeccdacb8b4e702494d799792b752661.1656583541.git.hakan.jansson@infineon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3591c206eeccdacb8b4e702494d799792b752661.1656583541.git.hakan.jansson@infineon.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jun 2022 14:45:21 +0200, Hakan Jansson wrote:
> Add conditional constraint to make property "reset-gpios" available only
> for compatible devices acually having the reset pin.
> 
> Make property "brcm,requires-autobaud-mode" depend on property
> "shutdown-gpios" as the shutdown pin is required to enter autobaud mode.
> 
> I looked at all compatible devices and compiled the matrix below before
> formulating the conditional constraint. This was a pure paper exercise and
> no verification testing has been performed.
> 
>                                 d
>                                 e
>                                 v h
>                                 i o
>                                 c s
>                             s   e t
>                             h   - -
>                             u   w w       v
>                             t r a a     v d
>                             d e k k     b d
>                             o s e e     a i
>                             w e u u     t o
>                             n t p p     - -
>                             - - - -     s s
>                             g g g g     u u
>                             p p p p t   p p
>                             i i i i x l p p
>                             o o o o c p l l
>                             s s s s o o y y
>     ---------------------------------------
>     brcm,bcm20702a1         X X X X X X X X
>     brcm,bcm4329-bt         X X X X X X X X
>     brcm,bcm4330-bt         X X X X X X X X
>     brcm,bcm4334-bt         X - X X X X X X
>     brcm,bcm43438-bt        X - X X X X X X
>     brcm,bcm4345c5          X - X X X X X X
>     brcm,bcm43540-bt        X - X X X X X X
>     brcm,bcm4335a0          X - X X X X X X
>     brcm,bcm4349-bt         X - X X X X X X
>     infineon,cyw55572-bt    X - X X X X X X
> 
> Signed-off-by: Hakan Jansson <hakan.jansson@infineon.com>
> ---
> V1 -> V2:
>   - New patch added to series
> 
>  .../bindings/net/broadcom-bluetooth.yaml         | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
