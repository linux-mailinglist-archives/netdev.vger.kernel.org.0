Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38BDE29DBCA
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390836AbgJ2ANq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 20:13:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50776 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390824AbgJ2ANp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 20:13:45 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kXZsT-003u8C-Oa; Wed, 28 Oct 2020 02:03:49 +0100
Date:   Wed, 28 Oct 2020 02:03:49 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] net: dsa: link aggregation support
Message-ID: <20201028010349.GA930647@lunn.ch>
References: <20201027105117.23052-1-tobias@waldekranz.com>
 <20201027223628.GG904240@lunn.ch>
 <87361zuqjs.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87361zuqjs.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 01:45:11AM +0100, Tobias Waldekranz wrote:
> On Tue, Oct 27, 2020 at 23:36, Andrew Lunn <andrew@lunn.ch> wrote:
> > If you are dynamically allocating dsa_lag structures, at run time, you
> > need to think about this. But the number of LAGs is limited by the
> > number of ports. So i would consider just allocating the worst case
> > number at probe, and KISS for runtime.
> 
> Oh OK, yeah that just makes stuff easier so that's absolutely fine. I
> got the sense that the overall movement within DSA was in the opposite
> direction. E.g. didn't the dst use to have an array of ds pointers?
> Whereas now you iterate through dst->ports to find them?

Yes, but they are all allocated at probe time. It saved a bit of heap
for adding some code.

   Andrew
