Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AAEE178049
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 19:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732786AbgCCRzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 12:55:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:37778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732491AbgCCRzv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 12:55:51 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A295214DB;
        Tue,  3 Mar 2020 17:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258150;
        bh=f9P66xgbJQ9wB5Inl51qyR5WIUHDwqFJZrF3AYu81Ro=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jBFbe2TdhpPom/L8rsdG3a33b0xuK3c/22fkaf27hP6RoIGByyB3pkoPqlSQu1dM2
         3EIbh+RckhcIt1A3Edy+Hgi/D7KLe/cskUnt6+3OhdBobKcnbv6Y/qccT1+FxZj7Nc
         KRRD5fnhtha/Rngt8xhD59S1oSY0QUC0oN5OKVVY=
Date:   Tue, 3 Mar 2020 09:55:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Alexander Aring <alex.aring@gmail.com>,
        alex.bluesman.smirnov@gmail.com, linux-wpan@vger.kernel.org
Subject: Re: [PATCH net 05/16] nl802154: add missing attribute validation
 for dev_type
Message-ID: <20200303095548.047a2c9b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <3c27dd0a-ff54-681b-b97c-98cd9d096b41@datenfreihafen.org>
References: <20200303050526.4088735-1-kuba@kernel.org>
        <20200303050526.4088735-6-kuba@kernel.org>
        <3c27dd0a-ff54-681b-b97c-98cd9d096b41@datenfreihafen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Mar 2020 16:39:55 +0100 Stefan Schmidt wrote:
> On 03.03.20 06:05, Jakub Kicinski wrote:
> > Add missing attribute type validation for IEEE802154_ATTR_DEV_TYPE
> > to the netlink policy.
> > 
> > Fixes: 90c049b2c6ae ("ieee802154: interface type to be added")
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>

> > diff --git a/net/ieee802154/nl_policy.c b/net/ieee802154/nl_policy.c
> > index 824e7e84014c..0672b2f01586 100644
> > --- a/net/ieee802154/nl_policy.c
> > +++ b/net/ieee802154/nl_policy.c
> > @@ -27,6 +27,7 @@ const struct nla_policy ieee802154_policy[IEEE802154_ATTR_MAX + 1] = {
> >   	[IEEE802154_ATTR_BAT_EXT] = { .type = NLA_U8, },
> >   	[IEEE802154_ATTR_COORD_REALIGN] = { .type = NLA_U8, },
> >   	[IEEE802154_ATTR_PAGE] = { .type = NLA_U8, },
> > +	[IEEE802154_ATTR_DEV_TYPE] = { .type = NLA_U8, },
> >   	[IEEE802154_ATTR_COORD_SHORT_ADDR] = { .type = NLA_U16, },
> >   	[IEEE802154_ATTR_COORD_HW_ADDR] = { .type = NLA_HW_ADDR, },
> >   	[IEEE802154_ATTR_COORD_PAN_ID] = { .type = NLA_U16, },
> >   
> 
> The reason to split this off from the patch before is to have the Fixes 
> tag differently to point to its origin?

Yup, plus they should hopefully be in chronological order to avoid
conflicts :)

> Might be a bit to much work for this little subsystem, but you did it 
> already, so:
> 
> Acked-by: Stefan Schmidt <stefan@datenfreihafen.org>

Thanks!
