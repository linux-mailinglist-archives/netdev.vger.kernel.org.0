Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78C915F5044
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 09:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbiJEHVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 03:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiJEHVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 03:21:35 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D556D72B78;
        Wed,  5 Oct 2022 00:21:34 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id z20so8176140plb.10;
        Wed, 05 Oct 2022 00:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Zq7AhUTtOPk1Tr/YwFGcLakjsaw7uONYvZ9maPWJy04=;
        b=RBhZBDBmPmD7b0FRPZG6hnbIF/ZKCLoimgdVZckiWOP4LXfB9hPQJ0jh4EHg/JbzOZ
         jCnXOKqQmTlxSDUGMTZYFaJUVZxlUFGNJEcFduLId5KQLVYyLsSxj9RXRDaQUMLaZSpW
         1pDbAABj666UCNgNMx8bCNsF5Smi0wQ7MjOowFthSfOE+Zr4VoQHrKqwcyHRvUVB23Q3
         VD18ONI69S1yT0kP3CVwwDq3jFtFemDIQpHrD3DTtIcGuzCoZ+5HAOT1f5ByCEDbVR9r
         CqO6JRGrdtZVqiV8GGfqXA6ToISuXWu1gj7AS7lCnlZ/XnGUmvu2XNtKLoVjUIWwIZ/l
         07Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zq7AhUTtOPk1Tr/YwFGcLakjsaw7uONYvZ9maPWJy04=;
        b=wbR69t5dw160qRYjxPmBl9SEP0FN2FVR91rYCjN3IZLmUiUSdK5o2GllZCjKGv9Vcs
         avX9lt7I//B0/ikW+5VKOmRagFfzigUXZTR9nNZ7Y8i1OI8wiLvobDxf4dXjFlZKSIz4
         t/YHmT7Usox/K60UJOZ/RlNCe3HsRpDjcGUl9QyUujAVBGI7KcuAm0JfKcS2dKKw4n6Z
         UhbMqDwUVMhVxNszQPlRavQ++G3JnWvpcBH2q/7WuVIpTz8caL6YGo044zGVowdPIR55
         h7+J/Wa66bXmONvoRs60wsdE6V5Qk5iS5UkLzRypdrikwgYBsXRD6YHTlRZC9RyA2cEA
         Te8w==
X-Gm-Message-State: ACrzQf3W6v+HkvEf+cSeKEn8zMqbXCHNrRxJB6qgjWPUOomJobgqrhQu
        I3AZwfEST5w3u57TbXgerd8=
X-Google-Smtp-Source: AMsMyM62yvU2HKLqEt2A9ArpPj9UT6A+0T1JLBFEqxkA5QprNNxUqw/fGdXbNcBMX5yDB9Dq9Q+SBQ==
X-Received: by 2002:a17:902:f609:b0:17d:311c:b5ad with SMTP id n9-20020a170902f60900b0017d311cb5admr22593999plg.43.1664954494305;
        Wed, 05 Oct 2022 00:21:34 -0700 (PDT)
Received: from [192.168.43.80] (subs03-180-214-233-30.three.co.id. [180.214.233.30])
        by smtp.gmail.com with ESMTPSA id g12-20020aa79dcc000000b0056196e54effsm4188210pfq.51.2022.10.05.00.21.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Oct 2022 00:21:33 -0700 (PDT)
Message-ID: <7bee79c4-c08d-56bd-52b5-455b9f1c397b@gmail.com>
Date:   Wed, 5 Oct 2022 14:21:28 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH net-next] docs: networking: phy: add missing space
Content-Language: en-US
To:     Casper Andersson <casper.casan@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20221004073242.304425-1-casper.casan@gmail.com>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20221004073242.304425-1-casper.casan@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/4/22 14:32, Casper Andersson wrote:
>  
>  * Some SoCs may offer a pin pad/mux/controller capable of configuring a given
> -  set of pins'strength, delays, and voltage; and it may be a suitable
> +  set of pins' strength, delays, and voltage; and it may be a suitable
>    option to insert the expected 2ns RGMII delay.
>  

Looks OK.

IMO, I would like to write the phrase as "... configuring a given set of
pin parameters (strength, delays, and voltage) ...".

Regardless,

Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
