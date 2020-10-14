Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD28E28D8D8
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 05:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729022AbgJNDHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 23:07:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:44738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727289AbgJNDHp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Oct 2020 23:07:45 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 760F42222F;
        Wed, 14 Oct 2020 03:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602644864;
        bh=Kg/Th/r9jM3AUQJ6/DBd6SzbbSRXMhloJCjTkANlcrY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vKfvqA/d68QazwdLBfF1eAIUvrfnj11+gS77o8y/s6HPBtRfZU5FnhfQqePGH8xrL
         O6N27z5WuC8BRjdTDwE9o5+2z2UtbeQXsvmgZupFUacD/KXfJTaUXj2J6NdF7Ta58q
         qEDOUc61gbES2rTwoThmzESHApZWD99Jj1uziv24=
Date:   Tue, 13 Oct 2020 20:07:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH 0/4] Netfilter fixes for net
Message-ID: <20201013200742.1210387a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201013234559.15113-1-pablo@netfilter.org>
References: <20201013234559.15113-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Oct 2020 01:45:55 +0200 Pablo Neira Ayuso wrote:
> Hi,
> 
> The following patchset contains Netfilter fixes for net:
> 
> 1) Extend nf_queue selftest to cover re-queueing, non-gso mode and
>    delayed queueing, from Florian Westphal.
> 
> 2) Clear skb->tstamp in IPVS forwarding path, from Julian Anastasov.
> 
> 3) Provide netlink extended error reporting for EEXIST case.
> 
> 4) Missing VLAN offload tag and proto in log target.
> 
> Please, pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git
> 
> Absolutely nothing urgent in this batch, you might consider pulling this
> once net-next.git gets merged into net.git so this shows up in 5.10-rc.

Pulled, thanks!
