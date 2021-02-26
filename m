Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60FB8326A80
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 00:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbhBZXuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 18:50:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:52984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229863AbhBZXuE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Feb 2021 18:50:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8479764EFA;
        Fri, 26 Feb 2021 23:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614383363;
        bh=bGCuAne9qltV0wpM3AH8NOFz7x+4d/E3laWWipFwXzY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FvNNdy6maTEbGyYGRpcw4ir9nvNWCIn6uiq3l9VJe04rdOIaLAVl+7mw6p4Ooy7cj
         9V1cMegUTp12i7/ujyV2lXl9M9/mMgyVEq7GpNbt9IGAjyIoiwIH0OdIdBZsX8XuZW
         /o190V8u0zrPFR8tyXeux5PkdzGOv8KtTpk5KBTp8GJDnPgVS3jGnHoLHlJaXioQJX
         G8FRtfhd4/r2sew90uqc1lpi/Xe8jwTJG8cKgt0ZPa1QqTeZyyu3GUcfmox2GFlJcf
         aSJpsDwy+1LQkggcdnsVsKVOoGFSnozhKCpzudoevuGM5Z8LVyp+juj812DKGMZ7h1
         J7Yi0LQifVYPw==
Date:   Fri, 26 Feb 2021 15:49:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Michael Walle <michael@walle.cc>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Markus =?UTF-8?B?QmzDtmNobA==?= <Markus.Bloechl@ipetronik.com>
Subject: Re: [PATCH v2 net 5/6] net: enetc: don't disable VLAN filtering in
 IFF_PROMISC mode
Message-ID: <20210226154922.5956512b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210226234244.w7xw7qnpo3skdseb@skbuf>
References: <20210225121835.3864036-1-olteanv@gmail.com>
        <20210225121835.3864036-6-olteanv@gmail.com>
        <20210226152836.31a0b1bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210226234244.w7xw7qnpo3skdseb@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 27 Feb 2021 01:42:44 +0200 Vladimir Oltean wrote:
> On Fri, Feb 26, 2021 at 03:28:36PM -0800, Jakub Kicinski wrote:
> > I don't understand what you're fixing tho.
> >
> > Are we trying to establish vlan-filter-on as the expected behavior?  
> 
> What I'm fixing is unexpected behavior, according to the applicable
> standards I could find. If I don't mark this change as a bug fix but as
> a simple patch, somebody could claim it's a regression, since promiscuity
> used to be enough to see packets with unknown VLANs, and now it no
> longer is...

Can we take it into net-next? What's your feeling on that option?
