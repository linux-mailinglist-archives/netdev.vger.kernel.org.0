Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31C123B0FA3
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 23:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbhFVV4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 17:56:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:44544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229501AbhFVV4B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 17:56:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9D3E6128E;
        Tue, 22 Jun 2021 21:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624398825;
        bh=p1/lrUIP7iLu1Yn909hDA9i2sIYn0w7fqsmy2OOOdCQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=vCDQD5oF6KabJrEjgfA71J143KcOKpErZECyCsQCPT5/hSgdFrhDMIhtn7dsEGzs2
         yhQcsk9+lqy2jzB1EWEMg834AKxan2tnDv6qR02RTWZkl4gjMc7F8329sGsp4YCh5M
         x1hHCQzftD8RSN7FyRgRDOB9QmEENtsHzLN3NYnx+Q+k61I/EKQX/I70y30fyaJDXl
         RjpfEzvUyllnQXmizF10ryuCIIw0LBnUCkjUYwuQFoArtwEhn5flD06DVN4k6eESRY
         iD/DE+zi2Btqy6EDEvm7mJPEym07N6Hn+fDIGR3z9ZSKs+hC6J2TaIZQVY5pSAX6Mq
         vk6W00A5krl0g==
Message-ID: <6c10216ae0d95aa3fb9e2290830f7196fea9365d.camel@kernel.org>
Subject: Re: [PATCH net-next v5 0/3] Fix IPsec crypto offloads with vxlan
 tunnel
From:   Saeed Mahameed <saeed@kernel.org>
To:     Huy Nguyen <huyn@nvidia.com>, netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, borisp@nvidia.com, raeds@nvidia.com,
        danielj@nvidia.com, yossiku@nvidia.com, kuba@kernel.org
Date:   Tue, 22 Jun 2021 14:53:43 -0700
In-Reply-To: <20210614143349.74866-1-huyn@nvidia.com>
References: <20210614143349.74866-1-huyn@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.2 (3.40.2-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-06-14 at 17:33 +0300, Huy Nguyen wrote:
> v4 -> v5:
>   - Fix double initialization of xo in xfrm_get_inner_ipproto
> 
> v3 -> v4:
>  - Check explicitly for skb->ecapsulation before calling
> xfrm_get_inner_ipproto.
>  - Move patche set to net-next
> 
> v2 -> v3:
>   - Fix bug in patch 003 when checking for xo null pointer in
> mlx5e_ipsec_feature_check
>   - Fix bug of accidentally commenting out memset in patch 003
> 
> v1 -> v2:
>   - Move inner_ipproto into xfrm_offload structure.
>   - Fix static code analysis errors.
>   - skip checking for skb->encapsulation to be more flexible for
> vendor
> 
> This small series fixes ipsec TX offloads with vxlan overlay on top
> of
> the offloaded ipsec packet, the driver (mlx5) was lacking such
> information
> and the skb->encapsulation bit wasn't enough as indication to reach
> the
> vxlan inner headers, as a solution we mark the tunnel in the
> offloaded
> context of ipsec.
> 

Series applied to net-next-mlx5.

Thanks,
Saeed.

