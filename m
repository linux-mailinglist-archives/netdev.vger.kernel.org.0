Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04FEC487859
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 14:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238884AbiAGNky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 08:40:54 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55924 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238835AbiAGNky (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jan 2022 08:40:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=HrULBV9j/S4+9VTe0HZSPuRavA5DY7yGoZL9/04SsdA=; b=gXG/GTEefaLShPh8EYZwVMRhzS
        ivq2HZMjPCcG2DDZRahXST0a9SNyDXYn7uf6jwx3fmTJjsu//8xiVsqA5whcldyGFyW8AQ3E97u5a
        TZDM1ruvjR1azGZ4XYJbodDD6eTj2fIT7CcBUoArh1S614D1RjWzt1lOgFm/DcW73S+s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n5pUA-000lFA-4f; Fri, 07 Jan 2022 14:40:50 +0100
Date:   Fri, 7 Jan 2022 14:40:50 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 3/8] net/funeth: probing and netdev ops
Message-ID: <YdhC4nykryjP+xLp@lunn.ch>
References: <20220104064657.2095041-1-dmichail@fungible.com>
 <20220104064657.2095041-4-dmichail@fungible.com>
 <20220104180739.572a80ac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAOkoqZmxHZ6KTZQPe+w23E_UPYWLNRiU8gVX32EFsNXgyzkucg@mail.gmail.com>
 <YdXDVakWSkQyvlqe@lunn.ch>
 <CAOkoqZkCkyiGbUx--zY67GF05Y_XxuW6APKaqYu8F_nR9Qu7Kg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOkoqZkCkyiGbUx--zY67GF05Y_XxuW6APKaqYu8F_nR9Qu7Kg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I can see this being valid if your FW is doing 802.1X. But i'm not
> > sure it is valid for other use cases. What exactly is your firmware
> > doing which stops it from handling frames?
> 
> The downtime happens occasionally after link up while the internal
> control processor is configuring the network units. So internal setup
> delays.

So it sounds like you should not be reporting carrier up until it is
actually ready to go. Carrier up means everything in the pipeline
between the MAC and the peer MAC is ready and transporting frames at
L1.

> I am told that "in the near future" the need for this will be
> removed. Trusting that near will be reasonable I'll remove this now.

O.K.

	Andrew
