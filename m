Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF496D0E9F
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 14:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730678AbfJIMYz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 9 Oct 2019 08:24:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46740 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727219AbfJIMYz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 08:24:55 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F309451F16;
        Wed,  9 Oct 2019 12:24:54 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-125-72.rdu2.redhat.com [10.10.125.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A6BE210027C5;
        Wed,  9 Oct 2019 12:24:53 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20191008094221.62d84587@canb.auug.org.au>
References: <20191008094221.62d84587@canb.auug.org.au>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     dhowells@redhat.com, David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build warning after merge of the net-next tree
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <19880.1570623892.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date:   Wed, 09 Oct 2019 13:24:52 +0100
Message-ID: <19881.1570623892@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Wed, 09 Oct 2019 12:24:55 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> diff --git a/net/rxrpc/peer_object.c b/net/rxrpc/peer_object.c
> index a7f1a2cdd198..452163eadb98 100644
> --- a/net/rxrpc/peer_object.c
> +++ b/net/rxrpc/peer_object.c
> @@ -231,7 +231,7 @@ struct rxrpc_peer *rxrpc_alloc_peer(struct rxrpc_local *local, gfp_t gfp)
>  			peer->cong_cwnd = 3;
>  		else
>  			peer->cong_cwnd = 4;
> -		trace_rxrpc_peer(peer, rxrpc_peer_new, 1, here);
> +		trace_rxrpc_peer(peer->debug_id, rxrpc_peer_new, 1, here);
>  	}
>  
>  	_leave(" = %p", peer);

Acked-by: David Howells <dhowells@redhat.com>
