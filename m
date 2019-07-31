Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D11A97C4F0
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 16:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729259AbfGaOa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 10:30:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50112 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727089AbfGaOa5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 10:30:57 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5DECD81F22;
        Wed, 31 Jul 2019 14:30:57 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-255.rdu2.redhat.com [10.10.120.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A16501001B07;
        Wed, 31 Jul 2019 14:30:55 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CACT4Y+YjdV8CqX5=PzKsHnLsJOzsydqiq3igYDm_=nSdmFo2YQ@mail.gmail.com>
References: <CACT4Y+YjdV8CqX5=PzKsHnLsJOzsydqiq3igYDm_=nSdmFo2YQ@mail.gmail.com> <0000000000004c2416058c594b30@google.com> <24282.1562074644@warthog.procyon.org.uk>
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
Content-ID: <20329.1564583454.1@warthog.procyon.org.uk>
Date:   Wed, 31 Jul 2019 15:30:54 +0100
Message-ID: <20330.1564583454@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Wed, 31 Jul 2019 14:30:57 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dmitry Vyukov <dvyukov@google.com> wrote:

> Re bisection, I don't know if there are some more subtle things as
> play (you are in the better position to judge that), but bisection log
> looks good, it tracked the target crash throughout and wasn't
> distracted by any unrelated bugs, etc. So I don't see any obvious
> reasons to not trust it.

Can you turn on:

	echo 1 > /sys/kernel/debug/tracing/events/rxrpc/rxrpc_local/enable

and capture the trace log at the point it crashes?

David
