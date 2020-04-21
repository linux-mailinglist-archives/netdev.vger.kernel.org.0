Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2171B2EFF
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 20:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729211AbgDUSX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 14:23:57 -0400
Received: from pb-smtp20.pobox.com ([173.228.157.52]:61107 "EHLO
        pb-smtp20.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgDUSX5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 14:23:57 -0400
Received: from pb-smtp20.pobox.com (unknown [127.0.0.1])
        by pb-smtp20.pobox.com (Postfix) with ESMTP id D8BFAB9C22;
        Tue, 21 Apr 2020 14:23:53 -0400 (EDT)
        (envelope-from nico@fluxnic.net)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=pobox.com; h=date:from:to
        :cc:subject:in-reply-to:message-id:references:mime-version
        :content-type; s=sasl; bh=XIF+lHQmIGJlgPyKUKfgN7ocejk=; b=K9v4tX
        y+mRt6OcJpt6RtETLC+W9D+ACu1UExe3jrOmLpVlTYRM7WUkdB5vj6aVE0UUlaOa
        udNMfKiGLYjYYQnlms8Q8l4NuSpG5qfsyHSEL4vnmz924SUs/rKOtmgh3hhQ0GoU
        8Tx850K4b0tY8POWlok71ONxLxRftDMBlvk6Y=
Received: from pb-smtp20.sea.icgroup.com (unknown [127.0.0.1])
        by pb-smtp20.pobox.com (Postfix) with ESMTP id CF244B9C20;
        Tue, 21 Apr 2020 14:23:53 -0400 (EDT)
        (envelope-from nico@fluxnic.net)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed; d=fluxnic.net;
 h=date:from:to:cc:subject:in-reply-to:message-id:references:mime-version:content-type; s=2016-12.pbsmtp; bh=x7fL8/5SX4Xr9sIGNCqUqMxcBILv9SZc87FE2gx3TwU=; b=l9pbCK2ETrm+QZLPaoOv8fFZyWmAeWWOcrwsohSI96G4dsavFYhV75RPBJuBptQ+TVkiyTSt0xvsNiImlBKmr0Nc/3ymXLeFFapNutfiMCQTSzAmNkDskibrOJ1IruUKnCIf8iEqBL/QX3nIAX+clCx7CHu9e0LroUCrPgn7Ht8=
Received: from yoda.home (unknown [24.203.50.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by pb-smtp20.pobox.com (Postfix) with ESMTPSA id 44DE3B9C1F;
        Tue, 21 Apr 2020 14:23:49 -0400 (EDT)
        (envelope-from nico@fluxnic.net)
Received: from xanadu.home (xanadu.home [192.168.2.2])
        by yoda.home (Postfix) with ESMTPSA id 544F62DA014B;
        Tue, 21 Apr 2020 14:23:47 -0400 (EDT)
Date:   Tue, 21 Apr 2020 14:23:47 -0400 (EDT)
From:   Nicolas Pitre <nico@fluxnic.net>
To:     Saeed Mahameed <saeedm@mellanox.com>
cc:     "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "Laurent.pinchart@ideasonboard.com" 
        <Laurent.pinchart@ideasonboard.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jernej.skrabec@siol.net" <jernej.skrabec@siol.net>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jonas@kwiboo.se" <jonas@kwiboo.se>,
        "jani.nikula@linux.intel.com" <jani.nikula@linux.intel.com>,
        "kieran.bingham+renesas@ideasonboard.com" 
        <kieran.bingham+renesas@ideasonboard.com>,
        "narmstrong@baylibre.com" <narmstrong@baylibre.com>,
        "leon@kernel.org" <leon@kernel.org>
Subject: Re: [RFC PATCH 1/2] Kconfig: Introduce "uses" keyword
In-Reply-To: <62a51b2e5425a3cca4f7a66e2795b957f237b2da.camel@mellanox.com>
Message-ID: <nycvar.YSQ.7.76.2004211411500.2671@knanqh.ubzr>
References: <20200417011146.83973-1-saeedm@mellanox.com> <CAK7LNAQZd_LUyA2V_pCvMTr_201nSX1Nm0TDw5kOeNV64rOfpA@mail.gmail.com> <nycvar.YSQ.7.76.2004181509030.2671@knanqh.ubzr> <CAK7LNATmPD1R+Ranis2u3yohx8b0+dGKAvFpjg8Eo9yEHRT6zQ@mail.gmail.com>
 <87v9lu1ra6.fsf@intel.com> <45b9efec57b2e250e8e39b3b203eb8cee10cb6e8.camel@mellanox.com> <nycvar.YSQ.7.76.2004210951160.2671@knanqh.ubzr> <62a51b2e5425a3cca4f7a66e2795b957f237b2da.camel@mellanox.com>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Pobox-Relay-ID: 3EDF1E74-83FD-11EA-8A3A-B0405B776F7B-78420484!pb-smtp20.pobox.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Apr 2020, Saeed Mahameed wrote:

> On Tue, 2020-04-21 at 09:58 -0400, Nicolas Pitre wrote:
> > On Tue, 21 Apr 2020, Saeed Mahameed wrote:
> > 
> > > I wonder how many of those 8889 cases wanted a weak dependency but
> > > couldn't figure out how to do it ? 
> > > 
> > > Users of depends on FOO || !FOO
> > > 
> > > $ git ls-files | grep Kconfig | xargs grep -E \
> > >   "depends\s+on\s+([A-Za-z0-9_]+)\s*\|\|\s*(\!\s*\1|\1\s*=\s*n)" \
> > >  | wc -l
> > > 
> > > 156
> > > 
> > > a new keyword is required :) .. 
> > > 
> > > 
> > > > In another mail I suggested
> > > > 
> > > > 	optionally depends on FOO
> > > > 
> > > > might be a better alternative than "uses".
> > > > 
> > > > 
> > > 
> > > how about just:
> > >       optional FOO
> > > 
> > > It is clear and easy to document .. 
> > 
> > I don't dispute your argument for having a new keyword. But the most 
> > difficult part as Arnd said is to find it. You cannot pretend that 
> 
> kconfig-language.rst  ?
> 
> > "optional FOO" is clear when it actually imposes a restriction when 
> > FOO=m. Try to justify to people why they cannot select y because of
> > this 
> > "optional" thing.
> > 
> 
> Then let's use "uses" it is more assertive. Documentation will cover
> any vague anything about it .. 

It uses what? And why can't I configure this with "uses FOO" when FOO=m?
That's not any clearer. And saying that "this is weird but it is 
described in the documentation" is not good enough. We must make things 
clear in the first place.

This is really a conditional dependency. That's all this is about.
So why not simply making it so rather than fooling ourselves? All that 
is required is an extension that would allow:

	depends on (expression) if (expression)

This construct should be obvious even without reading the doc, is 
already used extensively for other things already, and is flexible 
enough to cover all sort of cases in addition to this particular one.


Nicolas
