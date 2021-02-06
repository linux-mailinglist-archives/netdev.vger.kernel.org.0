Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA2B8311BD7
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 08:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbhBFHMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 02:12:34 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:50294 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229492AbhBFHMa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 02:12:30 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id E786C205CF;
        Sat,  6 Feb 2021 08:11:48 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id bmkgi2TFKruh; Sat,  6 Feb 2021 08:11:48 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 8993920591;
        Sat,  6 Feb 2021 08:11:48 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 6 Feb 2021 08:11:48 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Sat, 6 Feb 2021
 08:11:48 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 8E2E73182C11; Sat,  6 Feb 2021 08:11:48 +0100 (CET)
Date:   Sat, 6 Feb 2021 08:11:48 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] esp: Simplify the calculation of variables
Message-ID: <20210206071148.GS3576117@gauss3.secunet.de>
References: <1612320270-873-1-git-send-email-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1612320270-873-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 03, 2021 at 10:44:30AM +0800, Jiapeng Chong wrote:
> Fix the following coccicheck warnings:
> 
> ./net/ipv6/esp6.c:791:16-18: WARNING !A || A && B is equivalent
> to !A || B.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Applied to ipsec-next, thanks!
