Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94C113AA0E5
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 18:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234653AbhFPQK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 12:10:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40826 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231927AbhFPQK6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 12:10:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Blk7nvnHmJhaE4yX9QuhWWMwT2EicGC5yEUdji19O+A=; b=ZdYQKoIcaneB4vjxaoT5jRbYRZ
        h/aKFYXLKB4K83H5GWCMCu0QX294rgyVFfCHAbIr/VI5EaVNEg8B9u0tuAa/Q4oBRei2ksffoDEC/
        sTwV/J+V/97ZOiWrFN1fzg9VS/eoovVdPqIAEAp3T9NVKqEXvkLjx3vTAr94JrQcP8VM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ltY5x-009khm-EG; Wed, 16 Jun 2021 18:08:49 +0200
Date:   Wed, 16 Jun 2021 18:08:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Weihang Li <liweihang@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linuxarm@huawei.com,
        Wenpeng Liang <liangwenpeng@huawei.com>
Subject: Re: [PATCH v2 net-next 6/8] net: phy: print the function name by
 __func__ instead of an fixed string
Message-ID: <YMoiEaaf7AIkzsQz@lunn.ch>
References: <1623837686-22569-1-git-send-email-liweihang@huawei.com>
 <1623837686-22569-7-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1623837686-22569-7-git-send-email-liweihang@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 16, 2021 at 06:01:24PM +0800, Weihang Li wrote:
> From: Wenpeng Liang <liangwenpeng@huawei.com>
> 
> It's better to use __func__ than a fixed string to print a function's
> name.
> 
> Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
> Signed-off-by: Weihang Li <liweihang@huawei.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
