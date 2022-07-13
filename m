Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E972573F97
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 00:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbiGMW0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 18:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbiGMW0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 18:26:43 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 209294D16E;
        Wed, 13 Jul 2022 15:26:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 83F3BCE240C;
        Wed, 13 Jul 2022 22:26:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7B82C3411E;
        Wed, 13 Jul 2022 22:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657751198;
        bh=MNNSohJKOzjeKAMJfCPtmJjjR5KPf4n5+S8FRnHc6d4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gnT3Lemt2fw4JP9Fgiq4qHrHJvU/J/eh05TSTgMv8uPaqFn0qyLYED2iS8GryLnRs
         lkfGGU50eKmr/GTqSbGK5C49rNU8Q41KvLxSqTQOt80BYUs8TxJoIva3ua7/fQ6Ck7
         o8crxVNw7PBjjTgPxodV1CerrfKtMzb6avmlJ0X2gnp5GGy989GhQj9kQCspf255CA
         XWzoP2J4Zqn1uUG1KggmNnoiFJewyzFk/s+mJZQxIxuXB12Twr0BgNg/xtZrdOnbPp
         hCAWprylPN7cwQYM537j1fC1uAUxxvrZn+9pZHbAW5iU/y3gerdm+PM9yNI8L4Y0In
         tkBRmGgWef31Q==
Date:   Wed, 13 Jul 2022 15:26:38 -0700
From:   Saeed Mahameed <saeed@kernel.org>
To:     Rustam Subkhankulov <subkhankulov@ispras.ru>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maor Gottlieb <maorg@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: Re: [PATCH] net/mlx5e: Removed useless code in function
Message-ID: <20220713222638.nej53m5owfkr6dzz@sx1>
References: <20220711093303.14511-1-subkhankulov@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220711093303.14511-1-subkhankulov@ispras.ru>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11 Jul 12:33, Rustam Subkhankulov wrote:
>Comparison of eth_ft->ft with NULL is useless, because
>get_flow_table() returns either pointer 'eth_ft'
>such that eth_ft->ft != NULL, or an erroneous value that is
>handled on return, causing mlx5e_ethtool_flow_replace()
>to terminate before checking whether eth_ft->ft equals NULL.
>
>Found by Linux Verification Center (linuxtesting.org) with SVACE.
>
>Signed-off-by: Rustam Subkhankulov <subkhankulov@ispras.ru>
>Fixes: 6dc6071cfcde ("net/mlx5e: Add ethtool flow steering support")

Applied to net-next-mlx5 and removed the fixes tag. Since there is no bug
here.

Thanks,
Saeed.

