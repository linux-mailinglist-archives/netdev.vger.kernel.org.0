Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F04C935FE46
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 01:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbhDNXMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 19:12:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:48500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232752AbhDNXMe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 19:12:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E6A061164;
        Wed, 14 Apr 2021 23:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618441932;
        bh=YyVQh9YVMLAQgWRa1ZBPZGckSrUP9yRA45BmvNwgsHU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vNkQKd8ZvFyATy7dlEgh3czntI114U7z0NN1yjRELb1EQjLkLZzxolD4mngmuJuBF
         l1KB51fGLhP2GXfSgXeaF65iPLdOL679RvmKFUE16qVBunqKqetN6s72oCJJgbjSma
         2yl20ZqdShgaxID9hvy19uA5EIrNR+jbllgAif64SwLt1YpzjylB5/GaLizdCHBuB9
         XE/N8U5y2eK0GrQfJA3vPe5edNKTpTZvi4qwe55UQzIinhnYzhMLsHaAoEIWq+F8MY
         aNpC9UHuuY+gDeXkhyAHEPevjdJ4WmauBRIFKpyiqFtV8x84Rj5weWpSjXmbX97AFH
         IQ7+itIwgSePQ==
Date:   Wed, 14 Apr 2021 16:12:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] r8169: add support for pause ethtool ops
Message-ID: <20210414161211.2b897c69@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <0e0f42d5-d67e-52bb-20d2-d35c0866338a@gmail.com>
References: <0e0f42d5-d67e-52bb-20d2-d35c0866338a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Apr 2021 08:23:15 +0200 Heiner Kallweit wrote:
> This adds support for the [g|s]et_pauseparam ethtool ops. It considers
> that the chip doesn't support pause frame use in jumbo mode.

what happens if the MTU is changed afterwards?
