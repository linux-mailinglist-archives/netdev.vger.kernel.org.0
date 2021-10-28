Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4089C43D926
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 04:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbhJ1CIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 22:08:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:34684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229534AbhJ1CIO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 22:08:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C15E60E09;
        Thu, 28 Oct 2021 02:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635386748;
        bh=yyeRHmL2XLTSMi5FlnqLr2ijKOqh3ynU2oHM9dTTfeQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=l1kpu0g61Zl8vfOMwCC8PoPXq5IHBTHQHQBPLD+aTFr7zdZTwIrTumwTqHXkSkicX
         hPYmC1WN63aKX6l3+uf/dKKhQvvmuFkeXF4UIBe4AkZ5hllRW00El4ZtAhBLWmkZ+H
         OKlrVTZqifeXfiBm75vHuLkVtKRCaNK0BtU+ZbIURstuTjzuqzbp1x7RQhbs0PyYva
         t0J6DzE1/Unx1xW8I00S1fEMvpNvf14KAH8jF6K/rh28JH+hUH1oJu2mlWCk3wlh2/
         XFY7JcZvskEA94EkTlx5jnFc+wIki5VfYt103Xe7Tl9Z2zeFQt44AhgmBRXzpOmE6u
         +Ue4Z2JOVAo6Q==
Date:   Wed, 27 Oct 2021 19:05:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Janghyub Seo <jhyub06@gmail.com>
Cc:     nic_swsd@realtek.com, hkallweit1@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2] r8169:  Add device 10ec:8162 to driver r8169
Message-ID: <20211027190547.0340a7a5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1635231849296.1489250046.441294000@gmail.com>
References: <1635231849296.1489250046.441294000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Oct 2021 07:12:42 +0000 Janghyub Seo wrote:
> This patch makes the driver r8169 pick up device Realtek Semiconductor Co.
> , Ltd. Device [10ec:8162].
> 
> Signed-off-by: Janghyub Seo <jhyub06@gmail.com>
> Suggested-by: Rushab Shah <rushabshah32@gmail.com>

Applied, thanks.
