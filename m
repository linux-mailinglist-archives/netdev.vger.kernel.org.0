Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05B39F882B
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 06:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbfKLFmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 00:42:50 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:47312 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726981AbfKLFmu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 00:42:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573537369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=76U/1YEmgN9yWhXQEk/weE5G9j9NWPj0HeYjR1VvkXI=;
        b=clD8BWQaURJ4sanAe5zEq0yx7j59x949YRVa7gIfPZN53I25OevX1EBKFKMvbHsBHy/Ck+
        e6UoFFC9mZa5ZwClS0LI0MhtWkX7XWGfQv61CBtGps/v4aC3ZKCLR4rNyCMlgY7leKGg0t
        OaWBZ88Pc/g8eXlb4GVBON+LNCYGXrM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-e0RyBr4ePt2i1G0O3Vrf6w-1; Tue, 12 Nov 2019 00:42:44 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED202DB5D;
        Tue, 12 Nov 2019 05:42:42 +0000 (UTC)
Received: from localhost (ovpn-112-54.rdu2.redhat.com [10.10.112.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 176FC63742;
        Tue, 12 Nov 2019 05:42:38 +0000 (UTC)
Date:   Mon, 11 Nov 2019 21:42:37 -0800 (PST)
Message-Id: <20191111.214237.704198386375428842.davem@redhat.com>
To:     brouer@redhat.com
Cc:     linux-kbuild@vger.kernel.org, netdev@vger.kernel.org,
        acme@kernel.org, borkmann@iogearbox.net,
        alexei.starovoitov@gmail.com
Subject: Re: [net-next PATCH] samples/bpf: adjust Makefile and README.rst
From:   David Miller <davem@redhat.com>
In-Reply-To: <157340347607.14617.683175264051058224.stgit@firesoul>
References: <157340347607.14617.683175264051058224.stgit@firesoul>
Mime-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: e0RyBr4ePt2i1G0O3Vrf6w-1
X-Mimecast-Spam-Score: 0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>
Date: Sun, 10 Nov 2019 17:31:16 +0100

> Side effect of some kbuild changes resulted in breaking the
> documented way to build samples/bpf/.
>=20
> This patch change the samples/bpf/Makefile to work again, when
> invoking make from the subdir samples/bpf/. Also update the
> documentation in README.rst, to reflect the new way to build.
>=20
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

Applied.

