Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF35648B8A
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 01:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbiLJAHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 19:07:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiLJAHN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 19:07:13 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6581747DC
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 16:07:12 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id s9so4662534qtx.6
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 16:07:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DCYmz28rsGPLUcQ7YdDc/sAtncn/1Sm6dcUh3jnN/GA=;
        b=gwZSvfZSd4rcVsCG/5E2b54rzAYg7svcuXuj5H/pBJdmPBzhb2bYTR+blsS/55q2J1
         59mGA5R3usWceo9yrJqkkpC792Ik9mCJPBClR1H1oQq9q9+F4kgg2XG3z+xe+r52ybyH
         b73uiom1sEvnKSYSW5lM53sGqwUtJVmHwpm+pZrYU0/wV1OhbqJf5sZG7HxpkhGetLDO
         WK2gaFfRlQ8Ym9DgAmD8B8Ur+hivTvTkJtFudzrpY8bKu5WDdECwq1D4mVsoRd+nPeX8
         aPsrFQSshOqP7jds3R0YkqYGhv1yCpCGdgklE/uVOu4YN5kHH4B5h4VZgzIQ73pfhFlJ
         hixA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DCYmz28rsGPLUcQ7YdDc/sAtncn/1Sm6dcUh3jnN/GA=;
        b=rCDmsq056R2vy/FQH0PSP5PGl2LlAfeqMNjleeY+JTggHoO8FCtA4NnmJBkIUJ2FX1
         A4XakPvzKkR26Cxs/wQrDS+RDRnuQhyEefZqAg+WHzwAJmb9awWahQy4nD4RwsPvvyqJ
         M20R28a4gaR9+c5D0+z5YRvN72asO9PQ7FJ0eqOpByjBje5ofxNBIMZRlqhIAJDoEN70
         nDKxQ7CZNXcnFyXMm1heWxLsCG61lcSQi083ih7jLmxE7atN79c2InNJXCcXJ3SZQ2nm
         0W8HCi/vqpti0U67omgUHxc5XzNNjgI+k/wCcJUSbzq2D7EphDJtwg/YsgdBsZeJ8dpY
         L+sQ==
X-Gm-Message-State: ANoB5plf9Q2iZYXbBXHWe75SaKfgSBI8hsb8U+O0Kvx8Xsd14QRybGJs
        mkC6QiuuX8W6fM4onCGJtq5W/EQh0HoJsQ==
X-Google-Smtp-Source: AA0mqf6pIDoQJCo1nhF6FMwPz2IuOjkU7Hwfs2ZdsSDmQOGHCQt9UxsdZrYbPJSs9DPRFIJXNp2AKA==
X-Received: by 2002:ac8:4783:0:b0:3a8:741:1c45 with SMTP id k3-20020ac84783000000b003a807411c45mr2908329qtq.42.1670630832020;
        Fri, 09 Dec 2022 16:07:12 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id k16-20020a05622a03d000b0039a610a04b1sm1890523qtx.37.2022.12.09.16.07.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Dec 2022 16:07:11 -0800 (PST)
Message-ID: <dc6ae46c-d0e7-59b8-a674-d0736faa03a4@gmail.com>
Date:   Fri, 9 Dec 2022 16:07:04 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2 net-next 3/4] net: dsa: mv88e6xxx: replace ATU
 violation prints with trace points
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Hans J. Schultz" <netdev@kapio-technology.com>,
        Saeed Mahameed <saeed@kernel.org>
References: <20221209172817.371434-1-vladimir.oltean@nxp.com>
 <20221209172817.371434-4-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221209172817.371434-4-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/9/22 09:28, Vladimir Oltean wrote:
> In applications where the switch ports must perform 802.1X based
> authentication and are therefore locked, ATU violation interrupts are
> quite to be expected as part of normal operation. The problem is that
> they currently spam the kernel log, even if rate limited.
> 
> Create a series of trace points, all derived from the same event class,
> which log these violations to the kernel's trace buffer, which is both
> much faster and much easier to ignore than printing to a serial console.
> 
> New usage model:
> 
> $ trace-cmd list | grep mv88e6xxx
> mv88e6xxx
> mv88e6xxx:mv88e6xxx_atu_full_violation
> mv88e6xxx:mv88e6xxx_atu_miss_violation
> mv88e6xxx:mv88e6xxx_atu_member_violation
> $ trace-cmd record -e mv88e6xxx sleep 10
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

