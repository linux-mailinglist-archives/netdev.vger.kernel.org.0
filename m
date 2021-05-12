Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB9037EEA3
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 01:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442158AbhELV5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 17:57:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37818 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347157AbhELVpj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 17:45:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=G4FRzr8UOcQ0mGjU/d41grqZ4PRaNx1y9G+DGXzduP4=; b=w8mAlBwZh0NWwURiIt4ishGdXU
        O7l+wjTe0bacbb6zrO+Rmiv65PeFtAy55PfF4Dy/EJWGXvTZvjtIycewJujAM8gFuo1Q+cmPT69qe
        j/GThzI3gKXbsgY4tdN4Y3IoN3mM5aBNRIN15JjSZGgPvIbaE8ZyQxj11W8kikUGOzSg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lgweN-003yj3-3e; Wed, 12 May 2021 23:44:15 +0200
Date:   Wed, 12 May 2021 23:44:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, david.daney@cavium.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net: mdio: Fix a double free issue in the .remove
 function
Message-ID: <YJxML4HvQd+WiDK6@lunn.ch>
References: <f8ad939e6d5df4cb0273ea71a418a3ca1835338d.1620855222.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8ad939e6d5df4cb0273ea71a418a3ca1835338d.1620855222.git.christophe.jaillet@wanadoo.fr>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 12, 2021 at 11:35:38PM +0200, Christophe JAILLET wrote:
> 'bus->mii_bus' have been allocated with 'devm_mdiobus_alloc_size()' in the
> probe function. So it must not be freed explicitly or there will be a
> double free.

Hi Christophe

[PATCH] net: mdio: Fix a double free issue in the .remove function

Please indicate in the subject which mdio bus driver has a double
free.

Also, octeon_mdiobus_remove() appears to have the same problem.

      Andrew
