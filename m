Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8478F45E8FD
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 09:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352811AbhKZILT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 03:11:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:23763 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352864AbhKZIJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 03:09:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637913965;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=M//eB/FJBtYBGKBx+oH9sHQCtuYI5BupCwuN5dEn5+M=;
        b=C1qF71Pai+MwzHnnRjXY9xklTdKjlDchYX16s5PvBhQRWeMbq8kEGHFkQaurqpn8vinfNq
        ktU3WCo6+KjD+SLI1MW/yP6+bEQCztIWo8YFbnQ0juNGqaRnJnWCwgc3/2/9d3PVsvY/rB
        +8lmrHoLRIsWAvjXKsZOC6WhKtuq9Cw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-563-X654_A8nOrSIgsG3Y3glDA-1; Fri, 26 Nov 2021 03:06:01 -0500
X-MC-Unique: X654_A8nOrSIgsG3Y3glDA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E428781CCB4;
        Fri, 26 Nov 2021 08:05:59 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 54B46196F8;
        Fri, 26 Nov 2021 08:05:57 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20211125192727.74360e85@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211125192727.74360e85@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <163776465314.1844202.9057900281265187616.stgit@warthog.procyon.org.uk>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     dhowells@redhat.com, Eiichi Tsukata <eiichi.tsukata@nutanix.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] rxrpc: Fix rxrpc_peer leak in rxrpc_look_up_bundle()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2790422.1637913956.1@warthog.procyon.org.uk>
Date:   Fri, 26 Nov 2021 08:05:56 +0000
Message-ID: <2790423.1637913956@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:

> Are these supposed to go to net? They are addressed To: the author.

I'm hoping the author rechecks/reviews them.  I commented on his original
submission that I thought they could be done slightly differently.

David

