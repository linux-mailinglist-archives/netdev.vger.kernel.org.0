Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92CEB2C18A3
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 23:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732876AbgKWWlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 17:41:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:48564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732857AbgKWWlj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 17:41:39 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74211206B7;
        Mon, 23 Nov 2020 22:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606171298;
        bh=63QX6xzI0bDnVsnkfl4UNC4w2nSOAWn/TWg3heNzFO4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=niymz3KIHbCG4Kt8zM9DlfDIrxm7N90S7vWopXVTHtCotlwxFUJzfrPvILG1eSPak
         BnMpX7Es1Q89vDHv8Zq1ACudYueyU78TrCoLXHIhEsYorTdtwxTkneqxghXFC4QHOC
         RJsgTpS9nBkgF4TGgzyVXPZp6ZuKpHkc8fIBARt8=
Date:   Mon, 23 Nov 2020 14:41:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Nikolay Aleksandrov <nikolay@nvidia.com>, <roopa@nvidia.com>,
        <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] bridge: mrp: Implement LC mode for MRP
Message-ID: <20201123144137.16459e9c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201123223148.gvexo37ibzophobl@soft-dev3.localdomain>
References: <20201123111401.136952-1-horatiu.vultur@microchip.com>
        <5ffa6f9f-d1f3-adc7-ddb8-e8107ea78da5@nvidia.com>
        <20201123123132.uxvec6uwuegioc25@soft-dev3.localdomain>
        <13cef7c2-cacc-2c24-c0d5-e462b0e3b4df@nvidia.com>
        <20201123140519.3bb3db16@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201123223148.gvexo37ibzophobl@soft-dev3.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Nov 2020 23:31:48 +0100 Horatiu Vultur wrote:
> > The existing structs are only present in net-next as well, so if you
> > don't mind Horatiu it'd be good to follow up and remove the unused ones
> > and move the ones (if any) which are only used by the kernel but not by
> > the user space <-> kernel API communication out of include/uapi.  
> 
> Maybe we don't refer to the same structs, but I could see that they are
> already in net and in Linus' tree. For example the struct
> 'br_mrp_ring_topo_hdr'. Or am I missunderstanding something?

Ah, scratch that, I thought this was HSR, I should have paid more
attention. Nothing we can do about the existing ones, then.
