Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49CFA4ED5A7
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 10:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232847AbiCaIeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 04:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232710AbiCaIeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 04:34:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 33C65265E
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 01:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648715533;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=qRY7JKTwj3EwR6E8cHA785JcbodmkYG6EGDrjFIXkt8=;
        b=KKsclkJMgR9+ZxufWKCJL03YklcnWBOTU7iiYbuck9XaXSALJWf0ZDs93LFNWc1h4m2Gd+
        jQyEX/Qc1hv3LoaXz4vaa/AI3s/aUp+ALGuEj7S2N0WGm/g8oDnxkcLET0r6FHoTrT4EE8
        loBd7Ognb/d8GptSOBpdSFKG3pi8R1I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-50-XYHG5Hf9Pc2yJR-BE8HqJg-1; Thu, 31 Mar 2022 04:32:11 -0400
X-MC-Unique: XYHG5Hf9Pc2yJR-BE8HqJg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6EB9E802803;
        Thu, 31 Mar 2022 08:32:10 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B1E675B082E;
        Thu, 31 Mar 2022 08:32:06 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
To:     davem@davemloft.net
cc:     dhowells@redhat.com, netdev@vger.kernel.org
Subject: Could you update the http://vger.kernel.org/~davem/net-next.html url?
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3097538.1648715523.1@warthog.procyon.org.uk>
Date:   Thu, 31 Mar 2022 09:32:03 +0100
Message-ID: <3097539.1648715523@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

In Documentation/networking/netdev-FAQ.rst it mentions:

    If you aren't subscribed to netdev and/or are simply unsure if
    ``net-next`` has re-opened yet, simply check the ``net-next`` git
    repository link above for any new networking-related commits.  You may
    also check the following website for the current status:

      http://vger.kernel.org/~davem/net-next.html

but the URL no longer points anywhere useful.  Could you update that?

Thanks,
David

