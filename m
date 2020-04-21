Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60AAA1B28C4
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 15:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728918AbgDUN6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 09:58:25 -0400
Received: from pb-smtp21.pobox.com ([173.228.157.53]:60611 "EHLO
        pb-smtp21.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728912AbgDUN6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 09:58:22 -0400
Received: from pb-smtp21.pobox.com (unknown [127.0.0.1])
        by pb-smtp21.pobox.com (Postfix) with ESMTP id AE924B4ED3;
        Tue, 21 Apr 2020 09:58:18 -0400 (EDT)
        (envelope-from nico@fluxnic.net)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=pobox.com; h=date:from:to
        :cc:subject:in-reply-to:message-id:references:mime-version
        :content-type; s=sasl; bh=H8yh9MEx3hZkv8zIqzP78ok50J4=; b=x/Xbfg
        vZYvPS8Wqcq7omo/3Yq9OUmbsVLJHa2VNvxQEpouF+afBKVP/4FPIxxpHczJ9OBr
        p5JCD6YdSsRu7JXgkD0IexgBvEpHL1tDQ4j++ESXOqHrF/QrylAJlUn11BfNxVAo
        +6z+o19D6AXf3oiqvR26JXHX6i6C4vQlBxzCs=
Received: from pb-smtp21.sea.icgroup.com (unknown [127.0.0.1])
        by pb-smtp21.pobox.com (Postfix) with ESMTP id A4E23B4ED2;
        Tue, 21 Apr 2020 09:58:18 -0400 (EDT)
        (envelope-from nico@fluxnic.net)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed; d=fluxnic.net;
 h=date:from:to:cc:subject:in-reply-to:message-id:references:mime-version:content-type; s=2016-12.pbsmtp; bh=S9IEMKuiDJF/j1aD5HeQF9LyanvsJexzTiSbI4WlfDA=; b=HEE7M2YMLncR0Cx0FbMI4zv+qdbUdh5RGzbVr/VnLmFuCcA8EaAt2iu3/wxVYe3x5iiRjNumaZvBT2DnobJkrSrUr08ZTTJfWEoY9E2Qahout6wsZey493C/2R+FjLDszFdsTzb5GgH+F/9kgc+C0d0NI193Ji9twflHDSMWuhc=
Received: from yoda.home (unknown [24.203.50.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by pb-smtp21.pobox.com (Postfix) with ESMTPSA id 8BB0AB4ECD;
        Tue, 21 Apr 2020 09:58:15 -0400 (EDT)
        (envelope-from nico@fluxnic.net)
Received: from xanadu.home (xanadu.home [192.168.2.2])
        by yoda.home (Postfix) with ESMTPSA id 9DA582DA0D15;
        Tue, 21 Apr 2020 09:58:13 -0400 (EDT)
Date:   Tue, 21 Apr 2020 09:58:13 -0400 (EDT)
From:   Nicolas Pitre <nico@fluxnic.net>
To:     Saeed Mahameed <saeedm@mellanox.com>
cc:     "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "jani.nikula@linux.intel.com" <jani.nikula@linux.intel.com>,
        "Laurent.pinchart@ideasonboard.com" 
        <Laurent.pinchart@ideasonboard.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "jernej.skrabec@siol.net" <jernej.skrabec@siol.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jonas@kwiboo.se" <jonas@kwiboo.se>,
        "narmstrong@baylibre.com" <narmstrong@baylibre.com>,
        "kieran.bingham+renesas@ideasonboard.com" 
        <kieran.bingham+renesas@ideasonboard.com>,
        "leon@kernel.org" <leon@kernel.org>
Subject: Re: [RFC PATCH 1/2] Kconfig: Introduce "uses" keyword
In-Reply-To: <45b9efec57b2e250e8e39b3b203eb8cee10cb6e8.camel@mellanox.com>
Message-ID: <nycvar.YSQ.7.76.2004210951160.2671@knanqh.ubzr>
References: <20200417011146.83973-1-saeedm@mellanox.com> <CAK7LNAQZd_LUyA2V_pCvMTr_201nSX1Nm0TDw5kOeNV64rOfpA@mail.gmail.com> <nycvar.YSQ.7.76.2004181509030.2671@knanqh.ubzr> <CAK7LNATmPD1R+Ranis2u3yohx8b0+dGKAvFpjg8Eo9yEHRT6zQ@mail.gmail.com>
 <87v9lu1ra6.fsf@intel.com> <45b9efec57b2e250e8e39b3b203eb8cee10cb6e8.camel@mellanox.com>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Pobox-Relay-ID: 25A4AB2E-83D8-11EA-AC8D-8D86F504CC47-78420484!pb-smtp21.pobox.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Apr 2020, Saeed Mahameed wrote:

> I wonder how many of those 8889 cases wanted a weak dependency but
> couldn't figure out how to do it ? 
> 
> Users of depends on FOO || !FOO
> 
> $ git ls-files | grep Kconfig | xargs grep -E \
>   "depends\s+on\s+([A-Za-z0-9_]+)\s*\|\|\s*(\!\s*\1|\1\s*=\s*n)" \
>  | wc -l
> 
> 156
> 
> a new keyword is required :) .. 
> 
> 
> > In another mail I suggested
> > 
> > 	optionally depends on FOO
> > 
> > might be a better alternative than "uses".
> > 
> > 
> 
> how about just:
>       optional FOO
> 
> It is clear and easy to document .. 

I don't dispute your argument for having a new keyword. But the most 
difficult part as Arnd said is to find it. You cannot pretend that 
"optional FOO" is clear when it actually imposes a restriction when 
FOO=m. Try to justify to people why they cannot select y because of this 
"optional" thing.


Nicolas
