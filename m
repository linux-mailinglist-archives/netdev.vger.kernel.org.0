Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A649AE03F1
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 14:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388613AbfJVMfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 08:35:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57522 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388095AbfJVMfj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 08:35:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ekmS9190Bn2Ds6TK7FIVus9RSryzOWVRY/CXpqo3/M4=; b=1EJusHdeIt4gHqlXGvnGWPp2Lg
        IipDMNO8boT3wofq844BEFcBaRxGNxLrgL2GD26ooxXQ4UJ771uf5CzRVsHwYMizkiM5Mz0nO6mQU
        dcguS75M7CWqvtutsmqf8buDuqUmTyfCQW/s5JVwH0/+uyGUsaCrBawESrS+zcnhbVpQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iMtNv-0001Xh-DT; Tue, 22 Oct 2019 14:35:35 +0200
Date:   Tue, 22 Oct 2019 14:35:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Igor Russkikh <Igor.Russkikh@aquantia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "epomozov@marvell.com" <epomozov@marvell.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        Simon Edelhaus <sedelhaus@marvell.com>,
        Nikita Danilov <Nikita.Danilov@aquantia.com>
Subject: Re: [PATCH v3 net-next 10/12] net: aquantia: add support for Phy
 access
Message-ID: <20191022123535.GB5707@lunn.ch>
References: <cover.1571737612.git.igor.russkikh@aquantia.com>
 <427b326b9d79721ba0b58542fc0131540ae3cfe7.1571737612.git.igor.russkikh@aquantia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <427b326b9d79721ba0b58542fc0131540ae3cfe7.1571737612.git.igor.russkikh@aquantia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 09:53:45AM +0000, Igor Russkikh wrote:
> From: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>
> 
> GPIO PIN control and access is done by direct phy manipulation.
> Here we add an aq_phy module which is able to access phy registers
> via MDIO access mailbox.
> 
> Access is controlled via HW semaphore.
> 
> Co-developed-by: Nikita Danilov <nikita.danilov@aquantia.com>
> Signed-off-by: Nikita Danilov <nikita.danilov@aquantia.com>
> Signed-off-by: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>
> Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
