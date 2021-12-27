Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D021E47FDC1
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 15:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237033AbhL0OIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 09:08:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237016AbhL0OIQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 09:08:16 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B3B0C06173E;
        Mon, 27 Dec 2021 06:08:16 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1n1qfc-00006U-PU; Mon, 27 Dec 2021 15:08:12 +0100
Date:   Mon, 27 Dec 2021 15:08:12 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] selftests/netfilter: switch to socat for tests using
 -q option
Message-ID: <20211227140812.GA21386@breakpoint.cc>
References: <20211227035253.144503-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211227035253.144503-1-liuhangbin@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> wrote:
> The nc cmd(nmap-ncat) that distributed with Fedora/Red Hat does not have
> option -q. This make some tests failed with:
> 
> 	nc: invalid option -- 'q'
> 
> Let's switch to socat which is far more dependable.

Thanks for doing this work.

Acked-by: Florian Westphal <fw@strlen.de>
