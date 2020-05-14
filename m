Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8231D24E8
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 03:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgENBsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 21:48:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:54072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725925AbgENBsT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 21:48:19 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE9EA2054F;
        Thu, 14 May 2020 01:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589420899;
        bh=FAzyJuE7op8FsP6Nq/dq1FZ76ryX2HBMr1U3zwr9jGs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EX8fRi7G9zPHcF2oGctNZzx4S71j19uP2xrf5VOqVSVksVDEbGPI6HJjZR/KcfOI+
         ig2cyPYE+gSOvJk68HdWdae7zhW7P/zBFhHXTCsFNDhRip4YW/1x5QT1BXEEV81Nio
         Z1tkyd9xDlSKzb5jOu93YQ4+xTLAV56wQec3gzOs=
Date:   Wed, 13 May 2020 18:48:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH V5 00/19] net: ks8851: Unify KS8851 SPI and MLL drivers
Message-ID: <20200513184817.160e0268@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200514000747.159320-1-marex@denx.de>
References: <20200514000747.159320-1-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 May 2020 02:07:28 +0200 Marek Vasut wrote:
> The KS8851SNL/SNLI and KS8851-16MLL/MLLI/MLLU are very much the same pieces
> of silicon, except the former has an SPI interface, while the later has a
> parallel bus interface. Thus far, Linux has two separate drivers for each
> and they are diverging considerably.
> 
> This series unifies them into a single driver with small SPI and parallel
> bus specific parts. The approach here is to first separate out the SPI
> specific parts into a separate file, then add parallel bus accessors in
> another separate file and then finally remove the old parallel bus driver.
> The reason for replacing the old parallel bus driver is because the SPI
> bus driver is much higher quality.

There is a bunch of warnings in these patches when built one by one with
W=1, could you take a look?
