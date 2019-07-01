Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29C4F5BD02
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 15:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728508AbfGANfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 09:35:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45636 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727977AbfGANfN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 09:35:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vKPzDIk3GSbD5XduQd+dyT7zfLqpUuk/IsgjGXYph9I=; b=lAr8aZAT6nyCKqfFQHcbGqr4zG
        4nbKcBZRTf9MjoF6/CZryEUNGX22+c9BZAMjSHYb3Z1yv+x1+mEDisAozX3XvRHeY5rJGqX3RdYin
        zYzo5mClEvGSFbx8zR7Gy5AuZvHXrtjowm3hwYehahzNuGCs+2daOUibX93sxzvMvVIY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hhwSZ-0007AR-4G; Mon, 01 Jul 2019 15:35:07 +0200
Date:   Mon, 1 Jul 2019 15:35:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Karsten Wiborg <karsten.wiborg@web.de>, nic_swsd@realtek.com,
        romieu@fr.zoreil.com, netdev@vger.kernel.org
Subject: Re: r8169 not working on 5.2.0rc6 with GPD MicroPC
Message-ID: <20190701133507.GB25795@lunn.ch>
References: <4437a8a6-73f0-26a7-4a61-b215c641ff20@web.de>
 <b104dbf2-6adc-2eee-0a1a-505c013787c0@gmail.com>
 <62684063-10d1-58ad-55ad-ff35b231e3b0@web.de>
 <20190630145511.GA5330@lunn.ch>
 <3825ebc5-15bc-2787-4d73-cccbfe96a0cc@web.de>
 <27dfc508-dee0-9dad-1e6b-2a5df93c3977@gmail.com>
 <173251e0-add7-b2f5-0701-0717ed4a9b04@web.de>
 <de38facc-37ed-313f-cf1e-1ec6de9810c8@gmail.com>
 <116e4be6-e710-eb2d-0992-a132f62a8727@web.de>
 <94b0f05e-2521-7251-ab92-b099a3cf99c9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94b0f05e-2521-7251-ab92-b099a3cf99c9@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> When the vendor driver assigns a random MAC address, it writes it to the
> chip. The related registers may be persistent (can't say exactly due to
> missing documentation).

If the device supports WOL, it could be it is powered using the
standby supply, not the main supply. Try pulling the plug from the
wall to really remove all power.

     Andrew
