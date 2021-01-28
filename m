Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B89730722A
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 10:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231818AbhA1I4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 03:56:34 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:56590 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231906AbhA1I4Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 03:56:24 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id DAFAE204E0;
        Thu, 28 Jan 2021 09:57:00 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id QEuSYw3bstZx; Thu, 28 Jan 2021 09:57:00 +0100 (CET)
Received: from mail-essen-01.secunet.de (unknown [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 697F72054D;
        Thu, 28 Jan 2021 09:57:00 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Thu, 28 Jan 2021 09:56:59 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Thu, 28 Jan
 2021 09:56:59 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id C6F593181782;
 Thu, 28 Jan 2021 09:56:59 +0100 (CET)
Date:   Thu, 28 Jan 2021 09:56:59 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] net: Simplify the calculation of variables
Message-ID: <20210128085659.GA3576117@gauss3.secunet.de>
References: <1611556906-72262-1-git-send-email-abaci-bugfix@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1611556906-72262-1-git-send-email-abaci-bugfix@linux.alibaba.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 02:41:46PM +0800, Jiapeng Zhong wrote:
> Fix the following coccicheck warnings:
> 
>  ./net/ipv4/esp4_offload.c:288:32-34: WARNING !A || A && B is
> equivalent to !A || B.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>

Patch applied, thanks!
