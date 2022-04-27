Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 519615124DB
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 23:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235160AbiD0WAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 18:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237750AbiD0WA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 18:00:29 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C5FD116C
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 14:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=eCju4//7j32RLgojrAV7AzFnehTLEosjViFNjaYFxJA=; b=cPgytBH93sOtCvDS65FEwRabXb
        YRCUB5+xPwYsnIFrKUcZxNHdKOnIp96JMLalu58M2rDhumq5ZJdsIRemIAlPGejUDhq2P6CFHwyNh
        YW3G4iEgwfK/SqgjU0ByPaVl7rwSerqsChFLlaB0ILGMMK3jJt9ZtpZoto7tJrVztgerUPqaHnaur
        91Tzbf5BX6zDwHajm2qMuYIu5F79+IVLde7+EPb3NxifJjh67RDnI3BGiKn6TTWVPGhFju4araZ2B
        kqTy4AFNeNaz0MzlvBWWpJSjR63lOYebgSZev81eXtD1xZ2frmzZKgnDT9ruSgfr7WTWgkchU6+m0
        rLkso31A==;
Received: from [2602:306:c5a2:a380:b27b:25ff:fe2c:51a8]
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1njpeX-009AoX-E8; Wed, 27 Apr 2022 21:56:53 +0000
Message-ID: <5892767a-bbab-097b-2776-e4cd35abf289@infradead.org>
Date:   Wed, 27 Apr 2022 14:56:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next 13/14] eth: spider: remove a copy of the
 NAPI_POLL_WEIGHT define
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, kou.ishizaki@toshiba.co.jp,
        linuxppc-dev@lists.ozlabs.org
References: <20220427154111.529975-1-kuba@kernel.org>
 <20220427154111.529975-14-kuba@kernel.org>
From:   Geoff Levand <geoff@infradead.org>
In-Reply-To: <20220427154111.529975-14-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On 4/27/22 08:41, Jakub Kicinski wrote:
> Defining local versions of NAPI_POLL_WEIGHT with the same
> values in the drivers just makes refactoring harder.

> --- a/drivers/net/ethernet/toshiba/spider_net.c
> +++ b/drivers/net/ethernet/toshiba/spider_net.c
>  
>  	netif_napi_add(netdev, &card->napi,
> -		       spider_net_poll, SPIDER_NET_NAPI_WEIGHT);
> +		       spider_net_poll, NAPI_POLL_WEIGHT);

This seems fine. Both SPIDER_NET_NAPI_WEIGHT and NAPI_POLL_WEIGHT
are defined as 64.  Thanks for your contribution.

Acked-by: Geoff Levand <geoff@infradead.org>
