Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8866A61EB04
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 07:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbiKGGar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 01:30:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbiKGGao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 01:30:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 042686255;
        Sun,  6 Nov 2022 22:30:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 532BC60EEB;
        Mon,  7 Nov 2022 06:30:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0A89C433D6;
        Mon,  7 Nov 2022 06:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667802642;
        bh=is7koPTcZDEnFNOJRPVb338b8e/3q5j2AqlbfcYHkmE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QJTCuKCm87Be10r/k5HD0ZRvWiqX5u/rJM6ymjxaWh/yHV2uiY3IlyHbm4cfpvRuo
         ir/O+u+bWfrXo9bcRzsoWROfdzl91bxj3tPSrYjzBvUtBNO8XI6T9AyoKYpFBDEp9d
         cHZeWTTNZt5argt234bBDipTv1DV8kzOl95ePIPoTDAuRDYfv/TR0/UOn9EyzwXX4N
         2FZXC9t8m/GMbMVGHDAeP/VHPPLZO7yfs8f5BaEpllb/f8JjmDN/nI9VY05WBs5Olt
         z9ciSBRy6rWhRfuamlvku2X7BIs64XX8OaIbLFX+WDXpAgCz2zFb/7s7tyrLdzA4qw
         DhPO9JYXNT7Jg==
Date:   Mon, 7 Nov 2022 08:30:37 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Louis Peens <louis.peens@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Wojciech Drewek <wojciech.drewek@intel.com>,
        Maksym Glubokiy <maksym.glubokiy@plvision.eu>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: Re: [PATCH net-next] net: flow_offload: add support for ARP frame
 matching
Message-ID: <Y2imDVTGD4hv78tp@unreal>
References: <20221104123314.1349814-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104123314.1349814-1-steen.hegelund@microchip.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 04, 2022 at 01:33:14PM +0100, Steen Hegelund wrote:
> This adds a new flow_rule_match_arp function that allows drivers
> to be able to dissect APR frames.
> 
> Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> ---
>  include/net/flow_offload.h | 6 ++++++
>  net/core/flow_offload.c    | 7 +++++++
>  2 files changed, 13 insertions(+)

I don't see any usage of this new API.
Please send this as part of the code that actually uses it.

Thanks
