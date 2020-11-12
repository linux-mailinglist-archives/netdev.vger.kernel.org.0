Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 104CE2B06DD
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 14:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbgKLNoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 08:44:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25947 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727796AbgKLNoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 08:44:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605188659;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BUwAIt+GOyG7Z7TJGWPImVlKsyad1TuYvU2wjzCyMwM=;
        b=g/6i2SgqaaZJqiwLl1I+jPfj5Vg6l+ies2D+Tuuaj27E5hICR41GaA7Lzx2zeQP4aS8521
        tEFMbgyJGW26FC43iBW1qhnyNvs/a4nsnaudVP3kihv6YpG85DW1obc4DhWh15Xypx+yXb
        L/MFgive/koEQnnB5qbHSfL0UrcSNIw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-59-GVDbAyBiPoCIGQMZjHAg_Q-1; Thu, 12 Nov 2020 08:44:17 -0500
X-MC-Unique: GVDbAyBiPoCIGQMZjHAg_Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C717A100F7A3;
        Thu, 12 Nov 2020 13:44:15 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-115-47.rdu2.redhat.com [10.10.115.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D98195DA7E;
        Thu, 12 Nov 2020 13:44:13 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
References: <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
To:     herbert@gondor.apana.org.au
Cc:     dhowells@redhat.com, bfields@fieldses.org,
        trond.myklebust@hammerspace.com, linux-crypto@vger.kernel.org,
        linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 00/18] crypto: Add generic Kerberos library
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2319366.1605188653.1@warthog.procyon.org.uk>
Date:   Thu, 12 Nov 2020 13:44:13 +0000
Message-ID: <2319367.1605188653@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Would it be possible/practical to make the skcipher encrypt functions take an
offset into the scatterlist rather than always starting at the beginning?

David

