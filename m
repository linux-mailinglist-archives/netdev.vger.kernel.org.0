Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 834C024939C
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 05:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgHSDpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 23:45:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:37690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726342AbgHSDpm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 23:45:42 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17D7220709;
        Wed, 19 Aug 2020 03:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597808742;
        bh=nLhiDNyy+rXdZmfqSvL1+Wu2Ehr6J7iBIfGSi9aQkRA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LdY9vRlrbWY8cP5EWXRZFfKJAHIyqYfjhtCzpegdd1nP9i1uLJmuxxNBL+O54IG2u
         rn6mJa07ylfST/PeaPFHXBuO9S3zK08Y9HzMuJZztlOeAc4xiRsGO7owQ6Q6bgwNBe
         h1mgWnUMMmvlo6FqejXSyRNAZUNrepAUz8aPF6jY=
Date:   Tue, 18 Aug 2020 20:45:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Bin Luo <luobin9@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Danielle Ratson <danieller@mellanox.com>
Subject: Re: [net-next v3 1/4] devlink: check flash_update parameter support
 in net core
Message-ID: <20200818204540.2a278200@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200819002821.2657515-2-jacob.e.keller@intel.com>
References: <20200819002821.2657515-1-jacob.e.keller@intel.com>
        <20200819002821.2657515-2-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Aug 2020 17:28:15 -0700 Jacob Keller wrote:
>  struct devlink_ops {
> +	/**
> +	 * @supported_flash_update_params:
> +	 * mask of parameters supported by the driver's .flash_update
> +	 * implemementation.
> +	 */
> +	u32 supported_flash_update_params;

To be sure - this doesn't generate W=1 warnings?

Sadly the posting confused patchwork series grouping and my build tester
(I think it's the iproute patches mixed with the kernel stuff).
