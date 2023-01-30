Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B01E9681DF8
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 23:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231567AbjA3WXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 17:23:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbjA3WXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 17:23:40 -0500
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FED92135;
        Mon, 30 Jan 2023 14:23:39 -0800 (PST)
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-15085b8a2f7so17107965fac.2;
        Mon, 30 Jan 2023 14:23:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PI3Awd4JerWn0fe3vlblIk0s9rAEypgjGDblSG+ZIos=;
        b=DK2pBXs1QNEgMK2rwO6UO3JCkEGgB4qq+XcwdzB70s7hNGE8V030OLElhupMYwmAdj
         dBDvQ4BbI9pj0dTflIK797u4sdYdt7MQVPSN5dW/4VEI/J5zdt6logfN2+ZmgIwg4cCK
         itLscT476YsMyzGIyE9KcCIRWEW9MNh5jTLH0MiXAf5/23r1YHmrQyk9BPpHJASEWUNh
         MWPQZBnv90WaIUCDvPXL966PSypnjKf3rLfOj7lZu5cPpa+48g2HPfzp4c2rL/o+N9LN
         KqhkyujwCavKCVAU3WBSpnZRo0LFvt16W+reieAh3Op3pVXPwDY71DM6vzpAaE4ra5mo
         ix8w==
X-Gm-Message-State: AFqh2kp0Awgofwfbxay8uC+n+MqtaHxzIJvparHnDQRVpOnKwTlmYHQp
        APpyEweN88dbuYFgWWyDVw==
X-Google-Smtp-Source: AMrXdXsTnuLljnybua4AK97CM8WBMusPcrJy97X+k5iy4QoFI1RGMlyIUdBFmv3+gqmhdiorIRm2/w==
X-Received: by 2002:a05:6870:548f:b0:15f:d0dd:55f1 with SMTP id f15-20020a056870548f00b0015fd0dd55f1mr21239724oan.29.1675117418469;
        Mon, 30 Jan 2023 14:23:38 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id js10-20020a056870baca00b0015fadfaa960sm5756868oab.37.2023.01.30.14.23.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 14:23:38 -0800 (PST)
Received: (nullmailer pid 3634514 invoked by uid 1000);
        Mon, 30 Jan 2023 22:23:37 -0000
Date:   Mon, 30 Jan 2023 16:23:37 -0600
From:   Rob Herring <robh@kernel.org>
To:     Steev Klimaszewski <steev@kali.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Sven Peter <sven@svenpeter.dev>,
        Balakrishna Godavarthi <bgodavar@codeaurora.org>,
        Rocky Liao <rjliao@codeaurora.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH 1/4] dt-bindings: net: Add WCN6855 Bluetooth bindings
Message-ID: <20230130222337.GA3628858-robh@kernel.org>
References: <20230129215136.5557-1-steev@kali.org>
 <20230129215136.5557-2-steev@kali.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230129215136.5557-2-steev@kali.org>
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

On Sun, Jan 29, 2023 at 03:51:27PM -0600, Steev Klimaszewski wrote:
> Add bindings for the QTI WCN6855 chipset, based on the WCN6750.

Proper threading is all patches are reply to cover letter.

Drop the last 'binding' in the subject. Don't need it twice.

> 
> Signed-off-by: Steev Klimaszewski <steev@kali.org>
> ---
>  .../devicetree/bindings/net/bluetooth/qualcomm-bluetooth.yaml   | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/bluetooth/qualcomm-bluetooth.yaml b/Documentation/devicetree/bindings/net/bluetooth/qualcomm-bluetooth.yaml
> index a6a6b0e4df7a..64e278561ba8 100644
> --- a/Documentation/devicetree/bindings/net/bluetooth/qualcomm-bluetooth.yaml
> +++ b/Documentation/devicetree/bindings/net/bluetooth/qualcomm-bluetooth.yaml
> @@ -23,6 +23,7 @@ properties:
>        - qcom,wcn3998-bt
>        - qcom,qca6390-bt
>        - qcom,wcn6750-bt
> +      - qcom,wcn6855-bt
>  
>    enable-gpios:
>      maxItems: 1
> @@ -121,6 +122,7 @@ allOf:
>            contains:
>              enum:
>                - qcom,wcn6750-bt
> +              - qcom,wcn6855-bt
>      then:
>        required:
>          - enable-gpios
> -- 
> 2.39.0
> 
