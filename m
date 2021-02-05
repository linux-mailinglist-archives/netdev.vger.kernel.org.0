Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29C2A3107C1
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 10:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbhBEJXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 04:23:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47379 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230138AbhBEJQC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 04:16:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612516472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jdBXtW89kRFq+5UnkK3YUGykqTXPtO+Feeo+Gipgqjs=;
        b=g6BUieqj8Vj7prX2dxE8jMTgd4diIqJVzaeV2KJtyFbUz4TVzv2v9BGbcFnjed2V27brFF
        8p7SeXX22At7ikTQz+FsFdF28h7L72wQ0SDf6u+wZsNv2oWkWXgG+inXaK+v/4AoG3lkEB
        2beWqI8VyPvyrp6uQag/8MMytZsTF2M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-436-hC0gOZo9OVWkptKdTrvs0A-1; Fri, 05 Feb 2021 04:14:29 -0500
X-MC-Unique: hC0gOZo9OVWkptKdTrvs0A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 21CEE57058;
        Fri,  5 Feb 2021 09:14:28 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-115-23.rdu2.redhat.com [10.10.115.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4368810013DB;
        Fri,  5 Feb 2021 09:14:26 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CADvbK_ePdoJRna81YwJUL5cqu1ST3W8J8kRqhbNVGdSse-3u1w@mail.gmail.com>
References: <CADvbK_ePdoJRna81YwJUL5cqu1ST3W8J8kRqhbNVGdSse-3u1w@mail.gmail.com> <cover.1611637639.git.lucien.xin@gmail.com> <CADvbK_e-+tDucpUnRWQhQqpXSDTd_kbS_hLMkHwVNjWY5bnhuw@mail.gmail.com> <645990.1612339208@warthog.procyon.org.uk> <CADvbK_dJJjiQK+N0U04eWCU50DRbFLNqHSi7Apj==d3ygzkz6g@mail.gmail.com> <655776.1612343656@warthog.procyon.org.uk>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     dhowells@redhat.com, network dev <netdev@vger.kernel.org>,
        davem <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        Martin Varghese <martin.varghese@nokia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        vfedorenko@novek.ru
Subject: Re: [PATCHv4 net-next 0/2] net: enable udp v6 sockets receiving v4 packets with UDP GRO
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2099833.1612516465.1@warthog.procyon.org.uk>
Date:   Fri, 05 Feb 2021 09:14:25 +0000
Message-ID: <2099834.1612516465@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xin Long <lucien.xin@gmail.com> wrote:

> Subject: [PATCH net-next] rxrpc: use udp tunnel APIs instead of open code in
>  rxrpc_open_socket
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

You can add "Acked-by: David Howells <dhowells@redhat.com>" if you want.

David

