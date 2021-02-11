Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7F5E3190C6
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 18:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232210AbhBKRPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 12:15:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27042 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230170AbhBKRNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 12:13:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613063540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Dh4MKq42Fyslw2ZaoyVwm+WR81Lht+tiwx0z2OoZYPg=;
        b=U152NXA1ql7MS4m/HxTcz1uaVejuzoVq2bfqhHxKosZX1VKcI2a9jm80X90lk/8HHgk+rO
        g5cpsg9I0Brt2bn3ElcdWZeb8RaYrMzoM9z4Orqyg7MJm6x7NXfAk2Bn9zbiohOqSUcbcR
        4Bi5j4D67OR/7L5KA/bxvfLsl415qH0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-54-UmvdBkKiPXibnLPG8UE2tg-1; Thu, 11 Feb 2021 12:12:18 -0500
X-MC-Unique: UmvdBkKiPXibnLPG8UE2tg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF524801983;
        Thu, 11 Feb 2021 17:12:17 +0000 (UTC)
Received: from carbon (unknown [10.36.110.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7BFE610013D7;
        Thu, 11 Feb 2021 17:12:12 +0000 (UTC)
Date:   Thu, 11 Feb 2021 18:12:11 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        brouer@redhat.com
Subject: Re: [PATCH v2 net-next 1/2] samples: pktgen: allow to specify delay
 parameter via new opt
Message-ID: <20210211181211.5c2d61b0@carbon>
In-Reply-To: <20210211155626.25213-2-irusskikh@marvell.com>
References: <20210211155626.25213-1-irusskikh@marvell.com>
        <20210211155626.25213-2-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Feb 2021 16:56:25 +0100
Igor Russkikh <irusskikh@marvell.com> wrote:

> diff --git a/samples/pktgen/parameters.sh b/samples/pktgen/parameters.sh
> index ff0ed474fee9..70cc2878d479 100644
> --- a/samples/pktgen/parameters.sh
> +++ b/samples/pktgen/parameters.sh
> @@ -19,12 +19,13 @@ function usage() {
>      echo "  -v : (\$VERBOSE)   verbose"
>      echo "  -x : (\$DEBUG)     debug"
>      echo "  -6 : (\$IP6)       IPv6"
> +    echo "  -w : (\$DELAY)     Tx Delay value (us)"

This is not in "us" it is in "ns" (nanosec). (Like I pointed out last time...)

>      echo ""
>  }



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

