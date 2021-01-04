Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE0FE2E9550
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 13:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbhADMwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 07:52:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56147 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726608AbhADMwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 07:52:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609764652;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D7cdYIjLB2TJwkBcPMV987oTnRn/FEmni88uTGzxuGA=;
        b=YPwAv0r48FaWO0w/54j2/qJNz9lr6YTlOOmQLhfhEWa5rFJpVdOqyB4jIa5s0Zifa/1470
        7VYxXupjw61RFKyk7+8yGmpxAK5xziPAhg/X3R7fYVp8qAtMzq+8BWGoLdG7IQFSd6Av2+
        kcoqf/VldhIPSa5lXSTG2JYKoK3ANv4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-mAxJZbDYPF-TPxibUqBH0w-1; Mon, 04 Jan 2021 07:50:51 -0500
X-MC-Unique: mAxJZbDYPF-TPxibUqBH0w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 750D1107ACE3;
        Mon,  4 Jan 2021 12:50:49 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-8.rdu2.redhat.com [10.10.112.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 98D526F920;
        Mon,  4 Jan 2021 12:50:47 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20201229173916.1459499-1-trix@redhat.com>
References: <20201229173916.1459499-1-trix@redhat.com>
To:     trix@redhat.com
Cc:     dhowells@redhat.com, davem@davemloft.net, kuba@kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com,
        linux-afs@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH] rxrpc: fix handling of an unsupported token type in rxrpc_read()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <259548.1609764646.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Mon, 04 Jan 2021 12:50:46 +0000
Message-ID: <259549.1609764646@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

trix@redhat.com wrote:

> -		switch (token->security_index) {
> -		case RXRPC_SECURITY_RXKAD:
> ...
> -		switch (token->security_index) {
> -		case RXRPC_SECURITY_RXKAD:

These switches need to be kept.  There's another security type on the way.
See:

https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/=
?h=3Drxrpc-rxgk

for example.  I'll have a look later.

David

