Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E99705037EC
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 21:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232629AbiDPTcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 15:32:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbiDPTcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 15:32:42 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F8533EA1
        for <netdev@vger.kernel.org>; Sat, 16 Apr 2022 12:30:09 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id md20-20020a17090b23d400b001cb70ef790dso14225059pjb.5
        for <netdev@vger.kernel.org>; Sat, 16 Apr 2022 12:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=/TwpT3e9/cdR4EICG+BKCniDNRBv08wpl4thuHd6+/M=;
        b=k6aZZbihB7K5n4dkKR47gnrnP9E6O7twqTg5cdP257biTP1bjNA9XZI5xOguALcc50
         uHQpKLDJGOAcYeJ+/3+yxcHdNBKn0rcOuXehftDDXWuIHKnpdoLVEXkyX3EIVtnMzEhn
         lx2exZ4efDqbNBuUjHEFIP7+85D/9Yz4yZhwtBG/khVlcjSTd71rfpeuTQDHPrNu3rhw
         OKGpS64EjULXnpFVEl2T5h+4mvfXxtUFG02At7iTNnAYeM5SmfR9etP00O0wiopVdS9Y
         JmAVBQqcYpMkBVAlSnsa6z2UWWDPn4dRHnwR7Y8huf9tOZ4jHiLvGVq5VVJBGmx7tRti
         kxpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/TwpT3e9/cdR4EICG+BKCniDNRBv08wpl4thuHd6+/M=;
        b=qZO7vwjsIZVKUzF8DXUo8QyBJOIhdISufvoqt9SPxyXSN5ZqhvRiFxWQF2777ic8AV
         ftZrbKOSanYygSzP88D1X3vxiLiQy5y4fHaSX0pEUEAB7SqPxMuQJB7kTOMa548i0ACU
         /c8Oph/qeXurKpObIicc2dJ3mpjKJIigsHJBCY8395K0UY2LkX22prA9HgXD/Hi90wfI
         u1x1ZS4NmW3mYxTKKutkbXUg8TIApeU2KF1v5wzN5hRwHRiFHaOlu1cLfW62uHCgd+Oh
         2X5id2KaY3jL/qIVfNwSgyov/HklYahzPzD2hTAcicB8csSha/e7ohplggRUshyxTrPV
         9law==
X-Gm-Message-State: AOAM530Fj/CxcPDzqkq1VtNaZmhripJHIlIyVZr9H2HoGMuI3PhTQbXp
        wrNohfIQSRUID6EmqjOvAPQ=
X-Google-Smtp-Source: ABdhPJxQJRNC4kqDmYGj0Y3tMk8owK2lCetJOUIxQJwvodXkX2rs4vmEOCe4XmodqXF4L6rBTKqPrA==
X-Received: by 2002:a17:903:228b:b0:158:c040:5cd3 with SMTP id b11-20020a170903228b00b00158c0405cd3mr4615307plh.30.1650137409155;
        Sat, 16 Apr 2022 12:30:09 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id 65-20020a17090a09c700b001cba39c88fcsm10322641pjo.0.2022.04.16.12.30.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Apr 2022 12:30:08 -0700 (PDT)
Message-ID: <d563b0f7-ebff-2402-4e31-5688c97cd79d@gmail.com>
Date:   Sat, 16 Apr 2022 12:30:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH net 2/2] net: dsa: realtek: remove realtek,rtl8367s string
Content-Language: en-US
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, alsi@bang-olufsen.dk, andrew@lunn.ch,
        vivien.didelot@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzk+dt@kernel.org, arinc.unal@arinc9.com
References: <20220416062504.19005-1-luizluca@gmail.com>
 <20220416062504.19005-2-luizluca@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220416062504.19005-2-luizluca@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/15/2022 11:25 PM, Luiz Angelo Daros de Luca wrote:
> There is no need to add new compatible strings for each new supported
> chip version. The compatible string is used only to select the subdriver
> (rtl8365mb.c or rtl8366rb). Once in the subdriver, it will detect the
> chip model by itself, ignoring which compatible string was used.
> 
> Link: https://lore.kernel.org/netdev/20220414014055.m4wbmr7tdz6hsa3m@bang-olufsen.dk/
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
