Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 734794C6D2D
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 13:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbiB1Mvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 07:51:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbiB1Mvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 07:51:51 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D03F710F9;
        Mon, 28 Feb 2022 04:51:12 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id f8so5288664edf.10;
        Mon, 28 Feb 2022 04:51:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tvp6+/aDyKCIpbn6nOEqSF7Mhp5kWor08YlfstAh3xI=;
        b=KXWOqwnHoiC3qOfGN74nt02GNRh/BSLorIidLX9BkZwHMO6C8A9S6oN8uCpV1yDmkQ
         Y5SMVjRCYDr3okW+43h8IPg2KQMSg/Vwagez/DfKJX0goReZlQpHveN4uba+eZYjQj6U
         qkdW8kiKBeaRNIldyVwmknCr+Fl44DqJjplr3J1gVng4gIHsRjAtl00JK0niOxkH/KhV
         sXTxTTA8dmMMwQcg4yfOi0jqfV4JlJjNWFkHgbTmoQY3SIaa5UunzHOa4y/dhSbjopZF
         KD8PulAVYh4k8eusxyDh7Nr+5UMNwntzLsNDiAFtkG1MLEul25NI7xdESS3ybpOJ3Klt
         rK5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tvp6+/aDyKCIpbn6nOEqSF7Mhp5kWor08YlfstAh3xI=;
        b=SEBSthqkqtHqiS5koloH6mj1WKJ01rVQBK3gtzcrCIG0ChVqodUr/iqBxCAj22H3bL
         Y9Yl/0ZoD5SwXYsuDr0NAC0VsXJHqRT/k6ETTbMkWC8ub2XEen4QDfmGaLLk3329HA1n
         TRkiguo8CaSW1CJg24W/MvRJKQX8HCCIwLSYLTnopqgTg/kznOuAqlN755hjO37DH2UE
         3h9SVMbV42UHKmHyBcIlOB8ARJyUBMzv3/KCcqTgXrjr58QXketfGZ68auf/fKQTtT0k
         F9RBQhFfaeDDOu7W3iSSqU5bN1Ttas5yaKJJEXE6cy0f/4Ga7Ubhd6iCDP2gvoqv2HGp
         Uv9g==
X-Gm-Message-State: AOAM532ZSDpZ+SOikEChG2T3LG8gYqrDAqpcAGnxQcFgJMV/3GDbWgn9
        MDcIT3njJrwut6e3SIP0jVI=
X-Google-Smtp-Source: ABdhPJx/9iT25SvqezNjKzcjA155mwrQPzSJMvAjJLgu4lAM6PtODgl6saWyldg3gixnl8FlWMam+Q==
X-Received: by 2002:a05:6402:491:b0:413:6c2e:bb2c with SMTP id k17-20020a056402049100b004136c2ebb2cmr15461987edv.196.1646052670962;
        Mon, 28 Feb 2022 04:51:10 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id q10-20020aa7cc0a000000b0040f826f09fdsm6093055edt.81.2022.02.28.04.51.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 04:51:10 -0800 (PST)
Date:   Mon, 28 Feb 2022 14:51:08 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, linus.walleij@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v4 1/3] dt-bindings: net: dsa: add rtl8_4 and
 rtl8_4t
Message-ID: <20220228125108.vuhwc4bganjwh5vv@skbuf>
References: <20220227035920.19101-1-luizluca@gmail.com>
 <20220227035920.19101-2-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220227035920.19101-2-luizluca@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 27, 2022 at 12:59:18AM -0300, Luiz Angelo Daros de Luca wrote:
> Realtek rtl8365mb DSA driver can use and switch between these two tag
> types.
> 
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> ---
>  Documentation/devicetree/bindings/net/dsa/dsa-port.yaml | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
> index 702df848a71d..2e3f29c61cf2 100644
> --- a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
> @@ -52,6 +52,8 @@ properties:
>        - ocelot
>        - ocelot-8021q
>        - seville
> +      - rtl8_4
> +      - rtl8_4t

Alphabetic order please.

>  
>    phy-handle: true
>  
> -- 
> 2.35.1
> 
