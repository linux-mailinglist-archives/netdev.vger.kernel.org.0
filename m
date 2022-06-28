Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C934855E945
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347750AbiF1PEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 11:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347720AbiF1PEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 11:04:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29EB91D301;
        Tue, 28 Jun 2022 08:04:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2CC2B81E39;
        Tue, 28 Jun 2022 15:04:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F5CFC3411D;
        Tue, 28 Jun 2022 15:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656428686;
        bh=ENgejiw+sgjk1N/1PkHBRhDYnDtcy5LgtLT6/pcL9XY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=UDGL8Qieu0VRAUh2s/g6/HiBTtvuzwhPkwtmcs4kHRCf1smoNrrqiZtbsGG4AFrxX
         neBuBEhnWXf9WhUNNSlOX2F6+YVBoLYclb8tO/s/E39ava4dXeRqSzjq7BYk7JrM+F
         bn4t/cEtK+djEniP4h6ZJlcmP0JvXUadmBvTlZYSDBBYysDQXbWyBrTJDnCiqdQ16n
         8MhfcECywObJV14zwWVWutmWlI0lkpWnrGdDyWW1B3NPKE2oeNqDyg3K6S1JvYSmnY
         TYBHiOXBbFezIO0IH4110YIbwgLXCsbl8baEeGkvwVnFVp1KSukdPfawmEEBTktKzL
         UBszwnFWdOPPQ==
Message-ID: <002f8deb-f664-cc1b-53e6-b4297c8c6b49@kernel.org>
Date:   Tue, 28 Jun 2022 09:04:42 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [PATCH] ipv6: remove redundant store to value after addition
Content-Language: en-US
To:     Colin Ian King <colin.i.king@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220628145406.183527-1-colin.i.king@gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220628145406.183527-1-colin.i.king@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/28/22 8:54 AM, Colin Ian King wrote:
> There is no need to store the result of the addition back to variable count
> after the addition. The store is redundant, replace += with just +
> 
> Cleans up clang scan build warning:
> warning: Although the value stored to 'count' is used in the enclosing
> expression, the value is never actually read from 'count'
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  net/ipv6/route.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

