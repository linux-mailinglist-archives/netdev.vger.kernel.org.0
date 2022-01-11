Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5357848AA95
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 10:32:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349268AbiAKJcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 04:32:52 -0500
Received: from mail.netfilter.org ([217.70.188.207]:45730 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236995AbiAKJcw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 04:32:52 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 74FB9607C3;
        Tue, 11 Jan 2022 10:29:59 +0100 (CET)
Date:   Tue, 11 Jan 2022 10:32:43 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] netfilter: nf_tables: fix compile warnings
Message-ID: <Yd1OuyV3ztYc+jAl@salvia>
References: <20220110221419.60994-1-pablo@netfilter.org>
 <20220110205755.5dd76c64@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220110205755.5dd76c64@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 10, 2022 at 08:57:55PM -0800, Jakub Kicinski wrote:
> On Mon, 10 Jan 2022 23:14:19 +0100 Pablo Neira Ayuso wrote:
> > Remove unused variable and fix missing initialization.
> > 
> > >> net/netfilter/nf_tables_api.c:8266:6: warning: variable 'i' set but not used [-Wunused-but-set-variable]  
> >            int i;
> >                ^
> > >> net/netfilter/nf_tables_api.c:8277:4: warning: variable 'data_size' is uninitialized when used here [-Wuninitialized]  
> >                            data_size += sizeof(*prule) + rule->dlen;
> >                            ^~~~~~~~~
> >    net/netfilter/nf_tables_api.c:8262:30: note: initialize the variable 'data_size' to silence this warning
> >            unsigned int size, data_size;
> > 
> > Fixes: 2c865a8a28a1 ("netfilter: nf_tables: add rule blob layout")
> > Reported-by: kernel test robot <lkp@intel.com>
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> > Please, directly apply to net-next, thanks. Otherwise let me know and
> > I'll prepare a pull request with pending fixes once net-next gets merged
> > into net.
> 
> As you have probably seen Linus fixed this up himself.
> 
> You can take the fix for the other warning thru your tree.

That's fine, thanks.
