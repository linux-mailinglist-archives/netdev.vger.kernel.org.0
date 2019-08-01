Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 674737DE9A
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 17:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731129AbfHAPQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 11:16:28 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42887 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729812AbfHAPQ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 11:16:28 -0400
Received: by mail-pf1-f193.google.com with SMTP id q10so34237672pff.9
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 08:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ktOjTolCX0/cq35DDrCOuasG6WIhz9NP5X6Q9aR6Jks=;
        b=iQuAmAe3OFMmSnmhUa/2nX3HCNq1DomcjwaSOr1HB04sc8l0VhLbk/8YoXhi2zrymL
         SToTedeB73u8a6EqtorOOdCjt0pkV9hf5x4HfaFukUdRkYTJuuoYxvic5PKoEeUvzS7u
         Z1D6V944NKdVxkaaun/jxkuBpXmR0FT3ermDSM4oDdVtUXI38kiUVYS+7S3jXWdyrvxU
         6EIGmbu1ahA38PkQTMWgAqODlG4iBLk7DcJQ8fhplin/TgjnU2AVy3i5fwDBrU1YBL2T
         cyyoh5JoiPvZbnJEcMkpxv8da4eHgi/9u5sBGByOdRm/XMmE187VmEMeYsF0KWKodLca
         Aikw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ktOjTolCX0/cq35DDrCOuasG6WIhz9NP5X6Q9aR6Jks=;
        b=UvtNRgnPg7Gh7md8DsjMqgKIUC2o+c4iqtUrL/JW4EFKOPqCbpGniXIT0wfGl86/zZ
         /unMvFGkwcibVoYP+Q6VULNxzo6AWScJrRqBftodJTO2zzd3Gh4+5wPNyHj85O2LwV8d
         AjZFBicWDhFwi8ouGyvOlxm4Q09u8L9iT8Oa9cUrGIlQw+uyQ909kQEfYKhlWK/+ADEh
         dqwxj/3UeA5wy6DnVuQruzKjaQGlq+0jbc9Zhdp+fsArAm6GTW46jzF5xnKbpZF5wf7c
         jlKdhvisxAYTyqn5I3X8fc0RKkThqiOGORI4H7q/+4J70HHo9qjyPx+I4zN7/Na6eaTv
         n5NA==
X-Gm-Message-State: APjAAAUIJtrFShcgq/siVTUGVYNnChDXAAwL9yYr5tHJoRZpqPOHM2pA
        aZd9tSHyhty6bgDa2RPJ6/0x/kox
X-Google-Smtp-Source: APXvYqy3S4KSsYgRPfo3A9M2zL+AqDu5n3URNj8Ygzf+4qIekU++SCkYJX2upGD9nTo+TOroClW/qw==
X-Received: by 2002:a17:90a:8c06:: with SMTP id a6mr9481346pjo.45.1564672587513;
        Thu, 01 Aug 2019 08:16:27 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id u1sm68469662pgi.28.2019.08.01.08.16.27
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 08:16:27 -0700 (PDT)
Date:   Thu, 1 Aug 2019 08:16:20 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, dsahern@kernel.org
Subject: Re: [PATCH iproute2-next] ip tunnel: add json output
Message-ID: <20190801081620.6b25d23c@hermes.lan>
In-Reply-To: <7090709d3ddace589952a128fb62f6603e2da9e8.1564653511.git.aclaudi@redhat.com>
References: <7090709d3ddace589952a128fb62f6603e2da9e8.1564653511.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  1 Aug 2019 12:12:58 +0200
Andrea Claudi <aclaudi@redhat.com> wrote:

> Add json support on iptunnel and ip6tunnel.
> The plain text output format should remain the same.
> 
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> ---
>  ip/ip6tunnel.c | 82 +++++++++++++++++++++++++++++++--------------
>  ip/iptunnel.c  | 90 +++++++++++++++++++++++++++++++++-----------------
>  ip/tunnel.c    | 42 +++++++++++++++++------
>  3 files changed, 148 insertions(+), 66 deletions(-)
> 
> diff --git a/ip/ip6tunnel.c b/ip/ip6tunnel.c
> index d7684a673fdc4..f2b9710c1320f 100644
> --- a/ip/ip6tunnel.c
> +++ b/ip/ip6tunnel.c
> @@ -71,57 +71,90 @@ static void usage(void)
>  static void print_tunnel(const void *t)
>  {
>  	const struct ip6_tnl_parm2 *p = t;
> -	char s1[1024];
> -	char s2[1024];
> +	SPRINT_BUF(b1);
>  
>  	/* Do not use format_host() for local addr,
>  	 * symbolic name will not be useful.
>  	 */
> -	printf("%s: %s/ipv6 remote %s local %s",
> -	       p->name,
> -	       tnl_strproto(p->proto),
> -	       format_host_r(AF_INET6, 16, &p->raddr, s1, sizeof(s1)),
> -	       rt_addr_n2a_r(AF_INET6, 16, &p->laddr, s2, sizeof(s2)));
> +	open_json_object(NULL);
> +	print_string(PRINT_ANY, "ifname", "%s: ", p->name);

Print this using color for interface name?


> +	snprintf(b1, sizeof(b1), "%s/ipv6", tnl_strproto(p->proto));
> +	print_string(PRINT_ANY, "mode", "%s ", b1);
> +	print_string(PRINT_ANY,
> +		     "remote",
> +		     "remote %s ",
> +		     format_host_r(AF_INET6, 16, &p->raddr, b1, sizeof(b1)));
> +	print_string(PRINT_ANY,
> +		     "local",
> +		     "local %s",
> +		     rt_addr_n2a_r(AF_INET6, 16, &p->laddr, b1, sizeof(b1)));
> +
>  	if (p->link) {
>  		const char *n = ll_index_to_name(p->link);
>  
>  		if (n)
> -			printf(" dev %s", n);
> +			print_string(PRINT_ANY, "link", " dev %s", n);
>  	}
>  
>  	if (p->flags & IP6_TNL_F_IGN_ENCAP_LIMIT)
> -		printf(" encaplimit none");
> +		print_bool(PRINT_ANY,
> +			   "ip6_tnl_f_ign_encap_limit",
> +			   " encaplimit none",
> +			   true);

For flags like this, print_null is more typical JSON than a boolean
value. Null is better for presence flag. Bool is better if both true and
false are printed.
