Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B9E2E7C00
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 19:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgL3S60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 13:58:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbgL3S6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 13:58:25 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A30AC061573
        for <netdev@vger.kernel.org>; Wed, 30 Dec 2020 10:57:45 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kugez-00075i-W8; Wed, 30 Dec 2020 19:57:26 +0100
Date:   Wed, 30 Dec 2020 19:57:25 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Visa Hankala <visa@hankala.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH v2] xfrm: Fix wraparound in xfrm_policy_addr_delta()
Message-ID: <20201230185725.GD30823@breakpoint.cc>
References: <20201230160902.sYeDeDSVSPay2WBC@hankala.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201230160902.sYeDeDSVSPay2WBC@hankala.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Visa Hankala <visa@hankala.org> wrote:
> Use three-way comparison for address components to avoid integer
> wraparound in the result of xfrm_policy_addr_delta(). This ensures
> that the search trees are built and traversed correctly.
> 
> Treat IPv4 and IPv6 similarly by returning 0 when prefixlen == 0.
> Prefix /0 has only one equivalence class.

Acked-by: Florian Westphal <fw@strlen.de>
