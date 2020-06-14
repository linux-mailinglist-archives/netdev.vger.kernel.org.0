Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24AF21F8A94
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 22:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbgFNUTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 16:19:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50923 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726857AbgFNUTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jun 2020 16:19:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592165976;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kFnjBBxZoYPqHYe1qb3puDWa9sIB09spfxyDPU0xHcw=;
        b=HXt/4VioZpOWrJuRqC5SDWN6nAnjw2jZvMRq1D4gydIrjJ6JtBmmJqsqLCVMQzupxBtBd0
        BKbNE8NFsvNAmGic5WhEWkOS6zYfznMWqpqf2ungRi/ZYxR6BFGKigCFJ2r8vJzMzg9y0F
        WEDHmV6jP2m/qg2ZC02yY3b1eIFUcmI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-JJlrtXMePiK3O3EITrk7xw-1; Sun, 14 Jun 2020 16:19:34 -0400
X-MC-Unique: JJlrtXMePiK3O3EITrk7xw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 77F8E19067E0;
        Sun, 14 Jun 2020 20:19:30 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-114-66.rdu2.redhat.com [10.10.114.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D9A578F0A;
        Sun, 14 Jun 2020 20:19:25 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <9feded75-4b45-2821-287b-af00ec5f910f@al2klimov.de>
References: <9feded75-4b45-2821-287b-af00ec5f910f@al2klimov.de>
To:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Cc:     dhowells@redhat.com, Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Andrea Parri <parri.andrea@gmail.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Jade Alglave <j.alglave@ucl.ac.uk>,
        Luc Maranget <luc.maranget@inria.fr>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Akira Yokosawa <akiyks@gmail.com>,
        Daniel Lustig <dlustig@nvidia.com>,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: Good idea to rename files in include/uapi/ ?
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <174101.1592165965.1@warthog.procyon.org.uk>
Date:   Sun, 14 Jun 2020 21:19:25 +0100
Message-ID: <174102.1592165965@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander A. Klimov <grandmaster@al2klimov.de> wrote:

> *Is it a good idea to rename files in include/uapi/ ?*

Very likely not.  If programs out there are going to be built on a
case-sensitive filesystem (which happens all the time), they're going to break
if you rename the headers.  We're kind of stuck with them.

David

