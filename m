Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25C6D3952F9
	for <lists+netdev@lfdr.de>; Sun, 30 May 2021 23:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbhE3VSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 17:18:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:42972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229827AbhE3VSD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 May 2021 17:18:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42D42610CC;
        Sun, 30 May 2021 21:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622409384;
        bh=ul3X2v/geFbAbSaJxBb7FSQP/SGYokQioubxeoBAejo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=frMigB+zmRRj9gtYMo0t7lJejw9wRCyMvZ0Yu2t8BQVnxNZKR7Dc6LxYifNERl2qG
         Fce0n5wvH8mMbs2G43mjBUhp9YZ7yUdz5unRTlBeuwL8Nm5HH2AqrDPZA7MBbU7Cvm
         gfDmwHn9woTeYUhH6o2HgczXOg8q7wtJLRNmd+kugKF4tzpOhfkIJDU/ZQRUBolLd2
         Vgv0lv/CqdoixFvplsyiQjENEFiIKj8k4+ug2cwV6zlcGjA1Oe0mbf/rKsglNLktGD
         F6P6/5/K5ul/K8/0MUOMJDNzQaF6w7irzmAJKi/5oFVd0PUNFPTLhCUaFARjxz27Xp
         Jws3hFT43gi9g==
Date:   Sun, 30 May 2021 14:16:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sriranjani P <sriranjani.p@samsung.com>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        davem@davemloft.net, mcoquelin.stm32@gmail.com,
        linux@armlinux.org.uk, boon.leong.ong@intel.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: Re: [PATCH] net: stmmac: fix kernel panic due to NULL pointer
 dereference of mdio_bus_data
Message-ID: <20210530141623.33d2d00d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210528071056.35252-1-sriranjani.p@samsung.com>
References: <CGME20210528070406epcas5p3807d9c8f8a68c0c4a75af9951476c1b7@epcas5p3.samsung.com>
        <20210528071056.35252-1-sriranjani.p@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 May 2021 12:40:56 +0530 Sriranjani P wrote:
> Fixed link does not need mdio bus and in that case mdio_bus_data will
> not be allocated. Before using mdio_bus_data we should check for NULL.
> 
> This patch fix the kernel panic due to NULL pointer dereference of
> mdio_bus_data when it is not allocated.
> 
> Without this patch we do see following kernel crash caused due to kernel
> NULL pointer dereference.

Applied, thanks.
