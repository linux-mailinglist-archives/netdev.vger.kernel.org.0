Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91A4D28D16D
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 17:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730535AbgJMPnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 11:43:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:40302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727830AbgJMPnY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Oct 2020 11:43:24 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA15B251F1;
        Tue, 13 Oct 2020 15:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602603803;
        bh=9H6RvYXjAdfmhiVARIEhYFCwsR6+kod75btIsM3ob0I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JzcoCzTaABDx4AHinxNLecXKEFgiw8Mpx66MuOnSeUgioP/plxapgXBGvlWDETB0b
         lyAHI7ExrZu5nF74QtjfPAWQAwlY7RMuCZmX1X5fWaW5Ow76rm/AoUtVolUGbNoBkH
         LAkrlotQ09Onq+1h42Y2Kli8V01FM5XA/fADoof4=
Date:   Tue, 13 Oct 2020 08:43:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Danielle Ratson <danieller@nvidia.com>
Cc:     Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Jiri Pirko" <jiri@nvidia.com>, "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>, mlxsw <mlxsw@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: Re: [PATCH net-next 1/6] ethtool: Extend link modes settings uAPI
 with lanes
Message-ID: <20201013084320.40283ba6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <DM6PR12MB3865E4CB3854ECF70F5864D7D8040@DM6PR12MB3865.namprd12.prod.outlook.com>
References: <20201010154119.3537085-1-idosch@idosch.org>
        <20201010154119.3537085-2-idosch@idosch.org>
        <20201011153759.1bcb6738@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <DM6PR12MB3865B2FBA17BABBC747190D8D8070@DM6PR12MB3865.namprd12.prod.outlook.com>
        <20201012085803.61e256e6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <DM6PR12MB3865E4CB3854ECF70F5864D7D8040@DM6PR12MB3865.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Oct 2020 14:29:29 +0000 Danielle Ratson wrote:
> > On Mon, 12 Oct 2020 15:33:45 +0000 Danielle Ratson wrote:  
> > > > What's the use for this in practical terms? Isn't the lane count
> > > > basically implied by the module that gets plugged in?  
> > >
> > > The use is to enable the user to decide how to achieve a certain speed.
> > > For example, if he wants to get 100G and the port has 4 lanes, the
> > > speed can be achieved it using both 2 lanes of 50G and 4 lanes of 25G,
> > > as a port with 4 lanes width can work in 2 lanes mode with double
> > > speed each. So, by specifying "lanes 2" he will achieve 100G using 2
> > > lanes of 50G.  
> > 
> > Can you give a concrete example of serdes capabilities of the port, what SFP
> > gets plugged in and what configuration user wants to select?  
> 
> Example:
> - swp1 is a 200G port with 4 lanes.
> - QSFP28 is plugged in.
> - The user wants to select configuration of 100G speed using 2 lanes, 50G each.

I mean.. sounds quite contrived to me.

But I'm not opposed if others are fine with the change.
