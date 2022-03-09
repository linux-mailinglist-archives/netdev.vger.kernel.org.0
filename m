Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3554D363D
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbiCIRcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 12:32:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231575AbiCIRcS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 12:32:18 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA74DD6
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 09:31:19 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id mg21-20020a17090b371500b001bef9e4657cso5987294pjb.0
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 09:31:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a7Fxvii09jYa/3eOKKw3kvDoBSVVcI2G42MCwt+ywUg=;
        b=gMZ91P9l5Jk2IrjUwjuYzXwVwCXOmV8nl4GJaK+Y8PhvuFBxt5e8MHweHowEN5w3yE
         OuKW0VD9VlNQuBduXDXSWeTW5onh5zx7jE8d7Lc/CJPFFpkzTpht2hyX7SmvJMDLrxtg
         vWm5So9kPcIc2vQqm/EFWfQnFHcFwO4iR1FXTBS9etwyLMwMhMzFkTWDP5tadxQe+/9Y
         Cu5lPHSx9DbFUJNa53NELFp5QNg3zeXDl0jOf3yDtkX/DHhGAT5nHhV9uI9bZfMJftIF
         i0aCX/c+bNlIN8CKojh/rt73h50IhgHJIer/dCprivcpB6MjjCjODf7S6xaTkcy783NN
         1DqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a7Fxvii09jYa/3eOKKw3kvDoBSVVcI2G42MCwt+ywUg=;
        b=6PPKOczdbMEf9yBcfv7n0g9zA39mlJ9pz7WwIMc+QryqykJtA89Dn5IoyviwzBYhBy
         vKF8ryomkFSPnZWIlAb8UeFz4lYSYVGuanBXVko/ewlTid9foRG3F1iht9iGbkd/t/Js
         4A5yFgH+mtQyMUUpSzOyYMX/KuSudf457ZBpwsEsUDg3mWnI4cm9wi3zUzKr8UGcx7OZ
         19f5tlv+dXUUC+4KM0gqkJIrD/8kY0g6u9UvVhsXTT2YwEN9tl1BvQrLUt3G45UeQ1P0
         wIVLVQHvfeo/b62syBvFv5BDUFByPweTkxLXv9CyLiHZDADolk1nUJQUVNfLw9uEp6lD
         WNRw==
X-Gm-Message-State: AOAM531XheuNL+XvYpbKCHb/e7CUhn9WcR20M21LxSevimYfJKIfsj5i
        ACF8IWliaB87/ckLzwHsPcjt85X8pOugdI0n7EY=
X-Google-Smtp-Source: ABdhPJzDHz3mwDnaR+eOTBiou3M+riYY6VfYZ4uZunNlXz5wnNslsdyKaJXWiAqf/ffIqhHqQpLxWbeK1x2cqtP/Pso=
X-Received: by 2002:a17:90a:8595:b0:1bf:4592:a819 with SMTP id
 m21-20020a17090a859500b001bf4592a819mr498887pjn.183.1646847078665; Wed, 09
 Mar 2022 09:31:18 -0800 (PST)
MIME-Version: 1.0
References: <20220309022757.9539-1-luizluca@gmail.com> <20220308220329.554a3d0b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220308220329.554a3d0b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Wed, 9 Mar 2022 14:31:07 -0300
Message-ID: <CAJq09z5JjwtaqD=8mH91XjagwnJJaVz9f3d88boGTAi=thL+rA@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: dsa: tag_rtl8_4: fix typo in modalias name
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Fixes: 7c33ef0ad83d ("net: dsa: tag_rtl8_4: add rtl8_4t trailing variant")
>
> This SHA does not exist upstream.

Sorry, I got it from a backport branch. I'll send v3. Thanks for the review.

Regards,

Luiz
