Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 309343CF849
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 12:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237799AbhGTKGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 06:06:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:34986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237614AbhGTKEP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 06:04:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4748B6120F;
        Tue, 20 Jul 2021 10:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626777876;
        bh=J4am9/bVVh/y4DpPyboBO49mcaLQLuHHpQ8U9G74tLM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GLafNpJFthhFofmm7KYcXWxJZ8kEW8iN5MLI/SE2NA6r0HtLmmoBpV3HURGhRWnbB
         h6r+J2co8OCnH11uB16ZdOSHJOGqPmb5HH5LSSWzXzyqihDtvF96i1U7AgVwiygyb4
         JatBw+Zkksw1rKKxRhKSpcpca4soppvBHGoEEnRIY8AiTa9+YiQuhwO77EWeLYNAKc
         dBewllbngb1F4G1CR/PUXrUfKoGCUh1DGhTkRHgAQ+TDf7+cVJ3tvm42aME8I2PpbU
         lNdTCWUx6ZppCbkV8I7jExAG+jM7w/jQZ8q0Evspkip4O+uwDChCr3rl1Wks0ViBu6
         5G8TV2uXPUOUg==
Date:   Tue, 20 Jul 2021 12:44:27 +0200
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     davem@davemloft.net, roopa@nvidia.com, nikolay@nvidia.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, courmisch@gmail.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        johannes@sipsolutions.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-decnet-user@lists.sourceforge.net,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/4] Remove rtnetlink_send() in rtnetlink
Message-ID: <20210720124427.6b4e05a8@cakuba>
In-Reply-To: <20210719122158.5037-1-yajun.deng@linux.dev>
References: <20210719122158.5037-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Jul 2021 20:21:54 +0800, Yajun Deng wrote:
> rtnetlink_send() is similar to rtnl_notify(), there is no need for two 
> functions to do the same thing. we can remove rtnetlink_send() and 
> modify rtnl_notify() to adapt more case.
>
> Patch1: remove rtnetlink_send() modify rtnl_notify() to adapt 
> more case in rtnetlink.
> Path2,Patch3: Adjustment parameters in rtnl_notify().
> Path4: rtnetlink_send() already removed, use rtnl_notify() instead 
> of rtnetlink_send().

You can't break compilation in between patches. Each step of the series
(each patch) must be self-contained, build, and work correctly.
Otherwise bisection becomes a nightmare.

Please also post series as a thread (patches in reply to the cover
letter), it seems that patchwork did not group the patches correctly
here.
