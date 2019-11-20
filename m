Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3767710427E
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 18:49:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728397AbfKTRto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 12:49:44 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:53841 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728364AbfKTRtm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 12:49:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574272181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ODjoOFrCfJWqH0REftGehGkeWkjV+sQmFgs/zUioQPI=;
        b=P6ibUNPaoyGn4efNlYLD1e8DHi0PH1ptbaUqX2uTqGzBIwIgbFcb0F7AryRORTOZ1Ufcgh
        o5gJNVH5/01CEn306yCjEs9TUod9BA/2BPVQJH7TwsTQNI/m/LxWZuzb3jvVyHo8ZtU4BB
        AzlQdg77bE6JIItQevbYvWPRqOPU+F4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-5dlIfxnZMYCoUr3U-Ua0aw-1; Wed, 20 Nov 2019 12:49:40 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 55D3E477;
        Wed, 20 Nov 2019 17:49:39 +0000 (UTC)
Received: from carbon (ovpn-200-17.brq.redhat.com [10.40.200.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DF7B51C7;
        Wed, 20 Nov 2019 17:49:31 +0000 (UTC)
Date:   Wed, 20 Nov 2019 18:49:30 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        ilias.apalodimas@linaro.org, lorenzo.bianconi@redhat.com,
        mcroce@redhat.com, jonathan.lemon@gmail.com, brouer@redhat.com
Subject: Re: [PATCH v5 net-next 3/3] net: mvneta: get rid of huge dma sync
 in mvneta_rx_refill
Message-ID: <20191120184930.421e7b82@carbon>
In-Reply-To: <1e945f45259c09da6f5876a11e0bedd955c9d695.1574261017.git.lorenzo@kernel.org>
References: <cover.1574261017.git.lorenzo@kernel.org>
        <1e945f45259c09da6f5876a11e0bedd955c9d695.1574261017.git.lorenzo@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: 5dlIfxnZMYCoUr3U-Ua0aw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Nov 2019 16:54:19 +0200
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> Get rid of costly dma_sync_single_for_device in mvneta_rx_refill
> since now the driver can let page_pool API to manage needed DMA
> sync with a proper size.
>=20
> - XDP_DROP DMA sync managed by mvneta driver:=09~420Kpps
> - XDP_DROP DMA sync managed by page_pool API:=09~585Kpps
>=20
> Tested-by: Matteo Croce <mcroce@redhat.com>

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

