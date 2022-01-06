Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9FF486241
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 10:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237505AbiAFJlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 04:41:42 -0500
Received: from mail.netfilter.org ([217.70.188.207]:34784 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237485AbiAFJlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 04:41:39 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2B42F63F4F;
        Thu,  6 Jan 2022 10:38:51 +0100 (CET)
Date:   Thu, 6 Jan 2022 10:41:34 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] selftests/netfilter: switch to socat for tests using
 -q option
Message-ID: <Yda5TkFPqJnnEv+t@salvia>
References: <20211227035253.144503-1-liuhangbin@gmail.com>
 <20211227140812.GA21386@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211227140812.GA21386@breakpoint.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 27, 2021 at 03:08:12PM +0100, Florian Westphal wrote:
> Hangbin Liu <liuhangbin@gmail.com> wrote:
> > The nc cmd(nmap-ncat) that distributed with Fedora/Red Hat does not have
> > option -q. This make some tests failed with:
> > 
> > 	nc: invalid option -- 'q'
> > 
> > Let's switch to socat which is far more dependable.
> 
> Thanks for doing this work.
> 
> Acked-by: Florian Westphal <fw@strlen.de>

Also applied, thanks
