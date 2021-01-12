Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 465A72F3317
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 15:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728866AbhALOlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 09:41:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726458AbhALOlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 09:41:23 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE51AC061575
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 06:40:40 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id c124so2091667wma.5
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 06:40:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TkkkJZ1VdKmJQRBRfRBaz214s7NmqvOMrxvKyxKeWWM=;
        b=Fm2JLXdJg8vcqslwmmLplwUCwip28Bl4GZB57QtYnc/FdE18EFrQypEw7cVEVNYa9p
         iIRhn4cBkQQ0wZXMs6JUztMi/t7MmKB1WGg0oeoeKMm1FxC5QB3Xz5AVyCuAknPyZ4ZY
         ji2bxkhIIxHrcNxcyE9h4d6niS5qtHa073OVK7XOeuHCWhIBQMh4d5k5lnZon/YM50ot
         Dpxx/5kcJFka8tf8+fVZahnSJsVWmkS+jR7UF360tBbIHHmoExFK7hN0c7zXTFBeLkky
         yZaBmOK3uQfbum6yXZI7flU0bJWix1h6T2VyIKVuMtb4cG+jZFKt5HhkyQ5Yx2mv7SRN
         5y6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TkkkJZ1VdKmJQRBRfRBaz214s7NmqvOMrxvKyxKeWWM=;
        b=a4WR33gAAqMoUDw69TCnbMaJBVME5ffchTYC63JKitqR9Q2VPX9w2AALJUboq9pypD
         ZR3M7JmgNi7fdwNu2dpLVPqznkIyFNJ6180pizN1DfzyNT9QrDv0YcWXQQhHSowH6vR2
         XwBa/0Yt2DaKcZIWH3ayKx+xaP3y0msPLvU+oFYsxTcx7U6lU4gn/vy/1UwSAdL9zHJo
         Ae80Zw3Ay6Eqi5myiFQp/Har6jV4lyaNjHFHUuQbTKkD49JUtmtirExzg7MnjaUqyt14
         4QDuBOTbATYBdsU5QRWOh6OAMRGIeVjJpCpbE7AeAGKRbi3o8dDdn3D6DpeIekC4gAUa
         H8Xw==
X-Gm-Message-State: AOAM53348qz9QGevNjGopZeK7VDHvyb4d3ff5tDFyLtnmiFoNu8ijLw+
        lNdZ/2me2iA5YUamBB4wsVM=
X-Google-Smtp-Source: ABdhPJy6rJvk36pNtKltuDH0VOsQQVAEzcz88bFNX+X4ZlhO3JHkEAdaeD7OV3Ov71VlcWwLqXL4/Q==
X-Received: by 2002:a7b:c24d:: with SMTP id b13mr3895003wmj.151.1610462439434;
        Tue, 12 Jan 2021 06:40:39 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:692c:dce8:ab8c:98a? (p200300ea8f065500692cdce8ab8c098a.dip0.t-ipconnect.de. [2003:ea:8f06:5500:692c:dce8:ab8c:98a])
        by smtp.googlemail.com with ESMTPSA id i9sm5318216wrs.70.2021.01.12.06.40.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jan 2021 06:40:38 -0800 (PST)
Subject: Re: [PATCH net-next v4 1/4] net: phy: mdio-i2c: support I2C MDIO
 protocol for RollBall SFP modules
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>,
        netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        pali@kernel.org
References: <20210111050044.22002-1-kabel@kernel.org>
 <20210111050044.22002-2-kabel@kernel.org>
 <51416633-ab53-460f-0606-ef6408299adc@gmail.com> <X/2sCciKK9kVwnog@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <3cd4c604-70e8-d682-6ce5-b72111a22742@gmail.com>
Date:   Tue, 12 Jan 2021 15:40:33 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <X/2sCciKK9kVwnog@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.01.2021 15:02, Andrew Lunn wrote:
>> I'd think that mdio-i2c.c is for generic code. When adding a
>> vendor-specific protocol, wouldn't it make sense to use a dedicated
>> source file for it?
> 
> Hi Heiner
> 
> There is no standardised way to access MDIO over i2c. So the existing
> code is vendor code, even if it is used by a few different vendors.
> 
>      Andrew
> 
OK, I see. Thanks, Andrew.
