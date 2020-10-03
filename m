Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3541B282688
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 22:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725935AbgJCUB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 16:01:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33122 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725807AbgJCUB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 16:01:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601755316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/A6rRQgh7FIao3GEZvzvwL/dFHIVr0IqDIz99fdNOBo=;
        b=VLHwCGcKEER4YAxiBBJG7PBro7Clzpmy4/JJlDTS4PXpnyjSKgiXxh8toAkEYwAe5An2f8
        nxXmXhU4KrEnEXh55GGWochNw9WH53iyhqB+hSrKQuTjDypUtf9Mk2cgIYnSN/r+23XcO4
        T2Ncm0LYrbzqlts0OzAqNv/HXOdx8iw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-449-uWk0iau5OTi5HA1ASp-ruA-1; Sat, 03 Oct 2020 16:01:52 -0400
X-MC-Unique: uWk0iau5OTi5HA1ASp-ruA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7632D1074650;
        Sat,  3 Oct 2020 20:01:51 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-116-196.rdu2.redhat.com [10.10.116.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6504173681;
        Sat,  3 Oct 2020 20:01:50 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20201002.160325.520066148052804695.davem@davemloft.net>
References: <20201002.160325.520066148052804695.davem@davemloft.net> <160156420377.1728886.5309670328610130816.stgit@warthog.procyon.org.uk>
To:     David Miller <davem@davemloft.net>
Cc:     dhowells@redhat.com, netdev@vger.kernel.org,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 00/23] rxrpc: Fixes and preparation for RxGK
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2438799.1601755309.1@warthog.procyon.org.uk>
Date:   Sat, 03 Oct 2020 21:01:49 +0100
Message-ID: <2438800.1601755309@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Miller <davem@davemloft.net> wrote:

> > The patches are tagged here:
> > 
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
> > 	rxrpc-next-20201010
> 
> No, they aren't.

oops.  I transposed the last two digits.  I really need to make my script
check the cover message.

> Also, you have to submit changes much much much earlier.

Since the fixes in the set need to go after the patches in net-next, should I
resubmit just those for net-next, or sit on them till -rc1?

David

