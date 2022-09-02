Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 859CD5AA571
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 04:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234801AbiIBCGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 22:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234042AbiIBCGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 22:06:07 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C2C5465E
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 19:06:06 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id j6so450630qvu.10
        for <netdev@vger.kernel.org>; Thu, 01 Sep 2022 19:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=LsZw87AYzOuchFACU89HugfGoNFpxIJ08Pbb0hIlLR0=;
        b=TCyxP60nmDnXLQDzLQAk97ysC5L+qD8WSIO8v5qRYW5qSA+doA5nbJL40x0FFpQ+3O
         9bj+iWG9B8NEOKww9zg1p0yjtqKL7k7rIH37WKZ+noF0wM9f2fa+jn5MdJ+jpnCh7xjq
         jgporwTVdBF9/5C4MOYitO9Moas6F2Rk5Tct8eJO8KXi4LPEC4bTFZRD3XG1r2dJYwNP
         kv1kpd3ui93DcBy9nfd78ejGxNaiU6sCOTtVLFBhbODtJP62guj69OoGRIm1UTR0Xp1L
         T+/wF8+Xoytz5RUnypsJxWq4ZwZnowSydEtvhELxbukvx/MiV6BTOYtXmyCfOBddkpX/
         vvuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=LsZw87AYzOuchFACU89HugfGoNFpxIJ08Pbb0hIlLR0=;
        b=SRF3YK59VnYLnw8zxKPjNKoGMV8+NWgVyao+6kyuFInlsbRe6ss4QNJFnCfYeQnOnp
         ZcZWSvJsvNtwAZLgsIcJ3IWVsPSFjASXDoxjWuJTS8MlS3CBVvPOmf/2pYEHGCXKRQFo
         mXwzaUomojf3tqylgLU5ZvvQwzVFohbzFJd07wkYv/CSGs2sOVQEBX4FpEUAPWfxmXRP
         4rkNfzeesdCXfQfCrri3/Ua0JChMq5MelPgM6XMM+I3ryAuioduWdAjhSNIL0S+VpW90
         rakp5KjnDGztMnaRdrdGqnm1hdZCfOUSPJhWgJeIu8/a36BcZkXZJiBSKqy05/3dR2bV
         8Rjg==
X-Gm-Message-State: ACgBeo0taIYVODs5NSNgio5F4qc6EtwUAHuvqdIRa+l0r4XQ5BOZTKsG
        Xl6F/HrR45eoDS0xVHIwp+dT8O0y4RU=
X-Google-Smtp-Source: AA6agR7mrRa0uc736fn9T1lRXb+idOU3thswxZiFJHR27/a5UlPQNks3nbDDwxOj8FKENLTnclqPrA==
X-Received: by 2002:ad4:5941:0:b0:47b:5b81:e329 with SMTP id eo1-20020ad45941000000b0047b5b81e329mr27242137qvb.24.1662084365118;
        Thu, 01 Sep 2022 19:06:05 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id a15-20020a05622a064f00b003437a694049sm250754qtb.96.2022.09.01.19.06.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Sep 2022 19:06:04 -0700 (PDT)
Message-ID: <d750232d-efc7-b8ac-af29-0a6764d67156@gmail.com>
Date:   Thu, 1 Sep 2022 19:06:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v2 net-next] selftests: net: dsa: symlink the
 tc_actions.sh test
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
References: <20220831170839.931184-1-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220831170839.931184-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/31/2022 10:08 AM, Vladimir Oltean wrote:
> This has been validated on the Ocelot/Felix switch family (NXP LS1028A)
> and should be relevant to any switch driver that offloads the tc-flower
> and/or tc-matchall actions trap, drop, accept, mirred, for which DSA has
> operations.
> 
> TEST: gact drop and ok (skip_hw)                                    [ OK ]
> TEST: mirred egress flower redirect (skip_hw)                       [ OK ]
> TEST: mirred egress flower mirror (skip_hw)                         [ OK ]
> TEST: mirred egress matchall mirror (skip_hw)                       [ OK ]
> TEST: mirred_egress_to_ingress (skip_hw)                            [ OK ]
> TEST: gact drop and ok (skip_sw)                                    [ OK ]
> TEST: mirred egress flower redirect (skip_sw)                       [ OK ]
> TEST: mirred egress flower mirror (skip_sw)                         [ OK ]
> TEST: mirred egress matchall mirror (skip_sw)                       [ OK ]
> TEST: trap (skip_sw)                                                [ OK ]
> TEST: mirred_egress_to_ingress (skip_sw)                            [ OK ]
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
