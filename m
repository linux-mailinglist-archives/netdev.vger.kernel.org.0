Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFAF7293232
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 02:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389168AbgJTAEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 20:04:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:58790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389142AbgJTAEV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 20:04:21 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A86A1223FD;
        Tue, 20 Oct 2020 00:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603152261;
        bh=S9zp0TC3cfY9IrdSk+gNx2tHLTqXGmIK2HdMgzoCCug=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HBZCO9oRR3Z51OHruKzDo3vIX9rjMk2Tq4fDULVI8SWWPL8YsiG9THAkjGTG264QN
         WUnAsiUq6u9OqAaiyEe52rpIWR7Ez7SEUruhN4TIU2w/xuu3OMRwX+tLjO3sxIrbGP
         6m7OgfkbyfZtxN1cyL/QmWN1LSYVfTUgM/OcW/v0=
Date:   Mon, 19 Oct 2020 17:04:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Valentin Vidic <vvidic@valentin-vidic.from.hr>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Philip Rischel <rischelp@idt.com>,
        Florian Fainelli <florian@openwrt.org>,
        Roman Yeryomin <roman@advem.lv>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>,
        Martin Habets <mhabets@solarflare.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] net: korina: cast KSEG0 address to pointer in kfree
Message-ID: <20201019170419.5349577b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201018184255.28989-1-vvidic@valentin-vidic.from.hr>
References: <20201016194611.GK8773@valentin-vidic.from.hr>
        <20201018184255.28989-1-vvidic@valentin-vidic.from.hr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 18 Oct 2020 20:42:55 +0200 Valentin Vidic wrote:
> Fixes gcc warning:
> 
> passing argument 1 of 'kfree' makes pointer from integer without a cast
> 
> Fixes: 3af5f0f5c74e ("net: korina: fix kfree of rx/tx descriptor array")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Valentin Vidic <vvidic@valentin-vidic.from.hr>

Applied, thank you!
