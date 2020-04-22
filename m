Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84F541B48AE
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 17:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgDVPbp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 22 Apr 2020 11:31:45 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:35092 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725980AbgDVPbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 11:31:44 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-6-BEt8NvMfe0d5ySJvE5tw-1; Wed, 22 Apr 2020 11:31:39 -0400
X-MC-Unique: 6-BEt8NvMfe0d5ySJvE5tw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B218A8017F5;
        Wed, 22 Apr 2020 15:31:38 +0000 (UTC)
Received: from bistromath.localdomain (ovpn-112-35.ams2.redhat.com [10.36.112.35])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 019A65D714;
        Wed, 22 Apr 2020 15:31:37 +0000 (UTC)
Date:   Wed, 22 Apr 2020 17:31:36 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ipsec-next v2 2/2] xfrm: add IPv6 support for espintcp
Message-ID: <20200422153136.GA4098331@bistromath.localdomain>
References: <cover.1587484164.git.sd@queasysnail.net>
 <58b84b2af566138279348470b7ad27a8b9650372.1587484164.git.sd@queasysnail.net>
 <20200422110541.GZ13121@gauss3.secunet.de>
MIME-Version: 1.0
In-Reply-To: <20200422110541.GZ13121@gauss3.secunet.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-04-22, 13:05:41 +0200, Steffen Klassert wrote:
> On Tue, Apr 21, 2020 at 06:04:23PM +0200, Sabrina Dubroca wrote:
> > This extends espintcp to support IPv6, building on the existing code
> > and the new UDPv6 encapsulation support. Most of the code is either
> > reused directly (stream parser, ULP) or very similar to the IPv4
> > variant (net/ipv6/esp6.c changes).
> > 
> > The separation of config options for IPv4 and IPv6 espintcp requires a
> > bit of Kconfig gymnastics to enable the core code.
> > 
> > Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
> 
> This patch does not apply on top of patch 1/2:
> 
> git am -s ~/Mail/todo-ipsec-next
> Applying: xfrm: add support for UDPv6 encapsulation of ESP
> Applying: xfrm: add IPv6 support for espintcp
> error: patch failed: net/xfrm/espintcp.c:416
> error: net/xfrm/espintcp.c: patch does not apply
> Patch failed at 0002 xfrm: add IPv6 support for espintcp
> 
> Can you please doublecheck this?

*facepalm*
I had the sk_destruct fix in my branch when I exported those
patches, so git format-patch exported a patch with slightly different
offsets.

Sorry for the mess, I'll post a v3 that applies correctly on ipsec-next.

-- 
Sabrina

