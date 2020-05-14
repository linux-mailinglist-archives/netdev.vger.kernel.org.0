Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53ED21D24C6
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 03:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbgENBfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 21:35:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59402 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbgENBfO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 21:35:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=03YaS3ccAihBs8RxwR4kOnjOW0T5vJjNFTc/l1JngsA=; b=r77SpT4VD/zRbibiRQuRJXt/Fq
        kIr/E9fnLZRXvdaPyBTRHq9CbKBXGrx1MONdNgeXh5v/HvnvO1jIVINQ7PpKvStHb5nhFdnzZv+Ux
        tqnEnHvtuFGqV23vqxNNBEQ2k8VXU5FSHtdU9dJY2n1kp4fOIpP3xmF6MiJNeqtW+LHI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jZ2mF-002Es8-FL; Thu, 14 May 2020 03:35:11 +0200
Date:   Thu, 14 May 2020 03:35:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH V5 15/19] net: ks8851: Permit overridding interrupt
 enable register
Message-ID: <20200514013511.GJ527401@lunn.ch>
References: <20200514000747.159320-1-marex@denx.de>
 <20200514000747.159320-16-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514000747.159320-16-marex@denx.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 02:07:43AM +0200, Marek Vasut wrote:
> The parallel bus variant does not need to use the TX interrupt at all
> as it writes the TX FIFO directly with in .ndo_start_xmit, permit the
> drivers to configure the interrupt enable bits.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
