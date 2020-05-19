Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04F921D9C70
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 18:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729386AbgESQZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 12:25:00 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:51041 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728689AbgESQZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 12:25:00 -0400
Received: from compute7.internal (compute7.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id 7CBCF5C00D1;
        Tue, 19 May 2020 12:24:58 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute7.internal (MEProxy); Tue, 19 May 2020 12:24:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=benboeckel.net;
         h=date:from:to:cc:subject:message-id:reply-to:references
        :mime-version:content-type:in-reply-to; s=fm1; bh=7/52dq5GxyiFcd
        dCLps86QCxmzKufuJnLl7OH1657qI=; b=c1zsJqiWBgruzDh/25LryFc4I/tJS+
        KejzuOJ1efDWpsQMaT/iI4KAnDS8jXkboxzHQy4d076P8VZSYja7C1lqXzJAxwOU
        /hHqX9Vh52Pk30pdFhFxBvtUvWJnCkP/6ZXnwYHBHf/wv8gK+uHbv3hQusJ8DlUB
        tJgDY6o2zq2Rqj2G0aw14HNItLTKTgwuZCvTalwVu09DNN+r39xi3yiS0Fu4am2u
        TfYm1o6nbLAxFMsajd7qy/8HN6kEkoapPVwE2rrpHeNfQntfA85cDt453wuUY2nc
        4QmbMa00jCapZPZ8WeUbwAMb1HZBpHhCVqxFjQuXmt/PfKVCz/8cjO0A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:reply-to:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=7/52dq5GxyiFcddCLps86QCxmzKufuJnLl7OH1657qI=; b=fZkGF6+s
        2NFay7YhJ+tKBb+twAe0shLDdn1FlFIJBQuxiomMjsGpQ/K8Vfjw7b8lrfWLGyAl
        ASpfsxFhO1xrM3d/4JB2/9oQl7GK0irtWZY4mvvQFOGTKR3qLeATNUztzFFkG9hj
        mJ3vXnWYEyhcD1gj+PJ/ijWHDqJpjpC7du7daw3nn+lGpeREw/9mjYfHF5MJMevQ
        W9+49sDoDe2ddx0oK72Pr/S30OX5LWMdFSoN+pM6Ge8CFhZoQIp1gtAr2Y+zWUY3
        gDuv/2jlCR3X3zZXxA3jj2W0qMeJMvTo2VfhJnb++3fCWmWkExulf7TzjItqUtM0
        MufBtLPvlovf7A==
X-ME-Sender: <xms:VQjEXlRLzugsFLKbHpleHm2R5P4Xz3dzQH6kstjIiDtNAwXKpJnfTQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddtjedgleelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhrfhggtggujggfsehttdertddtreejnecuhfhrohhmpeeuvghn
    uceuohgvtghkvghluceomhgvsegsvghnsghovggtkhgvlhdrnhgvtheqnecuggftrfgrth
    htvghrnhepjedtvdffheetgfektdehvefgieelgeefheejvdehtdduieetgedtfedtleev
    vdffnecukfhppeeiledrvddtgedrudeikedrvdeffeenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehmvgessggvnhgsohgvtghkvghlrdhnvght
X-ME-Proxy: <xmx:VQjEXuym6QgehtMSmMpoV9E7TnaLg9GXaX3mTvL85qC7i3EAwGH9uQ>
    <xmx:VQjEXq1yZDifEBgM-BnSBJ_sg8hMsS0yLWT_4Yka9-rkqVDOO7U70w>
    <xmx:VQjEXtCtK0SpOh7vIKzJBJRtA5Rsv4RchA3niV5yLgsDwRm_jqcpyw>
    <xmx:WgjEXga2rAiJlnRndipxaz5S5Xibw8t-qKafQBRhmbZN_wm9Ok0GLw>
Received: from localhost (cpe-69-204-168-233.nycap.res.rr.com [69.204.168.233])
        by mail.messagingengine.com (Postfix) with ESMTPA id 63B91306643B;
        Tue, 19 May 2020 12:24:53 -0400 (EDT)
Date:   Tue, 19 May 2020 12:24:52 -0400
From:   Ben Boeckel <me@benboeckel.net>
To:     David Howells <dhowells@redhat.com>
Cc:     fweimer@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-afs@lists.infradead.org,
        ceph-devel@vger.kernel.org, keyrings@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dns: Apply a default TTL to records obtained from
 getaddrinfo()
Message-ID: <20200519162452.GA3010828@erythro.dev.benboeckel.internal>
Reply-To: me@benboeckel.net
References: <20200519141432.GA2949457@erythro.dev.benboeckel.internal>
 <20200518155148.GA2595638@erythro.dev.benboeckel.internal>
 <158981176590.872823.11683683537698750702.stgit@warthog.procyon.org.uk>
 <1080378.1589895580@warthog.procyon.org.uk>
 <1512927.1589904409@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1512927.1589904409@warthog.procyon.org.uk>
User-Agent: Mutt/1.13.3 (2020-01-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 19, 2020 at 17:06:49 +0100, David Howells wrote:
> Okay, how about this incremental change, then?  If fixes the typo, only prints
> the "READ CONFIG" line in verbose mode, filters escape chars in the config
> file and reduces the expiration time to 5s.

Thanks! Looks good to me.

Reviewed-by: Ben Boeckel <me@benboeckel.net>

--Ben
