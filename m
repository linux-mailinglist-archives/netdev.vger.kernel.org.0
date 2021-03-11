Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9783378A4
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 17:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234362AbhCKQBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 11:01:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233943AbhCKQAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 11:00:34 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F37B7C061574
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 08:00:32 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id f26so2798440ljp.8
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 08:00:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:reply-to:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=8860hX4fPOf456+xKreRpeUnMj3Q//DqxVtSgHXKnjM=;
        b=ads63UXV/wcdMPcYJlmtYF2ldLTnMvMcKQYtqwL/P1iMAet9jmLbgn/kf2Qt1Ya1wi
         HHc/D0SmMdnAdEnP0dEbxB3A6D6v5YS0FF6nRdAac693LOrwH3sPvMJdVf5argFPXaFZ
         H/yAnEGpNJxWlx2PgubQU9l1wdonQXJ8RPblXzRZhy71TTdhOBFsTrIz84u+LpJEa6yc
         hw6nQy0Y859miMTiKYAXfuloMZj/oE75c+dDGd2+v+2fiCZg+VzjFprxtr5SV2+dVIr/
         SbcSBMAXMjIuDDrmYrBlbiAWcdGMUwPSTNmgosuF7lsxMuXueRK2gBEmZm8vQ6Z2xjcD
         /gqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:reply-to:to:cc:references
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding;
        bh=8860hX4fPOf456+xKreRpeUnMj3Q//DqxVtSgHXKnjM=;
        b=Ay0Uc7sbMji3VLej7Zd9XMtpaXAx78h7emDyFp5JtLEZyVCCMNrYVqOvfq9PgbUIkj
         J0ZoZGsNQRAIIVYhQNe68BBE2prRN4owpXz/HOdsfQzj5qig0C84d87VeSajABE6j8zy
         pUtazPwqP5KmV/T21bDZCX/AmPbpjhQBRnAPaDkcUlxCdeF2+mpR3ZtEKLmboPV7RpCd
         vaGm+5zRNV0qt4q/OXHaVRYWsV8UF8FSjEWESMNTs5uPA+tHkalHCSTR2CkhTTd5a2Ps
         zP/WCaAddC01LCMOOaTMNj1NZLNdolf2KQQb9YaOL8xahJQA10UYO1qJA5TdBWqrEjDU
         eYvQ==
X-Gm-Message-State: AOAM533xqjlbX+hDZa4uX9SqJ+puRUBmPSx5XIrktzHyiLSBf0y9Kmiv
        bcuAiuPfOeBcUnAWcBU49OQ=
X-Google-Smtp-Source: ABdhPJzpW1vMvPXVHHQTzYfzPVHkZF6mLgzAVa6JedzeScYc3BETtuNzh+2i11I5lsN6c6G+Jgyokg==
X-Received: by 2002:a2e:b891:: with SMTP id r17mr5490888ljp.351.1615478431518;
        Thu, 11 Mar 2021 08:00:31 -0800 (PST)
Received: from ?IPv6:2001:14ba:14fd:ee00:f103:26cf:9a94:68c4? (dcx008yjvypxp-hzzqdcy-3.rev.dnainternet.fi. [2001:14ba:14fd:ee00:f103:26cf:9a94:68c4])
        by smtp.gmail.com with ESMTPSA id w24sm1129572ljh.19.2021.03.11.08.00.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Mar 2021 08:00:30 -0800 (PST)
From:   gmail <ljakku77@gmail.com>
Subject: Re: NET: r8168/r8169 identifying fix
Reply-To: ljakku77@gmail.com
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        nic_swsd@realtek.com
References: <4bc0fc0c-1437-fc41-1c50-38298214ec75@gmail.com>
 <20200413105838.GK334007@unreal>
 <dc2de414-0e6e-2531-0131-0f3db397680f@gmail.com>
 <20200413113430.GM334007@unreal>
 <03d9f8d9-620c-1f8b-9c58-60b824fa626c@gmail.com>
 <d3adc7f2-06bb-45bc-ab02-3d443999cefd@gmail.com>
 <f143b58d-4caa-7c9b-b98b-806ba8d2be99@gmail.com>
Message-ID: <0415fc0d-1514-0d79-c1d8-52984973cca5@gmail.com>
Date:   Thu, 11 Mar 2021 18:00:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <f143b58d-4caa-7c9b-b98b-806ba8d2be99@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

15. huhtik. 2020, 19.18, Heiner Kallweit <hkallweit1@gmail.com 
<mailto:hkallweit1@gmail.com>> kirjoitti:

    On 15.04.2020 16:39, Lauri Jakku wrote:

        Hi, There seems to he Something odd problem, maybe timing
        related. Stripped version not workingas expected. I get back to
        you, when  i have it working. 


    There's no point in working on your patch. W/o proper justification it
    isn't acceptable anyway. And so far we still don't know which problem
    you actually have.
    FIRST please provide the requested logs and explain the actual problem
    (incl. the commit that caused the regression).


      

        13. huhtik. 2020, 14.46, Lauri Jakku <ljakku77@gmail.com
        <mailto:ljakku77@gmail.com>> kirjoitti: Hi, Fair enough, i'll
        strip them. -lja On 2020-04-13 14:34, Leon Romanovsky wrote: On
        Mon, Apr 13, 2020 at 02:02:01PM +0300, Lauri Jakku wrote: Hi,
        Comments inline. On 2020-04-13 13:58, Leon Romanovsky wrote: On
        Mon, Apr 13, 2020 at 01:30:13PM +0300, Lauri Jakku wrote: From
        2d41edd4e6455187094f3a13d58c46eeee35aa31 Mon Sep 17 00:00:00
        2001 From: Lauri Jakku <lja@iki.fi> Date: Mon, 13 Apr 2020
        13:18:35 +0300 Subject: [PATCH] NET: r8168/r8169 identifying fix
        The driver installation determination made properly by checking
        PHY vs DRIVER id's. ---
        drivers/net/ethernet/realtek/r8169_main.c | 70
        ++++++++++++++++++++--- drivers/net/phy/mdio_bus.c | 11 +++- 2
        files changed, 72 insertions(+), 9 deletions(-) I would say that
        most of the code is debug prints. I tought that they are helpful
        to keep, they are using the debug calls, so they are not visible
        if user does not like those. You are missing the point of who
        are your users. Users want to have working device and the code.
        They don't need or like to debug their kernel. Thanks 


    Hi, now i got time to tackle with this again :) .. I know the proposed fix is quite hack, BUT it does give a clue what is wrong.

    Something in subsystem is not working at the first time, but it needs to be reloaded to work ok (second time). So what I will do
    is that I try out re-do the module load within the module, if there is known HW id available but driver is not available, that
    would be much nicer and user friendly way.


    When the module setup it self nicely on first load, then can be the hunt for late-init of subsystem be checked out. Is the HW
    not brought up correct way during first time, or does the HW need time to brough up, or what is the cause.

    The justification is the same as all HW driver bugs, the improvement is always better to take in. Or do this patch have some-
    thing what other patches do not?

    Is there legit reason why NOT to improve something, that is clearly issue for others also than just me ? I will take on the
    task to fiddle with the module to get it more-less hacky and fully working version. Without the need for user to do something
    for the module to work.

        --Lauri J.


