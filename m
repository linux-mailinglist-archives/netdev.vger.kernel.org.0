Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6339A31A376
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 18:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbhBLRVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 12:21:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27587 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230249AbhBLRVQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 12:21:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613150389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8rCxQNN16+K2hzoj5STU9hRYBNBsx6KVBdYVkcZbJGs=;
        b=OLAD5Cw4MnPh8Po3z1NCyTI2Ghj9EEiStzD/Gj8SP7dq5JIhPVp7ZbUMzGrUiyrm6bsjJg
        APCAL4lQrhIuANy/Y3BLwewK8AmCD9HyHCDNzy3JgW+ANtHuqeUaXUzm+2hyifnF6g//L/
        SowR+s/EumIzmc3oaRRAn5ZZzqqBSzw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-543-qjC43fPzP16zOc5K_U-V8g-1; Fri, 12 Feb 2021 12:19:45 -0500
X-MC-Unique: qjC43fPzP16zOc5K_U-V8g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E1BD5835E24;
        Fri, 12 Feb 2021 17:19:38 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-119-68.rdu2.redhat.com [10.10.119.68])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7BE9C1B473;
        Fri, 12 Feb 2021 17:19:37 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20210212104814.21452-1-vfedorenko@novek.ru>
References: <20210212104814.21452-1-vfedorenko@novek.ru>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     dhowells@redhat.com, Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [RESEND net-next] rxrpc: Fix dependency on IPv6 in udp tunnel config
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <133916.1613150376.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Fri, 12 Feb 2021 17:19:36 +0000
Message-ID: <133917.1613150376@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vadim Fedorenko <vfedorenko@novek.ru> wrote:

> As udp_port_cfg struct changes its members with dependency on IPv6
> configuration, the code in rxrpc should also check for IPv6.
> =

> Fixes: 1a9b86c9fd95 ("rxrpc: use udp tunnel APIs instead of open code in=
 rxrpc_open_socket")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>

Looks reasonable.

Acked-by: David Howells <dhowells@redhat.com>

