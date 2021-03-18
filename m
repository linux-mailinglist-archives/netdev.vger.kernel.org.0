Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD4B634089A
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 16:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbhCRPR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 11:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231790AbhCRPRQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 11:17:16 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A009CC06174A;
        Thu, 18 Mar 2021 08:17:15 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id b7so4555506ejv.1;
        Thu, 18 Mar 2021 08:17:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6I4fK3KIh7nvVeDlxIvnlzTbH7aTWaFZ8rA7KEHulZM=;
        b=Hm/hDDK3WOdEnJMWhOW9dFY7wxB13DGJ31r5esJ259MdDXGuOZt793vesPgJj4JYkl
         YaOuXj7qes7nYKz6miLhz9xEEJ0US4y7gYiPSKp9Nv2lm3qRzmee3XpZFhOAndl7A5fF
         EtOMyIZaA/K+hC1K8QRPfcazt2qrkNNw64uJD2QAg8sz04J7tyHuxWqyjfFXAp728iay
         egMQig/Hy1iq8vR9zJ7qNuYCMjrfGFHcbhitCjswfw6d5IKX3nc8eqc+y7Xd4ESMljiK
         6idzOxUxirdUB6DyFeNxE/EvQQwuYFFAwqio4pO95dbCotGG1yHF+yHZI44IC6UNsW/m
         1hzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6I4fK3KIh7nvVeDlxIvnlzTbH7aTWaFZ8rA7KEHulZM=;
        b=Wy2cC2oQoyvSx798SqQiACgpcfVSBZM/2z0o4rvO7BUrccirtc12JbGQzJe0JTW+W0
         XZ/BISyAzC35BiP0dEQ3zS7mg13kgCDAmIeNy0PKTN/mKeyiEbHtVObm8F6hKWPp3xAn
         xYqFKgDRnUsmNq6z5L8+MZWSoVHBy2ZdrQUbEBtRnCdjUIsthZJWMbZdqx0S9QSfqe6u
         yg9XMTgV87UmWrR2+t62Cau4lkhxyLTA6JSWvs4JS4+ILFwUkIEDawR9RzXvA2maEnpg
         Ytpgey0cVIi+YY5ozPJbMdDP6ivkG1sC84Zs6oM5NJCfml3Cu8bRQyT9Fbsg6A6Vd7o6
         8PJg==
X-Gm-Message-State: AOAM530/LS0j2uwx9TiggsP1aHZ8OfM3/7JzXwFu4ZLhn6h2o1EP20uv
        b7tZ9wYx68yc9mhvhyjUR3I=
X-Google-Smtp-Source: ABdhPJwgYWfjUVbf8fYnHv4Mh5jl1s7+5Gv4cxu44SiZ73UwrDTFNCj76OSuMY/6xE9A/j/xL272qA==
X-Received: by 2002:a17:906:c051:: with SMTP id bm17mr40738915ejb.21.1616080634298;
        Thu, 18 Mar 2021 08:17:14 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id l18sm2095560ejk.86.2021.03.18.08.17.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 08:17:13 -0700 (PDT)
Date:   Thu, 18 Mar 2021 17:17:12 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Michael Walle <michael@walle.cc>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: phy: at803x: remove at803x_aneg_done()
Message-ID: <20210318151712.7hmdaufxylyl33em@skbuf>
References: <20210318142356.30702-1-michael@walle.cc>
 <411c3508-978e-4562-f1e9-33ca7e98a752@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <411c3508-978e-4562-f1e9-33ca7e98a752@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 18, 2021 at 03:54:00PM +0100, Heiner Kallweit wrote:
> On 18.03.2021 15:23, Michael Walle wrote:
> > at803x_aneg_done() is pretty much dead code since the patch series
> > "net: phy: improve and simplify phylib state machine" [1]. Remove it.
> > 
> 
> Well, it's not dead, it's resting .. There are few places where
> phy_aneg_done() is used. So you would need to explain:
> - why these users can't be used with this PHY driver
> - or why the aneg_done callback isn't needed here and the
>   genphy_aneg_done() fallback is sufficient

The piece of code that Michael is removing keeps the aneg reporting as
"not done" even when the copper-side link was reported as up, but the
in-band autoneg has not finished.

That was the _intended_ behavior when that code was introduced, and you
have said about it:
https://www.spinics.net/lists/stable/msg389193.html

| That's not nice from the PHY:
| It signals "link up", and if the system asks the PHY for link details,
| then it sheepishly says "well, link is *almost* up".

If the specification of phy_aneg_done behavior does not include in-band
autoneg (and it doesn't), then this piece of code does not belong here.

The fact that we can no longer trigger this code from phylib is yet
another reason why it fails at its intended (and wrong) purpose and
should be removed.
