Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B144C4A9ADA
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 15:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359250AbiBDOUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 09:20:49 -0500
Received: from mail.netfilter.org ([217.70.188.207]:50164 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234877AbiBDOUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 09:20:48 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 7AE0C6019D;
        Fri,  4 Feb 2022 15:20:42 +0100 (CET)
Date:   Fri, 4 Feb 2022 15:20:44 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue] libnetfilter_queue: add support of
 skb->priority
Message-ID: <Yf02PG/793enEF4r@salvia>
References: <Yfy2YxiwvDLtLvTo@salvia>
 <20220204102637.4272-1-nicolas.dichtel@6wind.com>
 <8c08a4e0-83a0-9fc1-798b-dbd6a53f7231@6wind.com>
 <20220204120126.GB15954@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220204120126.GB15954@breakpoint.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 04, 2022 at 01:01:26PM +0100, Florian Westphal wrote:
> Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:
> > 
> > Le 04/02/2022 à 11:26, Nicolas Dichtel a écrit :
> > > Available since linux v5.18.
> > > 
> > > Link: https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=
> > > Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> > > ---
> > 
> > Should I send another patch for the 'set' part?
> > In this case, a nfq_set_verdict3(). The name is a bit ugly ;-)
> > Any suggestions?
> 
> I think we should just let the old api die and tell users
> to use the mnl interface, that allows to add the new attribute
> as soon as its available.

We have to provide a simple API based on mnl which ressembles the
existing old API.

Feedback in these years is that there are a users that do not need to
know about netlink details / advanced handling.
