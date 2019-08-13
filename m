Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7221A8BB61
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 16:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729553AbfHMOXD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 13 Aug 2019 10:23:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33934 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729151AbfHMOXD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 10:23:03 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1133C3064FD4;
        Tue, 13 Aug 2019 14:23:03 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-255.rdu2.redhat.com [10.10.120.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4365360852;
        Tue, 13 Aug 2019 14:23:01 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CACT4Y+bjLBwVK_6fz2H8fXm0baAVX+vRJ4UbVWG_7yNUO-SOUg@mail.gmail.com>
References: <CACT4Y+bjLBwVK_6fz2H8fXm0baAVX+vRJ4UbVWG_7yNUO-SOUg@mail.gmail.com> <0000000000004c2416058c594b30@google.com> <24282.1562074644@warthog.procyon.org.uk> <CACT4Y+YjdV8CqX5=PzKsHnLsJOzsydqiq3igYDm_=nSdmFo2YQ@mail.gmail.com> <20330.1564583454@warthog.procyon.org.uk> <CACT4Y+Y4cRgaRPJ_gz_53k85inDKq+X+bWmOTv1gPLo=Yod1=A@mail.gmail.com> <22318.1564586386@warthog.procyon.org.uk>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     dhowells@redhat.com,
        syzbot <syzbot+1e0edc4b8b7494c28450@syzkaller.appspotmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        David Miller <davem@davemloft.net>,
        linux-afs@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: kernel BUG at net/rxrpc/local_object.c:LINE!
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3134.1565706180.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date:   Tue, 13 Aug 2019 15:23:00 +0100
Message-ID: <3135.1565706180@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Tue, 13 Aug 2019 14:23:03 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dmitry Vyukov <dvyukov@google.com> wrote:

> > > Please send a patch for testing that enables this tracing
> > > unconditionally. This should have the same effect. There is no way to
> > > hook into a middle of the automated process and arbitrary tune things.
> >
> > I don't know how to do that off hand.  Do you have an example?
> 
> Few messages above I asked it to test:
> https://groups.google.com/d/msg/syzkaller-bugs/gEnZkmEWf1s/r2_X_KVQAQAJ
> 
> Basically, git repo + branch + patch. Here are the docs:
> https://github.com/google/syzkaller/blob/master/docs/syzbot.md#testing-patches

I meant that I don't know how to turn a tracepoint on from inside the kernel.

David
