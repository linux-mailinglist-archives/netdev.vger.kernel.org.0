Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74F6180B8F
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 18:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbfHDP75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 11:59:57 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:46140 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbfHDP75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 11:59:57 -0400
Received: by mail-ed1-f67.google.com with SMTP id d4so76566503edr.13;
        Sun, 04 Aug 2019 08:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LKEPVn9o+LbP/zEqacWA6Cm2RJzPdDZCIdvvzhFGTHI=;
        b=XDlk/958/bFLgKwtLuUmlqrc2kYHa79lwZh5zp/TvNdQbm9qZyuZxhyyTtJXKQROpt
         1RQACh8Xpa91K8TBhY0VOmaVR2TUi/L5DXKUSQXjMQcibulz7uzushV/zWym2AcqFj6u
         b5a50kYjAVcIyrLKoSRyedDF7FDlcj31bUHWNZ7unS/WgP+daql5V/Fj2bJPKUjni4Sp
         u5kZCLoYtzn7MSmD3I5AQfJkK9mw3eVvxJ+aDgD4+QynRAUMyt/la/NDev8Y9maqAN3U
         Zi9i4ieF+GxzX2uIwZkN7XacqV5hQZuRBVuqu6SK4Bd2gTfwPOwA+RvLA/36N57/nU2j
         eggw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LKEPVn9o+LbP/zEqacWA6Cm2RJzPdDZCIdvvzhFGTHI=;
        b=AGKaVJQ1ZCfwfrNeb4Hyys7QNf85qMMn5Igv9/979WJQFYX78a/PJynpuU6euH7Txf
         79nLMk/6yP2THZjqAHMBRsoncxT3tHZ1seBr1kUjWCycAGnMf7kyw3co8FhtYY3O+zaF
         kUou3ykL4SVSvajO/4kE1pvJz9CEo446fRJP6CQH715ntOvRWyJp3YwvAIYxDeAY9cDo
         A9kkmc9o34/irdisuUamCdw32wkLfQf1nYIplxt5cl0y7sZlLSV31WmvZbWgVGZq18yN
         E4OR7hTweKTkPY+NgvLk6TsRodO67Ky4lEBuaJ87D9EEt4eEyLMPAkhDes335SDO1Wtp
         Z+AA==
X-Gm-Message-State: APjAAAWjRM4MtoFD770+NuZNlLp8Qq5Rc9cUDNyr03NMtLVLmmZ4fgJ5
        M676KopjFwTODoRNcR2ZstjdJUFmAbvGMPy4Xlw=
X-Google-Smtp-Source: APXvYqwreSvMloqehil39KDrhBN9AS+72g3Fz7y8sj6sX+5ARUrwWyOmiRFQReqPP4rDwtFjwHcDG5plDPzyti8rAKs=
X-Received: by 2002:a05:6402:1285:: with SMTP id w5mr130982149edv.36.1564934395692;
 Sun, 04 Aug 2019 08:59:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190802215419.313512-1-taoren@fb.com> <CA+h21hrOEape89MTqCUyGFt=f6ba7Q-2KcOsN_Vw2Qv8iq86jw@mail.gmail.com>
 <53e18a01-3d08-3023-374f-2c712c4ee9ea@fb.com> <20190804145152.GA6800@lunn.ch>
In-Reply-To: <20190804145152.GA6800@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sun, 4 Aug 2019 18:59:44 +0300
Message-ID: <CA+h21hrUDaSxKpsy9TuWqwgaxKYaoXHyhgS=xSoAcPwxXzvrHg@mail.gmail.com>
Subject: Re: [PATCH net-next v3] net: phy: broadcom: add 1000Base-X support
 for BCM54616S
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Tao Ren <taoren@fb.com>, Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 4 Aug 2019 at 17:52, Andrew Lunn <andrew@lunn.ch> wrote:
>
> > > The patchset looks better now. But is it ok, I wonder, to keep
> > > PHY_BCM_FLAGS_MODE_1000BX in phydev->dev_flags, considering that
> > > phy_attach_direct is overwriting it?
> >
>
> > I checked ftgmac100 driver (used on my machine) and it calls
> > phy_connect_direct which passes phydev->dev_flags when calling
> > phy_attach_direct: that explains why the flag is not cleared in my
> > case.
>
> Yes, that is the way it is intended to be used. The MAC driver can
> pass flags to the PHY. It is a fragile API, since the MAC needs to
> know what PHY is being used, since the flags are driver specific.
>
> One option would be to modify the assignment in phy_attach_direct() to
> OR in the flags passed to it with flags which are already in
> phydev->dev_flags.
>
>         Andrew

Even if that were the case (patching phy_attach_direct to apply a
logical-or to dev_flags), it sounds fishy to me that the genphy code
is unable to determine that this PHY is running in 1000Base-X mode.

In my opinion it all boils down to this warning:

"PHY advertising (0,00000200,000062c0) more modes than genphy
supports, some modes not advertised".

You see, the 0x200 in the above advertising mask corresponds exactly
to this definition from ethtool.h:
    ETHTOOL_LINK_MODE_1000baseX_Full_BIT    = 41,

But it gets truncated and hence lost.

Regards,
-Vladimir
