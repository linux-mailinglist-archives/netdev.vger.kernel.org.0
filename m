Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B66AC5EF961
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 17:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235517AbiI2PpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 11:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235670AbiI2Poi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 11:44:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D22182A72B
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 08:43:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FE28618D7
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 15:43:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F00EC433D7;
        Thu, 29 Sep 2022 15:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664466231;
        bh=2ioRZatWUJGfkBU8cGzudfPcwvLXOSDvHfrZS/JrQOA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=llOLamkYMQO00cO3RQYyPjxuXAEOhEMucYMZ0y1nSvD2dKqz/9TUqFKVzzsZiwQnC
         7e7vhqc2NV5jhUzY1TNva3VVcnTJ6AXotHUtf6KnD4sMwSFFNtOiMh19nYkigrDwkx
         GQ7x4pZrwRJEmwl+apTHDmEWgPpe3wHK2A/sTIfdm2hQqbBKywOCZ1wgLwpc0QceUt
         EAJeuIAKhjKOiT3YMyGx92oNk+TRIFbon9+AlHLPQXrOpa6VTjpY3V5qwhgaIjSV+W
         H1+t/+rz41uQmbs/PQCHkz6k2d6UQyrZOsFwG0oBYDoxlifV8nKjue+Ff7B3QsmIwa
         1XVTTlXtuwxHA==
Date:   Thu, 29 Sep 2022 08:43:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH net-next 00/16] mlx5 xsk updates part2 2022-09-28
Message-ID: <20220929084350.62b953c5@kernel.org>
In-Reply-To: <20220929072156.93299-1-saeed@kernel.org>
References: <20220929072156.93299-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Sep 2022 00:21:40 -0700 Saeed Mahameed wrote:
> XSK buffer improvements, This is part #2 of 4 parts series.
> 
>  1) Expose xsk min chunk size to drivers, to allow the driver to adjust to a
>    better buffer stride size
> 
>  2) Adjust MTT page size to the XSK frame size, to avoid umem overrun in
>   certain situations.
> 
>  3) Use xsk frame size as the striding RQ page size for XSK RQs
> 
>  4) KSM for unaligned XSK, KSM allows arbitrary buffer chunk lengths
>     registration in HW, which makes more sense for unaligned XSK.
> 
>  4) More cleanups and optimizations in preparation for next improvements
>     in part3
> 
> part 1: https://lore.kernel.org/netdev/20220927203611.244301-1-saeed@kernel.org/

LGTM
