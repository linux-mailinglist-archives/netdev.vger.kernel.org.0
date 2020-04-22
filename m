Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 185D01B42C3
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 13:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbgDVLFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 07:05:45 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:49554 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726100AbgDVLFp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 07:05:45 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id CE655201E2;
        Wed, 22 Apr 2020 13:05:43 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id hwmFGFb_5JPx; Wed, 22 Apr 2020 13:05:42 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id AE8A42009B;
        Wed, 22 Apr 2020 13:05:42 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 MAIL-ESSEN-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Wed, 22 Apr 2020 13:05:42 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Wed, 22 Apr
 2020 13:05:42 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 089533180096;
 Wed, 22 Apr 2020 13:05:42 +0200 (CEST)
Date:   Wed, 22 Apr 2020 13:05:41 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>
Subject: Re: [PATCH ipsec-next v2 2/2] xfrm: add IPv6 support for espintcp
Message-ID: <20200422110541.GZ13121@gauss3.secunet.de>
References: <cover.1587484164.git.sd@queasysnail.net>
 <58b84b2af566138279348470b7ad27a8b9650372.1587484164.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <58b84b2af566138279348470b7ad27a8b9650372.1587484164.git.sd@queasysnail.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 06:04:23PM +0200, Sabrina Dubroca wrote:
> This extends espintcp to support IPv6, building on the existing code
> and the new UDPv6 encapsulation support. Most of the code is either
> reused directly (stream parser, ULP) or very similar to the IPv4
> variant (net/ipv6/esp6.c changes).
> 
> The separation of config options for IPv4 and IPv6 espintcp requires a
> bit of Kconfig gymnastics to enable the core code.
> 
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>

This patch does not apply on top of patch 1/2:

git am -s ~/Mail/todo-ipsec-next
Applying: xfrm: add support for UDPv6 encapsulation of ESP
Applying: xfrm: add IPv6 support for espintcp
error: patch failed: net/xfrm/espintcp.c:416
error: net/xfrm/espintcp.c: patch does not apply
Patch failed at 0002 xfrm: add IPv6 support for espintcp

Can you please doublecheck this?
