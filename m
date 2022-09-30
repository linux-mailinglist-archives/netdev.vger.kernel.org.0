Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC425F0DB4
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 16:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbiI3OiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 10:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbiI3Oh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 10:37:59 -0400
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E208C1A88E2;
        Fri, 30 Sep 2022 07:37:58 -0700 (PDT)
Received: by mail-oi1-f178.google.com with SMTP id s125so4944296oie.4;
        Fri, 30 Sep 2022 07:37:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=jevZr+HvLkIfabkJ9RHCFEAmFsQ/4U9+lScQ8KdTR4U=;
        b=pUBWgz0dR2M+dt4QpXi3rK2yssu4mME5nkCe81RQnoXcU+/1k3tCxPqqbs3hZYe0mX
         ekuW8EPFkBkhRhNgz8N1w/H1S3oU652DZ7KL9V0yzpYuOQD8WcEVCS3IvwbS3ew96ylc
         7EUTNF2zp7mBCDSm6ZFIKApp7uFPGWMovCsZylHNmDv4pdDjzBMk5gjfb9r0nvWJcc4E
         p3UqTXwDofVh90NtcbissDBVthGxMhtVe9xw+gdef31RKsuMmQn8/jWOSYGdaNqp1oRo
         SLEhTBg5rU+H0YRF2ojQAMXpwwXq+VzDyjacdUqP1OVJMURqmjJiGSZNSMIWrou8RseK
         /Thw==
X-Gm-Message-State: ACrzQf1Z14573MfJkFmadpaLdqKCkvuv+s62kQNKXRBzBv8NASel0QYC
        Qv1iouMqbBXgIfUJK72Mln9r382wvQ==
X-Google-Smtp-Source: AMsMyM5kZfkX/Nv7QtAjvly/AOG7XEZvqZmaaiCf9ocGcxeyK9zp/9aBEfwE7rKFBEIa44M8yyWlCQ==
X-Received: by 2002:a05:6808:19a:b0:34f:ddfc:5986 with SMTP id w26-20020a056808019a00b0034fddfc5986mr3930580oic.30.1664548677906;
        Fri, 30 Sep 2022 07:37:57 -0700 (PDT)
Received: from macbook.herring.priv (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id g26-20020a056830161a00b00616d25dc933sm606700otr.69.2022.09.30.07.37.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 07:37:57 -0700 (PDT)
Received: (nullmailer pid 281631 invoked by uid 1000);
        Fri, 30 Sep 2022 14:37:56 -0000
Date:   Fri, 30 Sep 2022 09:37:56 -0500
From:   Rob Herring <robh@kernel.org>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        devicetree@vger.kernel.org, Madalin Bucur <madalin.bucur@nxp.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next v5 2/9] dt-bindings: net: Add Lynx PCS binding
Message-ID: <166454867358.281536.13914577954285422823.robh@kernel.org>
References: <20220926190322.2889342-1-sean.anderson@seco.com>
 <20220926190322.2889342-3-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926190322.2889342-3-sean.anderson@seco.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Sep 2022 15:03:14 -0400, Sean Anderson wrote:
> This binding is fairly bare-bones for now, since the Lynx driver doesn't
> parse any properties (or match based on the compatible). We just need it
> in order to prevent the PCS nodes from having phy devices attached to
> them. This is not really a problem, but it is a bit inefficient.
> 
> This binding is really for three separate PCSs (SGMII, QSGMII, and XFI).
> However, the driver treats all of them the same. This works because the
> SGMII and XFI devices typically use the same address, and the SerDes
> driver (or RCW) muxes between them. The QSGMII PCSs have the same
> register layout as the SGMII PCSs. To do things properly, we'd probably
> do something like
> 
> 	ethernet-pcs@0 {
> 		#pcs-cells = <1>;
> 		compatible = "fsl,lynx-pcs";
> 		reg = <0>, <1>, <2>, <3>;
> 	};
> 
> but that would add complexity, and we can describe the hardware just
> fine using separate PCSs for now.
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
> 
> Changes in v5:
> - New
> 
>  .../bindings/net/pcs/fsl,lynx-pcs.yaml        | 40 +++++++++++++++++++
>  1 file changed, 40 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/pcs/fsl,lynx-pcs.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
