Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C20FC97DC
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 07:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbfJCFQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 01:16:35 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:32863 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726116AbfJCFQf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 01:16:35 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id CDBA221D51;
        Thu,  3 Oct 2019 01:16:34 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 03 Oct 2019 01:16:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=hd9cKa
        QDuxWfcf5JrbZ4dqRIVe67ArpxsRfeYUfAb0w=; b=a8fQvCr7QwqG8zFDMpp+58
        8Z0qKoMsDsqgQj5ci0hXJWr9TqPXf4t8BWP0D/kB9/2Rbh7GrjYJJzDikcJfXCPH
        Kl/P4Or42A0G9o3rerzOLpr7uEOEGJkBwvdUgm9YmBMwjd36MMjqFa4/Cs5aA9R6
        nLKlqvJ6y/CLnUPfXcEODAdA+4vBtF3XzYB28N3/3uv3/9hVFOQhAB/n8iT/wZcj
        nODNTxfkXpmsOwidoX3aUoKx/Lj8BRDXk4alqgFH2Xi56P2NKKJdiTlW7VXHIkpm
        4bRmg1biEdiaryYVfNPWVR3BRGD5VxVQOdvHf1cytpmCmLlJzSrf0CBPd89SCOmg
        ==
X-ME-Sender: <xms:MYSVXTqHGBRLV1SGEsvJBSbgbPS96r2sQCoWJ4BqG3Yisv4FR4ZVwg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeejgdelvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepudelfe
    drgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhes
    ihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:MYSVXTFFAF7QDDEvaZzxWNJqnIHY2aWdOGHdQLaLnrv0ddIMLwl-Gg>
    <xmx:MYSVXU-bel6dsyIsdu0z9SNxL_fx1d6dCrQnG4AxoaLAYISuLOZG2g>
    <xmx:MYSVXX2DBFWofPrUYE6dItjxy83L82HUS5S3pPE6Xzq1owZSv5GfbA>
    <xmx:MoSVXW-CKXd0UjldMPzGNq_cXEYI7uwgLjirQOPDKLGZMnKUGg0Jvw>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6D5F0D6005E;
        Thu,  3 Oct 2019 01:16:33 -0400 (EDT)
Date:   Thu, 3 Oct 2019 08:16:30 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        jakub.kicinski@netronome.com, saeedm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [RFC PATCH net-next 02/15] ipv4: Notify route after insertion to
 the routing table
Message-ID: <20191003051326.GA4325@splinter>
References: <20191002084103.12138-1-idosch@idosch.org>
 <20191002084103.12138-3-idosch@idosch.org>
 <576d658d-6aab-558c-0a20-13133217d3b6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <576d658d-6aab-558c-0a20-13133217d3b6@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 02, 2019 at 07:34:35PM -0600, David Ahern wrote:
> On 10/2/19 2:40 AM, Ido Schimmel wrote:
> > @@ -1269,14 +1269,19 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
> >  	new_fa->tb_id = tb->tb_id;
> >  	new_fa->fa_default = -1;
> >  
> > -	err = call_fib_entry_notifiers(net, event, key, plen, new_fa, extack);
> > +	/* Insert new entry to the list. */
> > +	err = fib_insert_alias(t, tp, l, new_fa, fa, key);
> >  	if (err)
> >  		goto out_free_new_fa;
> >  
> > -	/* Insert new entry to the list. */
> > -	err = fib_insert_alias(t, tp, l, new_fa, fa, key);
> > +	/* The alias was already inserted, so the node must exist. */
> > +	l = fib_find_node(t, &tp, key);
> > +	if (WARN_ON_ONCE(!l))
> > +		goto out_free_new_fa;
> 
> Maybe I am missing something but, the 'l' is only needed for the error
> path, so optimize for the success case and only lookup the node if the
> notifier fails.

Hi David,

You're correct that in this patch it is only needed by the error path, but
later on in patch 4 ("ipv4: Notify newly added route if should be
offloaded") we actually need it here as well. The FIB node can be NULL
and fib_insert_alias() will create one if that's the case.

> 
> > +
> > +	err = call_fib_entry_notifiers(net, event, key, plen, new_fa, extack);
> >  	if (err)
> > -		goto out_fib_notif;
> > +		goto out_remove_new_fa;
> >  
> >  	if (!plen)
> >  		tb->tb_num_default++;
> > @@ -1287,14 +1292,8 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
> >  succeeded:
> >  	return 0;
> >  
> > -out_fib_notif:
> > -	/* notifier was sent that entry would be added to trie, but
> > -	 * the add failed and need to recover. Only failure for
> > -	 * fib_insert_alias is ENOMEM.
> > -	 */
> > -	NL_SET_ERR_MSG(extack, "Failed to insert route into trie");
> > -	call_fib_entry_notifiers(net, FIB_EVENT_ENTRY_DEL, key,
> > -				 plen, new_fa, NULL);
> > +out_remove_new_fa:
> > +	fib_remove_alias(t, tp, l, new_fa);
> >  out_free_new_fa:
> >  	kmem_cache_free(fn_alias_kmem, new_fa);
> >  out:
> > 
> 
