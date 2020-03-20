Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDDF018CD10
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 12:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbgCTLea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 07:34:30 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45063 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbgCTLea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 07:34:30 -0400
Received: by mail-pf1-f195.google.com with SMTP id j10so3072374pfi.12;
        Fri, 20 Mar 2020 04:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=w5yCwFFb0Wy5K3PTZwx7bVnKFFcSKBW5tKJtkESs2aw=;
        b=ajHebim7c8DB+gyphBpDOpQUUg/DWO6XyWR+tC56I/NGTUMIsatgJAWVwOrLG+KiVz
         JnDOI13m2hwna1rxBav5HzHy3ne7vUJ7JxorKw12YsN3HVdiVY65Hscv7kifbpbnGAIz
         TPVp47Z0kvxMSheE8J7PFwbhgmi4rFAXsn9q/3Rw2JAgJmrYWUfqev5+XcSb2JznPvk7
         Zenh06nqJlaUoMsAZe5zVl4nSLMjV2TmmSuHWFpkRhXsF+qbi6UiCoeVLyUhd+lTeVox
         eE4VMkcywW+I2dBdqrxBKfBOmh7yKJdnYNapGPENPDd1AY+Sde8ENshPP5Uv+LVJb1kC
         KeHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=w5yCwFFb0Wy5K3PTZwx7bVnKFFcSKBW5tKJtkESs2aw=;
        b=j9nUBtFM46UpDd6+0cFolO+9bU2vgSKInWMFRF8u6QDMfdqLXc8Fj2iKUvOaTReayH
         l61kqpTJg6biixV/UqcV9zOzIzvMTrOTCNCGTooQxW4eFKUWAiCvYmbU0nbYeW4kH0W2
         /K2tbzplAYy6yFpH/vePmlUwmSxbm8YPkLzAnqTh9pfOEQ+O+oJgRt7V2MDiUIeXVzvL
         j8fa1oUIEvkg3jldXpoKPHFBTsvpBjipLh3T8oUEpTAHJTtM2qxF4ajLlolHbkJfEQHz
         4gAYtKRZB+tKCSRMTyIW0IiAHO9fxI9Q/XuroA34NNqIijnREYig41N3PanTa8MEPPK5
         yXqg==
X-Gm-Message-State: ANhLgQ25RKNDG1eGynNeDSf7j6ps23x8ntMbJO0Y4RHj9SEjqBpGjwye
        aZzgaxy+g1+tw422HmC/DSAa6Hg7
X-Google-Smtp-Source: ADFU+vsU/wDasiz6CVWOJuxcRdtMGvdG+9dyAmoR/SXy0i9xfJDdZyWNxGkjymDe87m5hrR5X8oAww==
X-Received: by 2002:aa7:9aa9:: with SMTP id x9mr9480760pfi.320.1584704068743;
        Fri, 20 Mar 2020 04:34:28 -0700 (PDT)
Received: from localhost (216.24.188.11.16clouds.com. [216.24.188.11])
        by smtp.gmail.com with ESMTPSA id q15sm5142428pgn.68.2020.03.20.04.34.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 20 Mar 2020 04:34:28 -0700 (PDT)
Date:   Fri, 20 Mar 2020 19:34:24 +0800
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, tglx@linutronix.de, broonie@kernel.org,
        corbet@lwn.net, mchehab+samsung@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/7] introduce read_poll_timeout
Message-ID: <20200320113424.GA29203@nuc8i5>
References: <20200319163910.14733-1-zhengdejin5@gmail.com>
 <d1ba5c47-5a8f-f689-6d33-ec927f4268d8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d1ba5c47-5a8f-f689-6d33-ec927f4268d8@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 19, 2020 at 09:42:42AM -0700, Florian Fainelli wrote:
> Le 2020-03-19 à 09:39, Dejin Zheng a écrit :
> > This patch sets is introduce read_poll_timeout macro, it is an extension
> > of readx_poll_timeout macro. the accessor function op just supports only
> > one parameter in the readx_poll_timeout macro, but this macro can
> > supports multiple variable parameters for it. so functions like
> > phy_read(struct phy_device *phydev, u32 regnum) and
> > phy_read_mmd(struct phy_device *phydev, int devad, u32 regnum) can
> > use this poll timeout framework.
> > 
> > the first patch introduce read_poll_timeout macro, and the second patch
> > redefined readx_poll_timeout macro by read_poll_timeout(), and the other
> > patches are examples using read_poll_timeout macro.
> > 
> > 
> > Dejin Zheng (7):
> >   iopoll: introduce read_poll_timeout macro
> >   iopoll: redefined readx_poll_timeout macro to simplify the code
> >   net: phy: introduce phy_read_mmd_poll_timeout macro
> >   net: phy: bcm84881: use phy_read_mmd_poll_timeout() to simplify the
> >     code
> >   net: phy: aquantia: use phy_read_mmd_poll_timeout() to simplify the
> >     code
> >   net: phy: introduce phy_read_poll_timeout macro
> >   net: phy: use phy_read_poll_timeout() to simplify the code
> > 
> >  drivers/net/phy/aquantia_main.c | 16 +++++++--------
> >  drivers/net/phy/bcm84881.c      | 24 ++++++----------------
> >  drivers/net/phy/phy_device.c    | 18 ++++++-----------
> >  include/linux/iopoll.h          | 36 ++++++++++++++++++++++++++-------
> >  include/linux/phy.h             |  7 +++++++
> >  5 files changed, 55 insertions(+), 46 deletions(-)
> 
> Your diffstat is positive, so what's the point of doing this? What
> problem are you trying to solve?

Since I added a lot of code comments(20 lines) in the first patch, so the
diffstat is positive.

this patches just want to fix an issue that people often implement polling
is wrong. we use a poll core which is known to be good by readx_poll_timeout
gives us. It can support multiple parameters after extending
readx_poll_timeout, so phy_read() and phy_read_mmd() also can use this
poll core. 

> -- 
> Florian
