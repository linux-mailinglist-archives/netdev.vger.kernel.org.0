Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 167BB2A958D
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 12:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbgKFLlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 06:41:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25914 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726010AbgKFLlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 06:41:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604662863;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wrZ4oLrRKAlkIXCkiskrapF3SJUeI8FJdBVtlw792IE=;
        b=RaQqK++jWookrCWlMqAtM09/4ylW9rwEpi9Kl9xCjYDHWV3rsj+9TTCgJbvYAUz+ao8mjr
        0THr1KPQPPHL9nRyMHMHvdkxmBOgGo8x5wzGOnGxa8mGTmuipYBg1eOlKVKbGciViQsvBn
        MCGAS3b+M6JKjfCsArDfSAW2m3134JM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-wkLnwCPxMuO8w8QgqW3KOg-1; Fri, 06 Nov 2020 06:41:01 -0500
X-MC-Unique: wkLnwCPxMuO8w8QgqW3KOg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D4E8218CBC7A;
        Fri,  6 Nov 2020 11:40:57 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-115-47.rdu2.redhat.com [10.10.115.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 16D7F380;
        Fri,  6 Nov 2020 11:40:53 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <000000000000e0a53705b2d7ec44@google.com>
References: <000000000000e0a53705b2d7ec44@google.com>
To:     syzbot <syzbot+d2b6e8cc299748fecf25@syzkaller.appspotmail.com>
Cc:     dhowells@redhat.com, a@unstable.cc,
        b.a.t.m.a.n@lists.open-mesh.org, davem@davemloft.net,
        fweisbec@gmail.com, ktkhai@virtuozzo.com,
        linux-afs@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mareklindner@neomailbox.ch,
        miklos@szeredi.hu, mingo@kernel.org, mszeredi@redhat.com,
        netdev@vger.kernel.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Subject: Re: INFO: rcu detected stall in security_file_open (3)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1797847.1604662853.1@warthog.procyon.org.uk>
Date:   Fri, 06 Nov 2020 11:40:53 +0000
Message-ID: <1797848.1604662853@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz fix: afs: Fix cell removal

