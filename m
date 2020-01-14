Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8FD13A7A9
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 11:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729290AbgANKna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 05:43:30 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23556 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726044AbgANKn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 05:43:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578998608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V/H2vuUfZ3zrlOmMB/hhcIqpKaCYyix9SS1PeB4Iw+Y=;
        b=IT4zTQrGc1uROKAGWI6j9EL/W2EVyotNqwK9KAnnEsuIwN5BaQ8uvBT10XZR/gbzBZ8VAh
        FdWjNYcFLLLbgJGMlvP9g/yJSidG7QRVP8v/lfuVMjL5Kf/DL734Mz0WDDvGnCixy5kgva
        i0MfcTMiYPhC20CUFtw6Lq6zjFTfhS0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-2-1_SDsLcbNvSbxVfbCwPpCw-1; Tue, 14 Jan 2020 05:43:27 -0500
X-MC-Unique: 1_SDsLcbNvSbxVfbCwPpCw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BDDA218AAFA1;
        Tue, 14 Jan 2020 10:43:25 +0000 (UTC)
Received: from carbon (ovpn-200-25.brq.redhat.com [10.40.200.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF17660BE2;
        Tue, 14 Jan 2020 10:43:18 +0000 (UTC)
Date:   Tue, 14 Jan 2020 11:43:17 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, ilias.apalodimas@linaro.org, kuba@kernel.org,
        brouer@redhat.com
Subject: Re: [PATCH net] net: mvneta: fix dma sync size in mvneta_run_xdp
Message-ID: <20200114114317.333a6dd7@carbon>
In-Reply-To: <c73de2bf79cc3d2f6d4f8c8864ff6a64198db2c8.1578996931.git.lorenzo@kernel.org>
References: <c73de2bf79cc3d2f6d4f8c8864ff6a64198db2c8.1578996931.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Jan 2020 11:21:16 +0100
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> Page pool API will start syncing (if requested) starting from
> page->dma_addr + pool->p.offset. Fix dma sync length in
> mvneta_run_xdp since we do not need to account xdp headroom
> 
> Fixes: 07e13edbb6a6 ("net: mvneta: get rid of huge dma sync in mvneta_rx_refill")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Looks correct to me.

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

