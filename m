Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35560340A07
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 17:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232111AbhCRQV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 12:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232110AbhCRQV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 12:21:26 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C100C06174A;
        Thu, 18 Mar 2021 09:21:25 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id f22-20020a7bc8d60000b029010c024a1407so5796791wml.2;
        Thu, 18 Mar 2021 09:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ptHRPUcJFE6Bu93FKigMS0Nm/kGzvMR3rd6kQRyhtOM=;
        b=Qk+K5Z1TxaWEVB6157Yw0mxjlhMq/by0ks9i05WwXEH7GT0YG8SJaewzE513HjSAjY
         on9zJV0wwL9Ciie8J0MNAiFHauRYZAwG+U7KW6LSwRgUbV4rcbX+MuwDa+gtJLUjdr5O
         t7BC+oHqQ3yOHi/z5NKfT95+fiIT+0dudmjmRcnDUXJaF+jtnPCqmPsG3i/WczpzkjB/
         ziPainebxS9/87+ip+/gCrJGr3pAhnGw9gop6dHdsAYbffSg8uWhvkjgEPh+V+ZKOpBs
         cHRARik6gkQbQGnfgWDTpiW/y9gArOpxjT4fPBXXDnf9hVzOME2RmWSLyVOla/m2VPP4
         v+yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ptHRPUcJFE6Bu93FKigMS0Nm/kGzvMR3rd6kQRyhtOM=;
        b=jEQQCGuxHLG6eKK5ejdmnAVHetzbS8GU8tRVq5bLqrGmAA0BhLqrzanGoUTAr3encs
         rF2zsAzGRuCtcSbzTCHNY+mzWLEwr2E34rdr0yUo7EgZ9MsXogruvo6tQBMfpKOuaWpf
         Lj5325ETOjJM2rjQFfHWV6FL9AX6qWXrjkHM9pzXOPkP/JE3e/uE/yx026tlk8oU1ccy
         qKkt4pJ+O4ENk4npQ4W4jPyYv/GcAZ8tljg0XUKAzi82eLJZmsj9gO7Cz1cbitc+UGlH
         suo7asWGjpfnDt25fFCViGeRJVS6pot3JQEQ9Q+taiLc5RbKB0pfuAQ6jFdOwl8ktkC+
         lk6Q==
X-Gm-Message-State: AOAM5337lAlY/eLBxb5Cs1Xu1VQFMtlIuVLBGFpmG2EPNbyqftUaghft
        DO5ga4ql2JWa7DHNxTGUCyo=
X-Google-Smtp-Source: ABdhPJwgI8dpv1uy3Ha/2GiguOdDu03WqxDqum+Zjk1g6wtpJJ11V/aCKL0wMUKCoG4c+E5oTkoteg==
X-Received: by 2002:a1c:cc04:: with SMTP id h4mr81084wmb.142.1616084484258;
        Thu, 18 Mar 2021 09:21:24 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f1f:bb00:8d2c:8cc:6c7f:1a84? (p200300ea8f1fbb008d2c08cc6c7f1a84.dip0.t-ipconnect.de. [2003:ea:8f1f:bb00:8d2c:8cc:6c7f:1a84])
        by smtp.googlemail.com with ESMTPSA id g16sm3726494wrs.76.2021.03.18.09.21.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 09:21:23 -0700 (PDT)
Subject: Re: [PATCH net-next] net: phy: at803x: remove at803x_aneg_done()
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Michael Walle <michael@walle.cc>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210318142356.30702-1-michael@walle.cc>
 <411c3508-978e-4562-f1e9-33ca7e98a752@gmail.com>
 <20210318151712.7hmdaufxylyl33em@skbuf>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <ee24b531-df8b-fa3d-c7fd-8c529ecba4c8@gmail.com>
Date:   Thu, 18 Mar 2021 17:21:18 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210318151712.7hmdaufxylyl33em@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.03.2021 16:17, Vladimir Oltean wrote:
> On Thu, Mar 18, 2021 at 03:54:00PM +0100, Heiner Kallweit wrote:
>> On 18.03.2021 15:23, Michael Walle wrote:
>>> at803x_aneg_done() is pretty much dead code since the patch series
>>> "net: phy: improve and simplify phylib state machine" [1]. Remove it.
>>>
>>
>> Well, it's not dead, it's resting .. There are few places where
>> phy_aneg_done() is used. So you would need to explain:
>> - why these users can't be used with this PHY driver
>> - or why the aneg_done callback isn't needed here and the
>>   genphy_aneg_done() fallback is sufficient
> 
> The piece of code that Michael is removing keeps the aneg reporting as
> "not done" even when the copper-side link was reported as up, but the
> in-band autoneg has not finished.
> 
> That was the _intended_ behavior when that code was introduced, and you
> have said about it:
> https://www.spinics.net/lists/stable/msg389193.html
> 
> | That's not nice from the PHY:
> | It signals "link up", and if the system asks the PHY for link details,
> | then it sheepishly says "well, link is *almost* up".
> 
> If the specification of phy_aneg_done behavior does not include in-band
> autoneg (and it doesn't), then this piece of code does not belong here.
> 
> The fact that we can no longer trigger this code from phylib is yet
> another reason why it fails at its intended (and wrong) purpose and
> should be removed.
> 
I don't argue against the change, I just think that the current commit
description isn't sufficient. What you just said I would have expected
in the commit description.
