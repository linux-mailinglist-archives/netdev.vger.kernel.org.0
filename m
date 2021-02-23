Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47D1E322D4E
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 16:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233075AbhBWPTU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 23 Feb 2021 10:19:20 -0500
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:59495 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231919AbhBWPTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 10:19:16 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-492-nW7OIwhVPt6Wbq1WRAL8tA-1; Tue, 23 Feb 2021 10:18:20 -0500
X-MC-Unique: nW7OIwhVPt6Wbq1WRAL8tA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4283D100A262;
        Tue, 23 Feb 2021 15:12:38 +0000 (UTC)
Received: from hog (ovpn-112-129.ams2.redhat.com [10.36.112.129])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6352B1899A;
        Tue, 23 Feb 2021 15:12:36 +0000 (UTC)
Date:   Tue, 23 Feb 2021 16:12:34 +0100
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH ipsec,v2] xfrm: interface: fix ipv4 pmtu check to honor
 ip header df
Message-ID: <YDUbYvCnRN/aBQrM@hog>
References: <20210219172127.2223831-1-eyal.birger@gmail.com>
 <20210220130115.2914135-1-eyal.birger@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20210220130115.2914135-1-eyal.birger@gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=sd@queasysnail.net
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2021-02-20, 15:01:15 +0200, Eyal Birger wrote:
> Frag needed should only be sent if the header enables DF.
> 
> This fix allows packets larger than MTU to pass the xfrm interface
> and be fragmented after encapsulation, aligning behavior with
> non-interface xfrm.
> 
> Fixes: f203b76d7809 ("xfrm: Add virtual xfrm interfaces")
> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
> 
> -----
> 
> v2: better align coding with ip_vti

LGTM. We also need to do the same thing in ip_vti and ip6_vti. Do you
want to take care of it, or should I?

Either way, for this patch:
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>

-- 
Sabrina

