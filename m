Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCFE508B50
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 16:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379851AbiDTO7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 10:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236824AbiDTO7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 10:59:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD3AA3BFA4
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 07:56:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F82DB81FC0
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 14:56:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E99BBC385A1;
        Wed, 20 Apr 2022 14:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650466606;
        bh=nGwfE7j88MZ4Otr9MOW1yAsIDbek6Q56ZPYFi/pU2vA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=P6Ivf1rR3R8kKivh1nrquTvR988hPInXlgChSqUk+nXI2foYn3+1A0IUwfbRkCr7Q
         FIm7VV2nbsOPpixSgAwdwb1JTN+6UeNBlpRJzDbq8YZo48uFEy0/Rr81m6OaSyLmaN
         wFn1tZCA9I5HPV/q+EMnfBUz218/YSvzmPbGh4Ea+Xn0XQvHRcfNCodl1apfex5TYl
         46dSzbl8rU+I9tqljNVnkCzHw4u636XXYmpVIRwXW11xyMV/fq6qrJ4F0ABifV8pGb
         2gcf7aNLn9UqG/VGTTDVA7aclL75f7ltEQ9VKBPFtx2ZP5f8nmlgUuolqmc80OB0vF
         d/tkwM7eyuwMQ==
Message-ID: <e4b167d4-4e3e-725d-3252-57641cb60b71@kernel.org>
Date:   Wed, 20 Apr 2022 08:56:45 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [PATCH net-next 2/2] ipv6: Use ipv6_only_sock() helper in
 condition.
Content-Language: en-US
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org
References: <20220420015851.50237-1-kuniyu@amazon.co.jp>
 <20220420015851.50237-3-kuniyu@amazon.co.jp>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220420015851.50237-3-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-11.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/19/22 7:58 PM, Kuniyuki Iwashima wrote:
> This patch replaces some sk_ipv6only tests with ipv6_only_sock().
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> ---
>  drivers/net/bonding/bond_main.c                                | 2 +-
>  drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c | 2 +-
>  drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c      | 2 +-
>  drivers/net/ethernet/netronome/nfp/crypto/tls.c                | 2 +-
>  net/core/filter.c                                              | 2 +-
>  net/ipv6/af_inet6.c                                            | 2 +-
>  6 files changed, 6 insertions(+), 6 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>
