Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 352871B5E85
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 17:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728970AbgDWPBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 11:01:46 -0400
Received: from pb-smtp2.pobox.com ([64.147.108.71]:52188 "EHLO
        pb-smtp2.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbgDWPBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 11:01:45 -0400
Received: from pb-smtp2.pobox.com (unknown [127.0.0.1])
        by pb-smtp2.pobox.com (Postfix) with ESMTP id E9F5A635E6;
        Thu, 23 Apr 2020 11:01:41 -0400 (EDT)
        (envelope-from nico@fluxnic.net)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=pobox.com; h=date:from:to
        :cc:subject:in-reply-to:message-id:references:mime-version
        :content-type; s=sasl; bh=78u2ohdjhWZpEjVtdjYFeCagL0w=; b=XEFUD4
        /Vin0OUbZukrHXwDy/uagnYbGpqMVSNGc+aAKuiXJr6KBs303Ho9VYA7J7DtWjfh
        KWf/mC92uG2Ga9plWYmPdOCqqnfHjwIKzS+pDH0lCqjOnlP4XfNbrJmJ8LgYdgbc
        GAF/jdkC3Kx8FZdoO6LikRd/xoW4b693oxsvU=
Received: from pb-smtp2.nyi.icgroup.com (unknown [127.0.0.1])
        by pb-smtp2.pobox.com (Postfix) with ESMTP id DE7BB635E5;
        Thu, 23 Apr 2020 11:01:41 -0400 (EDT)
        (envelope-from nico@fluxnic.net)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed; d=fluxnic.net;
 h=date:from:to:cc:subject:in-reply-to:message-id:references:mime-version:content-type; s=2016-12.pbsmtp; bh=4m4VwhMDCjaTm3eIC1ZXQR+cuWglIVYffGluXSzqGHk=; b=MMaYNHsUWptKS/65H7qstSyjNHA2GOOvwQyk9lV07T67vyTonML++rScUg0EVu9OPEmyH2pMc1QrnfIAHeNEmOgyRRCagcchAubMD2AOrBdWH+u7z/BXIgEAxhncD9eoadGmQqLU6KJcOI2f5RFbr/61ix6fTPupqctNiThtiQE=
Received: from yoda.home (unknown [24.203.50.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by pb-smtp2.pobox.com (Postfix) with ESMTPSA id 5B129635E3;
        Thu, 23 Apr 2020 11:01:41 -0400 (EDT)
        (envelope-from nico@fluxnic.net)
Received: from xanadu.home (xanadu.home [192.168.2.2])
        by yoda.home (Postfix) with ESMTPSA id 629C32DA0C9D;
        Thu, 23 Apr 2020 11:01:40 -0400 (EDT)
Date:   Thu, 23 Apr 2020 11:01:40 -0400 (EDT)
From:   Nicolas Pitre <nico@fluxnic.net>
To:     Randy Dunlap <rdunlap@infradead.org>
cc:     Jani Nikula <jani.nikula@linux.intel.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
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
        "kieran.bingham+renesas@ideasonboard.com" 
        <kieran.bingham+renesas@ideasonboard.com>,
        "narmstrong@baylibre.com" <narmstrong@baylibre.com>,
        "leon@kernel.org" <leon@kernel.org>
Subject: Re: [RFC PATCH 1/2] Kconfig: Introduce "uses" keyword
In-Reply-To: <940d3add-4d12-56ed-617a-8b3bf8ef3a0f@infradead.org>
Message-ID: <nycvar.YSQ.7.76.2004231059170.2671@knanqh.ubzr>
References: <20200417011146.83973-1-saeedm@mellanox.com> <CAK7LNAQZd_LUyA2V_pCvMTr_201nSX1Nm0TDw5kOeNV64rOfpA@mail.gmail.com> <nycvar.YSQ.7.76.2004181509030.2671@knanqh.ubzr> <CAK7LNATmPD1R+Ranis2u3yohx8b0+dGKAvFpjg8Eo9yEHRT6zQ@mail.gmail.com>
 <87v9lu1ra6.fsf@intel.com> <45b9efec57b2e250e8e39b3b203eb8cee10cb6e8.camel@mellanox.com> <nycvar.YSQ.7.76.2004210951160.2671@knanqh.ubzr> <62a51b2e5425a3cca4f7a66e2795b957f237b2da.camel@mellanox.com> <nycvar.YSQ.7.76.2004211411500.2671@knanqh.ubzr>
 <871rofdhtg.fsf@intel.com> <nycvar.YSQ.7.76.2004221649480.2671@knanqh.ubzr> <940d3add-4d12-56ed-617a-8b3bf8ef3a0f@infradead.org>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Pobox-Relay-ID: 56E794D4-8573-11EA-B31B-D1361DBA3BAF-78420484!pb-smtp2.pobox.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Apr 2020, Randy Dunlap wrote:

> On 4/22/20 2:13 PM, Nicolas Pitre wrote:
> > On Wed, 22 Apr 2020, Jani Nikula wrote:
> > 
> >> On Tue, 21 Apr 2020, Nicolas Pitre <nico@fluxnic.net> wrote:
> >>> This is really a conditional dependency. That's all this is about.
> >>> So why not simply making it so rather than fooling ourselves? All that 
> >>> is required is an extension that would allow:
> >>>
> >>> 	depends on (expression) if (expression)
> >>>
> >>> This construct should be obvious even without reading the doc, is 
> >>> already used extensively for other things already, and is flexible 
> >>> enough to cover all sort of cases in addition to this particular one.
> >>
> >> Okay, you convinced me. Now you only need to convince whoever is doing
> >> the actual work of implementing this stuff. ;)
> > 
> > What about this:
> > 
> > ----- >8
> > Subject: [PATCH] kconfig: allow for conditional dependencies
> > 
> > This might appear to be a strange concept, but sometimes we want
> > a dependency to be conditionally applied. One such case is currently
> > expressed with:
> > 
> > 	depends on FOO || !FOO
> > 
> > This pattern is strange enough to give one's pause. Given that it is
> > also frequent, let's make the intent more obvious with some syntaxic 
> > sugar by effectively making dependencies optionally conditional.
> > This also makes the kconfig language more uniform.
> > 
> > Signed-off-by: Nicolas Pitre <nico@fluxnic.net>
> 
> Hi,
> 
> If we must do something here, I prefer this one.
> 
> Nicolas, would you do another example, specifically for
> CRAMFS_MTD in fs/cramfs/Kconfig, please?

I don't see how that one can be helped. The MTD dependency is not 
optional.


Nicolas
