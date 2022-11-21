Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9B0B632D8A
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 20:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbiKUT7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 14:59:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbiKUT7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 14:59:03 -0500
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8968545A1B
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 11:59:02 -0800 (PST)
Received: by mail-qk1-x731.google.com with SMTP id v8so8796647qkg.12
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 11:59:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U7Z1nlS9hcss1xQnMGb9ASGNT3jDBI84+fF7J/Sejpc=;
        b=LL3uUblM04JB3eTu94IEyNLyb+n6dD5/U6+bmOFEjAt4Cdz7u1UBlfMju62NstIa0K
         wZ/0ZZTAzfB9l1MqMBW1X6UOZVBiJKg5hweohAIPqdRqqJcmyBCdVEApo5kxKPXPi/zK
         kJd8DTAW+uIcYjJ+iucO+X6c4YlhiA73dnuYMoZDYqmup3lWuDQyb52brIMy6P0LxWx7
         eVybV5Lg0HMmZW2RS0fFLUrY38OSnM7sI7hO/trvhEZdijX/g7cwrRGCL6IBB2BtqK1A
         bmzrNaDtvw2t2E2zfDqw4MhR1E6nXkf79H2axQU4o5RFuVH0FhIdJhA0E15NmTVDF9Rv
         ou5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U7Z1nlS9hcss1xQnMGb9ASGNT3jDBI84+fF7J/Sejpc=;
        b=EXy665DwjsFBvYYtin8MJK4i9vBtj6pp1LSkGJHm4qUtDXRl/FhM+DBglq7SL17iYG
         ZH8gsvWiIrYi7b68DE4hi+hOXY43Eys5qi4sLwqV3ahUVUxzzUnnonAgyc6M5nkdecDL
         BRGtajaotk1Y+zU80l+a6a/0b2C4woEL0h32LgH4E1X5qO7w/SG+yh8f3QWtaeIgMp6r
         ++Sh2V+7f9Fj7WpeW56iSWft0kqXlkvm/wF+o4gWGWjLJKl0T+oS/qjwKHR7nlNAsuj8
         MLej2zRM3zGKSnzM0dv5vhUbjjWvAxDQOLvK5gwE4LcTnbXT0tO7zFs+CVDZleUf0G7V
         uHYg==
X-Gm-Message-State: ANoB5plurIB/Xtzj9GdDsGnO1eq9EbuRN3VKmh31XQSn0ox/bn6vH1Gp
        aFFt4q40tJWN7Ne/pngUdxZYRy8rSbQ=
X-Google-Smtp-Source: AA0mqf4lXibm5HDTCxPJQtyiGoCYmx0JPxFBsUVjn0mAsl4dJhLukiJLDE48F52X2veyWTf4qs9KJg==
X-Received: by 2002:a37:895:0:b0:6fa:8ddf:256b with SMTP id 143-20020a370895000000b006fa8ddf256bmr17535963qki.662.1669060741602;
        Mon, 21 Nov 2022 11:59:01 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id oo19-20020a05620a531300b006fa00941e9dsm8381289qkn.136.2022.11.21.11.59.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Nov 2022 11:59:01 -0800 (PST)
Message-ID: <e58b428b-df69-a2a0-c22e-ceec7eeb5d99@gmail.com>
Date:   Mon, 21 Nov 2022 11:58:59 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next 05/17] net: dsa: move rest of devlink
 setup/teardown to devlink.c
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20221121135555.1227271-1-vladimir.oltean@nxp.com>
 <20221121135555.1227271-6-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221121135555.1227271-6-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/21/22 05:55, Vladimir Oltean wrote:
> The code that needed further refactoring into dedicated functions in
> dsa2.c was left aside. Move it now to devlink.c, and make dsa2.c stop
> including net/devlink.h.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

