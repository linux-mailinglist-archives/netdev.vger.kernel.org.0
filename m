Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D29211039D1
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 13:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728770AbfKTMP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 07:15:26 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34328 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728251AbfKTMP0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 07:15:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574252125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WcvwZMxhslhG4dsNrv6GszT7n4F02ToMpsBwIyIVvDs=;
        b=ZWB40VvpUgAkgLiHRy9eLEAPgVBvU6ViKHgYdXh6PG/iJAi5/5rEUoWiwfkDIKB2gJlAkM
        uDv3vfCwY9LkCf1bprNhHWovH7UdGy+nkTVvYYYI9hXYbY1eSmUTzcfCoqTjWbw9wsL6vX
        LNVUW2LYiFgpHj7RLTzQu1gc8rGIAio=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-L3dTSSP6PxShzajHue1fKA-1; Wed, 20 Nov 2019 07:15:19 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C507A80268B;
        Wed, 20 Nov 2019 12:15:17 +0000 (UTC)
Received: from carbon (ovpn-200-17.brq.redhat.com [10.40.200.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A4D2B7BF91;
        Wed, 20 Nov 2019 12:15:13 +0000 (UTC)
Date:   Wed, 20 Nov 2019 13:15:12 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        brouer@redhat.com
Subject: Re: [PATCH net-next V3 0/3] page_pool: API for numa node change
 handling
Message-ID: <20191120131512.65e38054@carbon>
In-Reply-To: <20191120001456.11170-1-saeedm@mellanox.com>
References: <20191120001456.11170-1-saeedm@mellanox.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: L3dTSSP6PxShzajHue1fKA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Nov 2019 00:15:14 +0000
Saeed Mahameed <saeedm@mellanox.com> wrote:

> Performance analysis and conclusions by Jesper [1]:
> Impact on XDP drop x86_64 is inconclusive and shows only 0.3459ns
> slow-down, as this is below measurement accuracy of system.

Yes, I have had time to micro-benchmark this (on Intel), and given I
cannot demonstrate statistically significant slowdown, I'm going to
accept this change to the fast-path of page_pool.

For series:

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

(I'm going to ack each patch, in-order to make patchwork pickup the
ACK, and hopefully make this easier for DaveM).


> v2->v3:
>  - Rebase on top of latest net-next and Jesper's page pool object
>    release patchset [2]
>  - No code changes
>  - Performance analysis by Jesper added to the cover letter.
>=20
> v1->v2:
>   - Drop last patch, as requested by Ilias and Jesper.
>   - Fix documentation's performance numbers order.

>=20
> [1] https://github.com/xdp-project/xdp-project/blob/master/areas/mem/page=
_pool04_inflight_changes.org#performance-notes
> [2] https://patchwork.ozlabs.org/cover/1192098/



--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

