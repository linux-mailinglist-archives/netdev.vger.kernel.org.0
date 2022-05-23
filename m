Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62245531C60
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233205AbiEWSd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 14:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240335AbiEWSdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 14:33:42 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77860FF586
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 11:08:24 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id m1so13806008plx.3
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 11:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=w0T2SfRXTKlT4DVwNNp0bcAPlOmxMr1ptDCB9+VAiwk=;
        b=pbhw1kyGXV2Mffwb+2yxQissCHjB2rwjA5wiB1vw865US3KycFvup4O27xqQoYYI4L
         CaZmbmEHXOeog1BfVQtS3oBdNYUVa7yjE4/oGNRP+VftdkddQmA+ntpUR2rEJuhHmqOD
         mdyKaO0zd5ea4DlKSLUQKhWiYOjmYClxFZeBEUeFhFEh9it3x9lIZCHfMQRcGiGbAyiT
         m2HXVm2z1OCnIiM8/I5tL7vCDOpYVPEQRbFP6B1hTiCpOUNsADwzPEUhzqkdbLPopM1a
         we7eM1+N8qr6F8sUnTPvZuzUCFD8ux88nvNU5dKZpLFvsDDqT63WsuRZA1LkXBzFfJGy
         EJ7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=w0T2SfRXTKlT4DVwNNp0bcAPlOmxMr1ptDCB9+VAiwk=;
        b=3yQgVaWzEPkTG1+/qYEvKAcSFSkojg9wa7tCtQ8RT2goW2YAns3ZxEZ7KNhkPifEq9
         3UHChJBzBeJbWqSUVTJvhrnPD1MMCLSpXzpoUxkGnNjWmXwSc1xamsLJkZ08CrFWhKcP
         //b+AHB6YGLf9/bYtAxiFyQLcjPHmcdEnslX6Fp+bkClFWaPQDqvxfagiTmfugDpqoPm
         mPPLFmZDS1oz6MSKNAJnN2h1r1CXXUxawfjmadrL55pj6nhUsqKOIPxgU+nFy1t6KxP7
         2e2f/NV4UFyhYBI8hJwYHdZ4Rx2fUm7f+mFvQoqqzSzVE7vhQuqZ3RZP5+3Z6m4hLBSd
         z/wQ==
X-Gm-Message-State: AOAM531V8FebZR+KEJA62ajC5ZrT7eEptyyu+eU9/EL8siOjFa1XU6kY
        vui9hLqP2UnY6dTsXCGFyCk=
X-Google-Smtp-Source: ABdhPJz6WQXSXT0gpkS1G77ufbKRg9TF4PyGwfmNDXXO7ealFlIFY+q8o4Xd658JW5XIYyESY+hzVw==
X-Received: by 2002:a17:903:288:b0:15f:a13:dfd5 with SMTP id j8-20020a170903028800b0015f0a13dfd5mr24102619plr.55.1653329303851;
        Mon, 23 May 2022 11:08:23 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y18-20020a170902ed5200b0015e8d4eb2e9sm5366083plb.307.2022.05.23.11.08.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 11:08:23 -0700 (PDT)
Message-ID: <55571ff6-2bdb-a062-a94b-d7a476fd5c4a@gmail.com>
Date:   Mon, 23 May 2022 11:08:19 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [RFC PATCH net-next 09/12] net: dsa: introduce
 dsa_port_get_master()
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Frank Wunderlich <frank-w@public-files.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20220523104256.3556016-1-olteanv@gmail.com>
 <20220523104256.3556016-10-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220523104256.3556016-10-olteanv@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/23/22 03:42, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> There is a desire to support for DSA masters in a LAG.
> 
> That configuration is intended to work by simply enslaving the master to
> a bonding/team device. But the physical DSA master (the LAG slave) still
> has a dev->dsa_ptr, and that cpu_dp still corresponds to the physical
> CPU port.
> 
> However, we would like to be able to retrieve the LAG that's the upper
> of the physical DSA master. In preparation for that, introduce a helper
> called dsa_port_get_master() that replaces all occurrences of the
> dp->cpu_dp->master pattern. The distinction between LAG and non-LAG will
> be made later within the helper itself.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
