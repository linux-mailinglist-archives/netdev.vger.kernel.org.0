Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3856ECD203
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 15:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbfJFNSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 09:18:37 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:44375 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbfJFNSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 09:18:36 -0400
Received: by mail-ed1-f65.google.com with SMTP id r16so9915053edq.11
        for <netdev@vger.kernel.org>; Sun, 06 Oct 2019 06:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Of4ngEqL2mLlj8uUdgE7QQgsY7V3Hk/LLrs3L3yx3GI=;
        b=uuygcU3zpAysJEfXM2jLMiCFVTDiRBtsh1GmEBZOTk37v/lUGV31Y3uD5icVHa+RHa
         KykzCHvY2dHQP/85QyCNLuAbhf+mEQ2uSR6zvIo/rX2+nkxKSWn4XWdi2MUIAy3M1dzr
         i1YmN26n5f+3kThyRGBpaFQdC2QnoggU9evZjASBSnT97oDeu982Oc8FgNjHzqCyIz7x
         R8P29uJxJm9d9Dp7Aqgxkw9l2xWPi6fhmq+wRyuR2YyTIPT0Ni6i48xPyYoHeIJzoBHy
         NQjDL4Q0jqDiyOrBFImLehmGAZdCK8hTZ7joZA/+EkwtiWqFRVcombfE/0UbkFLlWA9S
         kUiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Of4ngEqL2mLlj8uUdgE7QQgsY7V3Hk/LLrs3L3yx3GI=;
        b=okg7Ux50aAYCkHm5cm88lnxB9J03XIrJhCA6uaJuRZ3pYECjhdqMNyI0QmNJMTglCF
         5KksNgDla+dKKcWkl0PjTV6rA6iHgv1wC9IRDcdPhvtwwWgXlw6MnyVbmOU1CFWY+wFq
         Bfu/QuSsztkGBLu3iv1BM8DP0yvxVCk7juwnnGZMLT0YyJijP/9AV48g+sYEKHD6lFGx
         iyYW5E0LJSxEToQbj3SWHSG5KcCrYdPWEbW4EJ3dQ8byNEAktaRMRSfEVxXQ31rnsckT
         odAbuMtYED6aVfRFG2bLMAmlmZLpO+fkzmDKMB8919ZM5Dq88MmoS804b+DCFJRCEvik
         zc4Q==
X-Gm-Message-State: APjAAAVhd9eK6sj11GAEwMoKZ7fMUNTVK08sBv7gIyF9ztCGOQYl8lXc
        J5qufxI5KsvLagD4F8mSTb3v+Q==
X-Google-Smtp-Source: APXvYqzEmX45u5iqgskhZp1BRroifD74mno8J7/O8AUjB49ZlmZjHmKdMmFgFkEohPUEwyu61WS93Q==
X-Received: by 2002:aa7:d789:: with SMTP id s9mr24554865edq.62.1570367912804;
        Sun, 06 Oct 2019 06:18:32 -0700 (PDT)
Received: from netronome.com (penelope-musen.rivierenbuurt.horms.nl. [2001:470:7eb3:404:c685:8ff:fe7c:9971])
        by smtp.gmail.com with ESMTPSA id c32sm2786993eda.97.2019.10.06.06.18.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 06 Oct 2019 06:18:32 -0700 (PDT)
Date:   Sun, 6 Oct 2019 15:18:31 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Tom Herbert <tom@herbertland.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Tom Herbert <tom@quantonium.net>
Subject: Re: [PATCH v5 net-next 4/7] ip6tlvs: Registration of TLV handlers
 and parameters
Message-ID: <20191006131830.nfiwl2ovexnxbdnh@netronome.com>
References: <1570139884-20183-1-git-send-email-tom@herbertland.com>
 <1570139884-20183-5-git-send-email-tom@herbertland.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1570139884-20183-5-git-send-email-tom@herbertland.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 03, 2019 at 02:58:01PM -0700, Tom Herbert wrote:
