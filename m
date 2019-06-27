Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 205DE58D9C
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 00:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbfF0WHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 18:07:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35652 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726523AbfF0WHP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 18:07:15 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2F340309264C;
        Thu, 27 Jun 2019 22:07:07 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-57.rdu2.redhat.com [10.10.120.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EBE31608C1;
        Thu, 27 Jun 2019 22:07:04 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CAF=yD-Kgdwt5=0iboxhvZz4zvNewSGow74U15mQQvO1u8VUGcw@mail.gmail.com>
References: <CAF=yD-Kgdwt5=0iboxhvZz4zvNewSGow74U15mQQvO1u8VUGcw@mail.gmail.com> <156096279115.28733.8761881995303698232.stgit@warthog.procyon.org.uk> <156096287188.28733.15342608110117616221.stgit@warthog.procyon.org.uk>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     dhowells@redhat.com, "Eric W. Biederman" <ebiederm@xmission.com>,
        keyrings@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-nfs@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        linux-afs@lists.infradead.org, dwalsh@redhat.com,
        vgoyal@redhat.com, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/9] keys: Network namespace domain tag [ver #4]
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <30672.1561673224.1@warthog.procyon.org.uk>
Date:   Thu, 27 Jun 2019 23:07:04 +0100
Message-ID: <30674.1561673224@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Thu, 27 Jun 2019 22:07:15 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:

> > +#ifdef CONFIG_KEYS
> > +out_free_2:
> > +       kmem_cache_free(net_cachep, net);
> 
> needs
>             net = NULL;
> 
> to signal failure
> 
> > +#endif

I've folded that into the patch and retagged, remerged and repushed.

David
