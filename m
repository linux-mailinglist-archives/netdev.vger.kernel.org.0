Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43133508B43
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 16:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379796AbiDTO6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 10:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379824AbiDTO57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 10:57:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FE561F60E
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 07:55:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16296B81FB6
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 14:55:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D0CC385A1;
        Wed, 20 Apr 2022 14:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650466510;
        bh=Era6DGb22Pb4spzPvahyzs4k/rjS5Izu1SsYYTu21Uc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=sz0sAU1jmCJs4N4BJ96iNMnOW+Yp+KtlJIM1riXSRQk15hD0wCSne0ejNI096BSYs
         AWa8v8LJm3p8ER2KKL6KREwPheDFnbqlwd77iGuMqnmutWqyKD1kfPFR8fZL6PXNBV
         oA+Jcm9781HZCQZsHCjiPRnIty4Ef/MJLQtrIkJILyQ79j3LVnERoKQZLglWBzSbM7
         o2uM2gdGnHEJJ3FtN6S93TSVrMGJ9WsgXdqNrNgclPhVVjM92Xll3gKc6Rf++Bp0tY
         fAzjmYejuHFvRuRl3mkPyjXIQBXclAL4YVjTe7IfR/LNXYmJMZK3Z16UMg8smraLh8
         T0Nruk2lo74Fw==
Message-ID: <9e1bd74d-c0b5-77f6-2005-d2f1c548d901@kernel.org>
Date:   Wed, 20 Apr 2022 08:55:09 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [PATCH net-next 1/2] ipv6: Remove __ipv6_only_sock().
Content-Language: en-US
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org
References: <20220420015851.50237-1-kuniyu@amazon.co.jp>
 <20220420015851.50237-2-kuniyu@amazon.co.jp>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220420015851.50237-2-kuniyu@amazon.co.jp>
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
> Since commit 9fe516ba3fb2 ("inet: move ipv6only in sock_common"),
> ipv6_only_sock() and __ipv6_only_sock() are the same macro.  Let's
> remove the one.
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> ---
>  include/linux/ipv6.h | 4 +---
>  net/dccp/ipv6.c      | 2 +-
>  net/ipv6/datagram.c  | 4 ++--
>  net/ipv6/tcp_ipv6.c  | 2 +-
>  net/ipv6/udp.c       | 4 ++--
>  net/sctp/ipv6.c      | 4 ++--
>  6 files changed, 9 insertions(+), 11 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>
