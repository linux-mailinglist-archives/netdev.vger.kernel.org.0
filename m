Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8224E4081E4
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 23:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236451AbhILVkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 17:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236320AbhILVkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 17:40:13 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64216C061574;
        Sun, 12 Sep 2021 14:38:58 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 9so11241178edx.11;
        Sun, 12 Sep 2021 14:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=i/jEd8c7Upbl8XQpByKCTkjIzB/I2CUIv7rgFRPBAQM=;
        b=Y2gzZXrk2XTDD9Sh6p5GjcmZNQn1HYY9SQB56mBYz8MbHFRUVlbWBMHVhVs5bzKL+6
         hqAvu/rUFh+RsDTlgAei+Od2ARYGnr4ifR86TwWhOIwFb9g/Kii3SNbGdHH3PmGJnw/v
         v4PnJkdoocdRMbYALqC6eWw0Fjtk71pUBbUjZoA4bO2tbaDP5XMs5KBG1Mw7DF/1LEEP
         202Ya/TJfvQ1Rs+YFZ3hZo1wgHDACkPiVTkFtHN0kvtODE+l4R+ZT+DCjiY035FJS76f
         CCqfOl/VFfoQHAPqx8eHIuK/6iMCabyn6IooSlbaKNeaOz/HG1rTGiwbx8xh6fQw4u+N
         v6dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i/jEd8c7Upbl8XQpByKCTkjIzB/I2CUIv7rgFRPBAQM=;
        b=c8Y9xdk4VTtZDg6jodJtv7VvjRxTcaGWd3YE/hd1TQo2dVia9SCPdj/ES9dS7+VVlw
         l5pYyzFZDPHinyUzaTzsa/GSBYtJ69XK8guKYXnpL6UNAqrALY3nV2dkmjt9SXwKVLze
         izpVks8MgbLkhpCqwC7QzpJRiIiI1+tiMs9iCmSt9Bwoo0AfDTAw1A4bP5EhL2QT0Fmt
         R3Y5cUCFVN+lsiYV95HgmeiKFGRlcKl3jqvrPe49UQGbGZDjpgnwe9hpZCx4VUaOGBGz
         mmTtyOaHHY2LFNfkJoeo4WC4GV6o5OQfI2l2YsmRe5311ccKK5cgzlt28dcFWsYi221r
         xLoQ==
X-Gm-Message-State: AOAM533d1cc94GWLvTccfaLLVrb32OyjfA71YiTycImJ4QmXtUy3Ajb6
        pumXDeHuGhugiU5Oir5Hztk=
X-Google-Smtp-Source: ABdhPJzLKIiesrF1bvNuMiJnpElEmUgQB+M0bfbA5pbroDW+UunOO2En0TW87cEr33eCKtiVHNEh4A==
X-Received: by 2002:a05:6402:440f:: with SMTP id y15mr9497342eda.400.1631482736998;
        Sun, 12 Sep 2021 14:38:56 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id v12sm2870933ede.16.2021.09.12.14.38.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Sep 2021 14:38:56 -0700 (PDT)
Date:   Mon, 13 Sep 2021 00:38:55 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net] Revert "net: phy: Uniform PHY driver access"
Message-ID: <20210912213855.kxoyfqdyxktax6d3@skbuf>
References: <20210912192805.1394305-1-vladimir.oltean@nxp.com>
 <CANr-f5wCpcPM+FbeW+x-JmZt0-WmE=b5Ys1Pa_G7p8v3nLyCcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANr-f5wCpcPM+FbeW+x-JmZt0-WmE=b5Ys1Pa_G7p8v3nLyCcQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 12, 2021 at 10:49:25PM +0200, Gerhard Engleder wrote:
> > This reverts commit 3ac8eed62596387214869319379c1fcba264d8c6.
> >
> > I am not actually sure I follow the patch author's logic, because the
> > change does more than it says on the box, but this patch breaks
> > suspend/resume on NXP LS1028A and probably on any other systems which
> > have PHY devices with no driver bound, because the patch has removed the
> > "!phydev->drv" check without actually explaining why that is fine.
> 
> The wrong assumption was that the driver is set for every device during probe
> before suspend. Intention of the patch was only clean up of
> to_phy_driver() usage.

I am not sure why "to_phy_driver" needs cleanup. Au contraire, I think
the PHY library's usage of struct phy_device :: drv is what is strange
and potentially buggy, it is the only subsystem I know of that keeps its
own driver pointer rather than looking at struct device :: driver.
I think this is largely for historical reasons (it has done this since
the first commit), but it looks to me like to_phy_driver could be used
as part of a larger macro called something like phydev_get_drv which
retrieves the phy_driver from the phydev->mdio.dev.driver.

I say it is buggy because when probing fails ("fails" includes things
like -EPROBE_DEFER) it does not even bother to clear phydev->drv back to
NULL, even though the device will not have a driver pointer. There are
also other things which it does not clean up on probe failure, btw, each
with its own interesting side effects.

> >  static bool mdio_bus_phy_may_suspend(struct phy_device *phydev)
> >  {
> > +       struct device_driver *drv = phydev->mdio.dev.driver;
> > +       struct phy_driver *phydrv = to_phy_driver(drv);
> >         struct net_device *netdev = phydev->attached_dev;
> >
> > -       if (!phydev->drv->suspend)
> > +       if (!drv || !phydrv->suspend)
> >                 return false;
> >
> >         /* PHY not attached? May suspend if the PHY has not already been
> 
> I suggest to add the "!phydev->drv" check, but others may know it
> better than me.

So in this case, the difference will be that with your change, a
phy_probe that returns an error code like -EPROBE_DEFER will have the
phydev->drv set, and it will not return false ("may not suspend") quickly,
while the code in its original form will not attempt to suspend that PHY.

The implication is that we may call the ->suspend method of a PHY that
is deferring probe, _before_ the probe has actually succeeded.

To me, making that change and moving the code in yet a third state is
way outside of the scope, which was to restore it to a known working
condition (aka bug fix). If you want to make that change, feel free, I will not.
