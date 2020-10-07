Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16764286218
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 17:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728725AbgJGPZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 11:25:53 -0400
Received: from sitav-80046.hsr.ch ([152.96.80.46]:41520 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727234AbgJGPZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 11:25:49 -0400
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Oct 2020 11:25:48 EDT
Received: from [152.96.214.125] (unknown [152.96.214.125])
        by mail.strongswan.org (Postfix) with ESMTPSA id D343B40BEB;
        Wed,  7 Oct 2020 17:20:41 +0200 (CEST)
Subject: Re: [PATCH net] ipv4: Update exception handling for multipath routes
 via same device
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Kfir Itzhak <mastertheknife@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Paul Wouters <paul@nohats.ca>
References: <20200915030354.38468-1-dsahern@kernel.org>
From:   Tobias Brunner <tobias@strongswan.org>
Autocrypt: addr=tobias@strongswan.org; prefer-encrypt=mutual; keydata=
 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
Message-ID: <ab7d89d4-b673-93d6-0497-f64250c7204f@strongswan.org>
Date:   Wed, 7 Oct 2020 17:20:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200915030354.38468-1-dsahern@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

> @@ -2668,8 +2673,6 @@ struct rtable *ip_route_output_key_hash_rcu(struct net *net, struct flowi4 *fl4,
>  	fib_select_path(net, res, fl4, skb);
>  
>  	dev_out = FIB_RES_DEV(*res);
> -	fl4->flowi4_oif = dev_out->ifindex;
> -
>  
>  make_route:
>  	rth = __mkroute_output(res, fl4, orig_oif, dev_out, flags);

This breaks some IPsec scenarios with interfaces in IPsec policies, an
example can be found under [1], where host moon configures policies with
eth0 as interface.  Without this assignment, however, packets don't
match these policies anymore and are sent unprotected (or won't get
blocked by the drop policy).

Regards,
Tobias

[1] https://www.strongswan.org/testing/testresults/swanctl/manual-prio/
