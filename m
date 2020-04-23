Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86F841B640B
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 20:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbgDWSwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 14:52:23 -0400
Received: from pb-smtp20.pobox.com ([173.228.157.52]:63284 "EHLO
        pb-smtp20.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbgDWSwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 14:52:23 -0400
Received: from pb-smtp20.pobox.com (unknown [127.0.0.1])
        by pb-smtp20.pobox.com (Postfix) with ESMTP id 11492CC76A;
        Thu, 23 Apr 2020 14:52:20 -0400 (EDT)
        (envelope-from nico@fluxnic.net)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=pobox.com; h=date:from:to
        :cc:subject:in-reply-to:message-id:references:mime-version
        :content-type; s=sasl; bh=pYU0AMuQlOREd1+6VLkN+ll2Wmw=; b=unNW3G
        a0fmfK+aImdn2fY4EQSPU9uu9tT0VaYVTfSNbh/0IDBrgQ+i8Ul4QlqCYSOjeBYc
        KTGaaeeA957jiPuwY2tlDtUIhxR++NLP4/CGBCMd1RX/bWToMt88pkxdHZP4sERl
        v3WRduVsfUuDF4csGvtoBiKIV7BRmolP35F80=
Received: from pb-smtp20.sea.icgroup.com (unknown [127.0.0.1])
        by pb-smtp20.pobox.com (Postfix) with ESMTP id 0829ACC769;
        Thu, 23 Apr 2020 14:52:20 -0400 (EDT)
        (envelope-from nico@fluxnic.net)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed; d=fluxnic.net;
 h=date:from:to:cc:subject:in-reply-to:message-id:references:mime-version:content-type; s=2016-12.pbsmtp; bh=uCFGMAwTUfy3QWw/Nrw1WO4CjlHOh6AiWtHwO1XyK+c=; b=wWrhpOnobs5viGIBdcx+erqAnz9ARnG7BMjQrVIcpf92OBVxtzlP/axJsTrD6kqowNkI8GlzfYsIZfTMeYOPcGrFW0eeACS5UTQ2Rgq5+LUYwhRw6b6gSgal0KmtDFhAQetXgvwv5Ho6K+QG0YhmFCNmU8Et0SGM78A4V2Utomo=
Received: from yoda.home (unknown [24.203.50.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by pb-smtp20.pobox.com (Postfix) with ESMTPSA id DDD5CCC763;
        Thu, 23 Apr 2020 14:52:16 -0400 (EDT)
        (envelope-from nico@fluxnic.net)
Received: from xanadu.home (xanadu.home [192.168.2.2])
        by yoda.home (Postfix) with ESMTPSA id 09F152DA0CE0;
        Thu, 23 Apr 2020 14:52:15 -0400 (EDT)
Date:   Thu, 23 Apr 2020 14:52:14 -0400 (EDT)
From:   Nicolas Pitre <nico@fluxnic.net>
To:     Jason Gunthorpe <jgg@ziepe.ca>
cc:     Randy Dunlap <rdunlap@infradead.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "Laurent.pinchart@ideasonboard.com" 
        <Laurent.pinchart@ideasonboard.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jernej.skrabec@siol.net" <jernej.skrabec@siol.net>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jonas@kwiboo.se" <jonas@kwiboo.se>,
        "kieran.bingham+renesas@ideasonboard.com" 
        <kieran.bingham+renesas@ideasonboard.com>,
        "narmstrong@baylibre.com" <narmstrong@baylibre.com>,
        "leon@kernel.org" <leon@kernel.org>
Subject: Re: [RFC PATCH 1/2] Kconfig: Introduce "uses" keyword
In-Reply-To: <20200423183055.GB26002@ziepe.ca>
Message-ID: <nycvar.YSQ.7.76.2004231448020.2671@knanqh.ubzr>
References: <62a51b2e5425a3cca4f7a66e2795b957f237b2da.camel@mellanox.com> <nycvar.YSQ.7.76.2004211411500.2671@knanqh.ubzr> <871rofdhtg.fsf@intel.com> <nycvar.YSQ.7.76.2004221649480.2671@knanqh.ubzr> <940d3add-4d12-56ed-617a-8b3bf8ef3a0f@infradead.org>
 <nycvar.YSQ.7.76.2004231059170.2671@knanqh.ubzr> <20200423150556.GZ26002@ziepe.ca> <nycvar.YSQ.7.76.2004231109500.2671@knanqh.ubzr> <20200423151624.GA26002@ziepe.ca> <nycvar.YSQ.7.76.2004231128210.2671@knanqh.ubzr> <20200423183055.GB26002@ziepe.ca>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Pobox-Relay-ID: 8D860ECE-8593-11EA-8543-B0405B776F7B-78420484!pb-smtp20.pobox.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Apr 2020, Jason Gunthorpe wrote:

> On Thu, Apr 23, 2020 at 11:33:33AM -0400, Nicolas Pitre wrote:
> > > > No. There is no logic in restricting MTD usage based on CRAMFS or 
> > > > CRAMFS_MTD.
> > > 
> > > Ah, I got it backwards, maybe this:
> > > 
> > > config CRAMFS
> > >    depends on MTD if CRAMFS_MTD
> > > 
> > > ?
> > 
> > Still half-backward. CRAMFS should not depend on either MTD nor
> > CRAMFS_MTD.
> 
> Well, I would view this the same as all the other cases.. the CRAMFS
> module has an optional ability consume symbols from MTD.  Here that is
> controlled by another 'CRAMFS_MTD' selection, but it should still
> settle it out the same way as other cases like this - ie CRAMFS is
> restricted to m if MTD is m
> 
> Arnd's point that kconfig is acyclic does kill it though :(
> 
> > It is CRAMFS_MTD that needs both CRAMFS and MTD.
> > Furthermore CRAMFS_MTD can't be built-in if MTD is modular.
> 
> CRAMFS_MTD is a bool feature flag for the CRAMFS tristate - it is
> CRAMFS that can't be built in if MTD is modular.

Not exactly. CRAMFS still can be built irrespective of MTD. It is only 
the XIP part of CRAMFS relying on MTD that is restricted.


Nicolas
