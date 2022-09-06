Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E14F5AF735
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 23:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbiIFVoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 17:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiIFVoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 17:44:12 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B77DDBB006
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 14:44:09 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id h22so9130468qtu.2
        for <netdev@vger.kernel.org>; Tue, 06 Sep 2022 14:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=xJ1mY3lMNrChioAumP1snT8pdvDAXDzPHLORNiCxXAs=;
        b=HR2Bn8AeqShgr/G5Rhh/ob8DBR/ZBFuaILDXQ1lLCYm+zB3NB0wntd++ZdNJnqmtdv
         RR9Bnio+GqVRjKCZXY0vnAbUxGVaxkeA5nm2G128DlIEooss9F17ffWcflPa5NvdL/tY
         RARNz6tairdzW10wwQUj+n98PxsZV7QFPqxXvz52Sq4xdc0yQgJjMJSX1d0BQiWcSj1b
         jeUC7I8QOUqFQe17WefBpiGEOY5yl6XLI4iVgyxGovUSgplBSDXzAoHbXAatJ00XowUx
         kMfejd85ovllpky9yDn4J5q6bqgYToM8IlpX0g9gIsuDS5Vu5jXF4HlebJdu3h9dfk9i
         0apQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=xJ1mY3lMNrChioAumP1snT8pdvDAXDzPHLORNiCxXAs=;
        b=4y3+sGQ2CPyWIZTB+F16Zj+rSIMtYVS3CaXd73+f/L3HoAyiVKDBJIk4CJBXlklRCZ
         6skCewgbDRDZ3TSyviQbc/HNX//qpQ+lB+4ik/q3b26gaADBc1UaG8SLH6hN6qcVzAPF
         uZ2G0F+so8KQ2IIA19q5MpHMsTE59uJe7I16uUoGEEDvAsbqzZYnUfmPmNVZf8lA5dUM
         JiWc6Y47RFfTyK9aBk0BiN5OwzDKKiUN9O543lY2N08xN6PSD6WFDqN5lm2C/5dtXUp6
         1prAIBxzZVC8CgRtdVlDmjZuLPbvs60ymAN9HI/nuXfPkyAZLEblvNvxWHPvubLWJ++b
         5hBA==
X-Gm-Message-State: ACgBeo2dLa8GURsxWBn9KxRpGVlR1b5AbRty6tdmYSRN/0L3mj4ThmWK
        2p6t95wtZEoDRKxiwnRCe7U=
X-Google-Smtp-Source: AA6agR6zrvCKqgfNpyjZAf8ALUb5fr9PaxbryNQoIvHvN+DSdNaY4bY/MP8voZGoH6vX6vIA9HmiiA==
X-Received: by 2002:a05:622a:e:b0:344:9c6a:3616 with SMTP id x14-20020a05622a000e00b003449c6a3616mr623909qtw.362.1662500648503;
        Tue, 06 Sep 2022 14:44:08 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id x9-20020a05620a448900b006b5e296452csm13180034qkp.54.2022.09.06.14.44.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Sep 2022 14:44:07 -0700 (PDT)
Message-ID: <8d39e62b-ce0b-678b-4a0a-8b40663027e0@gmail.com>
Date:   Tue, 6 Sep 2022 14:44:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH net-next v4 2/6] net: dsa: Add convenience functions for
 frame handling
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
References: <20220906063450.3698671-1-mattias.forsblad@gmail.com>
 <20220906063450.3698671-3-mattias.forsblad@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220906063450.3698671-3-mattias.forsblad@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/5/2022 11:34 PM, Mattias Forsblad wrote:
> Add common control functions for drivers that need
> to send and wait for control frames.
> 
> Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>

With the feedback from Andrew addressed:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
