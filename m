Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 814C76C6DC4
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 17:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232333AbjCWQgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 12:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbjCWQgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 12:36:23 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3781367E1;
        Thu, 23 Mar 2023 09:34:58 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id t13so14459592qvn.2;
        Thu, 23 Mar 2023 09:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679589294;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=stUzCFXiD8PEYBONMfjB7APazeCwrM/CiIh5xilJVJw=;
        b=eKJLZ3Cdh0SSrcbVglElFiWgm8u8asgClu667oKe4dLR6pNXT1rg0Y14NS7rybTGKK
         EVTsaQm5UYqpvKAY2z/7N5zVRmvQc9GTaJXpCSxQlexZ8TT2ZHsfVJNqDQF3yO4YIiLP
         JzJO8TYDoEVC+gFK028z5Yb1F9S2D6+jwPEhWt43xXssMdOTlHaNu1z2awMv1F20vifC
         DEeNJJOCuylD9doTvOI4S1UF2L+d02esoWjLRH9SDog4/E22ThyHFxMU+zwg6wrDdG8U
         T8Lq1w27fYl6w6w8PRieIsmiA7Cb9ZI/GtQm6WqdtnZaUZhhbV9lVvpCDitRg5IncSt9
         fw0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679589294;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=stUzCFXiD8PEYBONMfjB7APazeCwrM/CiIh5xilJVJw=;
        b=qClwRTPSjqM7cpLu6kGK9yTEXJ3kQu2j2VqzibPnE7+x9lzPWP+6v7U3GhDzon/S1S
         bgAoF71RqI/4iLUsILYtvEtlf+nexD2Y0WgsNbyWew24Rl1zdfdjE2pe6rNFfiVIcTzV
         DUTzHT2/3f8uhGG/9sLXW2YOA/80p3QQNWWKulCyv1Uf5qMvMDmrS4rIcE0HX2tNkHyB
         w/yObrFVmo9cIr3y5Hy8ifoL/JYLocAv2yZSUSpra5R3ixQApySXqgoVVYMmUDftdDjm
         7K7jMo1171pvnI3QwAKcoICxiaSh3qvq9GII/hcTl+feDvk9TxgjbiUUO47rVhsawZtv
         nPGA==
X-Gm-Message-State: AO0yUKV5ZyA37wD5Q0BmFpaPoLZbc3rW4Acu9w9FGaliKMHEUoxwHyM9
        //6KXIDEF1+rzBHXHTB8BhM=
X-Google-Smtp-Source: AK7set8wSykQWhLKJW29Dr3h+aqlQ2XOZDHdJCbSAbjLfBqN9d1PUV6EBv7PR5nMwBVzXM49BB6C7A==
X-Received: by 2002:a05:6214:2409:b0:5a7:a434:c307 with SMTP id fv9-20020a056214240900b005a7a434c307mr14968249qvb.24.1679589293908;
        Thu, 23 Mar 2023 09:34:53 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id p11-20020a05620a22ab00b0074583bda590sm13401830qkh.10.2023.03.23.09.34.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 09:34:53 -0700 (PDT)
Message-ID: <d9d3b20b-d288-8b6c-b8fd-77a24bf7aab2@gmail.com>
Date:   Thu, 23 Mar 2023 09:34:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 1/2] dt-bindings: net: dsa: b53: add BCM53134 support
Content-Language: en-US
To:     =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari@gmail.com>,
        paul.geurts@prodrive-technologies.com, jonas.gorski@gmail.com,
        andrew@lunn.ch, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230323121804.2249605-1-noltari@gmail.com>
 <20230323121804.2249605-2-noltari@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230323121804.2249605-2-noltari@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/23/23 05:18, Álvaro Fernández Rojas wrote:
> BCM53134 are B53 switches connected by MDIO.
> 
> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

