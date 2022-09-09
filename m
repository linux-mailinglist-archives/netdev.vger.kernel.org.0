Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBEF85B3E04
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 19:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbiIIRfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 13:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230480AbiIIRfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 13:35:48 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC2712A32F
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 10:35:47 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id b2so1691665qkh.12
        for <netdev@vger.kernel.org>; Fri, 09 Sep 2022 10:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=hlXjO6XbKHeGHnb9Xm3RkHYZa2MhSHbX0KABoaqnpgI=;
        b=bqJ618vP9YlnFvZMlZou6+ljvFwoxg5siTRwVKOHO1LjIcmf2AvsfMfnlDQ2bOlPrJ
         b9AObMUfNd4vuhCCT6hVBPVCVVpeY8t4ayROXiIQT27FgZ93W/xC81ACeKvU8VdjYznm
         M04t2cVbfyZkT7cPD5oCZHGBnGfTbD+5J4EW/GVpvMbgICbYeui3rWN+SYKx9wLG5Bys
         mFK952z9yIEXtGYMaE1qD5O7HqRW9SOT1HYPtWYfbRyvqoJAxYnxrLewMWiEuoFqOTyT
         DvB2Qhe4fVbLqYadtTncktwevF8mnW71mmWQG4M6g7C/rNpVKPdiwIw+TcJ/ezMrH8Ui
         qu0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=hlXjO6XbKHeGHnb9Xm3RkHYZa2MhSHbX0KABoaqnpgI=;
        b=mzWpsym1Ywf7PFKKeCuMdHplfQF5UNAi5wbxus0f+JL5ChoKYig/M4wCb6fZyH0uJu
         o1Y42pCm7PPVOpNdHxnjoFegroCx38qIxJb6ykHRJb7lk/Uz4yeBx1gq4OuzRTrqrjKm
         p2OdtgrirvsAl4yYZMPwQcshOQt+5ou6YhgpnDklUKJa5Ii4xAbD09JrCVtLHvcnjp/S
         MC7n/8npuTu1nQ6mq593x38iYdMnOyL5Sh0Bbx6oKkI79T42C41BlN9w2F6Yj/VJtLR5
         8+xojcwBV8fIXfyeeJrI2ek1UCljXFe77zsgPfJqQ+S52rOTJ+HVnkvyEDrNQxqBXN8i
         BN7Q==
X-Gm-Message-State: ACgBeo3nijCXu+lO3S7l0kQrYqb/DqGqJLOH1W8BQpvdYfcMNAg14GC5
        EgKCqhDLIdukQXyN6GM45M8=
X-Google-Smtp-Source: AA6agR4pN8N4o/xJVcLfOu3MpIqIn3Zl6BoOcoToK5Sh/7ZQkf0Qut0PNsYvNABopTAsvDBg1BtrHQ==
X-Received: by 2002:a37:f514:0:b0:6be:730a:ac1a with SMTP id l20-20020a37f514000000b006be730aac1amr11244266qkk.10.1662744946674;
        Fri, 09 Sep 2022 10:35:46 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id bp11-20020a05620a458b00b006b93ff541dasm831170qkb.8.2022.09.09.10.35.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Sep 2022 10:35:46 -0700 (PDT)
Message-ID: <2034f3a3-922b-104e-4868-1b3ee7b463ef@gmail.com>
Date:   Fri, 9 Sep 2022 10:35:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH net-next v8 3/6] net: dsa: Introduce dsa tagger data
 operation.
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
 <20220909085138.3539952-4-mattias.forsblad@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220909085138.3539952-4-mattias.forsblad@gmail.com>
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
> Support connecting dsa tagger for frame2reg decoding
> with it's associated hookup functions.
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> 
> Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
