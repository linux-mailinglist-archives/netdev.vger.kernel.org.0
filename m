Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65C8B31571
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 21:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727331AbfEaTgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 15:36:03 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:38865 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726808AbfEaTgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 15:36:03 -0400
Received: by mail-it1-f196.google.com with SMTP id h9so2932475itk.3;
        Fri, 31 May 2019 12:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=I8pzWDsFT6+RuTnIe9x8s6+9s3G+oogH6IuABJnIxcw=;
        b=XNkEAsdRqft03Il1tSzuYJNxjRp3wx7k5taZVA/KUGVj/chZo9GHI295E4uL2JU/lX
         /XqF0sL4NaPNVV0pk5ayDw42l2DgxQ+9SvWarFJ29KGLKjsM9HNfR+iUbDRp6Md/FrTD
         0iKzvT7oPJzE/WpUoIi/h3yLrG6UfWQ6rbk9Qmx1thOE8dTiDD5N1Sl4CnPmpDjsOP3D
         1fEHe8SG0XvQamKZ8m6ZYXMStTdE9QWjWqmT0QohTVlfgZK7MxN+eqDNTxgDQ1nTNxB3
         rQ+7qgJQrR+GNn3vrGEAoYB6XGvcAPIvM7S8oQ1J8/AfZ6WYxbuWAa9wBtW43IPJE60b
         4Vug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=I8pzWDsFT6+RuTnIe9x8s6+9s3G+oogH6IuABJnIxcw=;
        b=SSW7ef8aINf5JgeFsuW40EeVV0KUXtbYu6PIeZBkkiibNrs7m+JEnYF0sCZPW4j4HN
         enOnVLBoRUZFc6ft33CfR/ziI9UF8WjJG9ohHv/YvXCulx46rd7EJeOnacrGF7zDcWE8
         gVEHV0NpzlegGAgMw/Md3iQvec25ViizILpbVgg3tEiCU/hKu0c34WlsURIl/kMXrc41
         1hTowdhf3y5rc6J0P1m4Rz7S9610tUR/DL1/JKpbWNW6w92oSWCUzDfYL4u7/YaJYqE1
         Fu+X1dNrTJnQhgIMTf6JDm7+fN8R4qqT5FlIQ3KZi1lLXmmQMrnNX475ddszVVb2xuvB
         GV+w==
X-Gm-Message-State: APjAAAXuxVe8p2dXeOfguuCTtKHS456f82RMPboL1It12t9UQkvSjTQQ
        SNVfZg2mkEDP+5vAgUjKhjWr6zM=
X-Google-Smtp-Source: APXvYqx+VByXnINs/E+AangcN5AncgP87AhjZLT4lMeIs07gU1bPmZCJ154I+NpgBwS2q1IYOZlJdQ==
X-Received: by 2002:a24:ee46:: with SMTP id b67mr3866231iti.87.1559331362724;
        Fri, 31 May 2019 12:36:02 -0700 (PDT)
Received: from ubuntu ([12.38.14.10])
        by smtp.gmail.com with ESMTPSA id z17sm2210411iol.73.2019.05.31.12.36.01
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 31 May 2019 12:36:01 -0700 (PDT)
Date:   Fri, 31 May 2019 15:35:58 -0400
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: add support for matching IPv4 options
Message-ID: <20190531193558.GB4276@ubuntu>
References: <20190523093801.3747-1-ssuryaextr@gmail.com>
 <20190531171101.5pttvxlbernhmlra@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190531171101.5pttvxlbernhmlra@salvia>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 07:11:01PM +0200, Pablo Neira Ayuso wrote:
> > +/* find the offset to specified option or the header beyond the options
> > + * if target < 0.
> > + *
> > + * Note that *offset is used as input/output parameter, and if it is not zero,
> > + * then it must be a valid offset to an inner IPv4 header. This can be used
> > + * to explore inner IPv4 header, eg. ICMP error messages.
> 
> In other extension headers (IPv6 and TCP options) this offset is used
> to match for a field inside the extension / option.
> 
> So this semantics you describe here are slightly different, right?

It is the same as the IPv6 one. The offset returned is the offset to the
specific option (target) or the byte beyond the options if the target
isn't specified (< 0).

> Align parameters to parens when breaking too long lines.
> Please, also break lines at 80 chars.
> Please, define variables using reverse xmas tree, ie.

OK on these.

> > +	optlen = iph->ihl * 4 - (int)sizeof(struct iphdr);
> > +	if (optlen <= 0)
> > +		return -ENOENT;
> 
> You could just:
> 
>                 return -1;
> 
> in all these errors in ipv4_find_option() since nft_exthdr_ipv4_eval()
> does not use it.

Yes, but I followed the pattern in ipv6_find_hdr().

> I'd suggest:
> 
>                 if (!opt->srr)
>                         break;
> 
> So you save one level of indentation below.
> 
> same here:
> 
>                 if (!opt->rr)
>                         break;
> 
> and same thing for other extensions.

OK on these.
> 
> > +	if (!found)
> > +		target = -ENOENT;
> > +	return target;
> 
> Hm, 'target' value is never used, right?

Again, this follows ipv6_find_hdr().

> This should also work for the NFPROTO_INET (inet tables), NFPROTO_BRIDGE
> and the NFPROTO_NETDEV families.
> 
> I would turn this into:
> 
> 		if (ctx->family != NFPROTO_IPV6) {
> 

OK.

> > +			if (tb[NFTA_EXTHDR_DREG])
> > +				return &nft_exthdr_ipv4_ops;
> > +		}
> > +		break;
> 
> Then, from the _eval() path:
> 
> You have to replace iph->version == 4 check abive, you could use
> skb->protocol instead, and check for htons(ETH_P_IP) packets.

A bit lost. Did you mean this?

static int ipv4_find_option(struct net *net, struct sk_buff *skb,
»       »       »           unsigned int *offset, int target,
»       »       »           unsigned short *fragoff, int *flags)
{
	...
»       iph = skb_header_pointer(skb, *offset, sizeof(_iph), &_iph);
»       if (!iph || skb->protocol != htons(ETH_P_IP))
»       »       return -EBADMSG;

Thank you.
