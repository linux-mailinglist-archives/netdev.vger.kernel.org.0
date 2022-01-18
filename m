Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5584925CC
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 13:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235619AbiARMg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 07:36:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232927AbiARMgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 07:36:53 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25879C061574;
        Tue, 18 Jan 2022 04:36:53 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1n9njH-0005gK-8A; Tue, 18 Jan 2022 13:36:51 +0100
Date:   Tue, 18 Jan 2022 13:36:51 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     fw@strlen.de, pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH nf-next] nfqueue: enable to get skb->priority
Message-ID: <20220118123651.GF28638@breakpoint.cc>
References: <20220117205613.26153-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220117205613.26153-1-nicolas.dichtel@6wind.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:
> This info could be useful to improve traffic analysis.

Acked-by: Florian Westphal <fw@strlen.de>

