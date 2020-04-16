Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80BCF1ABDBF
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 12:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504678AbgDPKSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 06:18:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:45834 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441495AbgDPKRx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Apr 2020 06:17:53 -0400
IronPort-SDR: AwA41n4JgjKZuuNgZRCP6UHT3UZ1/Za8i4jvp+2iuw24g9JtB0A34lTmesKM6GH21CTwW6R8I8
 0TXBR3vVAKnA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2020 03:17:42 -0700
IronPort-SDR: PabvyhK/GDPyBjaf0paWWd5oAAbGpqHHyicWhdVU0osJ1cJkrEV/y2jitUhatIDlUFj03yE+KQ
 +MY52IYzL9ng==
X-IronPort-AV: E=Sophos;i="5.72,390,1580803200"; 
   d="scan'208";a="400622555"
Received: from ellenfax-mobl2.ger.corp.intel.com (HELO localhost) ([10.249.44.122])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2020 03:17:34 -0700
From:   Jani Nikula <jani.nikula@linux.intel.com>
To:     Arnd Bergmann <arnd@arndb.de>, Saeed Mahameed <saeedm@mellanox.com>
Cc:     "narmstrong\@baylibre.com" <narmstrong@baylibre.com>,
        "masahiroy\@kernel.org" <masahiroy@kernel.org>,
        "Laurent.pinchart\@ideasonboard.com" 
        <Laurent.pinchart@ideasonboard.com>,
        "leon\@kernel.org" <leon@kernel.org>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "linux-renesas-soc\@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nico\@fluxnic.net" <nico@fluxnic.net>,
        "linux-rdma\@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dri-devel\@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "kieran.bingham+renesas\@ideasonboard.com" 
        <kieran.bingham+renesas@ideasonboard.com>,
        "a.hajda\@samsung.com" <a.hajda@samsung.com>,
        "jonas\@kwiboo.se" <jonas@kwiboo.se>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "airlied\@linux.ie" <airlied@linux.ie>,
        "jgg\@ziepe.ca" <jgg@ziepe.ca>,
        "jernej.skrabec\@siol.net" <jernej.skrabec@siol.net>
Subject: Re: [RFC 0/6] Regressions for "imply" behavior change
In-Reply-To: <CAK8P3a3Wx5_bUOKnN3_hG5nLOqv3WCUtMSq6vOkJzWZgsmAz+A@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20200408202711.1198966-1-arnd@arndb.de> <nycvar.YSQ.7.76.2004081633260.2671@knanqh.ubzr> <CAK8P3a2frDf4BzEpEF0uwPTV2dv6Jve+6N97z1sSuSBUAPJquA@mail.gmail.com> <20200408224224.GD11886@ziepe.ca> <87k12pgifv.fsf@intel.com> <7d9410a4b7d0ef975f7cbd8f0b6762df114df539.camel@mellanox.com> <20200410171320.GN11886@ziepe.ca> <16441479b793077cdef9658f35773739038c39dc.camel@mellanox.com> <20200414132900.GD5100@ziepe.ca> <CAK8P3a0aFQ7h4zRDW=QLogXWc88JkJJXEOK0_CpWwsRjq6+T+w@mail.gmail.com> <20200414152312.GF5100@ziepe.ca> <CAK8P3a1PjP9_b5NdmqTLeGN4y+3JXx_yyTE8YAf1u5rYHWPA9g@mail.gmail.com> <f6d83b08fc0bc171b5ba5b2a0bc138727d92e2c0.camel@mellanox.com> <CAK8P3a1-J=4EAxh7TtQxugxwXk239u8ffgxZNRdw_WWy8ExFoQ@mail.gmail.com> <834c7606743424c64951dd2193ca15e29799bf18.camel@mellanox.com> <CAK8P3a3Wx5_bUOKnN3_hG5nLOqv3WCUtMSq6vOkJzWZgsmAz+A@mail.gmail.com>
Date:   Thu, 16 Apr 2020 13:17:32 +0300
Message-ID: <874ktj4tvn.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Apr 2020, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thu, Apr 16, 2020 at 5:25 AM Saeed Mahameed <saeedm@mellanox.com> wrote:
>> BTW how about adding a new Kconfig option to hide the details of
>> ( BAR || !BAR) ? as Jason already explained and suggested, this will
>> make it easier for the users and developers to understand the actual
>> meaning behind this tristate weird condition.
>>
>> e.g have a new keyword:
>>      reach VXLAN
>> which will be equivalent to:
>>      depends on VXLAN && !VXLAN
>
> I'd love to see that, but I'm not sure what keyword is best. For your
> suggestion of "reach", that would probably do the job, but I'm not
> sure if this ends up being more or less confusing than what we have
> today.

Ah, perfect bikeshedding topic!

Perhaps "uses"? If the dependency is enabled it gets used as a
dependency.

Of course, this is all just talk until someone(tm) posts a patch
actually making the change. I've looked at the kconfig tool sources
before; not going to make the same mistake again.

BR,
Jani.


-- 
Jani Nikula, Intel Open Source Graphics Center
