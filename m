Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68C991AF417
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 21:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728052AbgDRTLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 15:11:23 -0400
Received: from pb-smtp20.pobox.com ([173.228.157.52]:58167 "EHLO
        pb-smtp20.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726751AbgDRTLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 15:11:22 -0400
Received: from pb-smtp20.pobox.com (unknown [127.0.0.1])
        by pb-smtp20.pobox.com (Postfix) with ESMTP id AC690C0F89;
        Sat, 18 Apr 2020 15:11:20 -0400 (EDT)
        (envelope-from nico@fluxnic.net)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=pobox.com; h=date:from:to
        :cc:subject:in-reply-to:message-id:references:mime-version
        :content-type; s=sasl; bh=VZi9Lq6WjEW2CMj7HADAyLMP9ZI=; b=ZLJbYg
        4nliaG/wB0lpsHa9Ci3Ow858DxY3MSXbTL18SlWGyEOyg3pYK/1u/hodTrFUc2Zh
        Pt8Muie1h9OY4vYRcfU48T2E23QAW11LwUri+mhm8h6gpdZJHAnu3n3wzbJFDDLm
        b1LrWxyhFeW1Z2U1kqesZRruoqrGAfu6m9iWc=
Received: from pb-smtp20.sea.icgroup.com (unknown [127.0.0.1])
        by pb-smtp20.pobox.com (Postfix) with ESMTP id A322EC0F88;
        Sat, 18 Apr 2020 15:11:20 -0400 (EDT)
        (envelope-from nico@fluxnic.net)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed; d=fluxnic.net;
 h=date:from:to:cc:subject:in-reply-to:message-id:references:mime-version:content-type; s=2016-12.pbsmtp; bh=tENhMTZ0DxDYPUZYBdHPCEQinqDZrI5H7ppeCRcGjKI=; b=unAv7lpBJ5hzW6YKxPPwiJaNbdzqxPfBLiZD0AZwW/+b0DjQD2STZ8xXtXxgO2/QDAcgR7LPXneVP9p5rJyAtdcNbD4PqSz/e5RTfd5AHN65Nek3vt0+2ZpaeS3kjoGzIpk1ue+PSNGlrK7rXV/rABLIbpo0yWip+9oe8GdYQb8=
Received: from yoda.home (unknown [24.203.50.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by pb-smtp20.pobox.com (Postfix) with ESMTPSA id 9CC5CC0F87;
        Sat, 18 Apr 2020 15:11:17 -0400 (EDT)
        (envelope-from nico@fluxnic.net)
Received: from xanadu.home (xanadu.home [192.168.2.2])
        by yoda.home (Postfix) with ESMTPSA id 9E36C2DA0A70;
        Sat, 18 Apr 2020 15:11:15 -0400 (EDT)
Date:   Sat, 18 Apr 2020 15:11:15 -0400 (EDT)
From:   Nicolas Pitre <nico@fluxnic.net>
To:     Masahiro Yamada <masahiroy@kernel.org>
cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Leon Romanovsky <leon@kernel.org>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        jonas@kwiboo.se, David Airlie <airlied@linux.ie>,
        jernej.skrabec@siol.net,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, linux-rdma@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] Kconfig: Introduce "uses" keyword
In-Reply-To: <CAK7LNAQZd_LUyA2V_pCvMTr_201nSX1Nm0TDw5kOeNV64rOfpA@mail.gmail.com>
Message-ID: <nycvar.YSQ.7.76.2004181509030.2671@knanqh.ubzr>
References: <20200417011146.83973-1-saeedm@mellanox.com> <CAK7LNAQZd_LUyA2V_pCvMTr_201nSX1Nm0TDw5kOeNV64rOfpA@mail.gmail.com>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Pobox-Relay-ID: 61636EB6-81A8-11EA-ACEA-B0405B776F7B-78420484!pb-smtp20.pobox.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 19 Apr 2020, Masahiro Yamada wrote:

> (FOO || !FOO) is difficult to understand, but
> the behavior of "uses FOO" is as difficult to grasp.

Can't this be expressed as the following instead:

	depends on FOO if FOO

That would be a little clearer.


Nicolas
