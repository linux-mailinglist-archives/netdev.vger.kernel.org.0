Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8DD6421BD6
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 03:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbhJEB0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 21:26:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:33356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230097AbhJEB0B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 21:26:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F4416140B;
        Tue,  5 Oct 2021 01:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633397051;
        bh=57LNnA6XsVpnlGoKJUQ0C8IgmbyCmlx3YFFD3e/WyOk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WFpCe1AmoQWQ66uZdkx10c2v2o/7M/02a4+v8fER2wGHrT3xXpKAHsVx4n7pUDX59
         cyyKRboHXzpjccP3/mQH2jWP5pU5E9LLdKDWL/n/C8xmdT5mCa/CLsAHDJ/1dcYO+j
         0RsSK9TLgdXM4Xltt3U5c92AE7yAo68ArgYS61tpx45JFP1WYwZorputd4pNGRaK42
         dvvjoQaQoLF7H32lcqPhcPvoihXvrqQRDjK11R5AMflhCWyLnyNij7qI6yAnV2gD1f
         S9Pu8rm3LhBFpWGLb3O1ZLxMfEQoQHe2l6wHSho/TDwIw9iwhouZI7B+ZRRv5U3OEx
         Up4+hgxlI7cfQ==
Date:   Mon, 4 Oct 2021 18:24:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        "Jose M. Guisado Gomez" <guigom@riseup.net>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH v1 net-next 1/1] net: Mark possible unused variables on
 stack with __maybe_unused
Message-ID: <20211004182410.3f3496b9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211001145056.12184-1-andriy.shevchenko@linux.intel.com>
References: <20211001145056.12184-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  1 Oct 2021 17:50:56 +0300 Andy Shevchenko wrote:
> When compile with COMPILE_TEST=y the -Werror is implied.
> If we run `make W=1` the first level warnings will become
> the build errors. Some of them related to possible unused
> variables. Hence, to allow clean build in such case, mark
> them with __maybe_unused.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

You need to split the socket and fib change from the netfilter ones.
Those go via different sub-trees.
