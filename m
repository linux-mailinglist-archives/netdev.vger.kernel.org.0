Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D534B2826CC
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 23:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726001AbgJCVZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 17:25:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35942 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725963AbgJCVZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 17:25:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601760300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RI9t3QpvbxrdIY+RQ7srct2+LY1Jf4IiVSWRdQxLDY0=;
        b=dir+ilIb+d9yMsr8AVznga2JmaAbxot7djPPJNuVkewwVnuX4Qdz5H5AUGiAWG5cXqNfF4
        QfQWZpGzG7yaHCGIjxH4RfN9E7bn62opuZ5Gofode7poHSniqHrop5E6iotKI23s+/YKcN
        L2laua39NhY8eoFohTQKI4unUd3DA9E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-576-rSE8_r2TP1CBc_FYuxiyDA-1; Sat, 03 Oct 2020 17:24:58 -0400
X-MC-Unique: rSE8_r2TP1CBc_FYuxiyDA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 57297801AAD;
        Sat,  3 Oct 2020 21:24:57 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-116-196.rdu2.redhat.com [10.10.116.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7596560BE2;
        Sat,  3 Oct 2020 21:24:56 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20201003.141720.1850598738964828712.davem@davemloft.net>
References: <20201003.141720.1850598738964828712.davem@davemloft.net> <20201002.160325.520066148052804695.davem@davemloft.net> <160156420377.1728886.5309670328610130816.stgit@warthog.procyon.org.uk> <2438800.1601755309@warthog.procyon.org.uk>
To:     David Miller <davem@davemloft.net>
Cc:     dhowells@redhat.com, netdev@vger.kernel.org,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 00/23] rxrpc: Fixes and preparation for RxGK
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2450212.1601760295.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Sat, 03 Oct 2020 22:24:55 +0100
Message-ID: <2450213.1601760295@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Miller <davem@davemloft.net> wrote:

> > Since the fixes in the set need to go after the patches in net-next, s=
hould I
> > resubmit just those for net-next, or sit on them till -rc1?
> =

> My 'net' tree is always open for bug fixes, and that's where bug fixes
> belong.  Not 'net-next'.

"Need to go after the patches in net-next" - ie. there's a dependency.

David

