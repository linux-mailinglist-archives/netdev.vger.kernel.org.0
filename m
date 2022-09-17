Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D08835BB940
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 18:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiIQQHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Sep 2022 12:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiIQQHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Sep 2022 12:07:32 -0400
Received: from smtp.smtpout.orange.fr (smtp-16.smtpout.orange.fr [80.12.242.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 815002AC5F
        for <netdev@vger.kernel.org>; Sat, 17 Sep 2022 09:07:26 -0700 (PDT)
Received: from [192.168.1.18] ([90.11.190.129])
        by smtp.orange.fr with ESMTPA
        id ZaLhoismi94emZaLhoujzK; Sat, 17 Sep 2022 18:07:24 +0200
X-ME-Helo: [192.168.1.18]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 17 Sep 2022 18:07:24 +0200
X-ME-IP: 90.11.190.129
Message-ID: <70a79b03-c691-3376-e88c-fd742d3e41d7@wanadoo.fr>
Date:   Sat, 17 Sep 2022 18:07:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH -next] nexthop: simplify code in nh_valid_get_bucket_req
Content-Language: en-GB
To:     williamsukatube@163.com, dsahern@kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220917063031.2172-1-williamsukatube@163.com>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <20220917063031.2172-1-williamsukatube@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 17/09/2022 à 08:30, williamsukatube@163.com a écrit :
> From: William Dean <williamsukatube@163.com>
> 
> It could directly return 'nh_valid_get_bucket_req_res_bucket' to simplify code.
> 
> Signed-off-by: William Dean <williamsukatube@163.com>
> ---
>   net/ipv4/nexthop.c | 6 +-----
>   1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
> index 853a75a8fbaf..1556961cf153 100644
> --- a/net/ipv4/nexthop.c
> +++ b/net/ipv4/nexthop.c
> @@ -3489,12 +3489,8 @@ static int nh_valid_get_bucket_req(const struct nlmsghdr *nlh,
>   		return -EINVAL;
>   	}
> 
> -	err = nh_valid_get_bucket_req_res_bucket(tb[NHA_RES_BUCKET],
> +	return nh_valid_get_bucket_req_res_bucket(tb[NHA_RES_BUCKET],
>   						 bucket_index, extack);

Nit: there should be 1 additional space to keep alignment.

CJ

> -	if (err)
> -		return err;
> -
> -	return 0;
>   }
> 
>   /* rtnl */


