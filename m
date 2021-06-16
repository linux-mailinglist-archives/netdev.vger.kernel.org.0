Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1D53A915E
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 07:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbhFPFrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 01:47:02 -0400
Received: from mailout1.secunet.com ([62.96.220.44]:51734 "EHLO
        mailout1.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbhFPFrC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 01:47:02 -0400
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id 963B680004A;
        Wed, 16 Jun 2021 07:44:51 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 07:44:51 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 16 Jun
 2021 07:44:51 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id CC3BF3180248; Wed, 16 Jun 2021 07:44:50 +0200 (CEST)
Date:   Wed, 16 Jun 2021 07:44:50 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Huy Nguyen <huyn@nvidia.com>
CC:     <netdev@vger.kernel.org>, <saeedm@nvidia.com>, <borisp@nvidia.com>,
        <raeds@nvidia.com>, <danielj@nvidia.com>, <yossiku@nvidia.com>,
        <kuba@kernel.org>
Subject: Re: [PATCH net-next v5 2/3] net/xfrm: Add inner_ipproto into sec_path
Message-ID: <20210616054450.GE40979@gauss3.secunet.de>
References: <20210614143349.74866-1-huyn@nvidia.com>
 <20210614143349.74866-3-huyn@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210614143349.74866-3-huyn@nvidia.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 14, 2021 at 05:33:48PM +0300, Huy Nguyen wrote:
> The inner_ipproto saves the inner IP protocol of the plain
> text packet. This allows vendor's IPsec feature making offload
> decision at skb's features_check and configuring hardware at
> ndo_start_xmit.
> 
> For example, ConnectX6-DX IPsec device needs the plaintext's
> IP protocol to support partial checksum offload on
> VXLAN/GENEVE packet over IPsec transport mode tunnel.
> 
> Signed-off-by: Raed Salem <raeds@nvidia.com>
> Signed-off-by: Huy Nguyen <huyn@nvidia.com>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>

In case you want to route this through the mlx5 tree:

Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
