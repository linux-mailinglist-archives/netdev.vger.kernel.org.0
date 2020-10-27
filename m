Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37FFF29A493
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 07:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506455AbgJ0GWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 02:22:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:56380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2506440AbgJ0GVP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 02:21:15 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48BAB207DE;
        Tue, 27 Oct 2020 06:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603779675;
        bh=yP09p9hZPmd+16unIG3T+EwKYoIL0pNMvswa7AvAxT4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OCXK1MqAXCw5aWvtyva7JWe+UcoOZ5sHTdsOJe8euA0Z9GAQ5oQ/5o9hngO4ggqOv
         Sl/feiQXVE6RZyIvPh6UBuJF35zOv9GK6BaXFw9YnrFEV6y0fEZqg3PGjBiCZDCVrM
         Rr0xlE0sI10yslvBYX3WpP1XRhMUJ2mXe5Wp9VWg=
Date:   Tue, 27 Oct 2020 07:21:11 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Cc:     stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        linux-kernel@vger.kernel.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH linux-5.9 1/1] net: netfilter: fix KASAN:
 slab-out-of-bounds Read in nft_flow_rule_create
Message-ID: <20201027062111.GD206502@kroah.com>
References: <20201019172532.3906-1-saeed.mirzamohammadi@oracle.com>
 <20201020115047.GA15628@salvia>
 <28C74722-8F35-4397-B567-FA5BCF525891@oracle.com>
 <3BE1A64B-7104-4220-BAD1-870338A33B15@oracle.com>
 <566D38F7-7C99-40F4-A948-03F2F0439BBB@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <566D38F7-7C99-40F4-A948-03F2F0439BBB@oracle.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 25, 2020 at 04:31:57PM -0700, Saeed Mirzamohammadi wrote:
> Adding stable.

What did that do?

confused,

greg k-h
