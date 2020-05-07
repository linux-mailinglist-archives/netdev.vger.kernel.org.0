Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47DD11C9EB0
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 00:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbgEGWup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 18:50:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:43584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726515AbgEGWuo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 18:50:44 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B6B52083B;
        Thu,  7 May 2020 22:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588891843;
        bh=i+twVoWgvvE+sIIP8RfgWgYxL/0MZSnTVluZHAQYh3Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ICncuhdNNndVuoB1VtwfIDdgvPbWU7TqOUOopbLTG92SjYIh2Y+ZXN7dZ7uv9QN/N
         cGD88cOB2d5XW7sFR+z2oKehsB3Xwxpp8roB7DvPSFKiT4X0MihPS6+mwq4PxGMaJH
         8DzcqHio0DrqnqsYLTTKoxab0nHtwN3l3kwaeu+M=
Date:   Thu, 7 May 2020 15:50:41 -0700
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
Message-ID: <20200507155041.4f1c71e7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200507055547.GB78674@unreal>
References: <20200505140231.16600-1-brgl@bgdev.pl>
        <20200505140231.16600-7-brgl@bgdev.pl>
        <CALq1K=Lu0hv9UCgxgrwCVoOe9L7A4sgBEM=RW2d9JkizHmdBPQ@mail.gmail.com>
        <20200506122329.0a6b2ac4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200507055547.GB78674@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 06, 2020 at 12:23:29PM -0700, Jakub Kicinski wrote:
> Please trim your replies.  
> 
> Off-topic.
> 
> Is there any simple way to trim replies semi-automatically in VIM?
> 
> Right now, I'm doing it manually, but maybe there is some better
> way to do it.

I'm also doing it manually :(
