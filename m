Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D52501C7A27
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 21:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728738AbgEFTXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 15:23:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:47194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727110AbgEFTXc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 15:23:32 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4A7720870;
        Wed,  6 May 2020 19:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588793012;
        bh=HT+hCyDDnp3A+m/VSXJaYiGdp3Y+AgCoLB8fV/ljk2w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B8Rz9G6AEtJsXLDcU5SN0axbD1UiixoRkMRXpd+reYcH1nNAqljAPm1kqXl6a62Fx
         OfeHQq8+PvUnHXBkkYxLMR98TSp6iVizYFtDu1jSTWBCot46PEfXlbDMCwIGKaB1gi
         IpcHIfbJG1bhaZlyPlunRqaMIf7V2DyCO+3weANQ=
Date:   Wed, 6 May 2020 12:23:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@leon.nu>
Cc:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felix Fietkau <nbd@openwrt.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-netdev <netdev@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: Re: [PATCH 06/11] net: ethernet: mtk-eth-mac: new driver
Message-ID: <20200506122329.0a6b2ac4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CALq1K=Lu0hv9UCgxgrwCVoOe9L7A4sgBEM=RW2d9JkizHmdBPQ@mail.gmail.com>
References: <20200505140231.16600-1-brgl@bgdev.pl>
        <20200505140231.16600-7-brgl@bgdev.pl>
        <CALq1K=Lu0hv9UCgxgrwCVoOe9L7A4sgBEM=RW2d9JkizHmdBPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 May 2020 22:16:11 +0300 Leon Romanovsky wrote:
> > +#define MTK_MAC_DRVNAME                                "mtk_eth_mac"
> > +#define MTK_MAC_VERSION                                "1.0"  
> 
> Please don't add driver version to new driver.

It has already been pointed out. Please trim your replies.
