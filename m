Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63EC8611A94
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 21:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbiJ1TBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 15:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbiJ1TBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 15:01:47 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4023C20750D
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 12:01:39 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id c23so4062483qtw.8
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 12:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TrrrPiEsaJjz2I4gZR9uDg73/3QRK40o8WZc68H+SKU=;
        b=hs34YtzgAoaQFOxylLaY3WS1CFJ99MNS6mPLJ8PcAv9PY4GsNKzUUpTPGt/YlynNLE
         d/2rY/wciydJ7WoHuyTIYHRDs9n+2coQ5aUaZdvNDIQIxxb3oOkkVsDuSON9JnvQhxxG
         Pg3XGwO/Ap3XOTZHlYHmaODBoHyi0DRusGXUaDB9e+IF0v/jCV7RLhcl8uLSW2uMJ7jP
         +HOS94qG+7Tn2KV8pz6wJ3GjWPxvGVll1Dfz55XLObU8p/HgyVrAzyVWyOJzzk64qW9x
         aljAjZJ3BqEo/6VCasVZ19UsuxCtcNdD0prd+IiCVp2Np7gMQl71jVqQy5D6ps+lSxSz
         SIMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TrrrPiEsaJjz2I4gZR9uDg73/3QRK40o8WZc68H+SKU=;
        b=MrGRhexC2KaAMvo2mx/avvOJLLYpRD+fDrrupsJ7/vtEe/h+2b29+FHnaGEIwiCDgP
         +iJH4FPXwogK+m/Fl98eqyixn0eRbAmC7i77HFhGgYEbfrsc9aRftKIGWB2o202t0/30
         XDYMNiNJgJGJ2Fw7p36EcP8PX3i+7jOb8TF+seQH2A2bgm85URNvGiccpkUCmeC/L/kQ
         xtl+LOg2xBKB1zu/LAzo6e0QwUUlf/OPVs+e/7YjqSWDWvbVZcBLzzOekA+jWimdt9iH
         WQKxvYi1Q0PnileGBcLF59WPQJsX+58qM5QiMakayd7MZ2nquSdr5p+TqrxMK80IoU+H
         9WYg==
X-Gm-Message-State: ACrzQf3PDKgTasrUEjsyVyEUJqVRGwIOBGAl/h6A4f0YRpWMZK1WiAMM
        MPkDlJoSxcxS5WmP904nT8qF5Q==
X-Google-Smtp-Source: AMsMyM5tI6t61tGPJX4Qmat7c8bhg7M4dZUK39Hr9ggtRlcSvI36L6NCrf8GcentL/vnPly4sejj6Q==
X-Received: by 2002:ac8:7fd5:0:b0:3a4:ec00:ad14 with SMTP id b21-20020ac87fd5000000b003a4ec00ad14mr856426qtk.56.1666983696901;
        Fri, 28 Oct 2022 12:01:36 -0700 (PDT)
Received: from [192.168.1.11] ([64.57.193.93])
        by smtp.gmail.com with ESMTPSA id f18-20020a05620a409200b006cdd0939ffbsm3523651qko.86.2022.10.28.12.01.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Oct 2022 12:01:36 -0700 (PDT)
Message-ID: <0a5446a4-ec28-6a91-f7b3-35a920546474@linaro.org>
Date:   Fri, 28 Oct 2022 15:01:33 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH net-next v6 5/5] ARM: dts: qcom: ipq4019: Add description
 for the IPQESS Ethernet controller
Content-Language: en-US
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        davem@davemloft.net, Rob Herring <robh+dt@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
References: <20221028154924.789116-1-maxime.chevallier@bootlin.com>
 <20221028154924.789116-6-maxime.chevallier@bootlin.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221028154924.789116-6-maxime.chevallier@bootlin.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/10/2022 11:49, Maxime Chevallier wrote:
> The Qualcomm IPQ4019 includes an internal 5 ports switch, which is
> connected to the CPU through the internal IPQESS Ethernet controller.
> 
> Add support for this internal interface, which is internally connected to a
> modified version of the QCA8K Ethernet switch.
> 
> This Ethernet controller only support a specific internal interface mode
> for connection to the switch.
> 
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Please use scripts/get_maintainers.pl to get a list of necessary people
and lists to CC.  It might happen, that command when run on an older
kernel, gives you outdated entries.  Therefore please be sure you base
your patches on recent Linux kernel.

You skipped the actual maintainers of the file.

Best regards,
Krzysztof

