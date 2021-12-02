Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C01C54664EC
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 15:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354987AbhLBOPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 09:15:11 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:57302 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355236AbhLBOPJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Dec 2021 09:15:09 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 098F12035C;
        Thu,  2 Dec 2021 15:11:46 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id FAGyw4maQBcc; Thu,  2 Dec 2021 15:11:45 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 8502D20265;
        Thu,  2 Dec 2021 15:11:45 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 7279480004A;
        Thu,  2 Dec 2021 15:11:45 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 2 Dec 2021 15:11:45 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.14; Thu, 2 Dec
 2021 15:11:45 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 601F33183D5D; Thu,  2 Dec 2021 15:11:44 +0100 (CET)
Date:   Thu, 2 Dec 2021 15:11:44 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     =?utf-8?B?Ss61YW4=?= Sacren <sakiwit@gmail.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: xfrm: drop check of pols[0] for the second
 time
Message-ID: <20211202141144.GT427717@gauss3.secunet.de>
References: <20211130070312.5494-3-sakiwit@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211130070312.5494-3-sakiwit@gmail.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 30, 2021 at 12:03:12AM -0700, Jεan Sacren wrote:
> From: Jean Sacren <sakiwit@gmail.com>
> 
> !pols[0] is checked earlier.  If we don't return, pols[0] is always
> true.  We should drop the check of pols[0] for the second time and the
> binary is also smaller.
> 
> Before:
>    text	   data	    bss	    dec	    hex	filename
>   48395	    957	    240	  49592	   c1b8	net/xfrm/xfrm_policy.o
> 
> After:
>    text	   data	    bss	    dec	    hex	filename
>   48379	    957	    240	  49576	   c1a8	net/xfrm/xfrm_policy.o
> 
> Signed-off-by: Jean Sacren <sakiwit@gmail.com>

Applied to ipsec-next, thanks!
