Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE33D3F1A1C
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 15:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239839AbhHSNNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 09:13:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58406 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239472AbhHSNNv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 09:13:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=gBtIxJWYugc+EFF9NXvpeecWmfabaXomnN0ipme+Trc=; b=WqIuz26wXnt6dk7ifYbdlbKajb
        ZW/bc/a+51ow4ClkqR7+77Cz0OhWBVUVSQYP0k5Ww04ro8068csmzj7iBlNJp15nkXwxe2X/Fgxd1
        8w4hZ8NnxDe3xkEhacaovr5VhetP9CWZ67bQSDll46Sc72vq7L3jq6eM8ci7sxQTfFlU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mGhr4-000yJc-ND; Thu, 19 Aug 2021 15:13:10 +0200
Date:   Thu, 19 Aug 2021 15:13:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, mkubecek@suse.cz, pali@kernel.org,
        jacob.e.keller@intel.com, jiri@nvidia.com, vadimp@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next v2 1/6] ethtool: Add ability to control
 transceiver modules' power mode
Message-ID: <YR5Y5hCavFaWZCFH@lunn.ch>
References: <20210818155202.1278177-1-idosch@idosch.org>
 <20210818155202.1278177-2-idosch@idosch.org>
 <20210818153241.7438e611@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YR2P7+1ZGiEBDtAq@lunn.ch>
 <YR4NTylFy2ejODV6@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YR4NTylFy2ejODV6@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Should we also document what the default is? Seems like
> > ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH_ON_UP is the generic network
> > interface default, so maybe it should also be the default for SFPs?
> 
> I will add a note in Documentation/networking/ethtool-netlink.rst that
> the default power mode policy is driver-dependent (can be queried) and
> that it can either be 'high' or 'auto'.

Hi Ido

That is kind of my question. Do you want the default driver defined,
and varying between implementations, or do we want a clearly defined
default?

The stack has a mixture of both. An interface is admin down by
default, but it is anybody guess how pause will be configured?

By making it driver undefined, you cannot assume anything, and you
require user space to always configure it.

I don't have too strong an opinion, i'm more interested in what others
say, those who have to live with this.

	Andrew
