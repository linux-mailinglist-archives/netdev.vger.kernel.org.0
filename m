Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59CED2725E7
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 15:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbgIUNmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 09:42:01 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:2256 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726471AbgIUNmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 09:42:00 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f68ad4b0000>; Mon, 21 Sep 2020 06:40:27 -0700
Received: from localhost (10.124.1.5) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 21 Sep 2020 13:41:57
 +0000
Date:   Mon, 21 Sep 2020 16:41:53 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Qinglang Miao <miaoqinglang@huawei.com>
CC:     Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] mlxsw: spectrum_router: simplify the return
 expression of __mlxsw_sp_router_init()
Message-ID: <20200921134153.GB1072139@shredder>
References: <20200921131041.92294-1-miaoqinglang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200921131041.92294-1-miaoqinglang@huawei.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600695628; bh=Yge7N+PNOJ4mrHc5IFXGcpf6PnoX8USlTc9Ke+KCzR8=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy;
        b=li9RzydbMf0C2OUOTbl9PRwQtcJzOQ7KkywGqedgN3V0SvYS0O9wmr6NLmNTQCZOe
         l/R4FMNQZ5fb3C45hz+Fy32pamOzbBLtLkXiRJ//6jiVvNI2lyriWHHuFMZrloKWWC
         Ta9QmiffX93ARz4U0WNEbdbBHLJOIXPtLdrIkFUTR/8BgnMbN7zOgrwLUfh/4pnMOv
         fUd8RglhZCmjrchIB6YVqiOw/nFN3TM1Gc2jHd/RumgwtIL9NWVokaoPMCWCe1ZGcS
         fNPE2YJobR1gfSR17BBU3qW7bCRDtIt8nP6ZHarQNdGUxd2QJ3PbpCwm5115aOPvRz
         DiNPR52bNwCfQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 21, 2020 at 09:10:41PM +0800, Qinglang Miao wrote:
> Simplify the return expression.
> 
> Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
