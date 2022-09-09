Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72EFD5B3E02
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 19:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbiIIRem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 13:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbiIIRel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 13:34:41 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A1F13FA25
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 10:34:39 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id g12so1438213qts.1
        for <netdev@vger.kernel.org>; Fri, 09 Sep 2022 10:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=ewai9EKcBYUhnwAWeYHdj/D2XMqRNJ5lNxNm014OEBc=;
        b=dHMhOmQAaamGtxokNv1jj3plxXvD7uGesdHgc+EXxbGfRGQxyHQ/6NIRaeZg/JCGuW
         W0fYa4MbVWk58yM7F2R/ytLF0cOGK4jITajgX2LAo1oJvWCqhER0djf7nYWTrsqMgxTl
         a0FHmNV+gCfBhG97enk9lSb/NuCGaQDZYO2qEPLJanbojBxLDZdnCEmdiscxyjE0qPp2
         vjlyK2+jfXGWaiflwan/Gx1PW7OcOzKJYUjKERcA62Wn1W8/4ci6uLBqMBGeaMq57DEf
         jVDPXFColsFReyJ2B7byQoqy7DJT5nOqrO0xkzktLcRKQFwqIpytnts1yCZwSHjRol6R
         DDzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=ewai9EKcBYUhnwAWeYHdj/D2XMqRNJ5lNxNm014OEBc=;
        b=2xGThHgURVLS0YcMJb1F8jwAqTHLig11gSBMIkdeJ5xWe7vV5HR1TX/d3sXxBRn5IZ
         78YST2KL4iULKo103xpD15jxfgjWycfPK4sl7mAYiciFD4jcZ81eCDsKQveiCLuwduEw
         WDM6n5YFuXqd+Z/QdV7Rw2oCbxeyu3C2eCnZ1YYklYL8kql38/e73YOAPPOYPr3C3CUq
         OH3sn/qEx9LBNTZWEWT1jVOPoHLqO7K4cD154gNU6kTqnWMZYF68VnMv9ws2CnSf78GD
         W7W5atQzRkIjSa3rDEYO6O3i+kCMm0NlA/DLRh1rClc1xV3ungGE7BCfGQscvMtUDKjL
         FTpQ==
X-Gm-Message-State: ACgBeo1nWhIK/An4RGNBBOgi34YvLI0H8a5bhdgiaVDm0isG58IAjZ3H
        AOPQnU6QyJonOg49xrUB9bg=
X-Google-Smtp-Source: AA6agR47MyxY0XJp6p2eS+wCcMlbvers22ZMKtounXKpJ2+m1IUZR2UVnRCNEC1Xzknne4OxASRHTA==
X-Received: by 2002:ac8:5755:0:b0:343:560d:f4e1 with SMTP id 21-20020ac85755000000b00343560df4e1mr13171479qtx.630.1662744878650;
        Fri, 09 Sep 2022 10:34:38 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id az40-20020a05620a172800b006c61999caffsm843804qkb.116.2022.09.09.10.34.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Sep 2022 10:34:38 -0700 (PDT)
Message-ID: <ee6ac1f4-4c80-948e-4711-7e7843329a16@gmail.com>
Date:   Fri, 9 Sep 2022 10:34:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH net-next v8 1/6] net: dsa: mv88e6xxx: Add RMU enable for
 select switches.
Content-Language: en-US
To:     Mattias Forsblad <mattias.forsblad@gmail.com>,
        netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220909085138.3539952-1-mattias.forsblad@gmail.com>
 <20220909085138.3539952-2-mattias.forsblad@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220909085138.3539952-2-mattias.forsblad@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/9/2022 1:51 AM, Mattias Forsblad wrote:
> Add RMU enable functionality for some Marvell SOHO switches.
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

No need for newline here.

> 
> Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>

Just one nit, sorry about that:

[snip]

> index e693154cf803..7ce3c41f6caf 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.h
> +++ b/drivers/net/dsa/mv88e6xxx/chip.h
> @@ -637,6 +637,7 @@ struct mv88e6xxx_ops {
>   
>   	/* Remote Management Unit operations */
>   	int (*rmu_disable)(struct mv88e6xxx_chip *chip);
> +	int (*rmu_enable)(struct mv88e6xxx_chip *chip, int port);

Change the argument name to upstream_port to match the implementation 
for each chip that you are adding?
-- 
Florian
