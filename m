Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1EB2A1B31
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 00:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbgJaXSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 19:18:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:55030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725809AbgJaXSN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 19:18:13 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8FBB2087E;
        Sat, 31 Oct 2020 23:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604186292;
        bh=WHX+avVMEsgkSCxTcMbO+ftrzCWRywGWN36fr67W3kk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nAYVKcg4ZYc0bYiUgpUVZOONOYmpmkmQ3/7kSsxaXop/JdDEAmTt2CPO9rV9YRZR6
         fEE+A5TJcNd86yak97YjN0KXJcv6u/KCW9FajElRuN1rY1y8n3vp5rctVande1k2u9
         gtrZ5cB0S1md36cmQGNi0yIOf0rosXkm2LVEBJDs=
Date:   Sat, 31 Oct 2020 16:18:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Armin Wolf <W_Armin@gmx.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net-next v3] ne2k: Fix Typo in RW-Bugfix
Message-ID: <20201031161812.505c64b7@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201029143357.7008-1-W_Armin@gmx.de>
References: <20201029143357.7008-1-W_Armin@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Oct 2020 15:33:57 +0100 Armin Wolf wrote:
> Correct a typo in ne.c and ne2k-pci.c which
> prevented activation of the RW-Bugfix.
> 
> Signed-off-by: Armin Wolf <W_Armin@gmx.de>

Applied.
