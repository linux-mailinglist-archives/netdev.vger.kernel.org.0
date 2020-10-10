Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C74428A3E6
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389427AbgJJWzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:55:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:54886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732190AbgJJTmt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Oct 2020 15:42:49 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9AB622470;
        Sat, 10 Oct 2020 17:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602352013;
        bh=j/twW6620GP4x6DRMJ2oSnck7XjStCUoWhmt9Vv3bpw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MaPXrenNuiO1OpVZqaR9xKdN4NXXfE3RmIYtU2INki8VQEU2w3AmAMP7lPnWJDSOA
         cx9PteXPB81uSEELosIzbv5GhJyetNVPyHWBS3qpr8ui9daSzcjjphudI+lkAklmGx
         zetwf0BMne4WYwDyZ9prOsxcSgOn+AayZeqY4TOg=
Date:   Sat, 10 Oct 2020 10:46:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] r8169: factor out handling rtl8169_stats
Message-ID: <20201010104651.0f1ae987@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <dee5d6ec-d7ab-03c0-9c3b-4fd4e9f2b1d0@gmail.com>
References: <dee5d6ec-d7ab-03c0-9c3b-4fd4e9f2b1d0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 9 Oct 2020 16:20:34 +0200 Heiner Kallweit wrote:
> Factor out handling the private packet/byte counters to new
> functions rtl_get_priv_stats() and rtl_inc_priv_stats().
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied, thank you!
