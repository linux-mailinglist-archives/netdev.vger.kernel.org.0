Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3FB31552E3
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 08:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbgBGHXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 02:23:25 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29877 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726451AbgBGHXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 02:23:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581060204;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B/1eHis89MpyLuxYDGM/uGf+wxAz3YIEtRor+3W21dw=;
        b=e4wqmYsumtzlwTfVQG8/2Fw3C8+moVh4IlE71pPekFSKimBLwTNBEvSezHxVDK+R/mNd+1
        3/epPSxW3rZzQHCA0jx9MXIBRhPMABpQr4Rj9o9d+E0jEo5/eWeRdg3L5fKHThUPRysraz
        u+d2c6UIVtr3d3FV2QNtgB2xZMsZp+k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-w5vvEUNNNmCIBUUG-UCjJQ-1; Fri, 07 Feb 2020 02:23:16 -0500
X-MC-Unique: w5vvEUNNNmCIBUUG-UCjJQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 69644DB64;
        Fri,  7 Feb 2020 07:23:15 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-218.rdu2.redhat.com [10.10.120.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 88CF78E9FE;
        Fri,  7 Feb 2020 07:23:13 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20200207031553.18696-1-hdanton@sina.com>
References: <20200207031553.18696-1-hdanton@sina.com> <20200204084005.11320-1-hdanton@sina.com>
To:     Hillf Danton <hdanton@sina.com>
Cc:     dhowells@redhat.com,
        syzbot <syzbot+3f1fd6b8cbf8702d134e@syzkaller.appspotmail.com>,
        davem@davemloft.net, kuba@kernel.org,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: inconsistent lock state in rxrpc_put_client_conn
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2394695.1581060192.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Fri, 07 Feb 2020 07:23:12 +0000
Message-ID: <2394696.1581060192@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I've posted a patch for this:

https://lore.kernel.org/netdev/158099746025.2198892.1158535190228552910.st=
git@warthog.procyon.org.uk/

David

