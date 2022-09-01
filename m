Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1987C5A946D
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 12:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234014AbiIAKXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 06:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234020AbiIAKXi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 06:23:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA291360A2
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 03:23:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662027816;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wcELDvI8lz+P8fQWhkWVynVIxW+VnN22dIpeCjTRvjE=;
        b=KDsIoQL0VpMP111iADP+9PsmRo3Qz3vshsz9Dwpf06Vyjorc19Lw91QawIZaHeLfrG3E6B
        JcswM0RZwcJBCmTESHeoMZCakL1tqSogk80B0D6ubvNFxZ7gqThSU0Olwj/Z0CDVOGoSH7
        s/0tx8S5/GdA5kJHdTqK/WfzVnH3nG4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-633-OmJ1robpO4aXG49sZf7weQ-1; Thu, 01 Sep 2022 06:23:33 -0400
X-MC-Unique: OmJ1robpO4aXG49sZf7weQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 203E4805B9A;
        Thu,  1 Sep 2022 10:23:33 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 637C8492C3B;
        Thu,  1 Sep 2022 10:23:32 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <166201964443.3817988.12088441548413332725.stgit@warthog.procyon.org.uk>
References: <166201964443.3817988.12088441548413332725.stgit@warthog.procyon.org.uk>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org,
        Jeffrey E Altman <jaltman@auristor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/6] rxrpc: Miscellaneous fixes
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4129910.1662027811.1@warthog.procyon.org.uk>
Date:   Thu, 01 Sep 2022 11:23:31 +0100
Message-ID: <4129912.1662027811@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please don't pull this.  The kernel test robot spotted a bug in it.

David

