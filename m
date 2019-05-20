Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC6523DE8
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 18:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390002AbfETQ6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 12:58:08 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34034 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388204AbfETQ6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 12:58:07 -0400
Received: by mail-pg1-f195.google.com with SMTP id c13so7076900pgt.1
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 09:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=QkODJEttn5U4TiN+Jib+y6Ur/e6sPblJJkX63+IVXiQ=;
        b=sSyVttRxBNaAF2DW1T32Ps+2Iv+PxLQjiLidFh1l01mAeedKMArmZvKVSxFOhipVoY
         3B4Wywe5VoeElqx8D05f5uiIhpa7YbHSrstexxaoqeMV0g+WbtL7qqnaIR20ruZd1kir
         hF5MspVgl6L1MLFP52n/kZ+p6JgVO+3GEB6Q+O1lmkLa+SaV+02AKrwpAwUmrC6wPxhL
         NvrAzinNrDgCggqrXQo0IoRr8CQqzpJjlQX4abt753EF3HXNWBZIvxchc/V0iJK9pfpj
         +8Org28btTWfMs5dyB88KSUT4joVpOduB837yt0DUgvbLNsEYRzHGbJaBfJRy9JVMyC1
         3KKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QkODJEttn5U4TiN+Jib+y6Ur/e6sPblJJkX63+IVXiQ=;
        b=ls0fuki643zluRsxCulJvtS21IZVcvblpOBO1x6giD6Aquzcc2BLpchYUUdCXon1Ni
         /W6EoIBoO+fwg45t7YWOmDjWj4Fl62JErBOWmSY9+DBWWyrn+JcPlMI+hDRdEOBj+Fd1
         WF5Hp5e5hDX2MV4yd3rSv1Me5DmT8t7Pp4yfvnPU+f0st6J+AIhfUR8/MfP1cpjhXiqb
         HgfnB5BxjramHE0Yu/gWCr9QXFb1OfJ5nL4xuFKK1RjZpurE6D9eylocdLfkozucI6Eb
         Lu2yqj+z2E/s+bH4TiGURhn68r3gv1eMVnFNUwkRlRbWsEsoWq0IGUA1Rbka0vTJjRBK
         dH0g==
X-Gm-Message-State: APjAAAUlUx2PuinbIdyQIGnCBbKC54On9FQNzDcJDRq2kR/3JAHRksDk
        nmPM1aHU454+qmdqd0GI5fXNcTzR
X-Google-Smtp-Source: APXvYqxTEWVIPZ72UakUTTxLktsU7orh2lE3y9Xt3Uwb9J+cP7Cfjn9MedGYhbVygGEqyhM62wHKOQ==
X-Received: by 2002:a63:7c55:: with SMTP id l21mr52047689pgn.121.1558371486963;
        Mon, 20 May 2019 09:58:06 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:4813:9811:27e6:a3ed? ([2601:282:800:fd80:4813:9811:27e6:a3ed])
        by smtp.googlemail.com with ESMTPSA id i12sm22373216pfd.33.2019.05.20.09.58.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 09:58:05 -0700 (PDT)
Subject: Re: [PATCH net] net/ipv6: Reinstate ping/traceroute use with source
 address in VRF
To:     Mike Manning <mmanning@vyatta.att-mail.com>, netdev@vger.kernel.org
References: <20190520084041.10393-1-mmanning@vyatta.att-mail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1d14e6d9-5cac-064d-aa4e-bad667516c75@gmail.com>
Date:   Mon, 20 May 2019 10:58:04 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190520084041.10393-1-mmanning@vyatta.att-mail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/20/19 2:40 AM, Mike Manning wrote:
> Since the commit 1893ff20275b ("net/ipv6: Add l3mdev check to
> ipv6_chk_addr_and_flags"), traceroute using TCP SYN or ICMP ECHO option
> and ping fail when specifying a source address typically on a loopback
> /dummy interface in the same VRF, e.g.:
> 
>     # ip vrf exec vrfgreen ping 3000::1 -I 2222::2
>     ping: bind icmp socket: Cannot assign requested address
>     # ip vrf exec vrfgreen traceroute 3000::1 -s 2222::2 -T
>     bind: Cannot assign requested address
> 
> IPv6 traceroute using default UDP and IPv4 ping & traceroute continue
> to work inside a VRF using a source address.
> 
> The reason is that the source address is provided via bind without a
> device given by these applications in this case. The call to
> ipv6_check_addr() in rawv6_bind() returns false as the default VRF is
> assumed if no dev was given, but the src addr is in a non-default VRF.
> 
> The solution is to check that the address exists in the L3 domain that
> the dev is part of only if the dev has been specified.
> 
> Signed-off-by: Mike Manning <mmanning@vyatta.att-mail.com>
> ---
>  net/ipv6/addrconf.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> index f96d1de79509..3963306ec27f 100644
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c
> @@ -1908,6 +1908,7 @@ int ipv6_chk_addr_and_flags(struct net *net, const struct in6_addr *addr,
>  			    int strict, u32 banned_flags)
>  {
>  	unsigned int hash = inet6_addr_hash(net, addr);
> +	const struct net_device *orig_dev = dev;
>  	const struct net_device *l3mdev;
>  	struct inet6_ifaddr *ifp;
>  	u32 ifp_flags;
> @@ -1922,7 +1923,7 @@ int ipv6_chk_addr_and_flags(struct net *net, const struct in6_addr *addr,
>  		if (!net_eq(dev_net(ifp->idev->dev), net))
>  			continue;
>  
> -		if (l3mdev_master_dev_rcu(ifp->idev->dev) != l3mdev)
> +		if (orig_dev && l3mdev_master_dev_rcu(ifp->idev->dev) != l3mdev)
>  			continue;
>  
>  		/* Decouple optimistic from tentative for evaluation here.
> 

Wrong fix. When looking up the address you have to give the L3 domain of
interest.

This change:

diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 84dbe21b71e5..96a3559f2a09 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -287,7 +287,9 @@ static int rawv6_bind(struct sock *sk, struct
sockaddr *uaddr, int addr_len)
                        /* Binding to link-local address requires an
interface */
                        if (!sk->sk_bound_dev_if)
                                goto out_unlock;
+               }

+               if (sk->sk_bound_dev_if) {
                        err = -ENODEV;
                        dev = dev_get_by_index_rcu(sock_net(sk),
                                                   sk->sk_bound_dev_if);

make raw binds similar to tcp. See:

c5ee066333ebc ("ipv6: Consider sk_bound_dev_if when binding a socket to
an address")
ec90ad334986f ("ipv6: Consider sk_bound_dev_if when binding a socket to
a v4 mapped address")
