Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 750B1566171
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 04:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231796AbiGECuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 22:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbiGECuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 22:50:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73773A197
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 19:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F2B761884
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 02:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 193A9C3411E;
        Tue,  5 Jul 2022 02:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656989412;
        bh=o2Tf/GxCCYcH/AncxCFoEYiWIu5x5d30HNQYufVVhXI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Enze3g/Y4TiimQmc0UdbBATJVvB4B88McrkG8jwK68Xw4HKOXjgXhmaUoRNKaHmIp
         unIpq+2tw1otFRYrRk1hmVCuiUVjBpx+yIYlQkFhH7pZQnKE+RG40MyrVaRFo+lQwa
         oSZRcEdrPgcIauMuufBUgarDVzwlCFdtUfqB9hldGFN/iqmogQaMeVw4xc+Wf6+Dyw
         84e4reF7/5nWSsv0R3QkZDaj/aMGUBa9MTHuhKuHtMscbegirT6mc/wIWHa/aMIo9Q
         Uhmk1K064HBzQvM2QA0ote/j7IfojGsb+IG+AYj/u+N74HRPteZbvhmr5R6is0ow6B
         CdcpnFAc8F3ig==
Date:   Mon, 4 Jul 2022 19:50:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Lamparter <equinox@diac24.net>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: Re: [PATCH net-next v3] net: ip6mr: add RTM_GETROUTE netlink op
Message-ID: <20220704195011.0af1dbab@kernel.org>
In-Reply-To: <20220704105223.395359-1-equinox@diac24.net>
References: <e41a3aba-ae19-9713-0d41-bd7287fdfc43@blackwall.org>
        <20220704105223.395359-1-equinox@diac24.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  4 Jul 2022 12:52:23 +0200 David Lamparter wrote:
> +const struct nla_policy rtm_ipv6_mr_policy[RTA_MAX + 1] = {
> +	[RTA_SRC]		= NLA_POLICY_EXACT_LEN(sizeof(struct in6_addr)),
> +	[RTA_DST]		= NLA_POLICY_EXACT_LEN(sizeof(struct in6_addr)),
> +	[RTA_TABLE]		= { .type = NLA_U32 },
> +};

net/ipv6/ip6mr.c:2515:25: warning: symbol 'rtm_ipv6_mr_policy' was not declared. Should it be static?
