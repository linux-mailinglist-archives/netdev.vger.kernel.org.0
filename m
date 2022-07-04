Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83B3C564FCC
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 10:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233332AbiGDIfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 04:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231497AbiGDIfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 04:35:24 -0400
Received: from eidolon.nox.tf (eidolon.nox.tf [IPv6:2a07:2ec0:2185::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC185FB2
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 01:35:23 -0700 (PDT)
Received: from equinox by eidolon.nox.tf with local (Exim 4.94.2)
        (envelope-from <equinox@diac24.net>)
        id 1o8HY8-003LOT-7j; Mon, 04 Jul 2022 10:35:20 +0200
Date:   Mon, 4 Jul 2022 10:35:20 +0200
From:   David Lamparter <equinox@diac24.net>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: ip6mr: add RTM_GETROUTE netlink op
Message-ID: <YsKmSMPRoUHeejCS@eidolon.nox.tf>
References: <20220630202706.33555ad2@kernel.org>
 <20220701075805.65978-1-equinox@diac24.net>
 <20220701075805.65978-3-equinox@diac24.net>
 <0d18f6a3-78da-2dee-d715-39a043870eec@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d18f6a3-78da-2dee-d715-39a043870eec@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 03, 2022 at 01:07:33PM -0600, David Ahern wrote:
> On 7/1/22 1:58 AM, David Lamparter wrote:
[...]
> > +	if (!netlink_strict_get_check(skb))
> > +		return nlmsg_parse_deprecated(nlh, sizeof(*rtm), tb, RTA_MAX,
> > +					      rtm_ipv6_policy, extack);
>
> Since this is new code, it always operates in strict mode.
>
[...]
> > +	err = nlmsg_parse_deprecated_strict(nlh, sizeof(*rtm), tb, RTA_MAX,
> > +					    rtm_ipv6_policy, extack);
>
> nlmsg_parse here.

Thanks for the feedback!  I've fixed the code, am currently retesting,
and will post a v2 shortly.


-David / equi
