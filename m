Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88C69688690
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 19:33:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232611AbjBBSdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 13:33:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232115AbjBBScm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 13:32:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5287466036;
        Thu,  2 Feb 2023 10:31:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B782E61C67;
        Thu,  2 Feb 2023 18:30:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4C3C433D2;
        Thu,  2 Feb 2023 18:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675362606;
        bh=5Jf+yddjXP7I6lxGihpoPmhwLthqmwwGVtt9aEdNhhI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fZxJUisT/bmTOq50LSDkkMBt/OvYDXoLznvvibb0XmHAkQBQo8SnKybIuVZtFrSHv
         iH7qDVVp1gYIQMIwJsKbncCk9u7OCpoVIDb0uLtwL9cLah+8HbgOU9ne1OXI1PIyLO
         TvgDhJiC+ALcdUls/Ate+bZyrvo0uSOmOoA+9G3Hwz0UIC9r76p6CWGkxFRjCXIvtp
         gNIttoP+bPqSbeHGt9GSL2OjMyW6TPaExI+G/7g8HHk0rkSHWzGft0/U60XBzHeK3+
         E4zSjspdUgniMPIc+YyRg/TBTjpahdM2gkHY9OcBVztJqlaxhUCIUt6eXGMgPFCOWL
         KgbWGxsUxLDRg==
Date:   Thu, 2 Feb 2023 10:30:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: pull-request: mlx5-next 2023-01-24 V2
Message-ID: <20230202103004.26ab6ae9@kernel.org>
In-Reply-To: <Y9v93cy0s9HULnWq@x130>
References: <20230126230815.224239-1-saeed@kernel.org>
        <Y9tqQ0RgUtDhiVsH@unreal>
        <20230202091312.578aeb03@kernel.org>
        <Y9vvcSHlR5PW7j6D@nvidia.com>
        <20230202092507.57698495@kernel.org>
        <Y9v2ZW3mahPBXbvg@nvidia.com>
        <20230202095453.68f850bc@kernel.org>
        <Y9v61gb3ADT9rsLn@unreal>
        <Y9v93cy0s9HULnWq@x130>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2 Feb 2023 10:15:57 -0800 Saeed Mahameed wrote:
> It's a reality that mlx5_core is serving both netdev and rdma, it's not
> about who has the keys for approving, it's that the fact the mlx5_core is
> not just a netdev driver

Nah, nah, nah, don't play with me. You put in "full IPsec offload" 
with little netdev use, then start pushing RDMA IPsec patches.
Don't make it sound like netdev and rdma are separate entities which
just share the HW when you're using APIs of one to configure the other.
If RDMA invented its own API for IPsec without touching xfrm, we would
not be having this conversation. That'd be fine by me.

You used our APIs to make your proprietary thing easier to integrate and
configure - now you have to find someone who will pull the PR and still
sleep at night. Not me.
