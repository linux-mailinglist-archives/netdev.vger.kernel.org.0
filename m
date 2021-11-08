Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C56A449C91
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 20:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237587AbhKHTip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 14:38:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbhKHTio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 14:38:44 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5392C061570
        for <netdev@vger.kernel.org>; Mon,  8 Nov 2021 11:35:59 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id b12so28839146wrh.4
        for <netdev@vger.kernel.org>; Mon, 08 Nov 2021 11:35:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=tMJWoZJzPvGomqVBuhtM8f/5fMdamy2TM7JQt+c2k/E=;
        b=L5+eDthlJ5gjOv1S0TK4MxnEvYRplKUv1qSdRVQo+YJUL/58NkHYH4LwZUzOhfxocJ
         JSZPZdUhG7+B/UDvut1nOeewLx8AUWy9POGaMG+BuGhzFmaoCSmcxFC+noegpAoTSM17
         3ijsFynyFgU+lznPztMZaxdZuIhfnEdeF0BpeeT5t1Vnh2me5Ouhq0p14IXs8EtZYOAb
         t/v7hSZ5iBicdpj8tXs85BsbfNzSC1vkcYcSwP8EtVRgnW+EPveXhsPJTGLsldGZ+O/C
         tVEdcTW29LjfryfF0SWTllkKeWn8ncKNToa5Paf5vlSzpBiuQpQT3D+/YbM4NU62z/PR
         wYRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=tMJWoZJzPvGomqVBuhtM8f/5fMdamy2TM7JQt+c2k/E=;
        b=ctBi7XgecotYEXUTK2suYQ5nm47phZMj1Z0+ctJ2SaWolG7QHZVNwTqsC+uyU7H3al
         k9YAuKLWKhu+ETePOHKMNFfZmfljgXqkYjFoQrUb9vK/2TeXYr7SlE3Tg/gATQq1udb2
         lFsji9K+p2c6xRxcBuOwLSfy27pZAAnM4vG6Cjt7H7ZVZUVH6QPwnHDKKrCSPbz4Yk8v
         jUdaAjPVjPA9pLJYZ15845ZKGG2aitsRWctf4CPbQYcRzL/uUtl7pETo9l+7rjSzf5JF
         BWTMTQ60ZyJDef3c/1WvfJfzDjVX+QMbrcwQlWqV1GorjmrGoUOuMVkVxJFE38ExAFwM
         +06A==
X-Gm-Message-State: AOAM530XBcp4rc5HpL+gMY5c098wR69vYUbYaxsI0H3D4qJqP0XECOHw
        tqGQj2+SfMWtlIJ/kESSNMmydWbrJbk=
X-Google-Smtp-Source: ABdhPJzrWSOlX5ArxupKUpehU95Jx1yet31/gzt7uAjOC0wrS+aKaFv8lZOJTHj8/FX+0TPyWdNtwQ==
X-Received: by 2002:a5d:62c5:: with SMTP id o5mr1977830wrv.408.1636400158529;
        Mon, 08 Nov 2021 11:35:58 -0800 (PST)
Received: from ?IPV6:2003:ea:8f1a:f00:2d8a:e3d9:1c29:7a84? (p200300ea8f1a0f002d8ae3d91c297a84.dip0.t-ipconnect.de. [2003:ea:8f1a:f00:2d8a:e3d9:1c29:7a84])
        by smtp.googlemail.com with ESMTPSA id e7sm17664944wrg.31.2021.11.08.11.35.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Nov 2021 11:35:57 -0800 (PST)
Message-ID: <b1defb1e-fd87-d84b-3ea1-efaa461ccd30@gmail.com>
Date:   Mon, 8 Nov 2021 20:35:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH net v2] net: phy: phy_ethtool_ksettings_set: Don't discard
 phy_start_aneg's return
Content-Language: en-US
To:     Benedikt Spranger <b.spranger@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>, Bastian Germann <bage@linutronix.de>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        davem@davemloft.net, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>
References: <20211105153648.8337-1-bage@linutronix.de>
 <20211108141834.19105-1-bage@linutronix.de>
 <YYkzbE39ERAxzg4k@shell.armlinux.org.uk> <20211108160653.3d6127df@mitra>
 <YYlLvhE6/wjv8g3z@lunn.ch>
 <63e5522a-f420-28c4-dd60-ce317dbbdfe0@linutronix.de>
 <YYlk8Rv85h0Ia/LT@lunn.ch> <e07b6b7c-3353-461e-887d-96be9a9f6f36@gmail.com>
 <20211108200257.78864d69@mitra>
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <20211108200257.78864d69@mitra>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.11.2021 20:02, Benedikt Spranger wrote:
> On Mon, 8 Nov 2021 19:01:23 +0100
> Heiner Kallweit <hkallweit1@gmail.com> wrote:
> 
>> If we would like to support PHY's that don't support all MDI modes
>> then supposedly this would require to add ETHTOOL_LINK_MODE bits for
>> the MDI modes. Then we could use the generic mechanism to check the
>> bits in the "supported" bitmap.
> 
> The things are even worse:
> The chip supports only auto-MDIX at Gigabit and force MDI and

The Gigabit part seems to be normal. Gigabit supports neither
forced mode nor forced MDI settings.

> auto-MDIX in 10/100 modes. No force MDIX at all.
> 
> A validation callback from phy_ethtool_ksettings_set() before
> restarting the PHY seems reasonable for me. Something like:
> 
> 	/* Verify the settings we care about. */
> 	if (autoneg != AUTONEG_ENABLE && autoneg != AUTONEG_DISABLE)
> 	        return -EINVAL;
> 
>         if (autoneg == AUTONEG_ENABLE && linkmode_empty(advertising))
> 	        return -EINVAL;
> 
>         if (autoneg == AUTONEG_DISABLE &&
> 	    ((speed != SPEED_1000 &&
> 	      speed != SPEED_100 &&
>               speed != SPEED_10) ||
>              (duplex != DUPLEX_HALF &&
>               duplex != DUPLEX_FULL)))
>                 return -EINVAL;
> 
> 	if (phydev->validate_cmd && phydev->validate_cmd(cmd))
> 		return -EINVAL;
> 
> Thanks
>     Benedikt Spranger
> 

