Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5692B2C1820
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 23:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732038AbgKWWDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 17:03:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:40566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729915AbgKWWDG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 17:03:06 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76A4C2065E;
        Mon, 23 Nov 2020 22:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606168986;
        bh=JtzYbIQxNXnKQ7ixjdTyyf8YhKFuCsZMS/dfwHzg/jQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CQ6UOoCUcSzhSumn4Q0WFYUR5o4drK39W06p2bvSmls13EKmrPBEvFEf/VaOnUySH
         PE7HR7+r/VQbl8aqv46d0TznjdVjYE1sE0ILz+uAJfJ2l5zLHQGObvHvMPxBnIF+dg
         HpfOqKsgmAxf+acFzeRNM1Hvq9WXTQezNzeE1Pes=
Date:   Mon, 23 Nov 2020 14:03:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Ido Schimmel <idosch@idosch.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Petr Machata <petrm@mellanox.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 2/3] mlxsw: spectrum_ptp: use PTP wide message
 type definitions
Message-ID: <20201123140304.6b8665a4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201122200154.GA668367@shredder.lan>
References: <20201122082636.12451-1-ceggers@arri.de>
        <20201122082636.12451-3-ceggers@arri.de>
        <20201122143555.GA515025@shredder.lan>
        <2074851.ybSLjXPktx@n95hx1g2>
        <20201122200154.GA668367@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 22 Nov 2020 22:01:54 +0200 Ido Schimmel wrote:
> > > I don't know what are Jakub's preferences, but had this happened on our
> > > internal patchwork instance, I would just ask the author to submit
> > > another version with all the patches.  
> > Please let me know how I shall proceed...  
> 
> Jakub has the final say, so I assume he will comment on that.

The pre-requisite was just merged, so please collect all the review tags
you got so far and repost.
