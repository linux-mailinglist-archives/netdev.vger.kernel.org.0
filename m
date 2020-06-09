Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 330CD1F3460
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 08:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbgFIGuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 02:50:37 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:60188 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726949AbgFIGud (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 02:50:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591685432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RMwcUIFPWAyOd8cKk46GmiqaJ7VH8w0Cpy4nyi0OjGc=;
        b=Q2XX1BIcRvHh/Ffa/vOneVFLtSHNBU2WgyajTxzp9XVTiIr2U9z8txAdg4ZP1G9JfjKCr/
        Xja7yaitye6uLhpV3ist3ib/FeOBnl9coc+NrcmYh2BBa1VPt3EJW/os/1bnWLn7sHxVMW
        spaLPGcqbI+O9Xf8XKVKURsCMUZPvA8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-391-pfs1qKM-NFKoNWHgrO6dWA-1; Tue, 09 Jun 2020 02:50:28 -0400
X-MC-Unique: pfs1qKM-NFKoNWHgrO6dWA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E95FC18FF661;
        Tue,  9 Jun 2020 06:50:25 +0000 (UTC)
Received: from carbon (unknown [10.40.208.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5700F768C1;
        Tue,  9 Jun 2020 06:50:18 +0000 (UTC)
Date:   Tue, 9 Jun 2020 08:50:17 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     gaurav singh <gaurav1086@gmail.com>
Cc:     brouer@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, kpsingh@chromium.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bpf: alloc_record_per_cpu Add null check after malloc
Message-ID: <20200609085017.0d285568@carbon>
In-Reply-To: <CAFAFadDVe1Au2eJ8ho_cK1riwf9FDaGck3o+VEcKpqRgO5qXdA@mail.gmail.com>
References: <CAFAFadDVe1Au2eJ8ho_cK1riwf9FDaGck3o+VEcKpqRgO5qXdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 6 Jun 2020 19:59:48 -0400
gaurav singh <gaurav1086@gmail.com> wrote:

> Hi,
> 
> The memset call is made right after malloc call. To fix this, add the null
> check right after malloc and then do memset.
> 
> Please find the patch below.

The fix in your patch seem correct (although there are more places),
but the way you send/submit the patch is wrong.  The patch itself also
mangle whitespaces.

You can read the guide:

 https://www.kernel.org/doc/html/latest/process/submitting-patches.html
 https://www.kernel.org/doc/html/latest/process/index.html

--Jesper


> Thanks and regards,
> Gaurav.
> 
> 
> From 552b7df0e12572737929c60478b5dca2a40f4ad9 Mon Sep 17 00:00:00 2001
> From: Gaurav Singh <gaurav1086@gmail.com>
> Date: Sat, 6 Jun 2020 19:57:48 -0400
> Subject: [PATCH] bpf: alloc_record_per_cpu Add null check after malloc
> 
> Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
> ---
>  samples/bpf/xdp_rxq_info_user.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/samples/bpf/xdp_rxq_info_user.c
> b/samples/bpf/xdp_rxq_info_user.c
> index 4fe47502ebed..490b07b7df78 100644
> --- a/samples/bpf/xdp_rxq_info_user.c
> +++ b/samples/bpf/xdp_rxq_info_user.c
> @@ -202,11 +202,11 @@ static struct datarec *alloc_record_per_cpu(void)
> 
>   size = sizeof(struct datarec) * nr_cpus;
>   array = malloc(size);
> - memset(array, 0, size);
>   if (!array) {
>   fprintf(stderr, "Mem alloc error (nr_cpus:%u)\n", nr_cpus);
>   exit(EXIT_FAIL_MEM);
>   }
> + memset(array, 0, size);
>   return array;
>  }
> 



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

