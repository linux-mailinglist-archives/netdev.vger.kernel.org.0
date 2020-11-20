Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE9672BA25B
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 07:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbgKTGcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 01:32:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725831AbgKTGcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 01:32:19 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF8EC0613CF;
        Thu, 19 Nov 2020 22:32:19 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kfzxr-00074O-R6; Fri, 20 Nov 2020 07:32:11 +0100
Date:   Fri, 20 Nov 2020 07:32:11 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     nusiddiq@redhat.com, dev@openvswitch.org, netdev@vger.kernel.org,
        Pravin B Shelar <pshelar@ovn.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next v2] net: openvswitch: Be liberal in tcp
 conntrack.
Message-ID: <20201120063211.GN15137@breakpoint.cc>
References: <20201116130126.3065077-1-nusiddiq@redhat.com>
 <20201119205749.0c3eaf8b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201119205749.0c3eaf8b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:
> On Mon, 16 Nov 2020 18:31:26 +0530 nusiddiq@redhat.com wrote:
> > From: Numan Siddique <nusiddiq@redhat.com>
> > 
> > There is no easy way to distinguish if a conntracked tcp packet is
> > marked invalid because of tcp_in_window() check error or because
> > it doesn't belong to an existing connection. With this patch,
> > openvswitch sets liberal tcp flag for the established sessions so
> > that out of window packets are not marked invalid.
> > 
> > A helper function - nf_ct_set_tcp_be_liberal(nf_conn) is added which
> > sets this flag for both the directions of the nf_conn.
> > 
> > Suggested-by: Florian Westphal <fw@strlen.de>
> > Signed-off-by: Numan Siddique <nusiddiq@redhat.com>
> 
> Florian, LGTY?

Sorry, this one sailed past me.

Acked-by: Florian Westphal <fw@strlen.de>
