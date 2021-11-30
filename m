Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8344640A8
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 22:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344953AbhK3Vuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 16:50:54 -0500
Received: from mail.netfilter.org ([217.70.188.207]:51786 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345007AbhK3VuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 16:50:06 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 3B02260022;
        Tue, 30 Nov 2021 22:44:28 +0100 (CET)
Date:   Tue, 30 Nov 2021 22:46:40 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Simon Horman <horms@verge.net.au>
Cc:     Julian Anastasov <ja@ssi.bg>,
        GuoYong Zheng <zhenggy@chinatelecom.cn>,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ipvs: remove unused variable for ip_vs_new_dest
Message-ID: <YaabwJ/EG5l7fTkG@salvia>
References: <1636112380-11040-1-git-send-email-zhenggy@chinatelecom.cn>
 <25e945b7-9027-43cb-f79c-573fdce42a26@ssi.bg>
 <20211114180206.GA2757@vergenet.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211114180206.GA2757@vergenet.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 14, 2021 at 07:02:06PM +0100, Simon Horman wrote:
> On Sat, Nov 13, 2021 at 11:56:36AM +0200, Julian Anastasov wrote:
> > 
> > 	Hello,
> > 
> > On Fri, 5 Nov 2021, GuoYong Zheng wrote:
> > 
> > > The dest variable is not used after ip_vs_new_dest anymore in
> > > ip_vs_add_dest, do not need pass it to ip_vs_new_dest, remove it.
> > > 
> > > Signed-off-by: GuoYong Zheng <zhenggy@chinatelecom.cn>
> > 
> > 	Looks good to me for -next, thanks!
> > 
> > Acked-by: Julian Anastasov <ja@ssi.bg>
> 
> Thanks GuoYong,
> 
> Acked-by: Simon Horman <horms@verge.net.au>
> 
> Pablo, please consider this for nf-next at your convenience.

Applied to nf-next, thanks
