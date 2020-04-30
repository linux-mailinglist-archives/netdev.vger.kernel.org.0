Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86C6D1C08A2
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 22:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbgD3U4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 16:56:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35054 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725844AbgD3U4z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 16:56:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=srGlQORI5YM3BP0QbPPPER+EBQuFL9ET+cm02FB3SPc=; b=KuPQ269bZ05USR9IU4UiWmH1nK
        eRABVVvzrEZc3xteCW/lle9qJepXuUa0iR9xQ1ODvm8rk7OKWwQQGc+/XnrkZMS2UZdpBNgdaX+ZT
        6ptfVV8O15baik2xLU35dZZe6L/+oj6Xo8rZuaj3aMWOZFWWToGaqiTCPpTK+1PfAGmo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jUGEl-000SpS-Fy; Thu, 30 Apr 2020 22:56:51 +0200
Date:   Thu, 30 Apr 2020 22:56:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, cphealy@gmail.com,
        davem@davemloft.net, hkallweit1@gmail.com, mkubecek@suse.cz,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 0/9] Ethernet Cable test support
Message-ID: <20200430205651.GH107658@lunn.ch>
References: <20200425180621.1140452-1-andrew@lunn.ch>
 <20200429160213.21777-1-michael@walle.cc>
 <20200429163247.GC66424@lunn.ch>
 <c4363f2888192efc692e08cc1a4a9a57@walle.cc>
 <61eb35f8-3264-117d-59c2-22f0fdc36e96@gmail.com>
 <9caef9bbfaed5c75e72e083db8a552fd@walle.cc>
 <20200430194143.GF107658@lunn.ch>
 <4cae330197a5bdd1559dcea3482f0732@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4cae330197a5bdd1559dcea3482f0732@walle.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 30, 2020 at 10:01:55PM +0200, Michael Walle wrote:
> Oh so, the time delta counter of the Marvell PHY also runs at 125MHz? ;)

No idea. But 125MHz is one of the fundamental clocks rates in
Ethernet, so it make sense to reuse it.

>        /* Accoring to the datasheet the distance to the fault is
>         * DELTA_TIME * 0.824 meters.

A calculation like that pops up in my second set of patches where i
add raw TDR data access.

    Andrew
