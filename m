Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB9126434DB
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 20:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232688AbiLETxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 14:53:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235187AbiLETxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 14:53:03 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E1F01144
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 11:51:29 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id fz10so12239258qtb.3
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 11:51:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=18yc6bxW++syaHnEK8KgZDqrWOgHZzWKRf78kkAympY=;
        b=kfGU+5l7A85xc3cEnaJPBJgHqCyjK/4ylncMKPIwAUL32G4/Jh3dU768hYDPcalpIQ
         AWmZx3niELrapGLaWYAYNexruSCMFe7ZXKgPiy9LXyvdmzWwCxoW1jPlEJ4nOFWyg+wC
         83yNXTE0cBBzYeg+UWZnzBOFw3g7OjzQMV2lPOxDhL4vf+FdyrgvR34Rkyvuh8Ld6e3p
         eA94n6GgqtvbyaxO7HbcmRRdt5B8i+gYEZlVx/TMe60UJbcQRuC4OYrtFEZVvnVbJFBM
         JDUnOIr1Mt8g2thdNc3OHvMoY1e0iKAxgyKZzP7HXH3sxnMlhNEksjlp4SJonyGB0GDZ
         Ufcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=18yc6bxW++syaHnEK8KgZDqrWOgHZzWKRf78kkAympY=;
        b=LCqhUQ9Z9k/KWOJJ/PW6ySCV2Ra/eudNuNnHpfDrnt2Uwfr4Mhe7lbVe9HQOCpb4eD
         oy9kRZQbkCc5IsfUN4M1FqbsTmmxHmVJ5iUMOCBzCZcHGU5vO/f+iz3Uk/Ur0aBkYaIL
         OJ4MPsqOaNVWxW3Cla2aC5gqYc5aw/VHFpS91ysjlvoELnBiGTJY3913/3Oe02F+gQgO
         ENa9daU+19fvPJeyT7xau/V31V4o1oCC6qx03seveZ87SnKu6EjVojOJCSAE0q6dDb0X
         Pmtlg2zkY1lyvmHd+Ya3mAqC8W+Q+NSNyLaKMfyx3QK7aHbUQws3e6JsmEBtID3FKwWS
         mzmg==
X-Gm-Message-State: ANoB5pnaQX9bPxkgKsGeJ4aVIDtVPSYHImkAgKIeT90iK2HDFnyi49XE
        KbkckSvJlTc0h7oEcEocHb8=
X-Google-Smtp-Source: AA0mqf4Xvs0OnmpGBDLSXc75EnLa6sxlyZhHiJRhQXhStUMgvTx7gavMBgNVHv/Qb8p5jmZB/5Z7hg==
X-Received: by 2002:ac8:4748:0:b0:3a5:82cf:faa5 with SMTP id k8-20020ac84748000000b003a582cffaa5mr78013252qtp.687.1670269888087;
        Mon, 05 Dec 2022 11:51:28 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id k14-20020a05620a414e00b006cebda00630sm10589984qko.60.2022.12.05.11.51.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 11:51:27 -0800 (PST)
Message-ID: <c14a66bf-f6c4-623a-0947-60cbf2c82d8d@gmail.com>
Date:   Mon, 5 Dec 2022 11:51:25 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: accept phy-mode = "internal" for
 internal PHY ports
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Tim Harvey <tharvey@gateworks.com>
References: <20221205194845.2131161-1-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221205194845.2131161-1-vladimir.oltean@nxp.com>
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

On 12/5/22 11:48, Vladimir Oltean wrote:
> The ethernet-controller dt-schema, mostly pushed forward by Linux, has
> the "internal" PHY mode for denoting MAC connections to an internal PHY.
> 
> U-Boot may provide device tree blobs where this phy-mode is specified,
> so make the Linux driver accept them.
> 
> It appears that the current behavior with phy-mode = "internal" was
> introduced when mv88e6xxx started reporting supported_interfaces to
> phylink. Prior to that, I don't think it would have any issues accepting
> this phy-mode.
> 
> Fixes: d4ebf12bcec4 ("net: dsa: mv88e6xxx: populate supported_interfaces and mac_capabilities")
> Link: https://lore.kernel.org/linux-arm-kernel/20221205172709.kglithpbhdbsakvd@skbuf/T/
> Reported-by: Tim Harvey <tharvey@gateworks.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

