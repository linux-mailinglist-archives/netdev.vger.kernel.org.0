Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73EC545FEA1
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 13:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232505AbhK0MsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Nov 2021 07:48:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53179 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239335AbhK0MqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Nov 2021 07:46:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638016983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WDTqGFUsAsCLetUVG/vUO9a5OS/hVgX06nVfr6avo0o=;
        b=ALe39znkODfYXu+KRYiLwg6skyPSw7VfUYvq72rWBcF6XeojV6oqfO0LKS/CpQPchE9/RB
        888Ry77xHMaO+1tq7Av0CguFEd7A7p2Qj+oLDeUUtxwet9e8HHMFoO9tbUhtskWQ0Wv5gs
        nS8EHqYQ4Bal+CH8ZYgc1qKNMeIWjWw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-390-LX146rs9P4KKGfBuVLmrHQ-1; Sat, 27 Nov 2021 07:43:01 -0500
X-MC-Unique: LX146rs9P4KKGfBuVLmrHQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E8D938042FC;
        Sat, 27 Nov 2021 12:42:59 +0000 (UTC)
Received: from maya.cloud.tilaa.com (unknown [10.40.208.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7612C60BE5;
        Sat, 27 Nov 2021 12:42:59 +0000 (UTC)
Date:   Sat, 27 Nov 2021 13:42:51 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Nikita Yushchenko <nikita.yushchenko@virtuozzo.com>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH nf 2/2] selftests: netfilter: Add correctness test for
 mac,net set type
Message-ID: <20211127134251.30d3b196@elisabeth>
In-Reply-To: <YaIU/7LKgAJD/TSS@kroah.com>
References: <cover.1637976889.git.sbrivio@redhat.com>
        <142425004cc8d6bc6777fef933d3f290491f87c4.1637976889.git.sbrivio@redhat.com>
        <YaIU/7LKgAJD/TSS@kroah.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

On Sat, 27 Nov 2021 12:22:39 +0100
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Sat, Nov 27, 2021 at 11:33:38AM +0100, Stefano Brivio wrote:
> > The existing net,mac test didn't cover the issue recently reported
> > by Nikita Yushchenko, where MAC addresses wouldn't match if given
> > as first field of a concatenated set with AVX2 and 8-bit groups,
> > because there's a different code path covering the lookup of six
> > 8-bit groups (MAC addresses) if that's the first field.
> > 
> > Add a similar mac,net test, with MAC address and IPv4 address
> > swapped in the set specification.
> > 
> > Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
> > ---
> >  .../selftests/netfilter/nft_concat_range.sh   | 24 ++++++++++++++++---
> >  1 file changed, 21 insertions(+), 3 deletions(-)  
> 
> <formletter>
> 
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.
> 
> </formletter>

This patch (2/2) is not intended for the stable kernel tree, only patch
1/2 is. I Cc'ed stable@kernel.org on the whole series for context.

-- 
Stefano

