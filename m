Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D08330CAB2
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 19:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239085AbhBBS5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 13:57:25 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:14570 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237908AbhBBS4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 13:56:12 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6019a0240001>; Tue, 02 Feb 2021 10:55:32 -0800
Received: from localhost (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 2 Feb
 2021 18:55:31 +0000
Date:   Tue, 2 Feb 2021 18:01:37 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next] inet: do not export inet_gro_{receive|complete}
Message-ID: <20210202160137.GD3264866@unreal>
References: <20210202154145.1568451-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210202154145.1568451-1-eric.dumazet@gmail.com>
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612292132; bh=d+QSK2YAfLOCuLB7Rzwq3/offIIWiA/L71zLLk8zUhk=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy;
        b=G6A3IbV6qn41fnIjREgPUL5zhA9Z+KDd7/lFS4Np8xG43JBpEJX/pru54i+HjSIL1
         rJiEVfa6aU7L4BS1V8JRVJ85gPhLPHpnrHOudm74aFJl/8R7KYmPIarAehYTCdnVnu
         g1eRv4BabmyMbrrX9779w9RXUwfz87x7A5+i5VCTG2GzcF5F0sh8/LKlH6LQeWxNPg
         bdbULCrCKgSweGpVCA4vE2BIcl6tCJJwA3IaZm5rjk/6UqdyhepXLLKlC2wwahYMWw
         PNH+vYu+LJQ8aF2ahimv5gToX0Fhbbm/694OYr4lr2mk41cmKLG7Iqafelk5CTEWUR
         o/ZgmMDDEUAfQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 02, 2021 at 07:41:45AM -0800, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
>
> inet_gro_receive() and inet_gro_complete() are part
> of GRO engine which can not be modular.
>
> Similarly, inet_gso_segment() does not need to be exported,
> being part of GSO stack.
>
> In other words, net/ipv6/ip6_offload.o is part of vmlinux,
> regardless of CONFIG_IPV6.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Leon Romanovsky <leonro@nvidia.com>
> ---
>  net/ipv4/af_inet.c | 3 ---
>  1 file changed, 3 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
