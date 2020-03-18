Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1391518959D
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 07:15:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbgCRGP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 02:15:56 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:56834 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726553AbgCRGP4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 02:15:56 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id F0423201E5;
        Wed, 18 Mar 2020 07:15:54 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id EJv0KzFP0wTi; Wed, 18 Mar 2020 07:15:54 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 7F7FE201D5;
        Wed, 18 Mar 2020 07:15:54 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Wed, 18 Mar 2020
 07:15:54 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 0754B3180156;
 Wed, 18 Mar 2020 07:15:53 +0100 (CET)
Date:   Wed, 18 Mar 2020 07:15:53 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
CC:     Torsten Hilbrich <torsten.hilbrich@secunet.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH] vti6: Fix memory leak of skb if input policy check fails
Message-ID: <20200318061553.GB19286@gauss3.secunet.de>
References: <5fe49744-88ca-a7ac-d71c-223492811545@secunet.com>
 <22c8ef07-70f4-e6a5-3066-357e1e688e72@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <22c8ef07-70f4-e6a5-3066-357e1e688e72@6wind.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 12, 2020 at 03:18:57PM +0100, Nicolas Dichtel wrote:
> Le 11/03/2020 à 11:19, Torsten Hilbrich a écrit :
> > The vti6_rcv function performs some tests on the retrieved tunnel
> > including checking the IP protocol, the XFRM input policy, the
> > source and destination address.
> > 
> > In all but one places the skb is released in the error case. When
> > the input policy check fails the network packet is leaked.
> > 
> > Using the same goto-label discard in this case to fix this problem.
> > 
> > Signed-off-by: Torsten Hilbrich <torsten.hilbrich@secunet.com>
> Fixes: ed1efb2aefbb ("ipv6: Add support for IPsec virtual tunnel interfaces")
> Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

Patch applied, thanks everyone!
