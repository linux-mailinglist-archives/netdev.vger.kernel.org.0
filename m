Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8E34C103A
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 11:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237804AbiBWKYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 05:24:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbiBWKYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 05:24:38 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C45AA8C7D8;
        Wed, 23 Feb 2022 02:24:08 -0800 (PST)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 9398E6434C;
        Wed, 23 Feb 2022 11:23:04 +0100 (CET)
Date:   Wed, 23 Feb 2022 11:24:04 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue] libnetfilter_queue: add support of
 skb->priority
Message-ID: <YhYLRLl9pJrdgsq1@salvia>
References: <Yfy2YxiwvDLtLvTo@salvia>
 <20220204102637.4272-1-nicolas.dichtel@6wind.com>
 <8c08a4e0-83a0-9fc1-798b-dbd6a53f7231@6wind.com>
 <20220204120126.GB15954@breakpoint.cc>
 <Yf02PG/793enEF4r@salvia>
 <e926bd60-7653-f528-ec15-2758a4ffc89a@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e926bd60-7653-f528-ec15-2758a4ffc89a@6wind.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 23, 2022 at 10:01:48AM +0100, Nicolas Dichtel wrote:
> 
> Le 04/02/2022 à 15:20, Pablo Neira Ayuso a écrit :
> > On Fri, Feb 04, 2022 at 01:01:26PM +0100, Florian Westphal wrote:
> >> Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:
> >>>
> >>> Le 04/02/2022 à 11:26, Nicolas Dichtel a écrit :
> >>>> Available since linux v5.18.
> >>>>
> >>>> Link: https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=
> >>>> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> >>>> ---
> >>>
> >>> Should I send another patch for the 'set' part?
> >>> In this case, a nfq_set_verdict3(). The name is a bit ugly ;-)
> >>> Any suggestions?
> >>
> >> I think we should just let the old api die and tell users
> >> to use the mnl interface, that allows to add the new attribute
> >> as soon as its available.
> > 
> > We have to provide a simple API based on mnl which ressembles the
> > existing old API.
> > 
> > Feedback in these years is that there are a users that do not need to
> > know about netlink details / advanced handling.
>
> If I understand well, libnetfilter_queue is deprecated?

This library is not deprecated.

> If this is right, maybe it could be advertised on the project page:
> https://netfilter.org/projects/libnetfilter_queue/index.html

Documentation already mentions this:

https://netfilter.org/projects/libnetfilter_queue/doxygen/html/
