Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2F81D24D3
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 03:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbgENBil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 21:38:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59422 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725925AbgENBik (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 21:38:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=wXnkf15bZ3WvrRVXFOnWT46IzQSU5PSMzFeodJP7SOU=; b=rDDd9O5hNTeQbz4gz/quU37IhE
        o7sq4FMNoZAAVgFHXL2nGikJl5F3gXba711xnflAtOuDh6KIa78XrNdHZcKuyyQtCSLSkhu2LMEwK
        MqSHFZFO4lLwVsmf49TrpgXhAHzd3vbRfvZ2WHVOF1ZMTh2vp+oIXIdAzXuSOmX2Zxck=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jZ2pb-002EtY-Gv; Thu, 14 May 2020 03:38:39 +0200
Date:   Thu, 14 May 2020 03:38:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH V5 16/19] net: ks8851: Implement register, FIFO, lock
 accessor callbacks
Message-ID: <20200514013839.GK527401@lunn.ch>
References: <20200514000747.159320-1-marex@denx.de>
 <20200514000747.159320-17-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514000747.159320-17-marex@denx.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 02:07:44AM +0200, Marek Vasut wrote:
> The register and FIFO accessors are bus specific, so is locking.
> Implement callbacks so that each variant of the KS8851 can implement
> matching accessors and locking, and use the rest of the common code.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
