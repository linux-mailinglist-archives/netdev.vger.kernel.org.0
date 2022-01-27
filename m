Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D326949D806
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 03:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235075AbiA0CYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 21:24:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiA0CYN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 21:24:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B22C06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 18:24:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02710B820FA
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 02:24:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D8F8C340E7;
        Thu, 27 Jan 2022 02:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643250250;
        bh=QtfJk8K/5bdg5Z28Af2/eH3aZUXbfbX2/x8B9Y4Wnlc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jh4cI3LVcXEnpHZb3RYEr3LF+8OLkQj+GazwgTWvD1eZhXoANq1XNhNE4XpvlBZ7n
         n1mB4jEENB1byCG/O3Tf9k+Rf1W+t/g5dsJ2GoCw6f5rTIMxd3kK1hR8veHgpLEfbX
         QXy82o+pmPF5ejEAty/UxKaPpqBAb2zvZn8PjJUvZk/lrNE6zNVc1nvQpLRp+ykcMH
         To4vO+Z/MmcRXlGXfJSGOnhiR67EB1dzEa2c5q3n8Wgog3uCkI7zscb59FiI9P0KwL
         gRIMW1zIDnp9ZSfXp3BzffysMzBSANTqbzBN8/3einUJwwSiu8bZfugMp/jZbYzsKZ
         qSI+VC6iVeEsg==
Date:   Wed, 26 Jan 2022 18:24:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     xiangxia.m.yue@gmail.com, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>
Subject: Re: [net-next v8 0/2] net: sched: allow user to select txqueue
Message-ID: <20220126182408.00b9d244@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220126143206.23023-1-xiangxia.m.yue@gmail.com>
References: <20220126143206.23023-1-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Jan 2022 22:32:04 +0800 xiangxia.m.yue@gmail.com wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> Patch 1 allow user to select txqueue in clsact hook.
> Patch 2 support skbhash, classid, cpuid to select txqueue.

Does anyone else have an opinion on this one?
