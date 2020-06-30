Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3C8720F12B
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 11:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731831AbgF3JIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 05:08:38 -0400
Received: from sitav-80046.hsr.ch ([152.96.80.46]:50342 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731666AbgF3JIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 05:08:37 -0400
Received: from [IPv6:2a01:8b81:5404:6500:3c25:5ba3:e8b1:1f22] (unknown [IPv6:2a01:8b81:5404:6500:3c25:5ba3:e8b1:1f22])
        by mail.strongswan.org (Postfix) with ESMTPSA id E1087401B3;
        Tue, 30 Jun 2020 11:08:34 +0200 (CEST)
Subject: Re: [PATCH ipsec] xfrm: state: match with both mark and mask on user
 interfaces
To:     Xin Long <lucien.xin@gmail.com>, netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <hadi@cyberus.ca>,
        Sabrina Dubroca <sd@queasysnail.net>
References: <4aaead9f8306859eb652b90582f23295792e9d15.1593497708.git.lucien.xin@gmail.com>
From:   Tobias Brunner <tobias@strongswan.org>
Autocrypt: addr=tobias@strongswan.org; prefer-encrypt=mutual; keydata=
 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
Message-ID: <d510d172-c605-725d-e6bc-e6462a3718ab@strongswan.org>
Date:   Tue, 30 Jun 2020 11:08:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <4aaead9f8306859eb652b90582f23295792e9d15.1593497708.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Xin,

> Similar to commit 4f47e8ab6ab79 ("xfrm: policy: match with both mark and
> mask on user interfaces"), this patch is to match both mark and mask for
> state on these user interfaces:
> 
>   xfrm_state_lookup_byaddr_user
>   xfrm_state_lookup_user
>   xfrm_state_update
>   xfrm_state_find
>   xfrm_state_add
>       __xfrm_state_lookup_byaddr(struct xfrm_mark)
>       __xfrm_state_lookup(struct xfrm_mark)
>   xfrm_find_acq_byseq
>   xfrm_stateonly_find
> 
>           mark.v == x->mark.v && mark.m == x->mark.m

I generally agree with matching marks/masks exactly for operations from
userland, and it doesn't introduce any issues in our test suite.
However, xfrm_state_find() is used to find an outbound state based on
the templates in a policy and the marks on both, so it's not directly
userland-facing.  Before this change, the mask configured on the state
was a applied to the policy's mark/mask and then compared to the state's
mark.  Now, the mark and mask both must match exactly:

> @@ -1051,7 +1061,6 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
>  	int acquire_in_progress = 0;
>  	int error = 0;
>  	struct xfrm_state *best = NULL;
> -	u32 mark = pol->mark.v & pol->mark.m;
>  	unsigned short encap_family = tmpl->encap_family;
>  	unsigned int sequence;
>  	struct km_event c;
> @@ -1065,7 +1074,7 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
>  	hlist_for_each_entry_rcu(x, net->xfrm.state_bydst + h, bydst) {
>  		if (x->props.family == encap_family &&
>  		    x->props.reqid == tmpl->reqid &&
> -		    (mark & x->mark.m) == x->mark.v &&
> +		    (pol->mark.v == x->mark.v && pol->mark.m == x->mark.m) &&
>  		    x->if_id == if_id &&
>  		    !(x->props.flags & XFRM_STATE_WILDRECV) &&
>  		    xfrm_state_addr_check(x, daddr, saddr, encap_family) &&
> @@ -1082,7 +1091,7 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
>  	hlist_for_each_entry_rcu(x, net->xfrm.state_bydst + h_wildcard, bydst) {
>  		if (x->props.family == encap_family &&
>  		    x->props.reqid == tmpl->reqid &&
> -		    (mark & x->mark.m) == x->mark.v &&
> +		    (pol->mark.v == x->mark.v && pol->mark.m == x->mark.m) &&
>  		    x->if_id == if_id &&
>  		    !(x->props.flags & XFRM_STATE_WILDRECV) &&
>  		    xfrm_addr_equal(&x->id.daddr, daddr, encap_family) &&

While this should usually not be a problem for strongSwan, as we set the
same mark/value on both states and corresponding policies (although the
latter can be disabled as users may want to install policies themselves
or via another daemon e.g. for MIPv6), it might be a limitation for some
use cases.  The current code allows sharing states with multiple
policies whose mark/mask doesn't match exactly (i.e. depended on the
masks of both).  I wonder if anybody uses it like this, and how others
think about it.

Regards,
Tobias
