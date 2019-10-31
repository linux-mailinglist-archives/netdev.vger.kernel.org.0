Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEA33EB831
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 21:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729679AbfJaUBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 16:01:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30993 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726741AbfJaUBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 16:01:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572552058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RTpF6GqH68/rZyVC7XNMQC2QLcczOOpZ7s1kBXXz3Hs=;
        b=JxBEcAC2nL3uYFkekELtnpIY2YUJliMw/hVIqm0Y/nWJ4yaBdqlgedAJtlLYnh13IZ+LWK
        uhjaRhpGguOleWt4M5OjFbXMKoTrd7m84qPdM6KJObLqlUY6LpXj/n1CWRPLf/Ebi2vVUC
        yLqfPcinhq4DErqM9pvFz3GcPy2M9bA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-I7uIp5HkNaWxQpqxNvbFMQ-1; Thu, 31 Oct 2019 16:00:52 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 864EB8017E0;
        Thu, 31 Oct 2019 20:00:51 +0000 (UTC)
Received: from carbon (ovpn-200-19.brq.redhat.com [10.40.200.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 672925D9CA;
        Thu, 31 Oct 2019 20:00:47 +0000 (UTC)
Date:   Thu, 31 Oct 2019 21:00:46 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Charles McLachlan <cmclachlan@solarflare.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-net-drivers@solarflare.com>, brouer@redhat.com
Subject: Re: [PATCH net-next v4 3/6] sfc: Enable setting of xdp_prog
Message-ID: <20191031210046.3c36478b@carbon>
In-Reply-To: <c5da10a4-884d-e94b-1473-00b9d9a2d5d2@solarflare.com>
References: <c0294a54-35d3-2001-a2b9-dd405d2b3501@solarflare.com>
        <c5da10a4-884d-e94b-1473-00b9d9a2d5d2@solarflare.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: I7uIp5HkNaWxQpqxNvbFMQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 31 Oct 2019 10:23:37 +0000
Charles McLachlan <cmclachlan@solarflare.com> wrote:

> Provide an ndo_bpf function to efx_netdev_ops that allows setting and
> querying of xdp programs on an interface.
>=20
> Also check that the MTU size isn't too big when setting a program or
> when the MTU is explicitly set.
>=20
> Signed-off-by: Charles McLachlan <cmclachlan@solarflare.com>
> ---
>  drivers/net/ethernet/sfc/efx.c | 70 ++++++++++++++++++++++++++++++++++
>  1 file changed, 70 insertions(+)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

