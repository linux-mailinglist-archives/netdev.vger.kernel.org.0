Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43382109029
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 15:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728196AbfKYOjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 09:39:25 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46722 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728071AbfKYOjZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 09:39:25 -0500
Received: by mail-pf1-f196.google.com with SMTP id 193so7457471pfc.13;
        Mon, 25 Nov 2019 06:39:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DTFCnl5gh1u+TR9T7mZcMZHn+JFU1MgZVavln5ZZFag=;
        b=MbGZAPdEGQpokB1vplVcMY1xo9Kfk48iqryyYjtGAlS7hyRFB5zH8YY6aR7mO8Xdis
         xmo6B2th0X8k5Yb6eoHYHLpaEfeuin0naZZlCoi2AQf4JC+60ccTheRE+eXAaK2kb8Jg
         Xs16MNWWj6B8pTSOtM0Xfqd/hbGzcZ1rmE7NErdTnSBKbvkVKXQYFAbWiafIyKQSIQt3
         Z0q1rFAjrt6IlVC2tyEG8fPwKcsqHYmTnIOHTOdRxmKWHdWVa6cz5A/OFo0z+jAy8y5y
         oy86jgUwg0V18FZ8WeqbGj3D1qxMr216FcQBkggMzHi6UNmuHArME6eZhf4HK9o6psQA
         zphA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DTFCnl5gh1u+TR9T7mZcMZHn+JFU1MgZVavln5ZZFag=;
        b=f6H0K6GoMcoMCoe4EiPIeFm7I8hTphiS+Oitw9lzNDrSiiTZDpvGoZeplzhHohVEcJ
         EsvxoFGGWCJfxEgOA7pIxvqBezq9hAEr0WhXc2ne3IOc4wamzhL7jaGXQ2CE6OtwIVC0
         5GMIMYY4BR8GBvyepQICctDaAYtjeETmqv6sQdcqSNary06UHLXAdvJmqYCT4eSk6eQ4
         5Ev62ME4ldq7aTVkacCDYEtc5z5Nc3l7cn6/pCxQle4cM+wxQDI05POKQOqrF4ZxZjG9
         M3uSCUpTc6wGOdpfawC4FtQxTrCCfIWk+FyhZrRD16DZtCiZN9VyLxvxIBZofqF3S66j
         4s8w==
X-Gm-Message-State: APjAAAW+yfr1sGzotPC3EhCUdf7+lAswKft8EU8JigjsuFwkCznRy07v
        OOb0euwqjcG+6dnRQAK8Qro=
X-Google-Smtp-Source: APXvYqy8f/sNdB9zlR2x/uQai4PddUprffiZxMQivT0emqtkfFV7dardd/K56g6HAct66PyfFGHZWA==
X-Received: by 2002:a63:d750:: with SMTP id w16mr32248403pgi.156.1574692760406;
        Mon, 25 Nov 2019 06:39:20 -0800 (PST)
Received: from nishad ([106.51.232.103])
        by smtp.gmail.com with ESMTPSA id u7sm8564035pfh.84.2019.11.25.06.39.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 25 Nov 2019 06:39:19 -0800 (PST)
Date:   Mon, 25 Nov 2019 20:09:10 +0530
From:   Nishad Kamdar <nishadkamdar@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: Use the correct style for SPDX License
 Identifier
Message-ID: <20191125143900.GA2572@nishad>
References: <20191123130815.GA3288@nishad>
 <20191123183455.6266e9a8@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191123183455.6266e9a8@cakuba.netronome.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 23, 2019 at 06:34:55PM -0800, Jakub Kicinski wrote:
> On Sat, 23 Nov 2019 18:38:19 +0530, Nishad Kamdar wrote:
> > diff --git a/drivers/net/phy/aquantia.h b/drivers/net/phy/aquantia.h
> > index 5a16caab7b2f..40e0be0f4e1c 100644
> > --- a/drivers/net/phy/aquantia.h
> > +++ b/drivers/net/phy/aquantia.h
> > @@ -1,5 +1,5 @@
> > -/* SPDX-License-Identifier: GPL-2.0
> > - * HWMON driver for Aquantia PHY
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*  HWMON driver for Aquantia PHY
> 
> You're adding an extra space here. Is this intentional?

No, It shouldn't be there.

Thanks you for pointing it out.
I'll update and resend the patch.

Thanks for the review.

Regards,
Nishad

> 
> >   *
> >   * Author: Nikita Yushchenko <nikita.yoush@cogentembedded.com>
> >   * Author: Andrew Lunn <andrew@lunn.ch>
