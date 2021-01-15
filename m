Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2717E2F88CE
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 23:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727439AbhAOWvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 17:51:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:55954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725863AbhAOWvK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 17:51:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B0DD23128;
        Fri, 15 Jan 2021 22:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610751029;
        bh=ZzraS6QbOgWkLI/mJd9WzPRDgGQG42nY/gHq31H8TG4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Rwkgg/vSEmcAdjhd7Su/XpauVSSoFefJCxbeRV5pJPviuGq7E/nf6VI39zQRP/Db3
         zZxhlsyYfPpHNnIWEcaUuN0CUKp5+ConxKqryP3fNdtpvga3riez010+RkTZ6A0Xm2
         hjhLfoRa9yTbjixtF2JIkPfLmJYn8KzDi3/GB6HY0AyYkatxMmdPutGNz+RRvgYBoh
         FNcG5Cw0omlmwsT1TlDDfQ3pL0AbJJ0Fqs2/LEqdVjhkRd7dH2ODeFOxSxex66RBeY
         wS6aL/zR3/7eRywiXCOpGj/v5S2/dLhc0a4UB16E4eM1yAKOQcY5helUYww8AU0/T/
         YH2yTXG9HcnDw==
Date:   Fri, 15 Jan 2021 14:50:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matteo Croce <mcroce@linux.microsoft.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH net 0/2] ipv6: fixes for the multicast routes
Message-ID: <20210115145028.3cb6997f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210115184209.78611-1-mcroce@linux.microsoft.com>
References: <20210115184209.78611-1-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Jan 2021 19:42:07 +0100 Matteo Croce wrote:
> From: Matteo Croce <mcroce@microsoft.com>
> 
> Fix two wrong flags in the IPv6 multicast routes created
> by the autoconf code.

Any chance for Fixes tags here?
