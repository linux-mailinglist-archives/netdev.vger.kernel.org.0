Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46B3C5B0CA9
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 20:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbiIGSoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 14:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbiIGSoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 14:44:09 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFECCC0E55;
        Wed,  7 Sep 2022 11:44:08 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id m5so11186498qkk.1;
        Wed, 07 Sep 2022 11:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=sm2917QyW/IpUoyRYPzvoGiRSjCQ4oILKJa4Mo6YtaM=;
        b=Q69cPnFnPOquM1IwxkrETlKul9pY/zSHDSq8OQaOCIVhaBJ+VMvIz6o9VUe1Km4pbN
         WgcFuJz72wym4by1ybdyyvv88ZmkJAQGwZorjWfsJP+MJCb4zyBmwU1qvFBMo2+CY/eM
         KyZFufBpnydp9vnv90Ezln8ZhWa273iKmIavuUfS+2nebyPVKMW+p5jHupslYQtlHptb
         v5Mn2dWlwHOLWxloODGnfwkVUK2GP6PNlvTRziKf8X2fBdMRUrogZslablQJ84Yg1/96
         ET5zOBCJF09HRX6yLX5mE3ptgmTiZkP/SOByOuq+wqh8J1ZWmkwPw8n2KHjcVSUh/l+t
         UU2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=sm2917QyW/IpUoyRYPzvoGiRSjCQ4oILKJa4Mo6YtaM=;
        b=DcUH6MO0ZcTC0PgT4idj/WcZbLd9vVRbabHtNv9/j+KMzTOysA4zHtU35YRwY4qTBs
         iJP0Ju5CBZ2BmvdK99VzEwZqaiC38yvy9nehxomksX0THNgv5Wch8ae4MZ7vV1xH8jl2
         deyp37gcfGcK6kNWJZhUxxv486h6E/h5VMlTOn4btHwN2XysTOaniSlBL2KIqZaWPic9
         /Csf3eb/T+Yxvy4BstZmoKb8HhZJpohk0OJg2zX7MQqcIe75JA87UAvaM49Zltqnl7ks
         yli5WDv2COP/jBDCIaaFIxoR6MWrC6HEn/mcDBQfgc/iFPIgfOLAaO/aS5p7m3tLsYRQ
         YPsg==
X-Gm-Message-State: ACgBeo0fjsppxw0gojzlgjAJx/59UPbqzOD0RD7230U6EE7CRP7ljvWn
        m4WuJ63ChDb8VeFq4ZHLAmk=
X-Google-Smtp-Source: AA6agR5IWIv5rr+ytIUtjyy/FfMPmJaqd00l6tl/LsbBSZg2aWEo6E2wOEQaVOwBiJDQmwJJDvZajg==
X-Received: by 2002:a05:620a:1470:b0:6bc:476a:31f4 with SMTP id j16-20020a05620a147000b006bc476a31f4mr3806296qkl.501.1662576247984;
        Wed, 07 Sep 2022 11:44:07 -0700 (PDT)
Received: from [192.168.1.102] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id dt46-20020a05620a47ae00b006a793bde241sm16116704qkb.63.2022.09.07.11.44.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Sep 2022 11:44:07 -0700 (PDT)
Message-ID: <7f3a2e42-6214-c41f-90f7-53ee637a720d@gmail.com>
Date:   Wed, 7 Sep 2022 11:44:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH net-next v3 2/2] ARM: dts: aspeed: elbert: Enable mac3
 controller
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
 <20220907054453.20016-3-rentao.bupt@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220907054453.20016-3-rentao.bupt@gmail.com>
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
> Enable mac3 controller in Elbert dts: Elbert MAC3 is connected to the
> BCM53134P onboard switch's IMP_RGMII port directly (fixed link, no PHY
> between BMC MAC and BCM53134P).
> 
> Note: BMC's mdio0 controller is connected to BCM53134P's MDIO interface,
> and the MDIO channel will be enabled later, when BCM53134 is added to
> "bcm53xx" DSA driver.
> 
> Signed-off-by: Tao Ren <rentao.bupt@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
