Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4C781BD698
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 09:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgD2HwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 03:52:10 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:48200 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726175AbgD2HwK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 03:52:10 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 3534220523;
        Wed, 29 Apr 2020 09:52:09 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id m4FdxvIQvFgD; Wed, 29 Apr 2020 09:52:08 +0200 (CEST)
Received: from cas-essen-02.secunet.de (202.40.53.10.in-addr.arpa [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id B9D432026E;
        Wed, 29 Apr 2020 09:52:08 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 29 Apr 2020 09:52:08 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Wed, 29 Apr
 2020 09:52:08 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id F07433180098; Wed, 29 Apr 2020 09:52:07 +0200 (CEST)
Date:   Wed, 29 Apr 2020 09:52:07 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>
Subject: Re: [PATCH ipsec-next v4 0/2] xfrm: add IPv6 encapsulation support
 for ESP over UDP and TCP
Message-ID: <20200429075207.GP13121@gauss3.secunet.de>
References: <cover.1588002010.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1588002010.git.sd@queasysnail.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 05:59:33PM +0200, Sabrina Dubroca wrote:
> This series adds IPv6 encapsulation of ESP over both UDP and TCP. In
> both cases, the code is very similar to the existing IPv4
> encapsulation implementation. The core espintcp code is almost
> entirely version-independent.
> 
> v2: rebase on top of ipsec-next/master
> v3: really rebase this time
> v4: fix build warning when !_HAVE_ARCH_IPV6_CSUM
> 
> Sabrina Dubroca (2):
>   xfrm: add support for UDPv6 encapsulation of ESP
>   xfrm: add IPv6 support for espintcp

Applied, thanks a lot Sabrina!
