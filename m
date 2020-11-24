Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 125D02C3268
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 22:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730153AbgKXVQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 16:16:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:38542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728492AbgKXVQK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 16:16:10 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 031FE206E0;
        Tue, 24 Nov 2020 21:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606252569;
        bh=SmxiJZ+5OAqMCGnV1EewVKl5hBXrHl/Vzm3CHDvnhrc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FyxEZDTHClhIlhJ2aQVtYMV048vWs4rrBjRVpjWbE9lpC0lMS/Hztc4sXe9+GLYkx
         m5pnvIRDQFwKmPlwsjtudXlAkp5aCF25X4JaWHHfUuEoeXvgWpVQsU5FLxiI/VUSJ3
         ggvCBkt2bvV0Ysjs1B43hKm8yffYCuCgtTbvGdkc=
Date:   Tue, 24 Nov 2020 13:16:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Adrian Pop <pop.adrian61@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: Re: [PATCH net-next v2 0/2] Add support for DSFP transceiver type
Message-ID: <20201124131608.1b884063@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201124011459.GD2031446@lunn.ch>
References: <1606123198-6230-1-git-send-email-moshe@mellanox.com>
        <20201124011459.GD2031446@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Nov 2020 02:14:59 +0100 Andrew Lunn wrote:
> On Mon, Nov 23, 2020 at 11:19:56AM +0200, Moshe Shemesh wrote:
> > Add support for new cable module type DSFP (Dual Small Form-Factor Pluggable
> > transceiver). DSFP EEPROM memory layout is compatible with CMIS 4.0 spec. Add
> > CMIS 4.0 module type to UAPI and implement DSFP EEPROM dump in mlx5.  
> 
> So the patches themselves look O.K.
> 
> But we are yet again kicking the can down the road and not fixing the
> underlying inflexibility of the API.
> 
> Do we want to keep kicking the can, or is now the time to do the work
> on this API?

This is hardly rocket science. Let's do it right.
