Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0F24201DF8
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 00:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729295AbgFSWWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 18:22:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35602 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728906AbgFSWWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 18:22:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592605339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KckeDijG9hpK4dBhAcGm37ROV9Z0JbkQ/pdnyqRrzZU=;
        b=fMi+T9UOLKrIqrxAbFmOCj4ZDMlDH7COtNPEeTSyhpxhjCNECPkt60ZadQr2uMfGGBfdPR
        LOxDdWIw2V5R9peBr52ok2fmXc3Tyjd6dcYFXy6YKid84zTInVIqFHZhpRLvVPMlCp6To/
        zpr1sjyv+vlkXjMEAJHxpvPAt+hqdcw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-19-PIKCnAkpPOuGYwEIMmjiMg-1; Fri, 19 Jun 2020 18:22:15 -0400
X-MC-Unique: PIKCnAkpPOuGYwEIMmjiMg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 668F3464;
        Fri, 19 Jun 2020 22:22:14 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-114-66.rdu2.redhat.com [10.10.114.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA75B5BAC3;
        Fri, 19 Jun 2020 22:22:12 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <0000000000005805de05a87732bf@google.com>
References: <0000000000005805de05a87732bf@google.com>
To:     syzbot <syzbot+d3eccef36ddbd02713e9@syzkaller.appspotmail.com>
Cc:     dhowells@redhat.com, davem@davemloft.net, kuba@kernel.org,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: net-next test error: KASAN: use-after-free Write in afs_wake_up_async_call
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2215551.1592605332.1@warthog.procyon.org.uk>
Date:   Fri, 19 Jun 2020 23:22:12 +0100
Message-ID: <2215552.1592605332@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot <syzbot+d3eccef36ddbd02713e9@syzkaller.appspotmail.com> wrote:

> This crash does not have a reproducer. I cannot test it.

This should do it:

	insmod fs/afs/kafs.ko; rmmod kafs

David

