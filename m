Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDCB30D329
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 06:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbhBCFqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 00:46:47 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:17355 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbhBCFqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 00:46:46 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601a389e0000>; Tue, 02 Feb 2021 21:46:06 -0800
Received: from localhost (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 3 Feb
 2021 05:46:05 +0000
Date:   Wed, 3 Feb 2021 07:46:02 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Alan Perry <alanp@snowmoose.com>
CC:     <netdev@vger.kernel.org>
Subject: Re: [PATCH iproute2-next] Add a description section to the rdma man
 page
Message-ID: <20210203054602.GI3264866@unreal>
References: <20210203045234.57492-1-alanp@snowmoose.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210203045234.57492-1-alanp@snowmoose.com>
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612331166; bh=nYjveTRrElhVDFfGudMCBCRpywaEzPvybMEIVpOsC+I=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy;
        b=DokVp8qM/UyR6ZiZFdig8H7TP8Zo6ZnWtWCmbUtTog5mEnk/q9wYmpNAU4pAvR+XG
         64qQGQjSc1WUabSrM79ZZT36eiCcoIJUUnVJmRw5Ixl5HEJJ/ZR1iZ+HCkQgIZh3HI
         U8iuCcfT16CxHfzQPi91dD8UdaPekpBgFkO0RB0yr67XXOUfzdHuz4d0PxBcpws5LQ
         bu1IDelEQq7MOmvLMl8rqm+MxjUVa+wqdhDWDAKCygYVRSikJC1ZpKcWkOY1lT/qzy
         xccLe/ock+sMC/bU5R1OmfQs9ZPF0cmnZEMIAsVcbWUXm8Lhz/fo8cUnLraIV6xuqH
         QovbpOAjZ/ErQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 02, 2021 at 08:52:35PM -0800, Alan Perry wrote:
> Signed-off-by: Alan Perry <alanp@snowmoose.com>
> Acked-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  man/man8/rdma.8 | 6 ++++++
>  1 file changed, 6 insertions(+)

We saw the commit message in the previous version.
https://lore.kernel.org/netdev/20210202143902.47dca3d3@hermes.local

Let's use it and don't forget to put Stephen in the TO:, also he needs
"iproute2" in the title instead of "iproute2-next".

Thanks
