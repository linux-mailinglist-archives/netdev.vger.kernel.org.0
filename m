Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC26633AFEE
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 11:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbhCOK0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 06:26:02 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:36816 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229652AbhCOKZe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 06:25:34 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 58792204EF;
        Mon, 15 Mar 2021 11:25:33 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id W__cExL5b3TL; Mon, 15 Mar 2021 11:25:32 +0100 (CET)
Received: from mail-essen-02.secunet.de (unknown [10.53.40.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id ED9442035C;
        Mon, 15 Mar 2021 11:25:29 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-02.secunet.de (10.53.40.205) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Mon, 15 Mar 2021 11:25:29 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Mon, 15 Mar
 2021 11:25:29 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 0D80A31803BF;
 Mon, 15 Mar 2021 11:25:29 +0100 (CET)
Date:   Mon, 15 Mar 2021 11:25:29 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] esp4: Simplify the calculation of variables
Message-ID: <20210315102529.GW62598@gauss3.secunet.de>
References: <1614595562-56960-1-git-send-email-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1614595562-56960-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 01, 2021 at 06:46:02PM +0800, Jiapeng Chong wrote:
> Fix the following coccicheck warnings:
> 
> ./net/ipv4/esp4.c:757:16-18: WARNING !A || A && B is equivalent to !A || B.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Now applied to ipsec-next, thanks!
