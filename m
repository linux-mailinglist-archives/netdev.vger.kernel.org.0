Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABB2C30B4A1
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 02:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbhBBBZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 20:25:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:51214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229527AbhBBBZj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 20:25:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C34C64DDB;
        Tue,  2 Feb 2021 01:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612229098;
        bh=/XJhfuoLgRSwUIS9I5m2whLl7kX4ewn4OPf60vcCyKE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Xs0FaNzjNf+F+/kFQwZZkla9SH8qaYu9l854R+S2blXB3+/jDXV72NLBRVqpLfcUo
         RxbM11WIyk2OMX3a1tYyYjgIkw6tr+HJoQ3NLSvYLfje9frzjASUurCchJx5tc+dCA
         t1VvAnhfFNClbsMEWczuqReEcxcA4PdLG07DiXICn+FOn1lMYnCXPeReJNotIZefN+
         6XcZoKuuHAFi/F/SahcS9c7YCMliWTfwjQyOryfl4mbfEUHGg+CzgxIDntDOWe7Nom
         b+1zWV4rn6hdl22nCTn/ylvP1uRJKu7xFUAaQd6H3gL+GdrWJMIEOvcaw4G+Xi1a6K
         2aMSTkYLOzGeQ==
Date:   Mon, 1 Feb 2021 17:24:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     hkallweit1@gmail.com,
        nic_swsd@realtek.com (maintainer:8169 10/100/1000 GIGABIT ETHERNET
        DRIVER), "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org (open list:8169 10/100/1000 GIGABIT ETHERNET
        DRIVER), linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH] r8169: Add support for another RTL8168FP
Message-ID: <20210201172456.79af6edd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210201164735.1268796-1-kai.heng.feng@canonical.com>
References: <20210201164735.1268796-1-kai.heng.feng@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  2 Feb 2021 00:47:35 +0800 Kai-Heng Feng wrote:
> According to the vendor driver, the new chip with XID 0x54b is
> essentially the same as the one with XID 0x54a, but it doesn't need the
> firmware.
> 
> So add support accordingly.
> 
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>

Please rebase on top of net-next, this patch does not apply to the
networking trees.
