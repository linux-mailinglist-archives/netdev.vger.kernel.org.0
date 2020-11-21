Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 995632BC1B8
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 20:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728405AbgKUTXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 14:23:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:33766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728397AbgKUTXt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Nov 2020 14:23:49 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32B4B221F1;
        Sat, 21 Nov 2020 19:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605986629;
        bh=0pJCGNTenNNBWUHzsE9A45K0tFQWW7QRUQ80lGJlWW0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CG9V9kJbxNQej5zCRmOcG3KLHP9xM4rfZReh69kz/wlnjOZRHSKma89juw081mNuE
         LnEJE61A4U4ls+AvohC/TSIG2atv60K3iPRDFF7iCS7OjvheiHWxy53CdZu/A46GkR
         HbU+hGIcRCrBN5kCWRc/XmtHFlM6jjYDcT+QEsxw=
Date:   Sat, 21 Nov 2020 11:23:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, razor@blackwall.org, jeremy@azazel.net
Subject: Re: [PATCH net-next,v3 0/9] netfilter: flowtable bridge and vlan
 enhancements
Message-ID: <20201121112348.0e25afa3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201121185621.GA23017@salvia>
References: <20201114115906.GA21025@salvia>
        <87sg9cjaxo.fsf@waldekranz.com>
        <20201114090347.2e7c1457@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201116221815.GA6682@salvia>
        <20201116142844.7c492fb6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201116223615.GA6967@salvia>
        <20201116144521.771da0c6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201116225658.GA7247@salvia>
        <20201121123138.GA21560@salvia>
        <20201121101551.3264c5fd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201121185621.GA23017@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 21 Nov 2020 19:56:21 +0100 Pablo Neira Ayuso wrote:
> > Please gather some review tags from senior netdev developers. I don't
> > feel confident enough to apply this as 100% my own decision.  
> 
> Fair enough.
> 
> This requirement for very specific Netfilter infrastructure which does
> not affect any other Networking subsystem sounds new to me.

You mean me asking for reviews from other senior folks when I don't
feel good about some code? I've asked others the same thing in the
past, e.g. Paolo for his RPS thing.

> What senior developers specifically you would like I should poke to
> get an acknowledgement on this to get this accepted of your
> preference?

I don't want to make a list. Maybe netconf attendees are a safe bet?
