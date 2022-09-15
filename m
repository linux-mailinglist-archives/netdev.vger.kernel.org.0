Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3E25B93EA
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 07:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbiIOFVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 01:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiIOFVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 01:21:32 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5727C79EC2;
        Wed, 14 Sep 2022 22:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1663219286;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=a0+G0qlSpn8buJvwIDlWKidBMJ657/oxcisbECuowPw=;
    b=Aw1jPz0b29Xi3jRkvNdpXASNH8TIrMmYFoJIsMZ97Igebp8JEgLnpTfbXz16PonLBJ
    ChrxDQqWjgnLbVfhnS8JXWRoMwvG4g8lxrwnGckKtSkOb/cu7hB8lwm5fzuQQbW4Guir
    OXYVCtUmG8fdDWCkpfL6UQSQTosfaN8+Ywk6GGk+5Av5F9T29D3Uax5Gr9kATA4V7v2r
    nUHddBRL4avgfeeVIKvdnDMyGpacT07aEhyrexv4sD8jI9vhltHgs7yWGUv+0ItEwiiL
    F0i3iBiinlfNnEmgEZ9/potNzX7XzPv5zC+Gg4B1i7600uFgmDZqvz0WEV+7LjXvTIg5
    gLjg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdIrpKytISr6hZqJAw=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cfd:d104::923]
    by smtp.strato.de (RZmta 48.1.0 AUTH)
    with ESMTPSA id d25a93y8F5LQBRK
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Thu, 15 Sep 2022 07:21:26 +0200 (CEST)
Message-ID: <2f30f0f3-aafc-6f15-b7e5-fa47595dcc63@hartkopp.net>
Date:   Thu, 15 Sep 2022 07:21:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v2 0/2] can: bcm: can: bcm: random optimizations
Content-Language: en-US
To:     Ziyang Xuan <william.xuanziyang@huawei.com>, mkl@pengutronix.de,
        davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <cover.1663206163.git.william.xuanziyang@huawei.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <cover.1663206163.git.william.xuanziyang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 15.09.22 03:55, Ziyang Xuan wrote:
> Do some small optimization for can_bcm.
> 
> ---
> v2:
>    - Continue to update currframe when can_send() failed in patch 2.
>    - Remove ‘Fixes’ tag in patch 2.

For this series:

Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>

Many Thanks!

> 
> Ziyang Xuan (2):
>    can: bcm: registration process optimization in bcm_module_init()
>    can: bcm: check the result of can_send() in bcm_can_tx()
> 
>   net/can/bcm.c | 25 +++++++++++++++++++------
>   1 file changed, 19 insertions(+), 6 deletions(-)
> 
