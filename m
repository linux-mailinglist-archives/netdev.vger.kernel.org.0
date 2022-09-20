Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99C4A5BEEAB
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 22:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbiITUl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 16:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbiITUlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 16:41:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F39E2B184
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 13:41:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3ABDAB80C6A
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 20:41:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A60D5C433D7;
        Tue, 20 Sep 2022 20:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663706482;
        bh=PYOG5FhWIwnP43jhCLZP89pFLqhT76E1+uqOs4Np7bk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G4Z65ntCEbIX7NCZ7FJNrUafcNmcCMABwmJVHEN9LwHPMjIstCEgBBqtu6WrQ3ZwB
         emxnvUtz8xpjTBMyJpuB9U+hjgOqmw519puF4KKvPDNiS7XCPO6sT6+h6eYbF2RYfs
         u5u6Yvh+TTpfkDB9DuAnevZzNOMYjxa3tcvg2WJ7RftdypJmxKmL0/q+EuMtkhws4t
         p0OEkGxS0HAtSAN8R/Dz/MDUpqYWLcAzoGZqrZYwl2bjqN7eyDKTanhrwHKnKT08HJ
         IxEM776kZn2mIUKtBQnb7aT+f8IuCDrs5Bnl+QdNS/JFuToTb74TOSrX8+S6RpWYT0
         GjXi+znPgrDUw==
Date:   Tue, 20 Sep 2022 13:41:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH net-next V2 00/10] mlx5 MACSec Extended packet number
 and replay window offload
Message-ID: <20220920134120.2abbd3f5@kernel.org>
In-Reply-To: <20220914162713.203571-1-saeed@kernel.org>
References: <20220914162713.203571-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Sep 2022 17:27:03 +0100 Saeed Mahameed wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> v1->v2:
>   - Fix 32bit build isse
>   - Replay protection can work without EPN being enabled so moved the code out
>     of the EPN enabled check 

Does not apply, I think it's because of the bot-based fixups
which I merged out of order. Please respin, sorry about that.

> This is a follow up series to the previously submitted mlx5 MACsec offload [1]
> earlier this release cycle.

> [1] https://lwn.net/Articles/907262/ 

nit: prefer lore links
