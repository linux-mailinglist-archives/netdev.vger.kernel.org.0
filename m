Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC47032A3DF
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379124AbhCBJvl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 2 Mar 2021 04:51:41 -0500
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:28653 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1378983AbhCBJdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 04:33:21 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-557-5l0qKjv-M86_vv9I37WSKw-1; Tue, 02 Mar 2021 04:32:21 -0500
X-MC-Unique: 5l0qKjv-M86_vv9I37WSKw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 48A07E75D;
        Tue,  2 Mar 2021 09:32:18 +0000 (UTC)
Received: from hog (ovpn-112-129.ams2.redhat.com [10.36.112.129])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 605DC60C05;
        Tue,  2 Mar 2021 09:32:15 +0000 (UTC)
Date:   Tue, 2 Mar 2021 10:32:13 +0100
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        bram-yvahk@mail.wizbit.be
Subject: Re: [PATCH ipsec 0/2] vti(6): fix ipv4 pmtu check to honor ip header
 df
Message-ID: <YD4GHf4CZUIK6M2E@hog>
References: <20210226213506.506799-1-eyal.birger@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20210226213506.506799-1-eyal.birger@gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2021-02-26, 23:35:04 +0200, Eyal Birger wrote:
> This series aligns vti(6) handling of non-df IPv4 packets exceeding
> the size of the tunnel MTU to avoid sending "Frag needed" and instead
> fragment the packets after encapsulation.
> 
> Eyal Birger (2):
>   vti: fix ipv4 pmtu check to honor ip header df
>   vti6: fix ipv4 pmtu check to honor ip header df

Thanks Eyal.
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>

Steffen, that's going to conflict with commit 4372339efc06 ("net:
always use icmp{,v6}_ndo_send from ndo_start_xmit") from net.

-- 
Sabrina

