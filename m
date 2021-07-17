Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBA673CC4EC
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 19:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233506AbhGQRjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Jul 2021 13:39:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59956 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232935AbhGQRjk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Jul 2021 13:39:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=QsBOko2A1a4cDMAFBIDRLR5pvuHWmnyaUdzaA9DUF7g=; b=wDNRz/pV3N++pd66mDt5xXKJkX
        ejgtXcQeA7i9HUMYrPzEfE7CGgMKtDk3VtPg4h8eOwLLXpwhtvz0IuZgQtvEf3L5NWgTbdQs3Xw/0
        zVffeHK+/nBi4IoVSnr9SbcxEfzUwB1Z88DAB2LCj/ztRrMzMHzFgVXho60YSYI3iLtI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m4oEx-00DkMy-1M; Sat, 17 Jul 2021 19:36:39 +0200
Date:   Sat, 17 Jul 2021 19:36:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com, vinicius.gomes@intel.com
Subject: Re: [PATCH net-next 0/5][pull request] 1GbE Intel Wired LAN Driver
 Updates 2021-07-16
Message-ID: <YPMVJy6K4BCAdIK3@lunn.ch>
References: <20210716212427.821834-1-anthony.l.nguyen@intel.com>
 <162648180587.17758.7584097411653240168.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162648180587.17758.7584097411653240168.git-patchwork-notify@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 17, 2021 at 12:30:05AM +0000, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This series was applied to netdev/net-next.git (refs/heads/master):

FYI: Depending on the reply to my question, i could be going to NACK
the last patch.

Please could we slow down the merging patches where there are
outstanding questions.

	    Andrew
