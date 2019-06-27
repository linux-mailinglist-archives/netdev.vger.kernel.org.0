Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5A7A58699
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 18:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbfF0QCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 12:02:47 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37756 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfF0QCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 12:02:46 -0400
Received: by mail-wm1-f66.google.com with SMTP id f17so6212577wme.2
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 09:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DfCscE/RsaeMxDZW2V3ZOo11aPdtnJ/Mii0SZSVoNxU=;
        b=qAamPC0hkjoGqT9qD45ZLNkN0kh5ldU8aNspe2f9lNvcfghMUUO9ztw50bcE7FaI1F
         t+wAe8iutpYq01wjVWJ5Rkc52Z7U+PPICNi0tW5KqpZp4ApTOZsrrtE6kvVMhIREIDeF
         AEb7FPD0gh2j3lQK9MGGNZ1JrdOcwQQtjHL7AEzc/xAH6DDl6pxZgvjFKJBI1pJg83wj
         J8WwrGsNV57teDwDN3CkxJVf5/V0NETc112zLJK2OlsUScvLW/xY4vrZ5TtuAXbE3BQq
         yd918jtPlaEpuNozI4fn+wAcUmolrV1/2EW08kG7nI5SIjpEXHMxwcsI3KWJ7a5pGNNj
         KrCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DfCscE/RsaeMxDZW2V3ZOo11aPdtnJ/Mii0SZSVoNxU=;
        b=jKGEebuZgPNgc+xadcQg3RY020OwQl8gmJC6tPxGeqfsozA0liepBZEkltVmnn+M26
         65jniPsu9O/JOiID56ODSBVxei0qCAYx4v1xuIiUZtyhUz1OPbXSajd67HyfdH0k6RTS
         pG6zEAuekFrgINab2zRLFzJRjUJ8Viek97V+NQt/SPgXsmTSBTv6iZ1rL+/+FUl3/8Fj
         o+hGI1IVCj1yig1q8tPcSaitMLm6elpZwFJalkF6usTq6KWnF6EgvUcNUCqG096g5maj
         x3h8FIdO4q0iPz1gLJmiYvQQNekUCysz1eD10aa07K+CsNj9TfHwjQfWhvgiEPTbP+X1
         rDjA==
X-Gm-Message-State: APjAAAUbU/lzo48yE/Nz7qIHynXL+EXIAmf6qJtryA1vGcIguqoHE+eP
        GYkGfMz94Ht7KrYU9VcSS/2IZquULOU=
X-Google-Smtp-Source: APXvYqwWi4MLdJ9So/Eufnurekgk4/g/7jeUc3IdBfXsseqhTMiKj0UbwINOgpmk+iaXz06THqKpdw==
X-Received: by 2002:a05:600c:23d2:: with SMTP id p18mr1833486wmb.108.1561651364433;
        Thu, 27 Jun 2019 09:02:44 -0700 (PDT)
Received: from jimi ([46.19.85.235])
        by smtp.gmail.com with ESMTPSA id x16sm3946396wmj.4.2019.06.27.09.02.43
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 09:02:44 -0700 (PDT)
Date:   Thu, 27 Jun 2019 19:02:37 +0300
From:   Eyal Birger <eyal.birger@gmail.com>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        davem@davemloft.net, pablo@netfilter.org, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, jhs@mojatatu.com
Subject: Re: [PATCH net-next v3 1/4] net: sched: em_ipt: match only on
 ip/ipv6 traffic
Message-ID: <20190627190237.0a08a4a2@jimi>
In-Reply-To: <20190627081047.24537-2-nikolay@cumulusnetworks.com>
References: <20190627081047.24537-1-nikolay@cumulusnetworks.com>
        <20190627081047.24537-2-nikolay@cumulusnetworks.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nik,

On Thu, 27 Jun 2019 11:10:44 +0300
Nikolay Aleksandrov <nikolay@cumulusnetworks.com> wrote:

> Restrict matching only to ip/ipv6 traffic and make sure we can use the
> headers, otherwise matches will be attempted on any protocol which can
> be unexpected by the xt matches. Currently policy supports only
> ipv4/6.
> 
> Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> ---
> v3: no change
> v2: no change
> 
>  net/sched/em_ipt.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/net/sched/em_ipt.c b/net/sched/em_ipt.c
> index 243fd22f2248..64dbafe4e94c 100644
> --- a/net/sched/em_ipt.c
> +++ b/net/sched/em_ipt.c
> @@ -185,6 +185,19 @@ static int em_ipt_match(struct sk_buff *skb,
> struct tcf_ematch *em, struct nf_hook_state state;
>  	int ret;
>  
> +	switch (tc_skb_protocol(skb)) {
> +	case htons(ETH_P_IP):
> +		if (!pskb_network_may_pull(skb, sizeof(struct
> iphdr)))
> +			return 0;
> +		break;
> +	case htons(ETH_P_IPV6):
> +		if (!pskb_network_may_pull(skb, sizeof(struct
> ipv6hdr)))
> +			return 0;
> +		break;
> +	default:
> +		return 0;
> +	}
> +

I just realized that I didn't consider the egress direction in my review.
Don't we need an skb_pull() in that direction to make the skb->data point
to L3? I see this is done e.g. in em_ipset.

Eyal.
