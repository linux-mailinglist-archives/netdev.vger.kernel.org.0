Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B37074B8C1D
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 16:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235395AbiBPPLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 10:11:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233894AbiBPPLE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 10:11:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C92CA2A64E2
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 07:10:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7864BB81F1E
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 15:10:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D40C6C004E1;
        Wed, 16 Feb 2022 15:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645024250;
        bh=lGgyAm5EpK0xvS+9RYFxVTzRzcYr0VwToVU6nAfWtqE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=M0Fw9lUb1Il2Q2UcpG17SUxwwdiJuEm2ia0oxNZm8nVx1tU+EWNDeCpQp+br0oR8a
         lwAAckJX1jmLbNeYSSUumOv3EULktAEIXFoqF2gY2m6cUuafdZjJHngVXbJouAQZ+S
         btCLMGsmuav1GjzEBBLDk3hUHup33IoWE70FxQ+Nu750kDlf7bA7O88lDMAWcll6kX
         cO21AzhAXgbM18/upISy3QhFSh03PXrEEKL+9+NLmACNuR5+ZPAYJnLBt9JkWl1pmF
         1Jv6xzf2A6DD1MHEfbjddcIY5v1omaHMwpQ4TRzE1oAmdnV2LPBNuDIYj966HozNqX
         Xo4ya7u5C7C1w==
Message-ID: <a4791b77-fe00-85a2-5259-e79e8be511c5@kernel.org>
Date:   Wed, 16 Feb 2022 08:10:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH net-next] net: rtnetlink: rtnl_stats_get(): Emit an extack
 for unset filter_mask
Content-Language: en-US
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
References: <01feb1f4bbd22a19f6629503c4f366aed6424567.1645020876.git.petrm@nvidia.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <01feb1f4bbd22a19f6629503c4f366aed6424567.1645020876.git.petrm@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/16/22 7:31 AM, Petr Machata wrote:
> Both get and dump handlers for RTM_GETSTATS require that a filter_mask, a
> mask of which attributes should be emitted in the netlink response, is
> unset. rtnl_stats_dump() does include an extack in the bounce,
> rtnl_stats_get() however does not. Fix the omission.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/core/rtnetlink.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

