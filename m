Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13E5D35A664
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 20:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234796AbhDIS5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 14:57:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:59012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234782AbhDIS5D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 14:57:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B38361106;
        Fri,  9 Apr 2021 18:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617994609;
        bh=7cAh+kkcW+6AMbXD4wJ2ZSFrNM/VIcLaAWhcDxEukx8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mJ8hVg84A+PMRawv25sPZ7R4LODYFixpEOXoJ8lN60SdvNrzYEt2jyeQ2T1dYxPgT
         PKrsCC+vrIVJgl1Lqp9We+QP41p8TIVvR2z6pjneVP2y0w2GKdisoHDR559LdUfo3p
         7UyHfJEgJxXKmCuZE+tqNUBH3snpYnwxbbYFJ6298pJTEtxXCUpc7btwmc71IoTHov
         spbBCAqnbmYoD2C04iV8Q7zRzK4EJgjF/u6b2PPBwS3081L8hHgxRPWL5ZP+hlnHYg
         KHG6XoNXQZvI0wpxtmvvt3FMFfNMJ1BAP/KeL6V2yn5GpdVVliX3375hNyjK9cFOsM
         47ZQVPDBPy5cw==
Date:   Fri, 9 Apr 2021 11:56:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matteo Croce <mcroce@linux.microsoft.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next v2 3/5] page_pool: Allow drivers to hint on SKB
 recycling
Message-ID: <20210409115648.169523fd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210402181733.32250-4-mcroce@linux.microsoft.com>
References: <20210402181733.32250-1-mcroce@linux.microsoft.com>
        <20210402181733.32250-4-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  2 Apr 2021 20:17:31 +0200 Matteo Croce wrote:
> Co-developed-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Co-developed-by: Matteo Croce <mcroce@microsoft.com>
> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

Checkpatch says we need sign-offs from all authors.
Especially you since you're posting.
