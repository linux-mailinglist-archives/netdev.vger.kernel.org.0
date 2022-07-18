Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBFC5789B6
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 20:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236038AbiGRSoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 14:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236035AbiGRSoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 14:44:02 -0400
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA9E46313;
        Mon, 18 Jul 2022 11:43:58 -0700 (PDT)
Received: by mail-il1-f180.google.com with SMTP id w9so2970117ilg.1;
        Mon, 18 Jul 2022 11:43:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=LD3jbsEBREK2eP4j8JRnU6BGqeHPwEv2Qmp6Ugb/5qQ=;
        b=4KJ0HC7tmiypX1eTrjKhG6Ye9il5jBQyFKXnYIR2vbVrj7t2LKnV738+oWCmHqnHgM
         D+hxNGlQnVX18BlSW3E3amp8BWQZwbcNIC6kVeqS/e/We6tgzBGUM+AvfNlMSYEqKYHe
         Ue10xXaX87+UYfUss/aL/Eb4l22XBemlMN8CHVh4+YkxfsX1Cb33ig2+z2K2Zc40TLtr
         dxdlsv+YZgN5xzIwhCahFT8pDB+WZxMQNJytRX6bZ9QgX/t1Nhumc0fI6SgLpMgnGv9c
         xKs5JLv4eY7B2Ctu7dd2aZbgeR4+MfIlWh0kgBOuoEg0XXw1muhGAHjtX0uFk26pHn2i
         qoDQ==
X-Gm-Message-State: AJIora+hiVGOcnghGFS8W90xDf+sRo31dFXhdkHtYA4qi1YvXwB+/vWn
        Ag8gy8rc6bgYa59ay12RGQ==
X-Google-Smtp-Source: AGRyM1sfYtsdKVAWmLlEzocHZtR9Hf5/A/3tf8A57ZltfKBeCCy+zLJhYGsU+xCXjYyzTImCk0NIGg==
X-Received: by 2002:a05:6e02:219e:b0:2dc:d166:f603 with SMTP id j30-20020a056e02219e00b002dcd166f603mr6367261ila.79.1658169838044;
        Mon, 18 Jul 2022 11:43:58 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id bs20-20020a056638451400b00341523a2a32sm4076443jab.122.2022.07.18.11.43.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 11:43:57 -0700 (PDT)
Received: (nullmailer pid 3325584 invoked by uid 1000);
        Mon, 18 Jul 2022 18:43:55 -0000
Date:   Mon, 18 Jul 2022 12:43:55 -0600
From:   Rob Herring <robh@kernel.org>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>
Cc:     brcm80211-dev-list.pdl@broadcom.com,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        SHA-cyfmac-dev-list@infineon.com, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, van Spriel <arend@broadcom.com>,
        Paolo Abeni <pabeni@redhat.com>, Kalle Valo <kvalo@kernel.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Franky Lin <franky.lin@broadcom.com>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Arend van Spriel <aspriel@gmail.com>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 1/2] dt-bindings: bcm4329-fmac: add optional
 brcm,ccode-map-trivial
Message-ID: <20220718184355.GA3325548-robh@kernel.org>
References: <20220711123005.3055300-1-alvin@pqrs.dk>
 <20220711123005.3055300-2-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220711123005.3055300-2-alvin@pqrs.dk>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Jul 2022 14:30:03 +0200, Alvin Šipraga wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> The bindings already offer a brcm,ccode-map property to describe the
> mapping between the kernel's ISO3166 alpha 2 country code string and the
> firmware's country code string and revision number. This is a
> board-specific property and determined by the CLM blob firmware provided
> by the hardware vendor.
> 
> However, in some cases the firmware will also use ISO3166 country codes
> internally, and the revision will always be zero. This implies a trivial
> mapping: cc -> { cc, 0 }.
> 
> For such cases, add an optional property brcm,ccode-map-trivial which
> obviates the need to describe every trivial country code mapping in the
> device tree with the existing brcm,ccode-map property. The new property
> is subordinate to the more explicit brcm,ccode-map property.
> 
> Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> ---
>  .../bindings/net/wireless/brcm,bcm4329-fmac.yaml       | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
