Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B39B1DF2FC
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 01:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387418AbgEVX1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 19:27:03 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:24951 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731183AbgEVX1C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 19:27:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590190021;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GuKh3dxo4RS45S6kys8EO/NCwJ8waxc1aZfQHF8KkoU=;
        b=Uv4Iqekm37ODGRndV4n7ZwuMnpt3FBDbZuNIkmzfmWwPdgr4Ok4ZEqCzGqRxMD+Hn57bt6
        s8J3tDVZVOtN+1pe6ZXcwWmv80onPeE7dbBDg0IpVfDmoAY9r5qKDhCyOzHu9yCuRef6sD
        TiIyavESZwLmrUIVbbNGoduNXXPSXm0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-431-g06uXK8ZNBG2JNyAum_1xA-1; Fri, 22 May 2020 19:20:25 -0400
X-MC-Unique: g06uXK8ZNBG2JNyAum_1xA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E8A80460;
        Fri, 22 May 2020 23:20:23 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-138.rdu2.redhat.com [10.10.112.138])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0169960BE2;
        Fri, 22 May 2020 23:20:22 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <159004420353.66254.3034741691675793468.stgit@warthog.procyon.org.uk>
References: <159004420353.66254.3034741691675793468.stgit@warthog.procyon.org.uk>
Cc:     dhowells@redhat.com, netdev@vger.kernel.org,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/3] rxrpc: Fix retransmission timeout and ACK discard [ver #2]
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <996436.1590189622.1@warthog.procyon.org.uk>
Date:   Sat, 23 May 2020 00:20:22 +0100
Message-ID: <996437.1590189622@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> The patches are tagged here:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
> 	rxrpc-fixes-20200520

Oops.  That's the wrong tag.  It should be rxrpc-fixes-20200521.

David

