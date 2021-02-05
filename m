Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC602310189
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 01:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbhBEAV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 19:21:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52171 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231366AbhBEAV1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 19:21:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612484400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mk4/q+m5a8dkisDGLvIhMTMkcY8JVJ4itzn6xJnzUYM=;
        b=gH2AvNtYuzA9lR+XSZjfmgTQlOx7ORor8hlt/e9zXtP4olBcU80EFkYC8rtxsGo8YPoxPA
        P6PhPQ+922FL49zV2mJBF3aNDfkcOWVkaMbnqispaNlnVnY/pOSpVgxFVvbNpoemA03zyN
        5hUDdRAkFFO2QBuiUbtQ+RvICiM7Ndg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-567-T-i7XwcKOZG2mZdFIQC6TQ-1; Thu, 04 Feb 2021 19:19:56 -0500
X-MC-Unique: T-i7XwcKOZG2mZdFIQC6TQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A02A8107ACE3;
        Fri,  5 Feb 2021 00:19:54 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-115-23.rdu2.redhat.com [10.10.115.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B22965D9CC;
        Fri,  5 Feb 2021 00:19:52 +0000 (UTC)
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
Content-ID: <2065088.1612484391.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Fri, 05 Feb 2021 00:19:51 +0000
Message-ID: <2065089.1612484391@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xin Long <lucien.xin@gmail.com> wrote:

> > If you could arrange for a random port to be assigned in such a case (=
and
> > indicated back to the caller), that would be awesome.  Possibly I just=
 don't
> > need to actually use bind in this case.
> >
> The patch is attached (based on this patch):

Initial testing seems to show that it works.  I'll poke at it some more
tomorrow.

David

