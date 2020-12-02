Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9B62CB28A
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 02:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbgLBByI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 20:54:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:47920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728057AbgLBByI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 20:54:08 -0500
Date:   Tue, 1 Dec 2020 17:53:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606874007;
        bh=qACSHOYG6L11g+xxM5Y/HmiE4Is6TkTFn01icin7LnE=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=dO7ULA43ALQCEoMY9neTAMWswD/Oo5XtBfsKCYNq15t8KRzKpJWUjVIrRlrg/3Dky
         rSLky1RJsJWWTPcYNujhl3Y1+wPOG1mLe5zpcEIvlkICsjK4le1aTVEnjx12+xQ2Hs
         JCoTUy2zxdTEb8pIXKHzj861JtsruJP6jvV1tCJI=
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rohit Maheshwari <rohitm@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com
Subject: Re: [net] net/tls: tls offload is broken
Message-ID: <20201201175326.1451e7ed@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201201090752.27355-1-rohitm@chelsio.com>
References: <20201201090752.27355-1-rohitm@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  1 Dec 2020 14:37:52 +0530 Rohit Maheshwari wrote:
> Recent changes made to remove AES constants started using protocol
> aware salt_size. ctx->prot_info's salt_size is filled in tls sw case,
> but not in tls offload mode, and was working so far because of the
> hard coded value was used.
> 
> Fixes: 6942a284fb3e ("net/tls: make inline helpers protocol-aware")
> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>

I updated the subject to something more meaningful and applied to
net-next. The commit in question was just applied to net-next, it
doesn't exist in net.
