Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4A638FEFB
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 12:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbhEYKZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 06:25:29 -0400
Received: from mailout1.secunet.com ([62.96.220.44]:45960 "EHLO
        mailout1.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbhEYKZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 06:25:28 -0400
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id B894C800056;
        Tue, 25 May 2021 12:23:56 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 25 May 2021 12:23:56 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 25 May
 2021 12:23:56 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 0C0AB3180299; Tue, 25 May 2021 12:23:56 +0200 (CEST)
Date:   Tue, 25 May 2021 12:23:55 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] esp: drop unneeded assignment in esp4_gro_receive()
Message-ID: <20210525102355.GW40979@gauss3.secunet.de>
References: <1619345672-31802-1-git-send-email-yang.lee@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1619345672-31802-1-git-send-email-yang.lee@linux.alibaba.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 25, 2021 at 06:14:32PM +0800, Yang Li wrote:
> Making '!=' operation with 0 directly after calling
> the function xfrm_parse_spi() is more efficient,
> assignment to err is redundant.
> 
> Eliminate the following clang_analyzer warning:
> net/ipv4/esp4_offload.c:41:7: warning: Although the value stored to
> 'err' is used in the enclosing expression, the value is never actually
> read from 'err'
> 
> No functional change, only more efficient.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>

Now applied to ipsec-next, thanks!
