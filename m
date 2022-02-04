Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9E244A9341
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 06:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbiBDFQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 00:16:31 -0500
Received: from mail.netfilter.org ([217.70.188.207]:49164 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232647AbiBDFQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 00:16:30 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 0296660198;
        Fri,  4 Feb 2022 06:16:23 +0100 (CET)
Date:   Fri, 4 Feb 2022 06:16:26 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH nf-next] nfqueue: enable to get skb->priority
Message-ID: <Yfy2qiiYEeWLe8sI@salvia>
References: <20220117205613.26153-1-nicolas.dichtel@6wind.com>
 <Yfy2YxiwvDLtLvTo@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yfy2YxiwvDLtLvTo@salvia>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 04, 2022 at 06:15:20AM +0100, Pablo Neira Ayuso wrote:
> On Mon, Jan 17, 2022 at 09:56:13PM +0100, Nicolas Dichtel wrote:
> > This info could be useful to improve traffic analysis.
> 
> Applied.

Maybe allow to update this skbuff field from the verdict path too?
I don't remember any read-only field like this in nfqueue.
