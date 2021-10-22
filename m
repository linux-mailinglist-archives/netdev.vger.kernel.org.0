Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20148437C6D
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 20:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233543AbhJVSId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 14:08:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:49964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233417AbhJVSIb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 14:08:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDF126120D;
        Fri, 22 Oct 2021 18:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634925974;
        bh=/KuhCiWfjX8v3AMvfNSEg2zLjZf0VFNSUeefW/M0Mfs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Chuxd2Ta0ctKe+6RKOFEk9zXQFwp+/jkLW7e1Y+IQxXkbKSdeJQmdaUCai+t//7F/
         G2jQDf8dleq1i+1pShhOASpyoaYgc4zeeh/08Wgew2K4zLr6OWSRpOpqmBFx9ad3SH
         +uNn+QjYv5Ro7DvJnaRf9b11eE7yNFYeW7QHRAlWsU8mgNXdaBo8QQyYB5usyIIbSA
         wOjuaB51MBEglp6ikUUYhtvZb+2yj9MEUun9ibHWrGvlttIb2EorAU7Xbpfzc/PnCl
         i1b2zpuoQxRf9LCAcP/abWBOvmTB7Mu3a0DU1oy7FRNXKF8cf9zOHXwZP1D94rUUZo
         QxAldBA9FvbUA==
Date:   Fri, 22 Oct 2021 11:06:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     luo penghao <cgel.zte@gmail.com>
Cc:     SimonHorman <horms@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        luo penghao <luo.penghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH linux-next] octeontx2-af: Remove redundant assignment
 and parentheses
Message-ID: <20211022110612.2041efc5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211022095321.1065922-1-luo.penghao@zte.com.cn>
References: <20211022095321.1065922-1-luo.penghao@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Oct 2021 09:53:21 +0000 luo penghao wrote:
> Subject: [PATCH linux-next] octeontx2-af: Remove redundant assignment and parentheses

octeontx2-af ? I don't think so:

>  drivers/net/ethernet/marvell/sky2.c | 2 +-

Please make sure you CC _all_ maintainers of the driver.
