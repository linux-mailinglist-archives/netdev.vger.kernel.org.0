Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7308254BF8D
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 04:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231710AbiFOCDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 22:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345651AbiFOCDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 22:03:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE51C42A25;
        Tue, 14 Jun 2022 19:03:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E21E619DD;
        Wed, 15 Jun 2022 02:03:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42144C3411B;
        Wed, 15 Jun 2022 02:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655258598;
        bh=ooQ+boKyWBcdibdOBlQX3Vvw/fy9lQQdF+1pOlITJdE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SfPGWYe/7kSQuIE28xE5KKktHR2JF+mggTTSQmQkNqlbmEN3yUWUdqe1Hn/iJa6kF
         z/regpz64z8ar5hqFMnRDDpT+gSBr1+i9IDkvXN1trDmsGoliRU5MbQJl4RtWkTOeJ
         kixxNwRfxQccJf/ZgKYq5KPLtbqU4sNtPkqJM1IeHYUKEu4Cr2InWGPz2IWvKz3I+w
         WEnvJ4ooeYrIjItguxUPSUA67wPnRRKcWcC1R7sQASG1jBWiC2YCsXWyGwOXaidiDl
         ZZxPpDdDD76OBuZhJU2B6Z4sK+Zqnk1lLdULpdqFvWLKq+Jtoik3b7CT/52879vF+O
         PdSdSLaxHYeMw==
Date:   Tue, 14 Jun 2022 19:03:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [GIT PULL][next-next][rdma-next] mlx5-next: updates 2022-06-14
Message-ID: <20220614190317.7c87d0d5@kernel.org>
In-Reply-To: <20220614184339.ywrfx6zgxs6bo4mg@sx1>
References: <20220614184028.51548-1-saeed@kernel.org>
        <20220614184339.ywrfx6zgxs6bo4mg@sx1>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Jun 2022 11:43:39 -0700 Saeed Mahameed wrote:
> s/next-next/net-next
> 
> net-next patchwork bots won't see this one :/ .. should I re-post ? 

Looks like it's in, I'll pull shortly.
