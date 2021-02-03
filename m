Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A40E230D47B
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 08:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232327AbhBCH7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 02:59:05 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:18388 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231704AbhBCH7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 02:59:04 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601a579e0001>; Tue, 02 Feb 2021 23:58:22 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Wed, 3 Feb 2021 07:58:19 +0000
Date:   Wed, 3 Feb 2021 09:58:12 +0200
From:   Paul Blakey <paulb@nvidia.com>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     <netdev@vger.kernel.org>, Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH net-next 3/3] net/mlx5: CT: Add support for matching on
 ct_state reply flag
In-Reply-To: <20210202123659.GA3405@horizon.localdomain>
Message-ID: <eb6f26e0-c8be-ccab-8fe9-d9c15a1ea9ab@nvidia.com>
References: <1611757967-18236-1-git-send-email-paulb@nvidia.com> <1611757967-18236-4-git-send-email-paulb@nvidia.com> <20210202123659.GA3405@horizon.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612339102; bh=rEzYmFQnjv8Ulxb4dKzodWC3TjtUgNCHy4iQhKL8AOE=;
        h=Date:From:To:CC:Subject:In-Reply-To:Message-ID:References:
         MIME-Version:Content-Type:X-Originating-IP:X-ClientProxiedBy;
        b=YIxIUBGC3iFirFcPMaXnEDP2my93nVbcjEbWaWBnBnKxDdjcoHZJwUo/uaMOM9Hc+
         rwzHKCh3Gd21avFCbfqzcog5rjX99fvXvFOcKR5OoUBb8tR8yHCsgbAHOksRaUcV3L
         foKGJyeVZshFXMJrASWumnDFxiTpJxpE3AEoRQ2kZLtJiZgIFWpwt2BHCOXXrfCWB+
         kC0V+u+bkTei2nj/IleyTVQsZjnm5dwcRSHqwQaTaEWo9p6PhjUFRrUE5E5AVEtZQb
         BiLbE4IXCAFD1NbAkpi5lyGpknlfq8glvFSHrUwoHdTw7ouqx54G6lqJuM2OFyBsq7
         0aYun7EAfm+zg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Tue, 2 Feb 2021, Marcelo Ricardo Leitner wrote:

> On Wed, Jan 27, 2021 at 04:32:47PM +0200, Paul Blakey wrote:
> > Add support for matching on ct_state reply flag.
> 
> Sorry for the late reply, missed the patchset here. (just noticed
> because of the iproute2 patch, thanks for the Cc in there)
> 
> Only one question though. Is it safe to assume that this will require
> a firmware update as well?

No, it will not, there was room for this flag in the register before (as 
long as you had a firmware recent enough that supported CT feature 
itself ofc).

Paul.

> 
> Thanks,
> Marcelo
> 
