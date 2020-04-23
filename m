Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 405181B5F51
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 17:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729200AbgDWPdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 11:33:42 -0400
Received: from pb-smtp21.pobox.com ([173.228.157.53]:58339 "EHLO
        pb-smtp21.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729020AbgDWPdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 11:33:42 -0400
Received: from pb-smtp21.pobox.com (unknown [127.0.0.1])
        by pb-smtp21.pobox.com (Postfix) with ESMTP id 23121C8574;
        Thu, 23 Apr 2020 11:33:39 -0400 (EDT)
        (envelope-from nico@fluxnic.net)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=pobox.com; h=date:from:to
        :cc:subject:in-reply-to:message-id:references:mime-version
        :content-type; s=sasl; bh=MzicH27rdexv30KgOupgDHNzO0A=; b=UvBmrF
        PMNz92Ewh+rcwgIdcQGR4M3AQ2jY6KWfOrfSkXL8JnFRn9Nh4Cro8Qx2aY7YO6tl
        h9CIZFjTUPH5OuzsSzc1+R3XANRPOa7ByVsaQ6gIWrk7cjddjyU6doaGeycpTs3/
        w8tZJWYpDXwuFOVjL32ekNMAenfqIkrgmZLVc=
Received: from pb-smtp21.sea.icgroup.com (unknown [127.0.0.1])
        by pb-smtp21.pobox.com (Postfix) with ESMTP id 05F3EC8573;
        Thu, 23 Apr 2020 11:33:39 -0400 (EDT)
        (envelope-from nico@fluxnic.net)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed; d=fluxnic.net;
 h=date:from:to:cc:subject:in-reply-to:message-id:references:mime-version:content-type; s=2016-12.pbsmtp; bh=O+rr3BNuwQiLVk4n3xxKa9AYdQMYS30XZdh6Q/mV6mA=; b=GP8FmoUAyQxzMBurjGECSXPTktUpNn0yelSY0szzIiWj0WaVqVQq+2mKCHjIUZKST8MdBgH6RFUMdn8mrh6T4v2kfKVQMqN7bu88pAAw4Oq8jbJQ85L0HFohdzuyU7tg02NWSRvJqRPHdW1oXbmfiNH1OppF+RnPP6GsaMUzMNw=
Received: from yoda.home (unknown [24.203.50.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by pb-smtp21.pobox.com (Postfix) with ESMTPSA id C5D35C856F;
        Thu, 23 Apr 2020 11:33:35 -0400 (EDT)
        (envelope-from nico@fluxnic.net)
Received: from xanadu.home (xanadu.home [192.168.2.2])
        by yoda.home (Postfix) with ESMTPSA id E37032DA0CB1;
        Thu, 23 Apr 2020 11:33:33 -0400 (EDT)
Date:   Thu, 23 Apr 2020 11:33:33 -0400 (EDT)
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
In-Reply-To: <20200423151624.GA26002@ziepe.ca>
Message-ID: <nycvar.YSQ.7.76.2004231128210.2671@knanqh.ubzr>
References: <45b9efec57b2e250e8e39b3b203eb8cee10cb6e8.camel@mellanox.com> <nycvar.YSQ.7.76.2004210951160.2671@knanqh.ubzr> <62a51b2e5425a3cca4f7a66e2795b957f237b2da.camel@mellanox.com> <nycvar.YSQ.7.76.2004211411500.2671@knanqh.ubzr> <871rofdhtg.fsf@intel.com>
 <nycvar.YSQ.7.76.2004221649480.2671@knanqh.ubzr> <940d3add-4d12-56ed-617a-8b3bf8ef3a0f@infradead.org> <nycvar.YSQ.7.76.2004231059170.2671@knanqh.ubzr> <20200423150556.GZ26002@ziepe.ca> <nycvar.YSQ.7.76.2004231109500.2671@knanqh.ubzr>
 <20200423151624.GA26002@ziepe.ca>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Pobox-Relay-ID: CBFEED22-8577-11EA-B0EC-8D86F504CC47-78420484!pb-smtp21.pobox.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Apr 2020, Jason Gunthorpe wrote:

> On Thu, Apr 23, 2020 at 11:11:46AM -0400, Nicolas Pitre wrote:
> > On Thu, 23 Apr 2020, Jason Gunthorpe wrote:
> > 
> > > On Thu, Apr 23, 2020 at 11:01:40AM -0400, Nicolas Pitre wrote:
> > > > On Wed, 22 Apr 2020, Randy Dunlap wrote:
> > > > 
> > > > > On 4/22/20 2:13 PM, Nicolas Pitre wrote:
> > > > > > On Wed, 22 Apr 2020, Jani Nikula wrote:
> > > > > > 
> > > > > >> On Tue, 21 Apr 2020, Nicolas Pitre <nico@fluxnic.net> wrote:
> > > > > >>> This is really a conditional dependency. That's all this is about.
> > > > > >>> So why not simply making it so rather than fooling ourselves? All that 
> > > > > >>> is required is an extension that would allow:
> > > > > >>>
> > > > > >>> 	depends on (expression) if (expression)
> > > > > >>>
> > > > > >>> This construct should be obvious even without reading the doc, is 
> > > > > >>> already used extensively for other things already, and is flexible 
> > > > > >>> enough to cover all sort of cases in addition to this particular one.
> > > > > >>
> > > > > >> Okay, you convinced me. Now you only need to convince whoever is doing
> > > > > >> the actual work of implementing this stuff. ;)
> > > > > > 
> > > > > > What about this:
> > > > > > 
> > > > > > Subject: [PATCH] kconfig: allow for conditional dependencies
> > > > > > 
> > > > > > This might appear to be a strange concept, but sometimes we want
> > > > > > a dependency to be conditionally applied. One such case is currently
> > > > > > expressed with:
> > > > > > 
> > > > > > 	depends on FOO || !FOO
> > > > > > 
> > > > > > This pattern is strange enough to give one's pause. Given that it is
> > > > > > also frequent, let's make the intent more obvious with some syntaxic 
> > > > > > sugar by effectively making dependencies optionally conditional.
> > > > > > This also makes the kconfig language more uniform.
> > > > > > 
> > > > > > Signed-off-by: Nicolas Pitre <nico@fluxnic.net>
> > > > > 
> > > > > Hi,
> > > > > 
> > > > > If we must do something here, I prefer this one.
> > > > > 
> > > > > Nicolas, would you do another example, specifically for
> > > > > CRAMFS_MTD in fs/cramfs/Kconfig, please?
> > > > 
> > > > I don't see how that one can be helped. The MTD dependency is not 
> > > > optional.
> > > 
> > > Could it be done as 
> > > 
> > > config MTD
> > >    depends on CRAMFS if CRAMFS_MTD
> > > 
> > > ?
> > 
> > No. There is no logic in restricting MTD usage based on CRAMFS or 
> > CRAMFS_MTD.
> 
> Ah, I got it backwards, maybe this:
> 
> config CRAMFS
>    depends on MTD if CRAMFS_MTD
> 
> ?

Still half-backward. CRAMFS should not depend on either MTD nor 
CRAMFS_MTD.

It is CRAMFS_MTD that needs both CRAMFS and MTD. 
Furthermore CRAMFS_MTD can't be built-in if MTD is modular.


Nicolas
