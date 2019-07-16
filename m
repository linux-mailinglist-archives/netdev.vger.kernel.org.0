Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2BAA6A27D
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 08:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729502AbfGPGy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 02:54:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:56258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726295AbfGPGy6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jul 2019 02:54:58 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CAD02145D;
        Tue, 16 Jul 2019 06:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563260098;
        bh=mPZSs7oRE9+88LDQ6Gv7uY7/oIkTMgRUyRNxCeNBqBs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NURzboA8MC98MpA39kAF3gLIPflHaLWm33Tl2gq9zwi/XQyV3wMcuWhce1cwqf4tb
         1EHwYrGTfJLsHhRf57odbNSiUVTm2rI4lelKwAywFiOUxPUCBvpON+CzRR2UQXEkzD
         e13mmhSUOOy4udBZv/gvjC4Tj1CnXwVLaRdi5O7k=
Date:   Tue, 16 Jul 2019 09:54:54 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Mark Zhang <markz@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH iproute2-rc 1/8] rdma: Update uapi headers to add
 statistic counter support
Message-ID: <20190716065454.GF10130@mtr-leonro.mtl.com>
References: <20190710072455.9125-1-leon@kernel.org>
 <20190710072455.9125-2-leon@kernel.org>
 <20190715135238.7c0c7242@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190715135238.7c0c7242@hermes.lan>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 15, 2019 at 01:52:38PM -0700, Stephen Hemminger wrote:
> On Wed, 10 Jul 2019 10:24:48 +0300
> Leon Romanovsky <leon@kernel.org> wrote:
>
> > From: Mark Zhang <markz@mellanox.com>
> >
> > Update rdma_netlink.h to kernel commit 6e7be47a5345 ("RDMA/nldev:
> > Allow get default counter statistics through RDMA netlink").
> >
> > Signed-off-by: Mark Zhang <markz@mellanox.com>
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>
> I am waiting on this until it gets to Linus's tree.

It was merged tonight.
https://git.kernel.org/torvalds/c/2a3c389a0fde49b241430df806a34276568cfb29

Thanks
