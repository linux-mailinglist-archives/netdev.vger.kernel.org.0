Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8AB4EDECC
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 18:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239944AbiCaQ1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 12:27:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239934AbiCaQ12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 12:27:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9E4BE5FF35
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 09:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648743940;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4cL6sv+iE7W1OShvGrAaZLqndqMYHrw6Rc98Wbo8jy4=;
        b=HwsK3ekq/z06gvKNxoMFisLu026vG9baIAZW8xhnsRHjBijJlcO/nieJBJy3mae+AeAskA
        Ivj2EGcQqsQBKrnwEAiMbM/5rELMyuQwtixkONAyElNyR1TeKjbXsl5wcTeYmmqC9apYNt
        XJE6ES82PuXMSr5+e1j/agM67RFzLEE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-248-Wwj2N_UgOa6qR4XEzVvqJw-1; Thu, 31 Mar 2022 12:25:39 -0400
X-MC-Unique: Wwj2N_UgOa6qR4XEzVvqJw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AA82D185A79C;
        Thu, 31 Mar 2022 16:25:38 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1521D2026D65;
        Thu, 31 Mar 2022 16:25:37 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20220331083446.1d833d78@kernel.org>
References: <20220331083446.1d833d78@kernel.org> <3097539.1648715523@warthog.procyon.org.uk>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     dhowells@redhat.com, davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: Could you update the http://vger.kernel.org/~davem/net-next.html url?
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3260215.1648743937.1@warthog.procyon.org.uk>
Date:   Thu, 31 Mar 2022 17:25:37 +0100
Message-ID: <3260216.1648743937@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:

> >       http://vger.kernel.org/~davem/net-next.html
> > 
> > but the URL no longer points anywhere useful.  Could you update that?
> 
> It should display an image of a door sign saying "open" or "closed".
> What do you see?

A door sign saying "Sorry we're closed".  That would seem to indicate that the
URL is essentially defunct.

David

