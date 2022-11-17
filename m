Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03DB462DA62
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 13:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240013AbiKQMMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 07:12:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239945AbiKQML7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 07:11:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E8962EF44
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 04:11:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668687064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nuETtLvYCdnVtGqJ4ys9BecIpGQszFoEMb7uCuEIkDg=;
        b=g253EJFjqhwEtiXamXwC4y3tgMXfkLQPXqytiBNHhz8NMioY8z4NBLioHrICbMTsg8Quyi
        h8DTJm4PjiLQE1D4jYlWQ/Vl/VAi41I3NhtWoZz4GbT841CJ3+qY9rsDb4TjXu8etU3o0g
        1Fhc5aNC4LF8VhBMgD2lDlNW5OMBvQA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-z1ztzz0tMY-U_s5OO7AnSg-1; Thu, 17 Nov 2022 07:11:02 -0500
X-MC-Unique: z1ztzz0tMY-U_s5OO7AnSg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4EB8D862FDC;
        Thu, 17 Nov 2022 12:11:02 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 29F024B3FCE;
        Thu, 17 Nov 2022 12:11:01 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <Y3XmKhBt5fclE6XC@kili>
References: <Y3XmKhBt5fclE6XC@kili>
To:     Dan Carpenter <error27@gmail.com>
Cc:     dhowells@redhat.com, Marc Dionne <marc.dionne@auristor.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] rxrpc: fix rxkad_verify_response()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3709167.1668687058.1@warthog.procyon.org.uk>
Date:   Thu, 17 Nov 2022 12:10:58 +0000
Message-ID: <3709168.1668687058@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dan Carpenter <error27@gmail.com> wrote:

> The error handling for if skb_copy_bits() fails was accidentally deleted
> so the rxkad_decrypt_ticket() function is not called.
> 
> Fixes: 5d7edbc9231e ("rxrpc: Get rid of the Rx ring")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: David Howells <dhowells@redhat.com>

