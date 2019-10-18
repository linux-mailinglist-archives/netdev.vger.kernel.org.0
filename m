Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F74ADD03B
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 22:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406437AbfJRU2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 16:28:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53342 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403797AbfJRU1w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 16:27:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=MJL8indOUtxiEjr9VBBt7bgZ+js2Y/110DtOOIaosPA=; b=KrnB9N8UPyzzO2kHe/xagfOgp/
        BU3JqBPM6ebfQVaOySJF8ZaZmixddu98mG6ZevFbErwMi5NJVIqBteDKjp+gWLoApvrAP3VZhEqnk
        wh4LBTdXJWTYsxZLWlUQwRlU4IWB2R8UF5kcyzJQZBH0JSpsdFTiENp7BRsWU7OdeTwU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iLYqi-00037d-PT; Fri, 18 Oct 2019 22:27:48 +0200
Date:   Fri, 18 Oct 2019 22:27:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, mlxsw@mellanox.com
Subject: Re: [patch net-next] devlink: add format requirement for devlink
 param names
Message-ID: <20191018202748.GL4780@lunn.ch>
References: <20191018160726.18901-1-jiri@resnulli.us>
 <20191018174304.GE24810@lunn.ch>
 <20191018200822.GI2185@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191018200822.GI2185@nanopsycho>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 18, 2019 at 10:08:22PM +0200, Jiri Pirko wrote:
> Fri, Oct 18, 2019 at 07:43:04PM CEST, andrew@lunn.ch wrote:
> >On Fri, Oct 18, 2019 at 06:07:26PM +0200, Jiri Pirko wrote:
> >> From: Jiri Pirko <jiri@mellanox.com>
> >> 
> >> Currently, the name format is not required by the code, however it is
> >> required during patch review. All params added until now are in-lined
> >> with the following format:
> >> 1) lowercase characters, digits and underscored are allowed
> >> 2) underscore is neither at the beginning nor at the end and
> >>    there is no more than one in a row.
> >> 
> >> Add checker to the code to require this format from drivers and warn if
> >> they don't follow.
> >
> >Hi Jiri
> >
> >Could you add a reference to where these requirements are derived
> >from. What can go wrong if they are ignored? I assume it is something
> 
> Well, no reference. All existing params, both generic and driver
> specific are following this format. I just wanted to make that required
> so all params are looking similar.
> 
> 
> >to do with sysfs?
> 
> No, why would you think so?

I was not expecting it to be totally arbitrary. I thought you would
have a real technical reason. Spaces often cause problems, as well as
/ etc.

I've had problems with hwmon device names breaking assumptions in the
user space code, etc. I was expecting something like this.

I don't really like the all lower case restriction. It makes it hard
to be consistent. All Marvell Docs refer to the Address Translation
Unit as ATU. I don't think there is any reference to atu. I would
prefer to be consistent with the documentation and use ATU. But that
is against your arbitrary rules.

       Andrew
