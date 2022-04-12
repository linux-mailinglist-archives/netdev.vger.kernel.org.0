Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 584234FDBC3
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 12:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240966AbiDLKGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 06:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345321AbiDLIkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 04:40:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AE65124970
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 01:06:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649750773;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IKyMecw34mvNL0m09Rq7fGdvRzCKMEJrRjIkdTThMmM=;
        b=YzSgmxnDd38GmkvmSmAlWdpk2ZEtiTAPSF0U5t6+PQx6eXyp/E3S/MP6cRl/A24Ht5ilMc
        pMd7zxKaXPp6bSjw6C6mz2KEMfDAJZpRd8sC7PYAHwuMWgVsbkL+1DTj8pvmd3RuGZWRbA
        VvDe7KCxvFSy4z6cXM9frjklHD9mFXQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-245-Ebv2GUKcPUih_n8ADkEabQ-1; Tue, 12 Apr 2022 04:06:10 -0400
X-MC-Unique: Ebv2GUKcPUih_n8ADkEabQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F203D811E80;
        Tue, 12 Apr 2022 08:06:09 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.37.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A950740CF91A;
        Tue, 12 Apr 2022 08:06:08 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20220404183439.3537837-1-eric.dumazet@gmail.com>
References: <20220404183439.3537837-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     dhowells@redhat.com, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net] rxrpc: fix a race in rxrpc_exit_net()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1313753.1649750767.1@warthog.procyon.org.uk>
Date:   Tue, 12 Apr 2022 09:06:07 +0100
Message-ID: <1313754.1649750767@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do you have a syzbot ref for this?

David

