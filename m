Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A50762B2924
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 00:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbgKMX2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 18:28:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:46632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725866AbgKMX2J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 18:28:09 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 728D12224F;
        Fri, 13 Nov 2020 23:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605310089;
        bh=TyTNr6dthjSmkZgrgaf8DURMMkJ5WSgZO7w2kKVizns=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0NuvOODFEs7x0wHsurYcpaupbyC173TRYg/DSPerMt305c9MJYwTGwxJKvqCBKIfs
         mnkUHJSk5Bajjl8shD83gYA90o+tfu9FKyCSV25EFWIsV6i2VS+TyqDP1sE9rs99yQ
         +J0sRBRmPQT3lUVVtxoqA4PnAm302h9GkaxMbEsE=
Date:   Fri, 13 Nov 2020 15:28:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Wang Qing <wangqing@vivo.com>, Sekhar Nori <nsekhar@ti.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Arnd Bergmann <arnd@kernel.org>
Subject: Re: [PATCH v5] net: ethernet: ti: am65-cpts: update ret when
 ptp_clock is ERROR
Message-ID: <20201113152807.649e49d9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201112164541.3223-1-grygorii.strashko@ti.com>
References: <20201112164541.3223-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 18:45:41 +0200 Grygorii Strashko wrote:
> From: Wang Qing <wangqing@vivo.com>
> 
> We always have to update the value of ret, otherwise the
>  error value may be the previous one.
> 
> Fixes: f6bd59526ca5 ("net: ethernet: ti: introduce am654 common platform time sync driver")
> Signed-off-by: Wang Qing <wangqing@vivo.com>
> [grygorii.strashko@ti.com: fix build warn, subj add fixes tag]
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> Acked-by: Richard Cochran <richardcochran@gmail.com>

Thanks for handling this, applied!
