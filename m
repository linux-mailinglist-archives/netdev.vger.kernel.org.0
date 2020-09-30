Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A720D27EB7A
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 16:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730568AbgI3OyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 10:54:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36032 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727426AbgI3OyF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 10:54:05 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kNdUT-00GuhF-V2; Wed, 30 Sep 2020 16:53:57 +0200
Date:   Wed, 30 Sep 2020 16:53:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next v2 1/7] net: devlink: Add unused port flavour
Message-ID: <20200930145357.GM3996795@lunn.ch>
References: <20200928153504.1b39a65d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <61860d84-d0c6-c711-0674-774149a8d0af@gmail.com>
 <20200928163936.1bdacb89@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <c877bda0-140c-dce1-49ff-61fac47a66bc@gmail.com>
 <20200929110356.jnqoyy72bjer6psw@skbuf>
 <20200929130758.GF8264@nanopsycho>
 <20200929135700.GG3950513@lunn.ch>
 <20200930065604.GI8264@nanopsycho>
 <20200930135725.GH3996795@lunn.ch>
 <20200930143452.GJ8264@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930143452.GJ8264@nanopsycho>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> What do you mean by "regions"? Devlink regions? They are per-device, not
> per-port. I have to be missing something.

The rest of the patch series, which add regions per port! This came
out of the discussion from the first version of this patchset, and
Jakub said it would make sense to add per port regions, rather than
have regions which embedded a port number in there name.

     Andrew
 
