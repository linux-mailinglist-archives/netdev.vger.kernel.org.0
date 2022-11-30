Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77E7763CE53
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 05:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232960AbiK3EUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 23:20:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232859AbiK3EUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 23:20:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E1396A76C;
        Tue, 29 Nov 2022 20:20:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FBC1619EC;
        Wed, 30 Nov 2022 04:20:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD11FC433C1;
        Wed, 30 Nov 2022 04:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669782034;
        bh=rhxe2NS1qMj88hLzeSaLLkIURFc6ENsFHmlnswfI07c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UanXum1bVt5dtWMfNwDK1Ip3MfLXPPCVi9tsG5FYKH1kLlCT4n7WGDOFd8i0weg0R
         mPSG1iGO0XGTi6NAirfNcf3aprB+5+TBWHXCPFyyvRlHY0Kb4OXexEe2/P1W3nHiM8
         YIhP1PTIcYaBd/OAjlvzw6U3WrzFoNsFv7BzcizDT7/gvTIPNGUDZNn6KvQwZ9mNLy
         9WKjFSXncJShNhwBgvtO3Jhm3sq3Rh1M0P6Ygs6M0c6y1O6KdyfmnrxbFrinOgclm2
         z5qfwJTzAIGc12/F0b9uLAlg1VVZYCZhSgTsNTFuGWJgEzYZFnEZPNfxMJNjy4bB+k
         +SP+bV8J6wqhw==
Date:   Tue, 29 Nov 2022 20:20:32 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Pavan Chebbi <pavan.chebbi@broadcom.com>
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH] net/mlx5e: Remove unneeded io-mapping.h #include
Message-ID: <Y4baEGvozPhBlUZw@fedora>
References: <7779439b2678fffe7d3e4e0d94bbb1b1eb850f5e.1669565797.git.christophe.jaillet@wanadoo.fr>
 <CALs4sv1x5kqHVu=q=kifSPXc=yhobowRvQhjkhG-3UwW2ZzbPg@mail.gmail.com>
 <CALs4sv24PiCW_9svBCLF8W+rkb=w90fBCEYOuFAkozXUQu_kLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CALs4sv24PiCW_9svBCLF8W+rkb=w90fBCEYOuFAkozXUQu_kLQ@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28 Nov 10:27, Pavan Chebbi wrote:
>Though I think having the target tree specified conventionally in the
>subject line [PATCH net] would be more complying with the process.

For such cleanup patches I think [PATCH net-next] is better.

[...]

>>
>> Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>

Thanks you Pavan & Christophe
applied to net-next-mlx5 will be sent to net-next shortly 

