Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0AF063F517
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 17:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbiLAQSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 11:18:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232206AbiLAQS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 11:18:26 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A796DA80B0
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 08:18:25 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id s8so3229991lfc.8
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 08:18:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8cY6vY+thlkCsq8gkvaJsPRCyrqqjPYljRJ5t7fEBhY=;
        b=jfbqHyeZzr8xPua9HCdHjoXzpBxC7ALd4kWIH5iTniEhGsyfEjibgdBA8R4ffEqr3V
         DInsg2LBqcoFqTYPg94zQW5MfzlnPd0KCKnj7wQlulFM+yStYvy1kkax8IbGNaQqDXwj
         UKQMOiZ4Bg5DylqDInXJxiS9nISr/iLti0B+d4nJWyobSe+VzLb2PJEnWVFp5ZM5IHkH
         bJHZVHtORznZg8knhE33yfZ/poItxg9WPJImuC0F8HNgq3/Zst2Wf9J6z1C75UepInHW
         9t894/JigyjJzfyv+x3m+inY93IkFT5U2IF0/jnEc/3Zuf+Eiknt6n7scRXOkFqxNP0U
         17AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8cY6vY+thlkCsq8gkvaJsPRCyrqqjPYljRJ5t7fEBhY=;
        b=P0zxWqQXowREOVrCrEvmFDh3BIMLR9uV1b7iOMViY30kDjwtBq8BOpy1CFlmFMH9YC
         R73G8OkIL7vux2YOOaJFsu7Ximm687lvE3U3/PfvmtLmt7l7vFl7tLLd3n7GISiWo7nL
         3ef2EWAgoTIoDKZU9GOx/BMJods38MHBNsCyMP6HfCHXNvI9taJEa3YpXa+bYYWHCTmr
         AlH3bDpyP/0Jgbt8fzTXU9fA/vt0K2RYahH75pBnPV6X7Po2CAsKbvne11PJsiDTUOgz
         tMZC2p1e8t4T3ZjUYfndZ0S7C1DeB6ZWG5JXf/1kEFup6+Vjq21qwUDk0LgHibScRN8j
         n8ig==
X-Gm-Message-State: ANoB5plUldrECDqgXCsGe8XzHJ1MnyZKOP80aZBQSM5Gotd6AGgY0Vuz
        H68p/eR1Q7FYHHsXBVCoxVn4cA==
X-Google-Smtp-Source: AA0mqf7qGU2jrUUfqNQ9zX7/puSmTFzU4/4K8uEfeV/EPQlWMS86NXUROJC3c9SDMfwfMHDNZvG25w==
X-Received: by 2002:ac2:4d95:0:b0:4a2:3d03:d951 with SMTP id g21-20020ac24d95000000b004a23d03d951mr16321829lfe.387.1669911503607;
        Thu, 01 Dec 2022 08:18:23 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id p9-20020a2e7409000000b002770a9ed61bsm408768ljc.66.2022.12.01.08.18.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Dec 2022 08:18:21 -0800 (PST)
Message-ID: <277f9665-e691-b0ad-e6ef-e11acddc2006@linaro.org>
Date:   Thu, 1 Dec 2022 17:18:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v1 1/7] dt-bindings: net: snps,dwmac: Add compatible
 string for dwmac-5.20 version.
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
References: <20221201090242.2381-1-yanhong.wang@starfivetech.com>
 <20221201090242.2381-2-yanhong.wang@starfivetech.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221201090242.2381-2-yanhong.wang@starfivetech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/12/2022 10:02, Yanhong Wang wrote:
> Add dwmac-5.20 version to snps.dwmac.yaml

Drop full stop from subject and add it here instead.

> 
> Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>

Two people contributed this one single line?

Best regards,
Krzysztof

