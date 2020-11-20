Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95BFD2BB1D2
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 18:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728430AbgKTRzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 12:55:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:38286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727421AbgKTRzt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 12:55:49 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12D0D2240B;
        Fri, 20 Nov 2020 17:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605894948;
        bh=p1gJDXFBdFgZFMlQqX3suQ5vf10pruvprWs0fDaXpEU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=M21V4cVQZrzq2sjgJaGX6CIeDTSp1hVwmOZe022JsG2y6gUrwGeOCircglJYKW1x/
         zQx3VvumF20fa1L813GnsaMuBwtJdsQUopuHgkOexnYXn3IuBHKREfQLyekcdmHqns
         TstzBvY2uYFqt5f7z9ScXWcyIAouICl5pE5v3vgY=
Date:   Fri, 20 Nov 2020 09:55:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     nusiddiq@redhat.com, dev@openvswitch.org, netdev@vger.kernel.org,
        Pravin B Shelar <pshelar@ovn.org>,
        netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next v2] net: openvswitch: Be liberal in tcp
 conntrack.
Message-ID: <20201120095546.169bb9c3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201120063211.GN15137@breakpoint.cc>
References: <20201116130126.3065077-1-nusiddiq@redhat.com>
        <20201119205749.0c3eaf8b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20201120063211.GN15137@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Nov 2020 07:32:11 +0100 Florian Westphal wrote:
> Jakub Kicinski <kuba@kernel.org> wrote:
> > On Mon, 16 Nov 2020 18:31:26 +0530 nusiddiq@redhat.com wrote:  
> > > From: Numan Siddique <nusiddiq@redhat.com>
> > > 
> > > There is no easy way to distinguish if a conntracked tcp packet is
> > > marked invalid because of tcp_in_window() check error or because
> > > it doesn't belong to an existing connection. With this patch,
> > > openvswitch sets liberal tcp flag for the established sessions so
> > > that out of window packets are not marked invalid.
> > > 
> > > A helper function - nf_ct_set_tcp_be_liberal(nf_conn) is added which
> > > sets this flag for both the directions of the nf_conn.
> > > 
> > > Suggested-by: Florian Westphal <fw@strlen.de>
> > > Signed-off-by: Numan Siddique <nusiddiq@redhat.com>  
> 
> Acked-by: Florian Westphal <fw@strlen.de>

Thanks! Applied.
