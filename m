Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC5DD9284
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 15:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405371AbfJPNcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 09:32:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48400 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405363AbfJPNcb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 09:32:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bI3j/lNqd37v2UjsCOVjDYtbKavFToQzGAe5GTYyiDo=; b=CB6a2dFSBDFrSxogDUqW0XQkV4
        hHU+dY+NSZ+cmUosWV13i2DVtvZfDilF3/4Uj3BHJxP182Rl6Evg77wG49m1LMzsbNMkQDLdGg8HV
        vWP9jgzqcESxYmMq3VDDSign3wN24T7rzoGhxSHDLUTJXfkiZO/uNVXpEF4hGcA0FMRo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iKjPT-0007bb-8z; Wed, 16 Oct 2019 15:32:15 +0200
Date:   Wed, 16 Oct 2019 15:32:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Chris Snook <chris.snook@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        James Hogan <jhogan@kernel.org>,
        Jay Cliburn <jcliburn@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH v1 1/4] net: ag71xx: port to phylink
Message-ID: <20191016133215.GA17013@lunn.ch>
References: <20191014061549.3669-1-o.rempel@pengutronix.de>
 <20191014061549.3669-2-o.rempel@pengutronix.de>
 <20191016121216.GD4780@lunn.ch>
 <20191016122401.jnldnlwruv7h5kgy@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016122401.jnldnlwruv7h5kgy@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 02:24:01PM +0200, Oleksij Rempel wrote:
> On Wed, Oct 16, 2019 at 02:12:16PM +0200, Andrew Lunn wrote:
> > On Mon, Oct 14, 2019 at 08:15:46AM +0200, Oleksij Rempel wrote:
> > > The port to phylink was done as close as possible to initial
> > > functionality.
> > > Theoretically this HW can support flow control, practically seems to be not
> > > enough to just enable it. So, more work should be done.
> > > 
> > > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > 
> > Hi Oleksij
> > 
> > Please include Russell King in Cc: in future.
> 
> He was included in To:. Do you mean, I need to move him from To to Cc?

Ah, sorry. Missed him among all the other To:

I don't know if there are any strict rules, but i tend to use To: for
the maintainer you expect to merge the patch, and Cc: for everybody
else, and the lists.

    Andrew
