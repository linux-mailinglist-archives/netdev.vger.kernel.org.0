Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 229F2425A03
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 19:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242995AbhJGRzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 13:55:32 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60240 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242757AbhJGRzb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 13:55:31 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id A88E563EB1;
        Thu,  7 Oct 2021 19:52:04 +0200 (CEST)
Date:   Thu, 7 Oct 2021 19:53:32 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Simon Horman <horms@verge.net.au>
Cc:     Julian Anastasov <ja@ssi.bg>, Dust Li <dust.li@linux.alibaba.com>,
        Wensong Zhang <wensong@linux-vs.org>,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, yunhong-cgl jiang <xintian1976@gmail.com>
Subject: Re: [PATCH net-next v4] net: ipvs: add sysctl_run_estimation to
 support disable estimation
Message-ID: <YV80HOzv+2oV4ppf@salvia>
References: <20210820053752.11508-1-dust.li@linux.alibaba.com>
 <5f590b6-4668-19fe-b768-15125f48df1e@ssi.bg>
 <20211002085929.GA27500@vergenet.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211002085929.GA27500@vergenet.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 02, 2021 at 10:59:29AM +0200, Simon Horman wrote:
> On Sat, Aug 21, 2021 at 11:41:50AM +0300, Julian Anastasov wrote:
> > 
> > 	Hello,
> > 
> > On Fri, 20 Aug 2021, Dust Li wrote:
> > 
> > > estimation_timer will iterate the est_list to do estimation
> > > for each ipvs stats. When there are lots of services, the
> > > list can be very large.
> > > We found that estimation_timer() run for more then 200ms on a
> > > machine with 104 CPU and 50K services.
> > > 
> > > yunhong-cgl jiang report the same phenomenon before:
> > > https://www.spinics.net/lists/lvs-devel/msg05426.html
> > > 
> > > In some cases(for example a large K8S cluster with many ipvs services),
> > > ipvs estimation may not be needed. So adding a sysctl blob to allow
> > > users to disable this completely.
> > > 
> > > Default is: 1 (enable)
> > > 
> > > Cc: yunhong-cgl jiang <xintian1976@gmail.com>
> > > Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
> > 
> > 	Looks good to me, thanks!
> > 
> > Acked-by: Julian Anastasov <ja@ssi.bg>
> 
> Likwewise, thanks. And sorry for the delay.
> 
> Acked-by: Simon Horman <horms@verge.net.au>
> 
> Pablo, could you consider picking this up?

Applied, thanks.
