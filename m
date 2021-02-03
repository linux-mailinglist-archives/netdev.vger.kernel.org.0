Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACB5030DDFD
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 16:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234250AbhBCPWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 10:22:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35787 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234356AbhBCPVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 10:21:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612365603;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/MApXmBD8HccPrGZXJhzqRpBzZhgXe4oRBPYOLT57U4=;
        b=HTYaPx5MdCmZQtqBYhaUPobo+55krhyh3LYIlIshbYd7OfWz+ZLTDNNXAKPtYgs5K/zlx+
        Vm7zDxm9TLDcLlVor55EoHnJsFY7MdUWHvhYbFCGvwBABJIfrsXfJ2DVA/9fZXWRgrwKPk
        PsRK00eLcxVPNOYD+tZMNUdnGEBsXsw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-oSnLsqRRMYqmXxJE-0UdDQ-1; Wed, 03 Feb 2021 10:19:59 -0500
X-MC-Unique: oSnLsqRRMYqmXxJE-0UdDQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D0CE6106BC91;
        Wed,  3 Feb 2021 15:19:30 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-115-23.rdu2.redhat.com [10.10.115.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A6E681001E73;
        Wed,  3 Feb 2021 15:19:28 +0000 (UTC)
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
Content-ID: <1028252.1612365567.1@warthog.procyon.org.uk>
Date:   Wed, 03 Feb 2021 15:19:27 +0000
Message-ID: <1028253.1612365567@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xin Long <lucien.xin@gmail.com> wrote:

> BTW: do you have any testing for this?

If you're using a distro like a recent-ish Fedora or, I think, Debian, you
should be able to install a kafs-client package.  If that works, start the
afs.mount service with systemctl and then look in /afs.  You should see
directories corresponding to a bunch of places that you can try accessing.  I
recommend you try "ls /afs/openafs.org".

If you don't have that available, if you have the keyutils package installed,
you can try:

	mount -t afs %openafs.org:root.cell /mnt

then do "ls /mnt".

David

