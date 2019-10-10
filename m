Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76097D271D
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 12:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbfJJKXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 06:23:34 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:50052 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726065AbfJJKXe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 06:23:34 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 477D420270;
        Thu, 10 Oct 2019 12:23:33 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ED5AZffA5UMx; Thu, 10 Oct 2019 12:23:32 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id E3DE520096;
        Thu, 10 Oct 2019 12:23:32 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Thu, 10 Oct 2019
 12:23:32 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 8B5B531800AF;
 Thu, 10 Oct 2019 12:23:32 +0200 (CEST)
Date:   Thu, 10 Oct 2019 12:23:32 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Alexey Dobriyan <adobriyan@gmail.com>
CC:     <davem@davemloft.net>, <herbert@gondor.apana.org.au>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH] xfrm: ifdef
 setsockopt(UDP_ENCAP_ESPINUDP/UDP_ENCAP_ESPINUDP_NON_IKE)
Message-ID: <20191010102332.GX2879@gauss3.secunet.de>
References: <20191003212157.GA6943@avx2>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20191003212157.GA6943@avx2>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 04, 2019 at 12:21:57AM +0300, Alexey Dobriyan wrote:
> If IPsec is not configured, there is no reason to delay the inevitable.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Applied to ipsec-next, thanks!
