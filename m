Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAEA656AA4
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 15:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727731AbfFZNeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 09:34:01 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:56010 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726484AbfFZNeB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 09:34:01 -0400
Received: by mail-wm1-f66.google.com with SMTP id a15so2130609wmj.5
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 06:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ev15sczlTeApLgLJNvXvzVf0qw2Pty91hPjhKItTBP0=;
        b=SD0bngym3bw/1SzzzCogYAgfniEGNiom9PJvb87syMsfIIPK533BcYTWWiPSdyp1Os
         xMZ/T8wpzejTcbjp9etlFX4LxmkrUF6BykBD40hiTecmRp9yN4+WOw3T4OeetDHNDLyF
         9/10KunoDoYGFBs0P7fiJoClzX2r9wulU5eQjsvF7omAhG5FSu29wj6/O/BhbMpOcvYM
         wp40r/MCcelqzpuVfyrG47e5UJJvJwKlN3icPHn9N+OILaqrqAOhlwIzDAsW3pb+Na2P
         BD4gCbsuvq8FEIzbOgaiFbVXf59yJEjWYjBIK3g2FubEQ6r2T1Cbt9npMfolnqLSVY5c
         kYVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ev15sczlTeApLgLJNvXvzVf0qw2Pty91hPjhKItTBP0=;
        b=aYgqsj0ZgZOYDafHw+fCMmLQy1sHU6uH4IMMSX99ylhI4aDIjSMpGSVQWyy4SGCK2+
         vpezyUuh0FdRpXdNcGy92Ayis141QIvURR/E4e50csNDh72J4hxN9PCL5hLAbBJntDJp
         2++SKoVOB6xX6SzjFJNhTcA6zPMdpv0oKqUPqTm0BIUlid7tU/ZBLW7PJBMI2jgFi9xr
         gOhB1X4JAEL+W6hYUmHuxmr03vVBdIgLxjXo3+JB61bmZhmpeHHt4NX+Tkn1LKCD4FXN
         Vc5eEuYzuFtqqA/jbrk9ndsFvJVA3lO6JygI8+Eu5D46cX4sXf/FYzlUaWmc2zsQ/f0y
         eCUQ==
X-Gm-Message-State: APjAAAURJhGSVsWCeigv81n9txxqiCjIOCvGOpVCKc/5QqtdVwpijqeg
        SiAkSPkP1yF0sEABCAPhNQo=
X-Google-Smtp-Source: APXvYqxRPqW3WducSbJWJ4Myp5AHAJpRb/gUcCfCo9fd62jiTnld+e0ei70XlqKhbw5JOUHNbcjirw==
X-Received: by 2002:a1c:21c6:: with SMTP id h189mr2760915wmh.79.1561556038684;
        Wed, 26 Jun 2019 06:33:58 -0700 (PDT)
Received: from jimi ([176.230.77.167])
        by smtp.gmail.com with ESMTPSA id q12sm20556971wrp.50.2019.06.26.06.33.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 26 Jun 2019 06:33:58 -0700 (PDT)
Date:   Wed, 26 Jun 2019 16:33:53 +0300
From:   Eyal Birger <eyal.birger@gmail.com>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        pablo@netfilter.org, xiyou.wangcong@gmail.com, davem@davemloft.net,
        jiri@resnulli.us, jhs@mojatatu.com
Subject: Re: [PATCH net-next 2/5] net: sched: em_ipt: set the family based
 on the protocol when matching
Message-ID: <20190626163353.6d5535cb@jimi>
In-Reply-To: <20190626115855.13241-3-nikolay@cumulusnetworks.com>
References: <20190626115855.13241-1-nikolay@cumulusnetworks.com>
        <20190626115855.13241-3-nikolay@cumulusnetworks.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nikolay,
   
On Wed, 26 Jun 2019 14:58:52 +0300
Nikolay Aleksandrov <nikolay@cumulusnetworks.com> wrote:

> Set the family based on the protocol otherwise protocol-neutral
> matches will have wrong information (e.g. NFPROTO_UNSPEC). In
> preparation for using NFPROTO_UNSPEC xt matches.
> 
> Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> ---
>  net/sched/em_ipt.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/sched/em_ipt.c b/net/sched/em_ipt.c
> index 64dbafe4e94c..23965a071177 100644
> --- a/net/sched/em_ipt.c
> +++ b/net/sched/em_ipt.c
> @@ -189,10 +189,12 @@ static int em_ipt_match(struct sk_buff *skb,
> struct tcf_ematch *em, case htons(ETH_P_IP):
>  		if (!pskb_network_may_pull(skb, sizeof(struct
> iphdr))) return 0;
> +		state.pf = NFPROTO_IPV4;
>  		break;
>  	case htons(ETH_P_IPV6):
>  		if (!pskb_network_may_pull(skb, sizeof(struct
> ipv6hdr))) return 0;
> +		state.pf = NFPROTO_IPV6;
>  		break;
>  	default:
>  		return 0;
> @@ -203,7 +205,7 @@ static int em_ipt_match(struct sk_buff *skb,
> struct tcf_ematch *em, if (skb->skb_iif)
>  		indev = dev_get_by_index_rcu(em->net, skb->skb_iif);
>  
> -	nf_hook_state_init(&state, im->hook, im->match->family,
> +	nf_hook_state_init(&state, im->hook, state.pf,
>  			   indev ?: skb->dev, skb->dev, NULL,
> em->net, NULL); 
>  	acpar.match = im->match;

I think this change is incompatible with current behavior.

Consider the 'policy' match which matches the packet's xfrm state (sec_path)
with the provided user space parameters. The sec_path includes information
about the encapsulating packet's parameters whereas the current skb points to
the encapsulated packet, and the match is done on the encapsulating
packet's info.

So if you have an IPv6 packet encapsulated within an IPv4 packet, the match
parameters should be done using IPv4 parameters, not IPv6.

Maybe use the packet's family only if the match family is UNSPEC?

Eyal.
