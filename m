Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1EC83AA0E4
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 18:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234645AbhFPQKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 12:10:25 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40812 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232646AbhFPQKY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 12:10:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ynVLyXteKld4uhEvUsUiwgee3xJBTERb5lqhll+x0zI=; b=BbJr192nbXOduXlzPQPhhNq2Vb
        g1reATC+ktTeoUFbVoog6nbL3ytuiZi//zcvbNEjXl97ktHPI95ELrGkh/F4QrE1O6lwYilY44yK+
        Zj0h4Xf9FcCHe2YTquzONFpF9xbY88+fcq8chOvWU3vNObxU8ttPNYDwZUtue8p1h70c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ltY5P-009kgi-8P; Wed, 16 Jun 2021 18:08:15 +0200
Date:   Wed, 16 Jun 2021 18:08:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Weihang Li <liweihang@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linuxarm@huawei.com,
        Wenpeng Liang <liangwenpeng@huawei.com>
Subject: Re: [PATCH v2 net-next 5/8] net: phy: fix formatting issues with
 braces
Message-ID: <YMoh78AYp4mVwt8n@lunn.ch>
References: <1623837686-22569-1-git-send-email-liweihang@huawei.com>
 <1623837686-22569-6-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1623837686-22569-6-git-send-email-liweihang@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 16, 2021 at 06:01:23PM +0800, Weihang Li wrote:
> From: Wenpeng Liang <liangwenpeng@huawei.com>
> 
> Fix following format issues:
> 1. open brace '{' following function definitions should go to the next
>    line.
> 2. braces {} are not necessary for single line statements.
> 3. else should follow close brace '}'.
> 
> Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
> Signed-off-by: Weihang Li <liweihang@huawei.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
