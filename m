Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7493D2670
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 17:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbhGVOak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 10:30:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40594 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232579AbhGVOaL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 10:30:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ajej3+irDqRdJgoNF2/l9QhKv78ek+8OVhoEERA6Psk=; b=aR3Xi+fgdmQ6dui1iOXYVoCdRe
        2uLOcSC4BoCvooLc39uGnbJRc0y15aK/e3xMGcYIhgzVrFoF0Y7bo8AS5efJUKHxA229nkD5XKSw6
        2nkrVT/vjNgZqx5QtHi+5/7r7vAXvJwyf8oZO5ZMnaDajbgh8QR3p5kmDHJTlwFhVt/k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m6aLG-00ELYG-CI; Thu, 22 Jul 2021 17:10:30 +0200
Date:   Thu, 22 Jul 2021 17:10:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        corbet@lwn.net, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next] docs: networking: dpaa2: add documentation for
 the switch driver
Message-ID: <YPmKZnU+8DptQMor@lunn.ch>
References: <20210722132735.685606-1-ciorneiioana@gmail.com>
 <YPmASiX46tOjUOe/@lunn.ch>
 <20210722144258.iir7cgowfplwzjlq@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722144258.iir7cgowfplwzjlq@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Are these requirements tested? Will the driver fail probe if they are
> > not met?
> 
> Yes, they are tested.
> 
> If the DPSW object configuration does not meet the requirements, the
> driver will error out on probe with a message explictly saying what
> is happening.

Good. Maybe reference that here, so somebody googling the error
message lands on this document.

> On the other hand, I think this section might give too much details on
> the actual implementation (I took it from the commit message of the
> patch adding the support). Might as well just remove it and add the
> example.
> 
> All that I was trying to say is that the filters will not be added in
> the ACL table with the explicit priority specified by the user but
> rather with one determined based on all the rules currently present in
> the table.
> Nothing is unusual in the usage, the order in which the rules are
> executed will be respected.

So if it is an implementation detail, it probably is not relevant
here.

	Andrew
