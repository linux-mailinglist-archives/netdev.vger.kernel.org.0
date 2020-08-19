Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B83B224A419
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 18:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgHSQb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 12:31:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:52010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725275AbgHSQb5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 12:31:57 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5C5B207BB;
        Wed, 19 Aug 2020 16:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597854717;
        bh=7UssN4aoqka0Tt/QHgPvZmzPeV4QpvTSg1+ALPNrWcA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EVyoNLedXCdfCwl20CFZYp6HjXdvxJHF+Rrh2tVroK6s6PDeYduXl2PlU6VLERA2D
         A5YhpWqfxSrasIWuXwFHe3xxhZbm/BSWjuGfUd6/NAuVnQCDRBzikeOqDK+KT+411l
         yQpve8uYiuQ5eYD0A7CHaz6Rb/Ug0BVEUaJ0maow=
Date:   Wed, 19 Aug 2020 09:31:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     kvalo@codeaurora.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Jakub Kicinski <kubakici@wp.pl>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felix Fietkau <nbd@openwrt.org>,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH 15/28] wireless: mediatek: mt7601u: phy: Fix misnaming
 when documented function parameter 'dac'
Message-ID: <20200819093155.14df0526@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200819072402.3085022-16-lee.jones@linaro.org>
References: <20200819072402.3085022-1-lee.jones@linaro.org>
        <20200819072402.3085022-16-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Aug 2020 08:23:49 +0100 Lee Jones wrote:
> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/net/wireless/mediatek/mt7601u/phy.c:1216: warning: Function parameter or member 'dac' not described in 'mt7601u_set_tx_dac'
>  drivers/net/wireless/mediatek/mt7601u/phy.c:1216: warning: Excess function parameter 'path' description in 'mt7601u_set_tx_dac'

Acked-by: Jakub Kicinski <kubakici@wp.pl>
