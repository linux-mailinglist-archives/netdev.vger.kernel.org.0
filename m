Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50AA11E8651
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 20:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbgE2SJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 14:09:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23435 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726970AbgE2SJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 14:09:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590775780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Re5Y7GYMgF5tXEOvc1Z0y7a6ywWpDP5iMSjUtX5Bfvo=;
        b=NCVof1wTgxG6oEKfq91KR8d/EPyq3VqmBmmD1gy4+oJjXYleHrBe08ZkUPqGh050OKhN9B
        IzXjRhXOk45H3x3147A/QWw8d5Bm578cCW5QsODJblU/gsbzzsRprDdr0BviVtS2k3e0zZ
        y0QPouGiZrbsBV9Zq5tiFk6ZfPCPx1M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-I6PWn1K-O66L9uMR8gHoUg-1; Fri, 29 May 2020 14:09:36 -0400
X-MC-Unique: I6PWn1K-O66L9uMR8gHoUg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3206A81CBE1;
        Fri, 29 May 2020 18:09:35 +0000 (UTC)
Received: from redhat.com (null.msp.redhat.com [10.15.80.136])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7D56E60BE2;
        Fri, 29 May 2020 18:09:27 +0000 (UTC)
Date:   Fri, 29 May 2020 13:09:25 -0500
From:   David Teigland <teigland@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org,
        cluster-devel@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH 1/4] sctp: add sctp_sock_set_nodelay
Message-ID: <20200529180925.GB25942@redhat.com>
References: <20200529120943.101454-1-hch@lst.de>
 <20200529120943.101454-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529120943.101454-2-hch@lst.de>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 02:09:40PM +0200, Christoph Hellwig wrote:
> Add a helper to directly set the SCTP_NODELAY sockopt from kernel space
> without going through a fake uaccess.

Ack, they look fine to me, thanks.
Dave

