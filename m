Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11F855B0C9F
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 20:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbiIGSoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 14:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiIGSn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 14:43:59 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 408D2A7A9A;
        Wed,  7 Sep 2022 11:43:58 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id s22so11186047qkj.3;
        Wed, 07 Sep 2022 11:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=Tfh1jYz2seicx6AV08/ib0aISutfnAtuDr/ZNE4dv/E=;
        b=qT2rv/W6yKqPgI56xw+ZJHPwcn3c0j+94Vr6SrPpFUYToCtCRwuhrJ7kNjZ43Xwk6d
         jBKomZqOYH5bUcozHEQqaH/Rcu21meIdr7vuAIOWyYcdeEunP2JD5ueXl2KewHUzevc0
         L/LO4NlITzyyMDohYnELXmBGWh9ennnEIMY0dwMRXfDguimE2mGH0OEsuwHy96/Tisi8
         uBpDO28UzMvZ9cU85H7o6F3R9HnIdetlwWJdefPTvXusTpUuRDEnQ57zOZtO6ttaLXqM
         wjAS5CrhJ4io6rxSPwwxVujpZcUWNz1VuncGETTAdXDZT48QPEkgOjKotrw3KoQtk9zp
         ZIag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Tfh1jYz2seicx6AV08/ib0aISutfnAtuDr/ZNE4dv/E=;
        b=Q6Leh7s6EyI5p7QRtRKhjHFtAamDEP+au+e2TrDOU6w9WLSEPmj9epaUkceKKW7Fec
         FBmRpMR5DLgtRVbkFPeeZbjs5fUdoOuDBS+Jnha6yGc6/twW1j3FCCY9dxeVo6v4mhta
         BUzsm1Lr9lsj8HRdi5BdiVT4JUSaz8wDXea1FqMd8uv+61ppgmR+fJwo3fY4iw+ufcM7
         ZX1IiBnLEismsbPn2VCPxet6W00AjnTKxJRqvBogR8IY4AXkPrcII4qtmMBEh1XZnzjb
         XMJMaLnJ+rVYwnDkwnUZRNlzGHAjsw83gHdqHSIn6L+ady3Kw7Wt18Q48bRIx/RFJNSP
         9w3w==
X-Gm-Message-State: ACgBeo39R5Hzc2owpt3s8H3vA2utxA/4pkc/pekfCF0UIILfq5OTE2u2
        HdR0Wy7t8Fl83Vt4q48fNm8=
X-Google-Smtp-Source: AA6agR5MMZEf+8dXTu6lY6P7Biw9MBxUWBD38CtWHxjt+Ah9nBTdaes6u1rSzcuHHYDNcYe2P4NO0A==
X-Received: by 2002:a37:2d05:0:b0:6be:8620:57f with SMTP id t5-20020a372d05000000b006be8620057fmr3578436qkh.688.1662576237270;
        Wed, 07 Sep 2022 11:43:57 -0700 (PDT)
Received: from [192.168.1.102] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id w15-20020a05620a424f00b006bbdcb3fff7sm15694869qko.69.2022.09.07.11.43.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Sep 2022 11:43:56 -0700 (PDT)
Message-ID: <666c3928-9495-1ee1-4e6e-f3ae1863cdd6@gmail.com>
Date:   Wed, 7 Sep 2022 11:43:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH net-next v3 1/2] net: ftgmac100: support fixed link
Content-Language: en-US
To:     rentao.bupt@gmail.com, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heyi Guo <guoheyi@linux.alibaba.com>,
        Dylan Hung <dylan_hung@aspeedtech.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Liang He <windhl@126.com>, Hao Chen <chenhao288@hisilicon.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>, Tao Ren <taoren@fb.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <20220907054453.20016-1-rentao.bupt@gmail.com>
 <20220907054453.20016-2-rentao.bupt@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220907054453.20016-2-rentao.bupt@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/6/2022 10:44 PM, rentao.bupt@gmail.com wrote:
> From: Tao Ren <rentao.bupt@gmail.com>
> 
> Support fixed link in ftgmac100 driver. Fixed link is used on several
> Meta OpenBMC platforms, such as Elbert (AST2620) and Wedge400 (AST2520).
> 
> Signed-off-by: Tao Ren <rentao.bupt@gmail.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
