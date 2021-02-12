Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD79319A1C
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 08:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbhBLHL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 02:11:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43077 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229598AbhBLHLZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 02:11:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613113777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8mhZkZKs20diLxFUzToHk7jnGcTrrMDi8W9COCWFWPI=;
        b=gRyiIMFfypXdP5OgiwUqpTWzuiAdVf9p9MK53pVLy7AVojCT9zC8cnr9PK/OfLoiGF3XU7
        yJfmSRDzQKXlzpd9M+go0TXiegio4HJ0OrY/bIr33gNbYW6Ffp9WXB78d5tBczpcixfp7h
        PWFmZSPTAW9vJ4NNlyBxZcmsr78Q+l8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-Ez5cxZ2cNsejTNSpLWHGAg-1; Fri, 12 Feb 2021 02:09:34 -0500
X-MC-Unique: Ez5cxZ2cNsejTNSpLWHGAg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 91510192AB79;
        Fri, 12 Feb 2021 07:09:33 +0000 (UTC)
Received: from carbon (unknown [10.36.110.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C3ABD7093A;
        Fri, 12 Feb 2021 07:09:28 +0000 (UTC)
Date:   Fri, 12 Feb 2021 08:09:27 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>, brouer@redhat.com,
        "Daniel T. Lee" <danieltimlee@gmail.com>
Subject: Re: [EXT] Re: [PATCH v2 net-next 1/2] samples: pktgen: allow to
 specify delay parameter via new opt
Message-ID: <20210212080927.008fd4c8@carbon>
In-Reply-To: <CY4PR1801MB1816E10B20760B287BF27DC8B78C9@CY4PR1801MB1816.namprd18.prod.outlook.com>
References: <20210211155626.25213-1-irusskikh@marvell.com>
        <20210211155626.25213-2-irusskikh@marvell.com>
        <20210211181211.5c2d61b0@carbon>
        <CY4PR1801MB1816E10B20760B287BF27DC8B78C9@CY4PR1801MB1816.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Feb 2021 17:39:35 +0000
Igor Russkikh <irusskikh@marvell.com> wrote:

> >> +    echo "  -w : (\$DELAY)     Tx Delay value (us)"  
> >This is not in "us" it is in "ns" (nanosec). (Like I pointed out last time...)  
> 
> Ah, sorry lost that. Will fix.

Also remember that you made similar mistake in next patch.
When adding documentation in samples/pktgen/README.rst.
Strictly speaking, the doc update for DELAY belongs in patch-1.


> One extra thing I wanted to raise is "set -o errexit" in functions.sh.
> It basically contradicts with the usecase I'm using (doing source ./functions.sh).
> After that, any error in current shell makes it to quit.

Cc. Daniel T. Lee, can you remember why this 'errexit' was added?

> Honestly, for my tests, I do always disable that line.

In your shell script, using "append", you can disable that shell
feature in your script (instead of removing the line from functions.sh).

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

