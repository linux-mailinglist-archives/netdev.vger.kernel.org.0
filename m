Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6D7D37151F
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 14:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233406AbhECMRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 08:17:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50808 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229594AbhECMRs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 May 2021 08:17:48 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1ldXVE-002Hsr-HD; Mon, 03 May 2021 14:16:44 +0200
Date:   Mon, 3 May 2021 14:16:44 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Chris Packham <Chris.Packham@alliedtelesis.co.nz>
Cc:     David Miller <davem@davemloft.net>,
        =?utf-8?B?5pu554Wc?= <cao88yu@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net] dsa: mv88e6xxx: 6161: Use chip wide MAX MTU
Message-ID: <YI/prD8CRv5zQ8dz@lunn.ch>
References: <20210426233441.302414-1-andrew@lunn.ch>
 <YIwNzKZbiuLZRnoR@lunn.ch>
 <86d42c49-27a7-734a-2ca8-b6e6ba826dc1@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86d42c49-27a7-734a-2ca8-b6e6ba826dc1@alliedtelesis.co.nz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 03, 2021 at 02:38:14AM +0000, Chris Packham wrote:
> 
> On 1/05/21 2:01 am, Andrew Lunn wrote:
> > On Tue, Apr 27, 2021 at 01:34:41AM +0200, Andrew Lunn wrote:
> >> The datasheets suggests the 6161 uses a per port setting for jumbo
> >> frames. Testing has however shown this is not correct, it uses the old
> >> style chip wide MTU control. Change the ops in the 6161 structure to
> >> reflect this.
> >>
> >> Fixes: 1baf0fac10fb ("net: dsa: mv88e6xxx: Use chip-wide max frame size for MTU")
> >> Reported by: 曹煜 <cao88yu@gmail.com>
> >> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> > self NACK.
> >
> > We dug deeper and found a different real problem. Patches to follow.
> 
> Hi Andrew,
> 
> I'm back on-line now. Anything I can help look at?

Hi Chris

I have patches to post soon. I will include you in Cc:.

  Andrew
