Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB0D118C95
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 16:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727502AbfLJPdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 10:33:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:53400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727407AbfLJPdp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 10:33:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 320EF20828;
        Tue, 10 Dec 2019 15:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575992024;
        bh=nLZA5ZbCz7QiGTtYWyz0V6hrLPBQJ/rlL4jRr8D7qKw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pNi69Nzbx6xl1X9jnQCirdLqTBm2eolQKSjfH7i4HM039C8U1ZaSTJtb2liIM1XUK
         zAeIajpHBWzwFFWVrBMFAlhiPMSmcrXiTdU0/UCC1MdFF+QCS+50QqyTSwc9/Q1VD0
         8b6Iha+/rzrH/j5Knrx3g2FOrEb4paCmBfSi47nQ=
Date:   Tue, 10 Dec 2019 16:33:42 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, Shiraz Saleem <shiraz.saleem@intel.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com, jgg@ziepe.ca,
        parav@mellanox.com, Mustafa Ismail <mustafa.ismail@intel.com>
Subject: Re: [PATCH v3 04/20] i40e: Register a virtbus device to provide RDMA
Message-ID: <20191210153342.GC4053085@kroah.com>
References: <20191209224935.1780117-1-jeffrey.t.kirsher@intel.com>
 <20191209224935.1780117-5-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191209224935.1780117-5-jeffrey.t.kirsher@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 02:49:19PM -0800, Jeff Kirsher wrote:
> --- a/drivers/infiniband/hw/i40iw/Makefile
> +++ b/drivers/infiniband/hw/i40iw/Makefile
> @@ -1,5 +1,4 @@
>  # SPDX-License-Identifier: GPL-2.0
> -ccflags-y :=  -I $(srctree)/drivers/net/ethernet/intel/i40e

Isn't dropping this cflags good for a nice simple separate patch to keep
the #include mess from cluttering up a patch that is trying to add
new functionality?

