Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23A54580839
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 01:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236698AbiGYXaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 19:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230411AbiGYXaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 19:30:03 -0400
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9130826AC1;
        Mon, 25 Jul 2022 16:30:02 -0700 (PDT)
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-10cf9f5b500so16757552fac.2;
        Mon, 25 Jul 2022 16:30:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VFMd4YPM+MTZCOe3E/qgYT9jDvzrDbOnnHU6wGc2pEI=;
        b=yBXcIzxjv8jH7M9EHB98fDAKoXjjfAJRXRHk9cwKvKCmilPV70psLsRY7ZuUdqN2QS
         lglpPFz+yfX4A7nRe+Bk+GslyC1dFCP032BE2GhkKrCs91cwdm41sP1j2E6j6U+jgNaJ
         LWve/jEcUzzuxcokgDS2XvWprpkWb9mgLLZpFRBIOFMf4ks6ebTiUihwL3eDuHuJlXni
         0ijMh8D+135VWYC+KcJ3+kbhlW1OL9UgjHsufcjiwjQntd4SF/yRrEQzvwGC818gKqOS
         w9dc+jyoupQ4ZG36AxxyiVopg4N2x+iJoRtGWhkxn2NJRpthb0N8iNTZY66PQJhB+M+5
         80JA==
X-Gm-Message-State: AJIora+dOp5ZXMoxFsUx56UxD/XLbY5Uv7eGdexTdDTmD7QEatyzeeBu
        xUcDg8ZpY2HC4yAFAXGigmiVibl0+w==
X-Google-Smtp-Source: AGRyM1vPaw5E5DetSCEcHODs9pPkmDjg+2p7b1DBkq7Uv5F0N3yRXmtzkd/qWMnnGP3ufMGgvW20WQ==
X-Received: by 2002:a05:6871:154:b0:10e:b20:6c3a with SMTP id z20-20020a056871015400b0010e0b206c3amr4127041oab.16.1658791801920;
        Mon, 25 Jul 2022 16:30:01 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id w65-20020acadf44000000b0032f51af1999sm5324041oig.42.2022.07.25.16.30.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 16:30:01 -0700 (PDT)
Received: (nullmailer pid 2959277 invoked by uid 1000);
        Mon, 25 Jul 2022 23:29:59 -0000
Date:   Mon, 25 Jul 2022 17:29:59 -0600
From:   Rob Herring <robh@kernel.org>
To:     Samuel Holland <samuel@sholland.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        linux-kernel@vger.kernel.org,
        Alistair Francis <alistair@alistair23.me>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, Vasily Khoruzhick <anarsoul@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        linux-bluetooth@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Subject: Re: [PATCH] dt-bindings: net: bluetooth: realtek: Add RTL8723DS
Message-ID: <20220725232959.GA2959243-robh@kernel.org>
References: <20220725055059.57498-1-samuel@sholland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220725055059.57498-1-samuel@sholland.org>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jul 2022 00:50:59 -0500, Samuel Holland wrote:
> RTL8723DS is another version of the RTL8723 WiFi + Bluetooth chip. It is
> already supported by the hci_uart/btrtl driver. Document the compatible.
> 
> Signed-off-by: Samuel Holland <samuel@sholland.org>
> ---
> 
>  Documentation/devicetree/bindings/net/realtek-bluetooth.yaml | 1 +
>  1 file changed, 1 insertion(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
