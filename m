Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 847B0EB837
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 21:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729708AbfJaUEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 16:04:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50937 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726741AbfJaUEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 16:04:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572552260;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x/cVvd5VoLn8nmT/4BoNHxHd9nJ9nHnmdXdwhFCtsQE=;
        b=WP/aJpi/ABRL9hXX2GOJX1rspoxr5WLypADxZIL/5JVALDViVqrjjUC2kIOF07AOUXVdPO
        zWT67suAT55KncWK1ZhLm+8YeNxistaljQkPwqot1HnaWgkMu3xo14b3MnB20qEvWx8ppq
        a5am5jIzUZoKfJaErAwMpe8GJLyhAww=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-4ljBDfVKOV2ughF_bX2vvQ-1; Thu, 31 Oct 2019 16:04:16 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3041A800D49;
        Thu, 31 Oct 2019 20:04:15 +0000 (UTC)
Received: from carbon (ovpn-200-19.brq.redhat.com [10.40.200.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 84E8A60BE0;
        Thu, 31 Oct 2019 20:04:10 +0000 (UTC)
Date:   Thu, 31 Oct 2019 21:04:09 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Charles McLachlan <cmclachlan@solarflare.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-net-drivers@solarflare.com>, brouer@redhat.com
Subject: Re: [PATCH net-next v4 4/6] sfc: allocate channels for XDP tx
 queues
Message-ID: <20191031210409.0b45a68c@carbon>
In-Reply-To: <c7b5b78a-3679-cb63-7e7e-6386a32f374f@solarflare.com>
References: <c0294a54-35d3-2001-a2b9-dd405d2b3501@solarflare.com>
        <c7b5b78a-3679-cb63-7e7e-6386a32f374f@solarflare.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: 4ljBDfVKOV2ughF_bX2vvQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 31 Oct 2019 10:23:49 +0000
Charles McLachlan <cmclachlan@solarflare.com> wrote:

> Each CPU needs access to its own queue to allow uncontested
> transmission of XDP_TX packets. This means we need to allocate (up
> front) enough channels ("xdp transmit channels") to provide at least
> one extra tx queue per CPU. These tx queues should not do TSO.
>=20
> Signed-off-by: Charles McLachlan <cmclachlan@solarflare.com>

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

