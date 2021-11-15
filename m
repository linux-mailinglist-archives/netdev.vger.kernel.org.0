Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92C19450B75
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 18:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236752AbhKORYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 12:24:45 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:33926 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237019AbhKORWL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 12:22:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=JZuI4Qy3jUfN9jGj7Qa+UxiF5Ss3iadbAbWszVn5Hw0=; b=yvY8IUVE/mVBUQys9wwCvr6114
        yPvIppO8d8B2E1YxCxz87fF4q3UJNGCTXXwCDvND0Z0Pb2hLQCzM5gLn8/Dfx/0BPv1rfqbzLw1be
        jWAV+mmnFK+q+USJ0g1iechjeAghvgeqHTXezO/NPiQWUpJWXA246p8CEeUY91RUjqug=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mmfcx-00DVm7-G3; Mon, 15 Nov 2021 18:18:43 +0100
Date:   Mon, 15 Nov 2021 18:18:43 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next] net: document SMII and correct phylink's new
 validation mechanism
Message-ID: <YZKWc7a7IpbOpwvI@lunn.ch>
References: <E1mmfVl-0075nP-14@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1mmfVl-0075nP-14@rmk-PC.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 15, 2021 at 05:11:17PM +0000, Russell King (Oracle) wrote:
> SMII has not been documented in the kernel, but information on this PHY
> interface mode has been recently found. Document it, and correct the
> recently introduced phylink handling for this interface mode.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
