Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9BF2C99CE
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 09:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728712AbgLAIqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 03:46:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27530 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727466AbgLAIqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 03:46:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606812309;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QSaVTW8Re5mr4mmiZruNg5eKqQXZkeeVuPsKPpTrCsM=;
        b=AXyLl04IYl6xDHwM4IaqTrZkU/drereYCRfrgeiywtH19u2ZgM4NhHTt8+rinifPsAwLH3
        lRA8tsBW/Lj6+jac9Qpwv7hUaycgpsMgVM0nGHR54NBROKagMGmV0XxxrhvSGZBnaIEwkY
        gTgPAqADkRU6TT9NKk1fBuSI7np8npE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-94-LxOjIfJ_Nbe2RzyVYSkHDA-1; Tue, 01 Dec 2020 03:45:05 -0500
X-MC-Unique: LxOjIfJ_Nbe2RzyVYSkHDA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7B9D1012774;
        Tue,  1 Dec 2020 08:44:36 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-159.rdu2.redhat.com [10.10.112.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 124FF19D9B;
        Tue,  1 Dec 2020 08:44:33 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20201127050701.GA22001@gondor.apana.org.au>
References: <20201127050701.GA22001@gondor.apana.org.au> <20201126063303.GA18366@gondor.apana.org.au> <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk> <1976719.1606378781@warthog.procyon.org.uk>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     dhowells@redhat.com, bfields@fieldses.org,
        trond.myklebust@hammerspace.com, linux-crypto@vger.kernel.org,
        linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 00/18] crypto: Add generic Kerberos library
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4035244.1606812273.1@warthog.procyon.org.uk>
Date:   Tue, 01 Dec 2020 08:44:33 +0000
Message-ID: <4035245.1606812273@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Btw, would it be feasible to make it so that an extra parameter can be added
to the cipher buffer-supplying functions, e.g.:

	skcipher_request_set_crypt(req, input, ciphertext_sg, esize, iv);

such that we can pass in an offset into the output sg as well?

David

