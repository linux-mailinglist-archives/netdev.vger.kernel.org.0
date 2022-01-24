Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D992A4983D3
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 16:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238677AbiAXPuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 10:50:44 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38748 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234527AbiAXPun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 10:50:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61386614BC;
        Mon, 24 Jan 2022 15:50:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B3E7C340E5;
        Mon, 24 Jan 2022 15:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643039442;
        bh=xdicGSG8aAW2ZswCJq/+VGwWSCIusYuBWyFM6SSX2JI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lGk7pW9VcjDDgx4thOFf/pGjF1dRnSrScl/EyBCm/6YCmBggEqdb+89hSNT24cpPU
         gMGtC66UYUjhY5rIxz2MHLUBqUTwe7E7lmTY0wtskvNvgEsmdOySvqkr9SKZcrtp3w
         PYiMnfzmp9ZNPq1ljHO/wD0dVwAm98s/YM4bZPSnb0YIDoWitvKFNp7ZAr8fjQLkeK
         HHnXI7PGf/hWsgaNUEt8EWi4Wr2EuhT9ikucRupTlZZVFDZ9DGDDtZy6RGYuj8fPV4
         YvXsSPt/Ca6TDgYjVi93OPrrI6Fx2+E/7+YyJlvowkPQn4SPWoBdXhkUAa0x03b8TD
         rYrH0ywEfCTYg==
Date:   Mon, 24 Jan 2022 07:50:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ignat Korchagin <ignat@cloudflare.com>,
        Amir Razmjou <arazmjou@cloudflare.com>,
        David Ahern <dsahern@kernel.org>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.10 3/9] sit: allow encapsulated IPv6 traffic
 to be delivered locally
Message-ID: <20220124075041.13c015a6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220123001258.2460594-3-sashal@kernel.org>
References: <20220123001258.2460594-1-sashal@kernel.org>
        <20220123001258.2460594-3-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 22 Jan 2022 19:12:52 -0500 Sasha Levin wrote:
> From: Ignat Korchagin <ignat@cloudflare.com>
> 
> [ Upstream commit ed6ae5ca437d9d238117d90e95f7f2cc27da1b31 ]
> 
> While experimenting with FOU encapsulation Amir noticed that encapsulated IPv6
> traffic fails to be delivered, if the peer IP address is configured locally.

Unless Ignat and Amir need it I'd vote for not backporting this to LTS.
This patch is firmly in the "this configuration was never supported"
category. 5.15 and 5.16 are probably fine.
