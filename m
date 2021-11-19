Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 986FA456BBC
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 09:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232167AbhKSIkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 03:40:07 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:48628 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232151AbhKSIkH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 03:40:07 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 3F4532057A;
        Fri, 19 Nov 2021 09:37:04 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 46b0vgaYYJNZ; Fri, 19 Nov 2021 09:37:03 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id B4971204FD;
        Fri, 19 Nov 2021 09:37:03 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id A3D7380004A;
        Fri, 19 Nov 2021 09:37:03 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 19 Nov 2021 09:37:03 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.14; Fri, 19 Nov
 2021 09:37:03 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id F15493180491; Fri, 19 Nov 2021 09:37:02 +0100 (CET)
Date:   Fri, 19 Nov 2021 09:37:02 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     <cgel.zte@gmail.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "David Ahern" <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        luo penghao <luo.penghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH linux-next] ipv6/esp6: Remove structure variables and
 alignment statements
Message-ID: <20211119083702.GM427717@gauss3.secunet.de>
References: <20211104031931.30714-1-luo.penghao@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20211104031931.30714-1-luo.penghao@zte.com.cn>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 04, 2021 at 03:19:31AM +0000, cgel.zte@gmail.com wrote:
> From: luo penghao <luo.penghao@zte.com.cn>
> 
> The definition of this variable is just to find the length of the
> structure after aligning the structure. The PTR alignment function
> is to optimize the size of the structure. In fact, it doesn't seem
> to be of much use, because both members of the structure are of
> type u32.
> So I think that the definition of the variable and the
> corresponding alignment can be deleted, the value of extralen can
> be directly passed in the size of the structure.
> 
> The clang_analyzer complains as follows:
> 
> net/ipv6/esp6.c:117:27 warning:
> 
> Value stored to 'extra' during its initialization is never read
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: luo penghao <luo.penghao@zte.com.cn>

Applied to ipsec-next, thanks!
