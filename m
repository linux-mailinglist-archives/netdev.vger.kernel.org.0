Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3B1929128C
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 16:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438436AbgJQO5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 10:57:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60824 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438431AbgJQO5i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 10:57:38 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kTne6-0029vG-5U; Sat, 17 Oct 2020 16:57:22 +0200
Date:   Sat, 17 Oct 2020 16:57:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH net-next v2 1/2] Makefile.extrawarn: Add symbol for W=1
 warnings for today
Message-ID: <20201017145722.GJ456889@lunn.ch>
References: <20201001011232.4050282-2-andrew@lunn.ch>
 <CAKwvOdnVC8F1=QT03W5Zh9pJdTxxNfRcqXeob5_b4CXycvG1+g@mail.gmail.com>
 <20201002014411.GG4067422@lunn.ch>
 <CAKwvOdmdfwWsRtJHtJ16B0RMyoxUi1587OKnyunQd5gfwmnGsA@mail.gmail.com>
 <20201005194913.GC56634@lunn.ch>
 <CAK8P3a1qS8kaXNqAtqMKpWGx05DHVHMYwKBD_j-Zs+DHbL5CNw@mail.gmail.com>
 <20201005210808.GE56634@lunn.ch>
 <CAK7LNASB6ashOzmL5XntkPSq9a+8VoWCowP5CAt+oX0o=0y=dA@mail.gmail.com>
 <20201016141237.GD456889@lunn.ch>
 <CAK8P3a1nBhmf1PQwHHbEjiVgRTXi4UuJAbwuK92CKEbR=yKGWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a1nBhmf1PQwHHbEjiVgRTXi4UuJAbwuK92CKEbR=yKGWw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 17, 2020 at 02:48:56PM +0200, Arnd Bergmann wrote:
> On Fri, Oct 16, 2020 at 4:12 PM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > > One drawback of your approach is that
> > > you cannot set KBUILD_CFLAGS_W1_20200930
> > > until you eliminate all the warnings in the
> > > sub-directory in interest.
> > > (i.e. all or nothing approach)
> >
> > Hi Mashiro
> >
> > That actual works well for my use case. drivers/net/ethernet is W=1
> > clean. So is drivers/net/phy, drivers/net/mdio. Developers generally
> > clean up a subsystem by adding W=1 to the command line because that is
> > the simple tool they have.
> >
> > And my aim here is to keep those subsystem W=1 clean. I don't care
> > about individual warnings within W=1, because those subsystems are
> > passed that stage already.
> 
> I tried to get a better grasp of what kind of warnings we are actually talking
> about and looked at the x86 allmodconfig W=1 output on today's linux-next.

Hi Arnd

The work done to cleanup drivers/net/ethernet was mostly done by an
Intel team. When built for ARM there are few warnings left, mostly due
to missing COMPILE_TEST. I have fixes for that.

But this raises the question, can we be a bit more tolerant of
warnings for not x86 to start with? 0-day should help us weed out the
remaining warnings on other architectures.

As for the plan, it looks O.K. to me. I can definitely help with
driver/net and net.

	   Andrew
