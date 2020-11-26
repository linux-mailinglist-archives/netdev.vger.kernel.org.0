Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEEDA2C5DC5
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 23:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391820AbgKZWYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 17:24:02 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:52012 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391811AbgKZWYC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Nov 2020 17:24:02 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kiPgF-0092Xi-6q; Thu, 26 Nov 2020 23:23:59 +0100
Date:   Thu, 26 Nov 2020 23:23:59 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Peter Vollmer <peter.vollmer@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: dsa/mv88e6xxx: leaking packets on MV88E6341 switch
Message-ID: <20201126222359.GO2075216@lunn.ch>
References: <CAGwvh_MAQWuKuhu5VuYjibmyN-FRxCXXhrQBRm34GShZPSN6Aw@mail.gmail.com>
 <20200930191956.GV3996795@lunn.ch>
 <20201001062107.GA2592@fido.de.innominate.com>
 <CAGwvh_PDtAH9bMujfvupfiKTi4CVKEWtp6wqUouUoHtst6FW1A@mail.gmail.com>
 <87y2in94o7.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y2in94o7.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I tested setting .tag_protocol=DSA_TAG_PROTO_DSA for the 6341 switch
> > instead, resulting in a register setting of 04 Port control for port 5
> > = 0x053f (i.e. EgressMode=Unmodified mode, frames are transmitted
> > unmodified), which looks correct to me. It does not fix the above
> > problem, but the change seems to make sense anyhow. Should I send a
> > patch ?
> 
> This is not up to me, but my guess is that Andrew would like a patch,
> yes. On 6390X, I know for a fact that setting the EgressMode to 3 does
> indeed produce the behavior that was supported in older devices (like
> the 6352), but there is no reason not to change it to regular DSA.

I already said to Tobias, i had problems getting the 6390 working, and
this was one of the things i changed. I don't think i ever undid this
specific change, to see how critical it is. But relying on
undocumented behaviour is not nice.

EDSA used to have the advantages that tcpdump understood it. But
thanks to work Florian and Vivien did, tcpdump can now decode DSA just
as well as EDSA.

So please do submit a patch.

   Andrew
