Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB60569E7DA
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 19:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbjBUSp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 13:45:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbjBUSp4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 13:45:56 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB5E83029F;
        Tue, 21 Feb 2023 10:45:51 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id qi12-20020a17090b274c00b002341621377cso5823792pjb.2;
        Tue, 21 Feb 2023 10:45:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F9dpv69EJ//X4bS+6sqzou1nABGXJ1utLa9NsT25NJw=;
        b=ZEPo7qj+YETBCXzwTBOrRZZUxyrt3srAjP2LW4mjF3OLvM5RcvAt+2K32b/pT5tZ1g
         n7GSO8wOkgm1EK1jviNt7wkauZOgxsQBdSbwL8/kx13dOxhbYTvMbIodmHgiAe5SMfs7
         f618Eo9afbp62iVPUKQWBXqXqjMPKXsfiJ+G7olfzR04zAyrwA6P/NGUwoy3HFej9SOP
         vecdR6f+6ricgwBC47t/dzzVcR4BxsZXFVlHNDnmWVBu+etohH94CDeZ4iyY2C83JL/Q
         PzHLWXZBpi/L4v6NTUGxCGt/1yKRr12b7H9Ugzvhiu5kH4/2vElAjWXHOL0n5PvgMoFd
         SvaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F9dpv69EJ//X4bS+6sqzou1nABGXJ1utLa9NsT25NJw=;
        b=scSfvD6cQyiLKSdbtuul/asQLft+edjm2U8U/ISsLkzOXahtKtdNdUv0TZ2Swzbvra
         Zxe0MD1xEBr64C2VuWp8xGHEEvg3eIWWbNox78ogUSSEScTRdyGOlqV4CSNCPMiWbD6u
         9RQjCrpGjZRTdXFnROBSJ6tFoSLjQpX+rBuzjTfNbu6o9mNpc8Gs0aMtDYWslG79Qhbm
         PmEoV+dPwarGwz4jbkMFx64EBoNn8TWjz44i83LYg5AJY5D6y6RU3/8ctjEoSN10Xx+P
         QYxOHUXndobKSUuLCSKaKk45K9sY9A9fN3TjQnS9Y6/Z8fkCJGfuId2IXmP1dynLEGKk
         GvCQ==
X-Gm-Message-State: AO0yUKXprhmrY/2jwXvG+SnneN8xmVgt7Kk3Tl/pEV0y8mHdgdGnP2Vl
        ic+HWJuKuN7uPZGbdkOmXIw=
X-Google-Smtp-Source: AK7set8jYxGB+DipVrTbvReNRPSuRl6BKUbABGwqY9In+rYHFOALfVhYGho7D0PstBM54C8u3fIGJg==
X-Received: by 2002:a17:903:2441:b0:196:5bac:e319 with SMTP id l1-20020a170903244100b001965bace319mr6909240pls.35.1677005151152;
        Tue, 21 Feb 2023 10:45:51 -0800 (PST)
Received: from [10.69.33.24] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y27-20020a637d1b000000b004facf728b19sm2831396pgc.4.2023.02.21.10.45.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Feb 2023 10:45:50 -0800 (PST)
Message-ID: <ae617cad-63dc-333f-c4c4-5266de88e4f8@gmail.com>
Date:   Tue, 21 Feb 2023 10:44:44 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: BCM54220: After the BCM54220 closes the auto-negotiation, the
 configuration forces the 1000M network port to be linked down all the time.
Content-Language: en-US
To:     "Wang, Xiaolei" <Xiaolei.Wang@windriver.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <MW5PR11MB5764F9734ACFED2EF390DFF795A19@MW5PR11MB5764.namprd11.prod.outlook.com>
From:   Doug Berger <opendmb@gmail.com>
In-Reply-To: <MW5PR11MB5764F9734ACFED2EF390DFF795A19@MW5PR11MB5764.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/17/2023 12:06 AM, Wang, Xiaolei wrote:
> hi
>
>      When I use the nxp-imx7 board, eth0 is connected to the PC, eth0 is turned off the auto-negotiation mode, and the configuration is forced to 10M, 100M, 1000M. When configured to force 1000M，
>      The link status of phy status reg(0x1) is always 0, and the chip of phy is BCM54220, but I did not find the relevant datasheet on BCM official website, does anyone have any suggestions or the datasheet of BCM54220?
>
> thanks
> xiaolei
>
It is my understanding that the 1000BASE-T PHY requires peers to take on 
asymmetric roles and that establishment of these roles requires 
negotiation which occurs during auto-negotiation. Some PHYs may allow 
manual programming of these roles, but it is not standardized and tools 
like ethtool do not support manual specification of such details.

Therefore manual configuration of a 1000BASE-T link cannot be assumed to 
work. If you want to "force" a gigabit link you should keep 
auto-negotiation on and only advertise support for the speed you want.


Regards,

     Doug

