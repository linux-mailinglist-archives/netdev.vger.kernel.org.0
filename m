Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70BBD470383
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 16:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235073AbhLJPNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 10:13:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242644AbhLJPNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 10:13:21 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF343C061746
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 07:09:46 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mvhWr-0005bQ-0n; Fri, 10 Dec 2021 16:09:45 +0100
Date:   Fri, 10 Dec 2021 16:09:44 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Ignacy =?utf-8?B?R2F3xJlkemtp?= 
        <ignacy.gawedzki@green-communications.fr>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v2] netfilter: fix regression in looped
 (broad|multi)cast's MAC handling
Message-ID: <20211210150944.GG26636@breakpoint.cc>
References: <20211210142741.fsklz2vzlsow3qre@zenon.in.qult.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211210142741.fsklz2vzlsow3qre@zenon.in.qult.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ignacy Gawędzki <ignacy.gawedzki@green-communications.fr> wrote:
> In commit 5648b5e1169f ("netfilter: nfnetlink_queue: fix OOB when mac
> header was cleared"), the test for non-empty MAC header introduced in
> commit 2c38de4c1f8da7 ("netfilter: fix looped (broad|multi)cast's MAC
> handling") has been replaced with a test for a set MAC header, which
> breaks the case when the MAC header has been reset (using
> skb_reset_mac_header), as is the case with looped-back multicast
> packets.

Please rephrase this to say what breaks here.

I guess you get a bogus hwaddr in the netlink message?

Also, this should be sent to netfilter-devel@, not netdev@.

For the patch itself:
Reviewed-by: Florian Westphal <fw@strlen.de>
