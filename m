Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3518B1039D6
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 13:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729649AbfKTMPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 07:15:50 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:52198 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728251AbfKTMPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 07:15:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574252148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yKnRYcmNL8BJ1ug3MK+Wuum2nKK0BHEptu0V4+b6Ml0=;
        b=D2ObYBJMf8q5pjzX2L0xa7+KzWRL9z2iVA8AJ+U+HM7/Hin74OnSjL6kmztPQOW23y/Pxt
        FcYaDww2CeAUzbPJwDbkaGerg31SClFoQItEyoeO4pq00QHv1xou9+xGlrTvy+9hsR1j7V
        RluMNLDDOG6U7IO8H/XaQpU3gbdaVd0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-131-Nnr_LN0bN1uhlV3AfYj6lg-1; Wed, 20 Nov 2019 07:15:45 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E8FFD1883522;
        Wed, 20 Nov 2019 12:15:43 +0000 (UTC)
Received: from carbon (ovpn-200-17.brq.redhat.com [10.40.200.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2884F66D5C;
        Wed, 20 Nov 2019 12:15:38 +0000 (UTC)
Date:   Wed, 20 Nov 2019 13:15:37 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        brouer@redhat.com
Subject: Re: [PATCH net-next V3 1/3] page_pool: Add API to update numa node
Message-ID: <20191120131537.5481402e@carbon>
In-Reply-To: <20191120001456.11170-2-saeedm@mellanox.com>
References: <20191120001456.11170-1-saeedm@mellanox.com>
        <20191120001456.11170-2-saeedm@mellanox.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: Nnr_LN0bN1uhlV3AfYj6lg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Nov 2019 00:15:17 +0000
Saeed Mahameed <saeedm@mellanox.com> wrote:

> Add page_pool_update_nid() to be called by page pool consumers when they
> detect numa node changes.
>=20
> It will update the page pool nid value to start allocating from the new
> effective numa node.
>=20
> This is to mitigate page pool allocating pages from a wrong numa node,
> where the pool was originally allocated, and holding on to pages that
> belong to a different numa node, which causes performance degradation.
>=20
> For pages that are already being consumed and could be returned to the
> pool by the consumer, in next patch we will add a check per page to avoid
> recycling them back to the pool and return them to the page allocator.
>=20
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

