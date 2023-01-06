Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17D0F660056
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 13:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231972AbjAFMhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 07:37:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjAFMhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 07:37:10 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 093DE687BF
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 04:37:09 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id l26so954586wme.5
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 04:37:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JfkdNWtaqfWf7qUFl/BGUV8KbJ5Fivhd3o6PbjSCcN8=;
        b=lP5AwIEjAC+3lfJNrf+S9HB/EoC0nnqsOeX2OpUVaCtd9m0t6N/SekUoj2S8/8a+oV
         3NDmOlZMPf/4H3gxlYzHbOKgYJbG1pAxkZU/IqDmP7gocWJYV6gw0qalGrw2uHDEa8ja
         t67SacSBAMqh8FhuwPMJsfsbaoEecUf/BhehB0RKihXqv/G+IKY59+9XVEDygULYFkvF
         MAs/IPzgz9TVNckMPf8yqsx24mYCQj7kzB7BZJNp+JLs3tqji7vbAiE5PvLDfKgerU1g
         AofBPUiNukfD4l5WoaQV8uFQ280d6gilfsIJQFcP14ZXCKqgN59C2j332NGhsr8QcgQ9
         CuUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JfkdNWtaqfWf7qUFl/BGUV8KbJ5Fivhd3o6PbjSCcN8=;
        b=GVYtbfGX2MrtGb/cR7VUAKHzo+ozniafYBGJ5qbyXYCU1GomcG6+ACCoYYQKSlPm0Y
         SY9sZDdZ39hRwVPm+0LN3vgkMl1DD43mvsMXnY6d9055K7Ts/LOVGHZi7ZjrxSsvl6vV
         0fMOmhZw2ViM/TPfe9OYwgzCaXbSIsadCtU9vJ5dbKFb7CzceujCPG+iLgFH9y5xfHU4
         9lVoG9cEL++RycyMUExevOZe2u52nSbsApeSUAh9ShNFJ+5a1NL4NkX4ZwFrFAfX/LRb
         ts4g6siajBUpEeFayntCxusQmpl+waFF1OnFSaXNeF+9+H9XkTwzOW+Ez8c9+RE4Mdba
         7CNA==
X-Gm-Message-State: AFqh2krloK+aBLEG9A35bMUp0XGtuAEZGMkDLjxx7Gfol/whyGAvF6cv
        tDjDSnbKq9AUwQjyjfhh9iwJmQ==
X-Google-Smtp-Source: AMrXdXt4SwoPX7N00J959R6a9X52m1stIfhnB9gX7yMTUn+jnioUf0KQclnbmOfsHkl40kkFhoLvcA==
X-Received: by 2002:a05:600c:b4d:b0:3d3:49db:d84 with SMTP id k13-20020a05600c0b4d00b003d349db0d84mr38422517wmr.20.1673008627610;
        Fri, 06 Jan 2023 04:37:07 -0800 (PST)
Received: from [192.168.1.102] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id fc14-20020a05600c524e00b003a3442f1229sm6903655wmb.29.2023.01.06.04.37.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jan 2023 04:37:07 -0800 (PST)
Message-ID: <e501df1b-93ac-b56e-cb57-8059fe251536@linaro.org>
Date:   Fri, 6 Jan 2023 13:37:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3 1/7] dt-bindings: net: snps,dwmac: Add dwmac-5.20
 version
Content-Language: en-US
To:     Yanhong Wang <yanhong.wang@starfivetech.com>,
        linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>
References: <20230106030001.1952-1-yanhong.wang@starfivetech.com>
 <20230106030001.1952-2-yanhong.wang@starfivetech.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230106030001.1952-2-yanhong.wang@starfivetech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/01/2023 03:59, Yanhong Wang wrote:
> From: Emil Renner Berthing <kernel@esmil.dk>
> 
> Add dwmac-5.20 IP version to snps.dwmac.yaml
> 
> Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
> ---


Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

