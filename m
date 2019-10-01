Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA3CAC30AE
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 11:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729782AbfJAJyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 05:54:12 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:34344 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbfJAJyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 05:54:12 -0400
Received: from reginn.horms.nl (watermunt.horms.nl [80.127.179.77])
        by kirsty.vergenet.net (Postfix) with ESMTPA id B423D25B7D2;
        Tue,  1 Oct 2019 19:54:09 +1000 (AEST)
Received: by reginn.horms.nl (Postfix, from userid 7100)
        id A2B7494046A; Tue,  1 Oct 2019 11:54:07 +0200 (CEST)
Date:   Tue, 1 Oct 2019 11:54:07 +0200
From:   Simon Horman <horms@verge.net.au>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     zhang kai <zhangkaiheb@126.com>,
        Wensong Zhang <wensong@linux-vs.org>,
        lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] ipvs: no need to update skb route entry for local
 destination packets.
Message-ID: <20191001095404.4sufoczzm7o3z7e2@verge.net.au>
References: <20190930051455.GA20692@toolchain>
 <alpine.LFD.2.21.1909302146530.2706@ja.home.ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.21.1909302146530.2706@ja.home.ssi.bg>
Organisation: Horms Solutions BV
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 30, 2019 at 09:49:38PM +0300, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Mon, 30 Sep 2019, zhang kai wrote:
> 
> > In the end of function __ip_vs_get_out_rt/__ip_vs_get_out_rt_v6,the
> > 'local' variable is always zero.
> > 
> > Signed-off-by: zhang kai <zhangkaiheb@126.com>
> 
> 	Looks good to me, thanks!
> 
> Acked-by: Julian Anastasov <ja@ssi.bg>
> 
> 	Simon, this is for -next kernels...

Thanks, applied to ipvs-next.
