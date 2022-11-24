Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 273D2636F89
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 01:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiKXA7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 19:59:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiKXA7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 19:59:04 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF10786D2;
        Wed, 23 Nov 2022 16:59:03 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id x13-20020a17090a46cd00b00218f611b6e9so248257pjg.1;
        Wed, 23 Nov 2022 16:59:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wNgqx4nOvBacXRcfWNIQEwnOw2cT8o68pm9m7IwR/gg=;
        b=X3BErgYpy3+uysZbtcDsNZ7XGMi6VDJ4M2UpEJYTm2ZIcAzzgdUC31pzHYDnTPm5hl
         xa+LgejTMwdOrl77sTGNP1dKTS7ltBeMIH2JfPfx36d0ToxxDblWx8abnihFZH4tGIyB
         9vOcAavA+bj2hLk+vQG/JmsWoFwMIawmWdh6Ieu/+vfctje3iQhwdHGadmXzWxI6dmnK
         pwBsMIzYxOMSCcZb2QTykFPIdahII9cFshRZFCmPfo5Ab+Vu2MFcC0rD3dYZdGoinLXL
         vc7Emew/hGDDJN/jGoia7AnARhpwR5maKxMJ2ObUKvej1siq+om/ymzlZZRxFyti6hAO
         hP7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wNgqx4nOvBacXRcfWNIQEwnOw2cT8o68pm9m7IwR/gg=;
        b=G9lA+4wO/kZgTv59waDAGXf8C/ZaFRr8CO7hMi+c3PS1VYhn2u236L3CMjFgnh6nQh
         8sryjP0nvqDuLi1mjsNXVzgU8qbZdKEzGavHSe0E7zP8+BEAT5XEIMZJL1zZtl4kYkl/
         zTSSwqxldaltQzzE7DwoiNKE4mA28phBO40x9rnRpp5hZCy0gRJfbL61+qR2z2JXsver
         2VF2szWbWyjKk7RxGt4xG98b1vL5aQXhfc/GoyZV6TRCVreCtbLV1Csq3x5VcHyeiDb3
         2oZf6rXSxdpXl6oQ/HBnYbj2PPIiHG9llXemRJD4KrfcKu66X/ip/9b2TMkSsFMBYRC7
         jk4A==
X-Gm-Message-State: ANoB5pk3GydgTR0rn+i+BEbFGHEA2umduVoJf9uBGmuwkFMsqmKcOJ83
        BnfxGRzy6I3GAqg7ZjaGosE=
X-Google-Smtp-Source: AA0mqf4daN8aZClSbe8nBcobYR0Zu0b8N4WjefmWi2EiezYKHFju1/+LYi14eFnabt/fV8Egy3TuZA==
X-Received: by 2002:a17:90b:3944:b0:214:1df0:fe53 with SMTP id oe4-20020a17090b394400b002141df0fe53mr38368187pjb.214.1669251543001;
        Wed, 23 Nov 2022 16:59:03 -0800 (PST)
Received: from [192.168.1.5] ([159.192.254.122])
        by smtp.googlemail.com with ESMTPSA id d7-20020a17090abf8700b00218e5959bfbsm1897336pjs.20.2022.11.23.16.58.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Nov 2022 16:59:02 -0800 (PST)
Message-ID: <360394e3-91c0-9a47-4046-1f7635ebf312@gmail.com>
Date:   Thu, 24 Nov 2022 07:58:54 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH] USB: disable all RNDIS protocol drivers
To:     Nicolas Cavallari <nicolas.cavallari@green-communications.fr>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Kalle Valo <kvalo@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andrzej Pietrasiewicz <andrzejtp2010@gmail.com>,
        Jacopo Mondi <jacopo@jmondi.org>,
        =?UTF-8?Q?=c5=81ukasz_Stelmach?= <l.stelmach@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Ilja Van Sprundel <ivansprundel@ioactive.com>,
        Joseph Tartaro <joseph.tartaro@ioactive.com>
References: <04ea37cc-d97a-3e00-8a99-135ab38860f2@green-communications.fr>
Content-Language: en-US
From:   Lars Melin <larsm17@gmail.com>
In-Reply-To: <04ea37cc-d97a-3e00-8a99-135ab38860f2@green-communications.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/23/2022 22:40, Nicolas Cavallari wrote:
> There are also probably cellular dongles that uses rndis by default.

Yes, there is a whole bunch of them and new ones are still coming out.
Some USB dongle mfgr prefer to implement RNDIS instead of MBIM because 
the same dongle can then be used for both old and new WIN versions.
I do agree that the RNDIS protocol is crap but removing RNDIS_HOST will 
be a regression for many linux users.

/Lars

