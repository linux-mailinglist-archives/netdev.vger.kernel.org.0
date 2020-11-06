Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5BC72A956E
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 12:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbgKFLa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 06:30:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41273 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726694AbgKFLa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 06:30:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604662257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wrZ4oLrRKAlkIXCkiskrapF3SJUeI8FJdBVtlw792IE=;
        b=JC1DD697nkr7bQVarm3mu9lzXwqJ9haaV7N/c/jfjdUhO9pixFGlDVP0cVIIuahTZOz/ys
        mBzXsffOnv/EWvTwi/a7lf6kmcJS0fabT9Bj4azQJlZDYqEWdQhtljxAkWJXruRFRNEy6c
        xOonrqFD6oA5y/sndFT3rsPlqKnZZmM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-544-pUgyyxONN_aDJAFzCvZADg-1; Fri, 06 Nov 2020 06:30:56 -0500
X-MC-Unique: pUgyyxONN_aDJAFzCvZADg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6E97757202;
        Fri,  6 Nov 2020 11:30:54 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-115-47.rdu2.redhat.com [10.10.115.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C648F73680;
        Fri,  6 Nov 2020 11:30:52 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <000000000000abdde905b2db0a11@google.com>
References: <000000000000abdde905b2db0a11@google.com>
To:     syzbot <syzbot+14189f93c40e0e6b19cd@syzkaller.appspotmail.com>
Cc:     dhowells@redhat.com, fweisbec@gmail.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        mingo@kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Subject: Re: INFO: rcu detected stall in ip_list_rcv
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1796756.1604662246.1@warthog.procyon.org.uk>
Date:   Fri, 06 Nov 2020 11:30:46 +0000
Message-ID: <1796757.1604662246@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz fix: afs: Fix cell removal

