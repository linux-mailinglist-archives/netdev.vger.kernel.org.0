Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2403944BB
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 16:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236278AbhE1PAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 11:00:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42747 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235676AbhE1PAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 11:00:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622213935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+09fWLZ1LzGSmUqTDbtBGdCUB/3cnryBQroLXDrOho0=;
        b=YpjTJpzXCYcixqR5P7DIxyW5g2BZn8yAjzC0e96OG1YC48UeLzGPEMTjEShgX2UtDlU7X5
        2n04q5qCPZJoeNO/rfO8fuhwS2mYJ3O0XhSTaucL7A4nTrxAlw39hVHOeZKn/USUFeX/XF
        3VqbTtQBRpRVGQxP+gkTJSvECMvTPVU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-329hAd5SM9mQmX9-aKrcxQ-1; Fri, 28 May 2021 10:58:54 -0400
X-MC-Unique: 329hAd5SM9mQmX9-aKrcxQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 23FEA1007467;
        Fri, 28 May 2021 14:58:53 +0000 (UTC)
Received: from carbon (unknown [10.36.110.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C097960918;
        Fri, 28 May 2021 14:58:45 +0000 (UTC)
Date:   Fri, 28 May 2021 16:58:44 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com
Subject: Re: [PATCH v2 net-next] samples: pktgen: add UDP tx checksum
 support
Message-ID: <20210528165844.00e2b489@carbon>
In-Reply-To: <cf16417902062c6ea2fd3c79e00510e36a40c31a.1622210713.git.lorenzo@kernel.org>
References: <cf16417902062c6ea2fd3c79e00510e36a40c31a.1622210713.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 May 2021 16:06:35 +0200
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> Introduce k parameter in pktgen samples in order to toggle UDP tx
> checksum
> 
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
> Changes since v1:
> - use spaces instead of tabs
> ---
>  samples/pktgen/parameters.sh                               | 7 ++++++-
>  samples/pktgen/pktgen_sample01_simple.sh                   | 2 ++
>  samples/pktgen/pktgen_sample02_multiqueue.sh               | 2 ++
>  samples/pktgen/pktgen_sample03_burst_single_flow.sh        | 2 ++
>  samples/pktgen/pktgen_sample04_many_flows.sh               | 2 ++
>  samples/pktgen/pktgen_sample05_flow_per_thread.sh          | 2 ++
>  .../pktgen_sample06_numa_awared_queue_irq_affinity.sh      | 2 ++
>  7 files changed, 18 insertions(+), 1 deletion(-)

Looks great, thanks!

Double:

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

