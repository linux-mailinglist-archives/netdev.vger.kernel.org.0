Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 385B144B455
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 21:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244772AbhKIU4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 15:56:08 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53364 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244754AbhKIU4I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 15:56:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=k9OffywahQgnSC/QJ1NyxfTjjP1psGZwavJWBVx5iCw=; b=T1
        +sNnAvpGVLRTCCwaQlw7ikYFuaoqCUGdQqSQTMpOaQ1W9DgpO6Jvo17mFU968FtlTfa60gz+w4lYc
        0ZhgJ3iMbEADPj8eJNRjxSBuuExnnCdU0LBanouEx5SdAYWc99l/kgOxuHTTfEtd6o1jrHO3mTTHF
        3NsaJ1IY4Bksc5s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mkY7H-00D1Rp-TP; Tue, 09 Nov 2021 21:53:15 +0100
Date:   Tue, 9 Nov 2021 21:53:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [RFC PATCH v3 3/8] leds: trigger: netdev: drop
 NETDEV_LED_MODE_LINKUP from mode
Message-ID: <YYrfu8EIPMsbgL2T@lunn.ch>
References: <20211109022608.11109-1-ansuelsmth@gmail.com>
 <20211109022608.11109-4-ansuelsmth@gmail.com>
 <20211109040257.29f42aa1@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211109040257.29f42aa1@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 09, 2021 at 04:02:57AM +0100, Marek Behún wrote:
> On Tue,  9 Nov 2021 03:26:03 +0100
> Ansuel Smith <ansuelsmth@gmail.com> wrote:
> 
> > Drop NETDEV_LED_MODE_LINKUP from mode list and convert to a simple bool
> > that will be true or false based on the carrier link. No functional
> > change intended.
> 
> The last time I tried this, I did it for all the fields that are now in
> the bitmap, and I was told that the bitmap guarantees atomic access, so
> it should be used...
> 
> But why do you needs this? I guess I will see in another patch.

I agree with Marek here. The commit message says what you have done,
which is not very useful, i can read the patch. What it should include
is why you have made this change. The why is very important in the
commit message.

       Andrew
