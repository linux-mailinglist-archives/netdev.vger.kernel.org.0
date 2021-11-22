Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12AE6458BC2
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 10:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234460AbhKVJvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 04:51:43 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:54011 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229806AbhKVJvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 04:51:43 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id B92C05C016D;
        Mon, 22 Nov 2021 04:48:36 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 22 Nov 2021 04:48:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=PC9xmx
        mXeQIlFxrsJ09Q3G0/oM6yv0DOA3IQPNLEKp0=; b=SZf5YrMOAlWyXq6QgjtMTS
        HqPNFMDp/VzT2k3SdDhhxcPhZfIkV1GJgSdxZRCaupV7JhZoaLxE88n41VIQMfP3
        RYfNEMwdgRQb/5UCFkPGHHy81vbPlc+lo01ovItsCj0GuMqSX3oLbBfr4nTSc5Z+
        WDGwtUaByW49QDxDxharM1WQfUdE5U135ZMGIQcexIZmNjr619+EUDcVhq5/f/b/
        szHJV4R+Zge/ThEZR/E+5FDAymAhkXykPS9pc+99YK+PmVOPg6xDsn4tf7dD4OR8
        nqcDgDUFwWQszxeD8ZwU/jM0Xd0ZaTxIO7fPgHTjTISI0Rd9PE1wDgZg8B3kmFnA
        ==
X-ME-Sender: <xms:dGebYewT8BORDwf1UyzPZGo-rJtsXt-6yhdCBhUmD4RLX9P3pDHSQw>
    <xme:dGebYaSfpHwuzSCPN2XJLAqHRFseECBKMjrYV2hz8JcstPIb2RPCt0Ei25H-x3Y98
    eFLy7Wq1kgwDWU>
X-ME-Received: <xmr:dGebYQWpFVQgG5qkZHrL9F1ocLT5Qz2mCSZaUmhdUV2Rdpvftj_lGPe8wQWxEPwRW4Jk1Ct7y-Hbq-WnlkCQDAE2OGJJMA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrgeeggddtkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:dGebYUjhkq7hc2eh76lYJUrDwtk1ByYHpDtveL-HaPcMPJ9r64ln_Q>
    <xmx:dGebYQBglKWmArC_rXlzoZSSmjtK6SZe9_Di8NZVH6QkG6myL8lX8Q>
    <xmx:dGebYVJ8U88mKPdFLexjLZQ6tm0FGsPyfuTM3AazQDbCZqO0UfI4kA>
    <xmx:dGebYTNafF8vlWt1SA66mHT4gqwokC3neLYwkI1sJXKVkBw80at5eQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 22 Nov 2021 04:48:35 -0500 (EST)
Date:   Mon, 22 Nov 2021 11:48:32 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net 0/3] net: nexthop: fix refcount issues when replacing
 groups
Message-ID: <YZtncGsgIbo+q390@shredder>
References: <20211121152453.2580051-1-razor@blackwall.org>
 <YZqIBVcFwIzj6VZG@shredder>
 <d902fd06-00c2-fbff-1df2-4db3e890724a@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d902fd06-00c2-fbff-1df2-4db3e890724a@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 21, 2021 at 08:17:49PM +0200, Nikolay Aleksandrov wrote:
> On 21/11/2021 19:55, Ido Schimmel wrote:
> > On Sun, Nov 21, 2021 at 05:24:50PM +0200, Nikolay Aleksandrov wrote:
> >> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> >>
> >> Hi,
> >> This set fixes a refcount bug when replacing nexthop groups and
> >> modifying routes. It is complex because the objects look valid when
> >> debugging memory dumps, but we end up having refcount dependency between
> >> unlinked objects which can never be released, so in turn they cannot
> >> free their resources and refcounts. The problem happens because we can
> >> have stale IPv6 per-cpu dsts in nexthops which were removed from a
> >> group. Even though the IPv6 gen is bumped, the dsts won't be released
> >> until traffic passes through them or the nexthop is freed, that can take
> >> arbitrarily long time, and even worse we can create a scenario[1] where it
> >> can never be released. The fix is to release the IPv6 per-cpu dsts of
> >> replaced nexthops after an RCU grace period so no new ones can be
> >> created. To do that we add a new IPv6 stub - fib6_nh_release_dsts, which
> >> is used by the nexthop code only when necessary. We can further optimize
> >> group replacement, but that is more suited for net-next as these patches
> >> would have to be backported to stable releases.
> > 
> > Will run regression with these patches tonight and report tomorrow
> > 
> 
> Thank you, I've prepared v2 with the selftest mausezahn check and will hold
> it off to see how the tests would go. Also if any comments show up in the
> meantime. :)
> 
> By the way I've been running a torture test all day for multiple IPv6 route
> forwarding + local traffic through different CPUs while also replacing multiple
> nh groups referencing multiple nexthops, so far it looks good.

Regression looks good. Later today I will also have results from a debug
kernel, but I think it should be fine.

Regarding patch #2, can you add a comment (or edit the commit message)
to explain why the fix is only relevant for IPv4? I made this comment,
but I think it was missed:

"This problem is specific to IPv6 because IPv4 dst entries do not hold
references on routes / FIB info thereby avoiding the circular dependency
described in the commit message?"

Thanks!
