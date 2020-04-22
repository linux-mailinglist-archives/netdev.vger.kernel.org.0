Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17AA11B5068
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 00:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbgDVWh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 18:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725839AbgDVWh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 18:37:58 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD3DEC03C1A9;
        Wed, 22 Apr 2020 15:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=ELd+lIpZ+BIBbyIuMMJ83qOUII9r2nADeB7F0SdSefg=; b=OQ+MfXN35zU6e5S6hx3UDK1fNd
        AbGEikLauA3ZzUIWgzWIcF1QMYUQIiQGBKU9qFF4Koqbfs/0xpyW7/89rTV7uz4hE9ydxCThN1IjY
        Ts3m4IvWhRGbrtFaSYLxb04gVitsS3cUBQm2SWvSZIHgXYf5UogCVAxq8kc/RjL4D74n04wOO/BRF
        1HKdHip21kghxOcnlMY85hA6YxKVOfSyPBTqq6/hOc/cXohgWkcYJyXrnKq0IY8DGSahwaBt+mEaQ
        trZTjhJfyaDgnY7x3nbXo6L2y0BRILykhpf0UHJlqRACs9A1u9r3ddoEYqo9hpTyS2mLA2E5K5+17
        C+e9gxyg==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jRO05-0005n5-Og; Wed, 22 Apr 2020 22:37:49 +0000
Subject: Re: [RFC PATCH 1/2] Kconfig: Introduce "uses" keyword
To:     Nicolas Pitre <nico@fluxnic.net>,
        Jani Nikula <jani.nikula@linux.intel.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
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
References: <20200417011146.83973-1-saeedm@mellanox.com>
 <CAK7LNAQZd_LUyA2V_pCvMTr_201nSX1Nm0TDw5kOeNV64rOfpA@mail.gmail.com>
 <nycvar.YSQ.7.76.2004181509030.2671@knanqh.ubzr>
 <CAK7LNATmPD1R+Ranis2u3yohx8b0+dGKAvFpjg8Eo9yEHRT6zQ@mail.gmail.com>
 <87v9lu1ra6.fsf@intel.com>
 <45b9efec57b2e250e8e39b3b203eb8cee10cb6e8.camel@mellanox.com>
 <nycvar.YSQ.7.76.2004210951160.2671@knanqh.ubzr>
 <62a51b2e5425a3cca4f7a66e2795b957f237b2da.camel@mellanox.com>
 <nycvar.YSQ.7.76.2004211411500.2671@knanqh.ubzr> <871rofdhtg.fsf@intel.com>
 <nycvar.YSQ.7.76.2004221649480.2671@knanqh.ubzr>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <940d3add-4d12-56ed-617a-8b3bf8ef3a0f@infradead.org>
Date:   Wed, 22 Apr 2020 15:37:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <nycvar.YSQ.7.76.2004221649480.2671@knanqh.ubzr>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/22/20 2:13 PM, Nicolas Pitre wrote:
> On Wed, 22 Apr 2020, Jani Nikula wrote:
> 
>> On Tue, 21 Apr 2020, Nicolas Pitre <nico@fluxnic.net> wrote:
>>> This is really a conditional dependency. That's all this is about.
>>> So why not simply making it so rather than fooling ourselves? All that 
>>> is required is an extension that would allow:
>>>
>>> 	depends on (expression) if (expression)
>>>
>>> This construct should be obvious even without reading the doc, is 
>>> already used extensively for other things already, and is flexible 
>>> enough to cover all sort of cases in addition to this particular one.
>>
>> Okay, you convinced me. Now you only need to convince whoever is doing
>> the actual work of implementing this stuff. ;)
> 
> What about this:
> 
> ----- >8
> Subject: [PATCH] kconfig: allow for conditional dependencies
> 
> This might appear to be a strange concept, but sometimes we want
> a dependency to be conditionally applied. One such case is currently
> expressed with:
> 
> 	depends on FOO || !FOO
> 
> This pattern is strange enough to give one's pause. Given that it is
> also frequent, let's make the intent more obvious with some syntaxic 
> sugar by effectively making dependencies optionally conditional.
> This also makes the kconfig language more uniform.
> 
> Signed-off-by: Nicolas Pitre <nico@fluxnic.net>

Hi,

If we must do something here, I prefer this one.

Nicolas, would you do another example, specifically for
CRAMFS_MTD in fs/cramfs/Kconfig, please?

thanks.
-- 
~Randy

