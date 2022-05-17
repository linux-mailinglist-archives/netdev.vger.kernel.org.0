Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93F42529DDD
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 11:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242141AbiEQJWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 05:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244635AbiEQJUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 05:20:32 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C6F02A24F
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 02:20:32 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id j6so33414057ejc.13
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 02:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ELBUULZ+H7tDKjXi1syCZRjo0DspiKSXNZhuMeDbS8M=;
        b=Oto8JnsMXAy5xnVrtEZ8VRJCXAt3L/IGKvZ2/7zs9VChSJ7E5fS7ObmqERVE+MHLfu
         nkI42xoMudKThi21E5FS8Ht0XVhEpZQRIGMmh1U0DANsA7FvrCe6t6uvm94i4/Smb1Ew
         BkzqdPxXVuKTmHSz8FMTE8YWTG09fVjgHtemMsh9SXlndueEVYDnQV5/q/lAT19+S9qG
         EODzJl+/bZ0XMf7NY7VZSU59swsPj1Hzi+2msP7vgrlzhefxhAsrhDNo1zxbkmeumvev
         rwlwReNFXGsXibDs/Ab+02aIXU1qN3SE09sNZIrB9tGlNA6U7qg/895Houlu5RQ7nw36
         avZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ELBUULZ+H7tDKjXi1syCZRjo0DspiKSXNZhuMeDbS8M=;
        b=szaOPCadcFSudXTIJ44da/MO0d+n3KxS/MGzUDrTUbDvf7JlI5POCPUReErP3t0LHp
         UCG+bkNR7U8biRjBsxRNWxvT2fD9VXZrBunLFb9D+5gFH8QDfwvAk9+/efOBCEUff0fr
         uml/EVlkANdrCbYuxVdj3D2PrCcMLwy87KSBPmQJN49VlahEvyVK6LJ+v7l4/rJZ3J2R
         Zrg7JAWNLtX06jNgS5q9wtM+jUQTSsxjURaIlwDmax9wmo9uf1zfhD2MoRLfKrXzNbRl
         R+v0Ac4i8mfUIYq2CwFAdJChG+bZxPAu8B3hTMutRUBosPROMn26nq8PC4gJtdPCSgCD
         NJlw==
X-Gm-Message-State: AOAM533Bre/bNyRc2gjz38kvHiFMko5ue4IghJgJEIz45pn7Sz7bNnQF
        bxM1HPDCwrZEB+GUu6cTQ1yqbNNvRQnX2YJF
X-Google-Smtp-Source: ABdhPJyC/uOHckeWkcv6cdcS5rrKDPa9siWvchV+E2rFERmgvYA08QEdQ+IuV8D5APF5PeSPWPxuCw==
X-Received: by 2002:a17:907:961d:b0:6f4:d3bd:6758 with SMTP id gb29-20020a170907961d00b006f4d3bd6758mr19543568ejc.401.1652779230554;
        Tue, 17 May 2022 02:20:30 -0700 (PDT)
Received: from [192.168.0.17] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id g25-20020a056402115900b0042aaacd4edasm3854255edw.26.2022.05.17.02.20.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 May 2022 02:20:30 -0700 (PDT)
Message-ID: <6b856ede-88e8-f589-e31a-4ba91ff67317@linaro.org>
Date:   Tue, 17 May 2022 11:20:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v5 1/3] dt-bindings: net: adin: document phy clock output
 properties
Content-Language: en-US
To:     Josua Mayer <josua@solid-run.com>, netdev@vger.kernel.org
Cc:     alvaro.karsz@solid-run.com,
        Michael Hennerich <michael.hennerich@analog.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
References: <20220517085143.3749-1-josua@solid-run.com>
 <20220517085431.3895-1-josua@solid-run.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220517085431.3895-1-josua@solid-run.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/05/2022 10:54, Josua Mayer wrote:
> The ADIN1300 supports generating certain clocks on its GP_CLK pin, as
> well as providing the reference clock on CLK25_REF.
> 
> Add DT properties to configure both pins.
> 
> Technically the phy also supports a recovered 125MHz clock for
> synchronous ethernet. However SyncE should be configured dynamically at
> runtime, so it is explicitly omitted in this binding.
> 
> Signed-off-by: Josua Mayer <josua@solid-run.com>


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

No need to remove my tag, please keep it.


Best regards,
Krzysztof
