Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22B8939B470
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 09:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbhFDH7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 03:59:19 -0400
Received: from mailout2.secunet.com ([62.96.220.49]:57886 "EHLO
        mailout2.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbhFDH7S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 03:59:18 -0400
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 2B76A80005A;
        Fri,  4 Jun 2021 09:57:31 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 4 Jun 2021 09:57:31 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 4 Jun 2021
 09:57:30 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 5FE523180326; Fri,  4 Jun 2021 09:57:30 +0200 (CEST)
Date:   Fri, 4 Jun 2021 09:57:30 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Huy Nguyen <huyn@nvidia.com>
CC:     <netdev@vger.kernel.org>, <saeedm@nvidia.com>, <borisp@nvidia.com>,
        <raeds@nvidia.com>, <danielj@nvidia.com>, <yossiku@nvidia.com>,
        <kuba@kernel.org>
Subject: Re: [RESEND PATCH net v3 0/3] Fix IPsec crypto offloads with vxlan
 tunnel
Message-ID: <20210604075730.GE40979@gauss3.secunet.de>
References: <20210603160045.11805-1-huyn@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210603160045.11805-1-huyn@nvidia.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 03, 2021 at 07:00:42PM +0300, Huy Nguyen wrote:
> v1 -> v2:
>   - Move inner_ipproto into xfrm_offload structure.
>   - Fix static code analysis errors.
>   - skip checking for skb->encapsulation to be more flexible for vendor
> 
> v2 -> v3:
>   - Fix bug in patch 003 when checking for xo null pointer in mlx5e_ipsec_feature_check
>   - Fix bug of accidentally commenting out memset in patch 003
> 
> This small series fixes ipsec TX offloads with vxlan overlay on top of
> the offloaded ipsec packet, the driver (mlx5) was lacking such information
> and the skb->encapsulation bit wasn't enough as indication to reach the
> vxlan inner headers, as a solution we mark the tunnel in the offloaded
> context of ipsec.

This patchset does not look like a fix. It looks more that you add
a feature that was not supported before, so the pachset should
go to -next.

Also, who should merge that pachset? I contains xfrm and mlx5
parts.
