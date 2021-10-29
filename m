Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C36CA43F535
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 05:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbhJ2DKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 23:10:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:56814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231640AbhJ2DKd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 23:10:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF4AD60FC1;
        Fri, 29 Oct 2021 03:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635476886;
        bh=Wj8MaqthCKxB6fLxKISMLfqFaPugMm5z/56a9t3tAok=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LoHOixzmfSDE9PhriEXw3vjtAo7yiv7Ua0ZZJy1rXR808lC6OPmfgfLFLc8bk+RXJ
         qb0vgWAsTerMDK+qWySLYzicj0aWtVdSQsGutBC/nIbHrv6bxRTYGW7S+a4VF801qx
         GvQOfHUiZN808EGIRIVMLHQPbNEc0JKtLXenWjSSUn97ZhNz4TtfF+/gIp9KENj0zL
         jsKiCYa9ClZFT0ViIicMgseXhvCL+c9pEGzdQF3f13qIUFea2hRrqnt1tsbgZXwmeS
         Pk7IhouBdDRujQM4IuICEDf9+E6Vmu7m3HveUQJ75+NDE0ut4SBdUhiXO9J4hQ7wHe
         JopUAbhwTUDmg==
Date:   Thu, 28 Oct 2021 20:08:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, petrm@nvidia.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 1/3] mlxsw: spectrum_qdisc: Offload root TBF as
 port shaper
Message-ID: <20211028200804.63164d3e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211027152001.1320496-2-idosch@idosch.org>
References: <20211027152001.1320496-1-idosch@idosch.org>
        <20211027152001.1320496-2-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Oct 2021 18:19:59 +0300 Ido Schimmel wrote:
> +	 * shaper makes sense. Also note that that is what we do for

That that that. checkpatch is sometimes useful.. :)
