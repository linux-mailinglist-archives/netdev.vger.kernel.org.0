Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDAC3D11A1
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 16:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233168AbhGUOKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 10:10:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38358 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232976AbhGUOKE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 10:10:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xPtqv/Z7copylAAqDx4d4w/vVdbEYCfDt5gzNgsEnOQ=; b=Qh9r6VxhIycpjnjRzGhDd3C6uq
        6t/18/BXu1zxw3aa8ohcx9x9YRqkjk8prPzJvniLmF3Ljz7La2JGmouEfjJVjCxxbS96nDwGPeK9l
        mJ7i62cI/lf+tbxLq2iwCpVERiy8ae5sKpPmb279TDqZU2qj7Gz4bbGiwCkalzCOYRxw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m6DYT-00ED6i-4f; Wed, 21 Jul 2021 16:50:37 +0200
Date:   Wed, 21 Jul 2021 16:50:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        vitaly.lifshits@intel.com,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: Re: [PATCH net-next 09/12] igc: Remove _I_PHY_ID checking
Message-ID: <YPg0PRYHe74+TucS@lunn.ch>
References: <20210720232101.3087589-1-anthony.l.nguyen@intel.com>
 <20210720232101.3087589-10-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210720232101.3087589-10-anthony.l.nguyen@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 20, 2021 at 04:20:58PM -0700, Tony Nguyen wrote:
> From: Sasha Neftin <sasha.neftin@intel.com>
> 
> i225 devices have only one PHY vendor. There is no point checking
> _I_PHY_ID during the link establishment and auto-negotiation process.
> This patch comes to clean up these pointless checkings.

I don't know this hardware....

Is the PHY integrated into the MAC? Or is it external?

For the ixgbe, the InPhi CS4227 is now owned by Marvell, and it is
very difficult to get any information from them. At some point, it
would be nice to have a second source, maybe a Microchip PHY. The bits
of code you are removing make it easier to see where changes would be
needed to add support for a second PHY. Why would you want to limit it
to just one vendor?

       Andrew
