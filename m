Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 691A54A98D2
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 13:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233781AbiBDMB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 07:01:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbiBDMB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 07:01:28 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C959AC061714;
        Fri,  4 Feb 2022 04:01:28 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nFxHK-0007Yz-VG; Fri, 04 Feb 2022 13:01:27 +0100
Date:   Fri, 4 Feb 2022 13:01:26 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue] libnetfilter_queue: add support of
 skb->priority
Message-ID: <20220204120126.GB15954@breakpoint.cc>
References: <Yfy2YxiwvDLtLvTo@salvia>
 <20220204102637.4272-1-nicolas.dichtel@6wind.com>
 <8c08a4e0-83a0-9fc1-798b-dbd6a53f7231@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8c08a4e0-83a0-9fc1-798b-dbd6a53f7231@6wind.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:
> 
> Le 04/02/2022 à 11:26, Nicolas Dichtel a écrit :
> > Available since linux v5.18.
> > 
> > Link: https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=
> > Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> > ---
> 
> Should I send another patch for the 'set' part?
> In this case, a nfq_set_verdict3(). The name is a bit ugly ;-)
> Any suggestions?

I think we should just let the old api die and tell users
to use the mnl interface, that allows to add the new attribute
as soon as its available.
