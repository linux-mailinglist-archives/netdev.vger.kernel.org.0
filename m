Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46278B6473
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 15:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730488AbfIRNcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 09:32:42 -0400
Received: from elvis.franken.de ([193.175.24.41]:45955 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726671AbfIRNcm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Sep 2019 09:32:42 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1iAa4U-0002PB-00; Wed, 18 Sep 2019 15:32:38 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id C013FC2797; Wed, 18 Sep 2019 15:27:36 +0200 (CEST)
Date:   Wed, 18 Sep 2019 15:27:36 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Helge Deller <deller@gmx.de>
Cc:     John David Anglin <dave.anglin@bell.net>,
        Arlie Davis <arlied@google.com>, Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org, linux-parisc@vger.kernel.org
Subject: Re: Bug report (with fix) for DEC Tulip driver (de2104x.c)
Message-ID: <20190918132736.GA9231@alpha.franken.de>
References: <CAK-9enMxA68mRYFG=2zD02guvCqe-aa3NO0YZuJcTdBWn5MPqg@mail.gmail.com>
 <20190917212844.GJ9591@lunn.ch>
 <CAK-9enOx8xt_+t6-rpCGEL0j-HJGm=sFXYq9-pgHQ26AwrGm5Q@mail.gmail.com>
 <df0f961d-2d53-63e3-8087-6f0b09e14317@bell.net>
 <f71e9773-5cfb-f20b-956f-d98b11a5d4a7@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f71e9773-5cfb-f20b-956f-d98b11a5d4a7@gmx.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 18, 2019 at 07:56:16AM +0200, Helge Deller wrote:
> On 18.09.19 00:51, John David Anglin wrote:
> > On 2019-09-17 5:36 p.m., Arlie Davis wrote:
> >> Likewise, I'm at a loss for testing with real hardware. It's hard to
> >> find such things, now.
> > How does de2104x compare to ds2142/43?  I have a c3750 with ds2142/43 tulip.  Helge
> > or some others might have a machine with a de2104x.
> 
> The machines we could test are
> * a C240 with a DS21140 tulip chip (Sven has one),
> * a C3000 or similiar with DS21142 and/or DS21143 (me).
> 
> If the patch does not show any regressions, I'd suggest to
> apply it upstream.

2114x chips use a different driver, so it won't help here.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
