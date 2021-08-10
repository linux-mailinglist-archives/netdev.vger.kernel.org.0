Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0C73E5727
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 11:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239214AbhHJJh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 05:37:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:36440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238140AbhHJJh6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 05:37:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAF556105A;
        Tue, 10 Aug 2021 09:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628588256;
        bh=n7vVQefJGFgclM3fzJhmI2FZ74PlKs9IqTzOOlSzIpc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fj/QxCa5JEjInHGs0jBhkYGDlnWj17gGfWtlAF1cxbI79JMMxfrb0V+WR27++OPit
         E+URKoWWVEE85RFMau7SPjzPwfqmwVUeVmwQjJtcembIlY8YB+hB8u9932zdQ5hXoM
         VVjKnThfPS91JUSdL5W5JSBgKtunyvfwMrV5kfBxBds5yGpbajcr2AEZoo45W4HsXi
         J4cG9Sq6b+W3tW1GUWojISbuuSt4Eaozr1VUBQ6Xte6rnpKLBVd9wWfXDhsejF0ugx
         XwfKjJQXuRp8zr5URVZ9HceqvmQALQu9SBGLlk0nkrKD8R7nz3DwCPqtSIO/DYkMSp
         r94QI09pXB57w==
Date:   Tue, 10 Aug 2021 12:37:32 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Lahav Schlesinger <lschlesinger@drivenets.com>
Cc:     netdev@vger.kernel.org, dsahern@kernel.org, davem@davemloft.net,
        kuba@kernel.org
Subject: Re: [PATCH net-next v3] net: Support filtering interfaces on no
 master
Message-ID: <YRJI3PIWoqTvwXub@unreal>
References: <20210810090658.2778960-1-lschlesinger@drivenets.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810090658.2778960-1-lschlesinger@drivenets.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 09:06:58AM +0000, Lahav Schlesinger wrote:
> Currently there's support for filtering neighbours/links for interfaces
> which have a specific master device (using the IFLA_MASTER/NDA_MASTER
> attributes).
> 
> This patch adds support for filtering interfaces/neighbours dump for
> interfaces that *don't* have a master.
> 
> Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> ---
> v2 -> v3
>  - Change the way 'master' is checked for being non NULL
> v1 -> v2
>  - Change from filtering just for non VRF slaves to non slaves at all
> 
>  net/core/neighbour.c | 7 +++++++
>  net/core/rtnetlink.c | 7 +++++++
>  2 files changed, 14 insertions(+)
> 

Thanks, for resending.
