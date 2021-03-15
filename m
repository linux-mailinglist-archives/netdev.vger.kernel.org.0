Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7138933ADD6
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 09:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbhCOIqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 04:46:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33909 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229652AbhCOIpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 04:45:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615797938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7aGBPeiSBPhKk5XLH6RNa1t7S9xQFcMLEe8c7bu9zJI=;
        b=O+ZQ/MtUhRhyYoYEypXFW6FjvZqS7acUVh9dDX+TBYbreNrHwiG8EYScvDQMEZ7lMkMH0H
        SUh+Xm6dvKugUmqHfCje7ikg3q5UZDOqP/c2uXjU8Xb9xywcmloz6gtN9izG/C0RvskByW
        Mkb/u9jJtsXUnLSklfOoFbActvz4Bk4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-458-15OmnOoSOvmymmXFmeEl8Q-1; Mon, 15 Mar 2021 04:45:36 -0400
X-MC-Unique: 15OmnOoSOvmymmXFmeEl8Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CC6A2EC1A0;
        Mon, 15 Mar 2021 08:45:35 +0000 (UTC)
Received: from carbon (unknown [10.36.110.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 722461F43B;
        Mon, 15 Mar 2021 08:45:31 +0000 (UTC)
Date:   Mon, 15 Mar 2021 09:45:30 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        brouer@redhat.com
Subject: Re: [PATCH v3 net-next 0/2] pktgen: scripts improvements
Message-ID: <20210315094530.6a77018f@carbon>
In-Reply-To: <20210311103253.14676-1-irusskikh@marvell.com>
References: <20210311103253.14676-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Mar 2021 11:32:51 +0100
Igor Russkikh <irusskikh@marvell.com> wrote:

> Hello netdev community,
> 
> Please consider small improvements to pktgen scripts we use in our environment.
> 
> Adding delay parameter through command line,
> Adding new -a (append) parameter to make flex runs
> 
> v3: change us to ns in docs
> v2: Review comments from Jesper
> 
> CC: Jesper Dangaard Brouer <brouer@redhat.com>

Did a quick review and everything looks okay.
The patches are already applied, but you will still get my ACK,
even-though it will not make it to the commit log.

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

> Igor Russkikh (2):
>   samples: pktgen: allow to specify delay parameter via new opt
>   samples: pktgen: new append mode
> 
>  samples/pktgen/README.rst                     | 18 +++++++++++
>  samples/pktgen/functions.sh                   |  7 ++++-
>  samples/pktgen/parameters.sh                  | 15 ++++++++-
>  .../pktgen_bench_xmit_mode_netif_receive.sh   |  3 --
>  .../pktgen_bench_xmit_mode_queue_xmit.sh      |  3 --
>  samples/pktgen/pktgen_sample01_simple.sh      | 25 ++++++++-------
>  samples/pktgen/pktgen_sample02_multiqueue.sh  | 29 +++++++++--------
>  .../pktgen_sample03_burst_single_flow.sh      | 15 ++++-----
>  samples/pktgen/pktgen_sample04_many_flows.sh  | 17 +++++-----
>  .../pktgen/pktgen_sample05_flow_per_thread.sh | 17 +++++-----
>  ...sample06_numa_awared_queue_irq_affinity.sh | 31 ++++++++++---------
>  11 files changed, 110 insertions(+), 70 deletions(-)

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

