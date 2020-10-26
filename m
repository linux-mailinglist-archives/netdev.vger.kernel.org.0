Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BEDB299974
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 23:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392761AbgJZWRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 18:17:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:34246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392676AbgJZWRd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 18:17:33 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC1D420878;
        Mon, 26 Oct 2020 22:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603750653;
        bh=p4PC76Jm/Q6Lj605enidru+/QU7zyvBpuAEcCx480Kw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VdgWunkXIWAmQSOM5UtVMKsqxuueW7tru2GBJAI1IifwZyrV/ixcW/m6WVtpGkA+Y
         aV7h3S2zXsPMmC68Dww6civoZta1nslhSyJl9Evz4awq1/ubfMM3MUx+8BQzhRyD3D
         mSkm/D8OeVacb8NiOHDVGu2+NyYRh5NmRILXere4=
Date:   Mon, 26 Oct 2020 15:17:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christian Langrock <christian.langrock@secunet.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>
Subject: Re: [RESEND: PATCH net] drivers: net: ixgbe: Fix
 *_ipsec_offload_ok():, Use ip_hdr family
Message-ID: <20201026151731.5fb25150@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <5bbccb85-9d71-1f99-e668-27893c4e9945@secunet.com>
References: <5bbccb85-9d71-1f99-e668-27893c4e9945@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Oct 2020 17:03:16 +0100 Christian Langrock wrote:
> Xfrm_dev_offload_ok() is called with the unencrypted SKB. So in case of
> interfamily ipsec traffic (IPv4-in-IPv6 and IPv6 in IPv4) the check
> assumes the wrong family of the skb (IP family of the state).
> With this patch the ip header of the SKB is used to determine the
> family.
> 
> Fixes IP family handling for offloading inter family packets.
> 
> Signed-off-by: Christian Langrock <christian.langrock@secunet.com>

All your 3 submissions got mangled by the email client.

You'll need to resend, perhaps try git send-email?
