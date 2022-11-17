Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBE562DA2A
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 13:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239830AbiKQMFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 07:05:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239908AbiKQMFU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 07:05:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E0921B2
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 04:04:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668686667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qrMf7ylVcpabMKACoAsS+EsmuZfYjDPBDOs0DgnUe0E=;
        b=gbq0DK9Wa1CAnIBvyg/xIasHUKO+WSAokwHSq9ncTYkB9bBsbniFYi+uJAijKJjNa4Rt4G
        qRyqq8lClBfjxSl7w8AeHNpbvuggercsGEJ7KW6fDFZFYZ+dK5BtushMWi1VRhjQZWS+Eq
        eIlLgZGzZ9l9boyo4FnhuT4tZJKPm3Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-vWekJQalNeiaOt7325Gqlg-1; Thu, 17 Nov 2022 07:04:23 -0500
X-MC-Unique: vWekJQalNeiaOt7325Gqlg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0207F811E7A;
        Thu, 17 Nov 2022 12:04:23 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D57E640C83EB;
        Thu, 17 Nov 2022 12:04:21 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <Y3XmQsOFwTHUBSLU@kili>
References: <Y3XmQsOFwTHUBSLU@kili>
To:     Dan Carpenter <error27@gmail.com>
Cc:     dhowells@redhat.com, Marc Dionne <marc.dionne@auristor.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] rxrpc: uninitialized variable in rxrpc_send_ack_packet()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3708529.1668686659.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 17 Nov 2022 12:04:19 +0000
Message-ID: <3708530.1668686659@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dan Carpenter <error27@gmail.com> wrote:

> The "pkt" was supposed to have been deleted in a previous patch.  It
> leads to an uninitialized variable bug.
> =

> Fixes: 72f0c6fb0579 ("rxrpc: Allocate ACK records at proposal and queue =
for transmission")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: David Howells <dhowells@redhat.com>

