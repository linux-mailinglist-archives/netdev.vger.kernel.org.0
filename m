Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02079284C9E
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 15:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725970AbgJFNkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 09:40:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39781 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725906AbgJFNkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 09:40:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601991611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dMSX3M4ms1Pfyuj4AFtJd//I37UaeKB5Z21Mn27FVzA=;
        b=ZOXvTzNW2jCNfpZmn7LBB+9V8jGv3OulJ4IXeNuK7l0P+7jZb1WpHfjYElVwaA/bhH3wCI
        YGtRXj9hSGH0Es2/9kw0VIf/a9S+YsXbE0CuXNmDrL2Qr48BbcvH8Z+8KTFBSBp9DrwSTo
        2lwyaT2CCf9AgqLrTa4eozfiQupPpVs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-a50WqnLVMfilPYw22XVeiw-1; Tue, 06 Oct 2020 09:40:09 -0400
X-MC-Unique: a50WqnLVMfilPYw22XVeiw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 041E6805F11;
        Tue,  6 Oct 2020 13:40:07 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-116-196.rdu2.redhat.com [10.10.116.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6E1E660C5C;
        Tue,  6 Oct 2020 13:40:05 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20201006.061910.2028674026807610400.davem@davemloft.net>
References: <20201006.061910.2028674026807610400.davem@davemloft.net> <160191472433.3050642.12600839710302704718.stgit@warthog.procyon.org.uk>
To:     David Miller <davem@davemloft.net>
Cc:     dhowells@redhat.com, netdev@vger.kernel.org,
        marc.dionne@auristor.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/6] rxrpc: Miscellaneous fixes
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3385883.1601991604.1@warthog.procyon.org.uk>
Date:   Tue, 06 Oct 2020 14:40:04 +0100
Message-ID: <3385884.1601991604@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Miller <davem@davemloft.net> wrote:

> I think the ".txt" at the end of the branch name is a mistake.

Sigh.  That's the name of the file with the cover message in it (named for the
tag).  I need to adjust my script yet more to check not only that the tag name
is in there, but that it also doesn't have any bits on the end.

David

