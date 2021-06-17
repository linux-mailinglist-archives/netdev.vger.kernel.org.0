Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52B963ABD0B
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 21:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233702AbhFQTqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 15:46:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43398 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231186AbhFQTqV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 15:46:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=WcfYPRE0/EJf8qotBrb5aK+0y3nj++4NLAbgWTjHHrg=; b=Oo
        dPNxwiG8q4J96mStd1uisfqYOSYVu9/iAm5VSCebDFL0XXBpP3QwOZbaYTEtAHCDE4V/MPNKxHvIV
        IvA92ML69hEYFIUg820lYU5I8tY3e8seuFnVQfHmPdnNZ7FdUxWRQLdJRRs+Gc8dBpQ2AHIs4+zLc
        o/0COcKLatUmDVU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ltxvq-009xSv-Oe; Thu, 17 Jun 2021 21:44:06 +0200
Date:   Thu, 17 Jun 2021 21:44:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Cc:     "jiri@nvidia.com" <jiri@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 00/11] Marvell Prestera driver implementation of
 devlink functionality.
Message-ID: <YMumBqQ1/gNEk6O5@lunn.ch>
References: <20210609151602.29004-1-oleksandr.mazur@plvision.eu>
 <AM0P190MB0738F58BF9FFE2ED8073FA84E40E9@AM0P190MB0738.EURP190.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AM0P190MB0738F58BF9FFE2ED8073FA84E40E9@AM0P190MB0738.EURP190.PROD.OUTLOOK.COM>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 17, 2021 at 05:30:07PM +0000, Oleksandr Mazur wrote:
> > Prestera Switchdev driver implements a set of devlink-based features,
> > that include both debug functionality (traps with trap statistics), as well
> > as functional rate limiter that is based on the devlink kernel API (interfaces).
> 
> > The core prestera-devlink functionality is implemented in the prestera_devlink.c.
> 
> > The patch series also extends the existing devlink kernel API with a list of core
> > features:
> >  - devlink: add API for both publish/unpublish port parameters.
> >  - devlink: add port parameters-specific ops, as current design makes it impossible
> >    to register one parameter for multiple ports, and effectively distinguish for
> >   what port parameter_op is called.
> 
> As we discussed the storm control (BUM) done via devlink port params topic, and agreed that it shouldn't be done using the devlink API itself, there's an open question i'd like to address: the patch series included, for what i think, list of needed and benefitial changes, and those are the following patches:

Please wrap your emails at around 70 characters.

> 
> > Oleksandr Mazur (2):
> ...
> >  net: core: devlink: add port_params_ops for devlink port parameters altering
> >  drivers: net: netdevsim: add devlink port params usage
>  
> > Sudarsana Reddy Kalluru (1):
> >  net: core: devlink: add apis to publish/unpublish port params
> 
> So, should i create a new patch series that would include all of them?
> 
> Because in that case the series itself would lack an actual HW usage of it. The only usage would be limited to the netdevsim driver.

We generally don't add APIs without a user. And in this case, i'm not
sure netdevsim is a valid user. Can you refactor some other driver to
make use of the new code? If not, i would suggest they are not merged
at the moment. When you do have a valid use case, you can post them
again.

	Andrew