> From: Tom Herbert <tom@quantonium.net>
> 
> Create a single TLV parameter table that holds meta information for IPv6
> Hop-by-Hop and Destination TLVs. The data structure is composed of a 256
> element array of u8's (one entry for each TLV type to allow O(1)
> lookup). Each entry provides an offset into an array of TLV proc data
> structures which follows the array of u8s. The TLV proc data structure
> contains parameters and handler functions for receiving and transmitting
> TLVs. The zeroth element in the TLV proc array provides default
> parameters for TLVs.
> 
> A class attribute indicates the type of extension header in which the
> TLV may be used (e.g. Hop-by-Hop options, Destination options, or
> Destination options before the routing header).
> 
> Functions are defined to manipulate entries in the TLV parameter table.
> 
> * tlv_{set|unset}_proc set a TLV proc entry (ops and parameters)
> * tlv_{set|unset}_params set parameters only

Perhaps it would be worth mentioning that these will
be used by a following patch in the series.

> Receive TLV lookup and processing is modified to be a lookup in the TLV
> parameter table. An init table containing parameters for TLVs supported
> by the kernel is used to initialize the TLV table.
> 
> Signed-off-by: Tom Herbert <tom@herbertland.com>

Minor nit about types below, but overall this looks good to me.

Reviewed-by: Simon Horman <simon.horman@netronome.com>

...

> diff --git a/include/net/ipeh.h b/include/net/ipeh.h
> index c1aa7b6..aaa2910 100644
> --- a/include/net/ipeh.h
> +++ b/include/net/ipeh.h

...

> +/* ipeh_tlv_get_proc_by_type assumes rcu_read_lock is held */
> +static inline struct tlv_proc *ipeh_tlv_get_proc_by_type(
> +		struct tlv_param_table *tlv_param_table, unsigned char type)
> +{
> +	struct tlv_param_table_data *tpt =
> +				rcu_dereference(tlv_param_table->data);
> +
> +	return &tpt->types[tpt->entries[type]].proc;
> +}
> +
> +/* ipeh_tlv_get_proc assumes rcu_read_lock is held */
> +static inline struct tlv_proc *ipeh_tlv_get_proc(
> +		struct tlv_param_table *tlv_param_table,
> +		const __u8 *tlv)
> +{
> +	return ipeh_tlv_get_proc_by_type(tlv_param_table, tlv[0]);

The type of tlv is const __u8 *, however,
1. the type of the 'type' parameter of ipeh_tlv_get_proc_by_type is
unsigned char; and
2. this function is passed a value of type const unsigned char * by
ipeh_parse_tlv().

I understand these are all one byte unsigned integer types.
But perhaps this could be made more consistent somehow.

> +}

...

> diff --git a/net/ipv6/exthdrs_common.c b/net/ipv6/exthdrs_common.c
> index 99a0911..43737fc 100644
> --- a/net/ipv6/exthdrs_common.c
> +++ b/net/ipv6/exthdrs_common.c

..

> @@ -221,26 +226,22 @@ bool ipeh_parse_tlv(const struct tlvtype_proc *procs, struct sk_buff *skb,
>  
>  			tlv_count++;
>  			if (tlv_count > max_count &&
> -			    parse_error(skb, off, IPEH_PARSE_ERR_OPT_TOOMANY))
> +			    !parse_error(skb, off, IPEH_PARSE_ERR_OPT_TOOMANY))
>  				goto bad;
>  
> -			for (curr = procs; curr->type >= 0; curr++) {
> -				if (curr->type == nh[off]) {
> -					/* type specific length/alignment
> -					 * checks will be performed in the
> -					 * func().
> -					 */
> -					if (curr->func(skb, off) == false)
> -						return false;
> -					break;
> -				}
> -			}
> -			if (curr->type < 0 &&
> -			    !parse_error(skb, off,
> +			curr = ipeh_tlv_get_proc(tlv_param_table, &nh[off]);
> +			if ((curr->params.r.class & class) && curr->ops.func) {
> +				/* Handler will apply additional checks to
> +				 * the TLV
> +				 */
> +				if (!curr->ops.func(class, skb, off))
> +					return false;
> +			} else if (!parse_error(skb, off,
>  					 disallow_unknowns ?
>  						IPEH_PARSE_ERR_OPT_UNK_DISALW :
> -						IPEH_PARSE_ERR_OPT_UNK))
> +						IPEH_PARSE_ERR_OPT_UNK)) {
>  				goto bad;
> +			}
>  
>  			padlen = 0;
>  			break;
