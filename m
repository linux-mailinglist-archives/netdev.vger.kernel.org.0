Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94A3130D488
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 09:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232446AbhBCIBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 03:01:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24943 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232406AbhBCIBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 03:01:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612339216;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Q9U7Zpga/dimth/hDU8rLT+lYe8sKjMHG8zw81gDAlM=;
        b=PRhAH7gZIGASg0oY9QSyOA6Ljs/BUHWKIp7psWS7SraIYMOJo9jl1eNBUQn4xfgdy5/6Fr
        wLw7A/Pf0tCQOdceGN4AfGi5ylTAb70Bvs3kmADaedOHqReDPwmt1zyz/6K3sn4OTmU34G
        eDaidq4RB48NcZ0UVD6YFIjM04vPknA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-541-yWxjuEYwOG6HKmsun9_9lg-1; Wed, 03 Feb 2021 03:00:13 -0500
X-MC-Unique: yWxjuEYwOG6HKmsun9_9lg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A713100F341;
        Wed,  3 Feb 2021 08:00:11 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-115-23.rdu2.redhat.com [10.10.115.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D864160C66;
        Wed,  3 Feb 2021 08:00:09 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CADvbK_e-+tDucpUnRWQhQqpXSDTd_kbS_hLMkHwVNjWY5bnhuw@mail.gmail.com>
References: <CADvbK_e-+tDucpUnRWQhQqpXSDTd_kbS_hLMkHwVNjWY5bnhuw@mail.gmail.com> <cover.1611637639.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     dhowells@redhat.com, network dev <netdev@vger.kernel.org>,
        davem <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        Martin Varghese <martin.varghese@nokia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCHv4 net-next 0/2] net: enable udp v6 sockets receiving v4 packets with UDP GRO
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <645989.1612339208.1@warthog.procyon.org.uk>
Date:   Wed, 03 Feb 2021 08:00:08 +0000
Message-ID: <645990.1612339208@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xin Long <lucien.xin@gmail.com> wrote:

> I saw the state of this patchset is still new, should I repost it?

It needs a fix in patch 2 (see my response to that patch).

Thanks,
David

