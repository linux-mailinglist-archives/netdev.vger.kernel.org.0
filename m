Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 406A26372D2
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 08:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbiKXHN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 02:13:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiKXHNS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 02:13:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A34FCE9C7
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 23:15:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669274103;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lP707BwfQgKnlZOfdqaylAUd1tPryakkz8FSroX5OJE=;
        b=L7+qWnMQ/hjcBCmGSfqXdx5fGlCVARQXb00YZhoO18naWT8tDTdAN0JTD45QnR4eUW7Z5T
        y+S4xoA0X6kW+gv4LInwVl/K3ZHWcSybrXulj2pAIGRrwJ5pU6Dy/QiDJalyWW2o+8qLO+
        Lhn/9iwXhIbIiT0Yd8T0KlsrrbWEnqI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-567-hb8_fqEEOzuhn_v2l0Ftqw-1; Thu, 24 Nov 2022 02:08:14 -0500
X-MC-Unique: hb8_fqEEOzuhn_v2l0Ftqw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 49DC23806714;
        Thu, 24 Nov 2022 07:08:13 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 96A2B492B04;
        Thu, 24 Nov 2022 07:08:11 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20221123192335.119335ac@kernel.org>
References: <20221123192335.119335ac@kernel.org> <166919798040.1256245.11495568684139066955.stgit@warthog.procyon.org.uk>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     dhowells@redhat.com, netdev@vger.kernel.org,
        linux-afs@lists.infradead.org,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 00/13] rxrpc: Increasing SACK size and moving away from softirq, part 2
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1869060.1669273688.1@warthog.procyon.org.uk>
Date:   Thu, 24 Nov 2022 07:08:08 +0000
Message-ID: <1869061.1669273688@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

What's the best way to base on a fix commit that's in net for patches in
net-next?  Here I tried basing on a merge between them.  Should I include the
fix patch on my net-next branch instead? Or will net be merged into net-next
at some point and I should wait for that?

Thanks,
David

