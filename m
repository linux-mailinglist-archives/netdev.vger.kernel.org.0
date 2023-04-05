Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 129EA6D7C5E
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 14:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237883AbjDEMYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 08:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237438AbjDEMYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 08:24:08 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C866F2D6D;
        Wed,  5 Apr 2023 05:24:07 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id u38so23518841pfg.10;
        Wed, 05 Apr 2023 05:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680697447; x=1683289447;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HL6YlgHVByQMHzQoHL5rb+NFg4QOwdKUk6/U2KspYq8=;
        b=kpQRmTda0TdgQle35lhoCr9wmkJVmjpYdphtPRoXHUXbWi+cFyxP4BHcdwHn31PmFS
         POTN0otoENjmBrT+OHtRt7DRbZhgO4vMETMZol1lx4jljwCRpbLsT8VlMoCnhRlIpOT0
         xl2awqAHKB/frVUy+BlOv6+3AfXz5IDyg0RtYBknctqIhGEiFDFPe7UQUGuF4gjWUBoL
         +pVOqUwACb8h1it23rce8yWLIPKwf6WGLn5DzPBlNZAOeAvQV3wjoO40qxZ2SuH/ke/z
         sBNtdEy2U8M+MDJ12cAFpwZJOQXIi76dkQQuDqj/1aSR6PxigibTM9OtLvlPG0mNYob0
         AYhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680697447; x=1683289447;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HL6YlgHVByQMHzQoHL5rb+NFg4QOwdKUk6/U2KspYq8=;
        b=c/09EAghdVZe3kE9kQr4A3U9hVuZxu17w8sINp4BN2JSNghBZn1m2pfqPEYpqbv1mJ
         IMFbWqseV9bCi0zoXWmuM4qQsfeurZ/RKdSjRGko+0EiGsRNEhbFCzCtDFR48xmDVZ/i
         zgdWIDF/zeFViRR1W2K5T0CyuvXVNITfMcX0m6rC1UKbTyVhvp37OhDRdIzVHb3BCVyr
         452F0kOhHqn18k9qxU+NMyijlowZODf9V2/gEgLYQmfYOywTHt/PEiwRh0yeU3B2Sjox
         1Pc7yKT6Znqlop4KMrEE/NOSAJn2S3iy+ZcU4hcNuVzc4sb4c9gsui7+8MDrorK3LbDz
         Y04Q==
X-Gm-Message-State: AAQBX9fTdKKGUp5DA22xr7ZiDnYpa08IC9yFqZXlYg2dd2JPfuemF0Cz
        r/xbdQ03/Im/Q/2XhIbcSPRhmoPCycWAkw==
X-Google-Smtp-Source: AKy350Z7w4xiTCMGphCtVnaJ96rcUC17ISCwq81IfoADJ49GDn/4nGMqRJQpzYrnFa2iqNEHyyWMgA==
X-Received: by 2002:aa7:9734:0:b0:627:e61e:1ae with SMTP id k20-20020aa79734000000b00627e61e01aemr5174109pfg.12.1680697447150;
        Wed, 05 Apr 2023 05:24:07 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id c23-20020aa78c17000000b0062c0c3da6b8sm10964887pfd.13.2023.04.05.05.24.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Apr 2023 05:24:06 -0700 (PDT)
Message-ID: <8fedb85c-5ad7-0f79-7d7b-2e90406f798c@gmail.com>
Date:   Wed, 5 Apr 2023 05:23:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH] dt-bindings: net: ethernet-switch: Make
 "#address-cells/#size-cells" required
Content-Language: en-US
To:     Rob Herring <robh@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Christian Marangi <ansuelsmth@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
References: <20230404204213.635773-1-robh@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230404204213.635773-1-robh@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/4/2023 1:42 PM, Rob Herring wrote:
> The schema doesn't allow for a single (unaddressed) ethernet port node
> nor does a single port switch make much sense. So if there's always
> multiple child nodes, "#address-cells" and "#size-cells" should be
> required.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
