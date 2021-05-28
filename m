Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9C539428B
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 14:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234782AbhE1Mdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 08:33:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26936 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232310AbhE1Mdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 08:33:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622205120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3xvx0Eh+3kd627h0P39un7EnOyA+2Snx56TfgXcAzC0=;
        b=ZMSE293gqeE2i7tkVEtsqwbzkknw7CcwF5FeP+0RxlSqaLsY+TxClcUBDtr3adPJQB2Bey
        OrUBOFCvSSOCgXv5J9g/sI3Tqy1dJnvthm3LITREri8vVbBYj5r9WJMA88AhuILafAIA62
        VJybLSh4uTPEMXTrd+f8x5/g0ZjgXTw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-dfFbTothMyKTlUJjlWNFCg-1; Fri, 28 May 2021 08:31:56 -0400
X-MC-Unique: dfFbTothMyKTlUJjlWNFCg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 98AA4501E3;
        Fri, 28 May 2021 12:31:55 +0000 (UTC)
Received: from carbon (unknown [10.36.110.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 27E2D62460;
        Fri, 28 May 2021 12:31:50 +0000 (UTC)
Date:   Fri, 28 May 2021 14:31:49 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        brouer@redhat.com
Subject: Re: [PATCH net-next] samples: pktgen: add UDP tx checksum support
Message-ID: <20210528143149.59e5543a@carbon>
In-Reply-To: <d8476fd6ca67441dde0f2bf2618401ef91de2867.1622200776.git.lorenzo@kernel.org>
References: <d8476fd6ca67441dde0f2bf2618401ef91de2867.1622200776.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 May 2021 13:22:21 +0200
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> Introduce k parameter in pktgen samples in order to toggle UDP tx
> checksum
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---

If you fix whitespace nits below:

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

>  samples/pktgen/parameters.sh                               | 7 ++++++-
>  samples/pktgen/pktgen_sample01_simple.sh                   | 2 ++
>  samples/pktgen/pktgen_sample02_multiqueue.sh               | 2 ++
>  samples/pktgen/pktgen_sample03_burst_single_flow.sh        | 2 ++
>  samples/pktgen/pktgen_sample04_many_flows.sh               | 2 ++
>  samples/pktgen/pktgen_sample05_flow_per_thread.sh          | 2 ++
>  .../pktgen_sample06_numa_awared_queue_irq_affinity.sh      | 2 ++
>  7 files changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/samples/pktgen/parameters.sh b/samples/pktgen/parameters.sh
> index b4c1b371e4b8..7a425fc260ee 100644
> --- a/samples/pktgen/parameters.sh
> +++ b/samples/pktgen/parameters.sh
[...]
> @@ -88,6 +89,10 @@ while getopts "s:i:d:m:p:f:t:c:n:b:w:vxh6a" option; do
>            export APPEND=yes
>            info "Append mode: APPEND=$APPEND"
>            ;;
> +	k)
> +	  export UDP_CSUM=yes
> +          info "UDP tx checksum: UDP_CSUM=$UDP_CSUM"
> +	  ;;

You whitespaces are off here... could you just use the existing (shell)
code use of whitespaces?  (else it looks silly when viewing with
different editors, you vim likely hides this looks off).

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

