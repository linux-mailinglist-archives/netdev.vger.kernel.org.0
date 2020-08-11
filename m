Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE19A241EAF
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 18:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729039AbgHKQxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 12:53:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:50076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728962AbgHKQxJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Aug 2020 12:53:09 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED2562076B;
        Tue, 11 Aug 2020 16:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597164788;
        bh=xkRH82B3R+oZS8iV2euS0c6n9AZFBM7sHNdbfeUt9LE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NL6+TBVyajFpv5hu9jZ1nSOZiNm+uUIMyDH8GxFw+R3sMnJeu1nDPHAAd0zeTT+eI
         pU/rDBDGfRbGYBEE4XVsfsqjsFUL1yPHp7cZPUIzbMQiCwDRDRsXjlisLRE2HJAESl
         zkiCOh8I6mSbHq0CMgHOrsNghO17JZHQFc8jy8Lo=
Date:   Tue, 11 Aug 2020 19:53:04 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     David Ahern <dsahern@gmail.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH iproute2-rc] rdma: Fix owner name for the kernel resources
Message-ID: <20200811165304.GF634816@unreal>
References: <20200811063304.581395-1-leon@kernel.org>
 <20200811085417.5a3dc986@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200811085417.5a3dc986@hermes.lan>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 11, 2020 at 08:54:17AM -0700, Stephen Hemminger wrote:
> On Tue, 11 Aug 2020 09:33:04 +0300
> Leon Romanovsky <leon@kernel.org> wrote:
>
> > +	print_color_string(PRINT_ANY, COLOR_NONE, "comm", "comm %s ", tmp);
>
> If you don't want color then just print_string will do the same thing.
>
> 	print_string(PRINT_ANY, "comm", "comm %s ", tmp);

We put print_color_string() in all places as a preparation to for the
future and didn't color it on purpose at this point of time.

I prefer to keep it in this way and color it later.

Thanks

>
>
>
