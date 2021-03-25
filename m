Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37CD6349268
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 13:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbhCYMvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 08:51:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46890 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230155AbhCYMux (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 08:50:53 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lPPRr-00Cx7G-0C; Thu, 25 Mar 2021 13:50:51 +0100
Date:   Thu, 25 Mar 2021 13:50:50 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sunil Kovvuri <sunil.kovvuri@gmail.com>
Cc:     Hariprasad Kelam <hkelam@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
Subject: Re: [net-next PATCH 0/8] configuration support for switch headers &
 phy
Message-ID: <YFyHKqUpG9th+F62@lunn.ch>
References: <MWHPR18MB14217B983EFC521DAA2EEAD2DE649@MWHPR18MB1421.namprd18.prod.outlook.com>
 <YFpO7n9uDt167ANk@lunn.ch>
 <CA+sq2CeT2m2QcrzSn6g5rxUfmJDVQqjYFayW+bcuopCCoYuQ6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+sq2CeT2m2QcrzSn6g5rxUfmJDVQqjYFayW+bcuopCCoYuQ6Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > So you completely skipped how this works with mv88e6xxx or
> > prestera. If you need this private flag for some out of mainline
> > Marvell SDK, it is very unlikely to be accepted.
> >
> >         Andrew
> 
> What we are trying to do here has no dependency on DSA drivers and
> neither impacts that functionality.

So this is an indirect way of saying: Yes, this is for some out of
mainline Marvell SDK.

> Here we are just notifying the HW to parse the packets properly.

But the correct way for this to happen is probably some kernel
internal API between the MAC and the DSA driver. Mainline probably has
no need for this private flag.

   Andrew
