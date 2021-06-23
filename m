Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD39A3B21C2
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 22:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhFWU0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 16:26:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52412 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229758AbhFWU0i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 16:26:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=6Ii75us1kCULe9IWZ/dfVhM3nBnfsNUJlSfNnoF9IjY=; b=PrJWAIs+QcC5F8WFBNLgYEJ9IU
        7+caU2bD5RGcgRsAnEqZhhXVZmwbc+o7n/T4+qnRhKOpHvXoElg4pX3m8DcZ1hn5hBLTR9wBRpWWb
        5UD5q6E4ILWjSNKvwKWzFvZ/E/hHEiPpI+abXsgvw9FDrClWheJqKilUcejWucWAnvYQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lw9Q3-00At9D-6O; Wed, 23 Jun 2021 22:24:19 +0200
Date:   Wed, 23 Jun 2021 22:24:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        jaz@semihalf.com, gjb@semihalf.com, upstream@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, jon@solid-run.com, tn@semihalf.com,
        rjw@rjwysocki.net, lenb@kernel.org
Subject: Re: [net-next: PATCH v3 3/6] net/fsl: switch to
 fwnode_mdiobus_register
Message-ID: <YNOYc3O/GMH18eaR@lunn.ch>
References: <20210621173028.3541424-1-mw@semihalf.com>
 <20210621173028.3541424-4-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621173028.3541424-4-mw@semihalf.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 21, 2021 at 07:30:25PM +0200, Marcin Wojtas wrote:
> Utilize the newly added helper routine
> for registering the MDIO bus via fwnode_
> interface.
> 
> Signed-off-by: Marcin Wojtas <mw@semihalf.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
