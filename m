Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E49C1D14AF
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 15:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387659AbgEMNZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 09:25:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47736 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387608AbgEMNZk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 09:25:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589376338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d/0WQiW+co/T0Lh806Aa2CF0lrVFjIjJV8t4w61WLTw=;
        b=HyPMrQAVCoA9TwjWHmuIkLwMpDeZ0dvqnHvbnZM8NjUP2RYf/ned0zXjoc4OWWn1s2SNJB
        VdvncxMmBAgjgiDU34hJrXnpYaP7YA7qo53JX1lBEkz0KHyuB+2Y6KmtraZXuDSiJs/Rp8
        r9BQZUd97LjpY+QOHcCU0ugdURKGEII=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-QSRiE1hJM-O7Lq496hJNkw-1; Wed, 13 May 2020 09:25:35 -0400
X-MC-Unique: QSRiE1hJM-O7Lq496hJNkw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 360CB18FE866;
        Wed, 13 May 2020 13:25:30 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-59.rdu2.redhat.com [10.10.112.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 31ED9783B3;
        Wed, 13 May 2020 13:25:19 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20200513062649.2100053-24-hch@lst.de>
References: <20200513062649.2100053-24-hch@lst.de> <20200513062649.2100053-1-hch@lst.de>
To:     Christoph Hellwig <hch@lst.de>
Cc:     dhowells@redhat.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-nvme@lists.infradead.org, linux-sctp@vger.kernel.org,
        target-devel@vger.kernel.org, linux-afs@lists.infradead.org,
        drbd-dev@lists.linbit.com, linux-cifs@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-rdma@vger.kernel.org,
        cluster-devel@redhat.com, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-nfs@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>,
        linux-kernel@vger.kernel.org, Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 23/33] ipv6: add ip6_sock_set_recverr
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3124570.1589376319.1@warthog.procyon.org.uk>
Date:   Wed, 13 May 2020 14:25:19 +0100
Message-ID: <3124571.1589376319@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christoph Hellwig <hch@lst.de> wrote:

> Add a helper to directly set the IPV6_RECVERR sockopt from kernel space
> without going through a fake uaccess.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: David Howells <dhowells@redhat.com>

