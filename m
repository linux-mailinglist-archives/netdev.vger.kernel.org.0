Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5F975703
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 20:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbfGYSet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 14:34:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38152 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725800AbfGYSet (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 14:34:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=M6GuFdL+bO6L1qoMoP2vNiL93csRJG5VJGOAi/Rol8Q=; b=AvN8/TWFD3shwUn3mjIXxPqVgg
        PiMjgC+KBi9fbr5D2dFEpxZlbi6fN+J3ijrxYFR18Wj1Bz+hH5D1VsOaQROJ+aWtctyrQTiNLVPwr
        uaGpTcFAi4x3VLyv66yznSQeC9jc897+S4GHoLKlfRV02mnw2YF4FZ42IZnUWwcdm1O0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hqiZd-0008GV-9l; Thu, 25 Jul 2019 20:34:41 +0200
Date:   Thu, 25 Jul 2019 20:34:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Matthias Kaehlcke <mka@chromium.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
Subject: Re: [RFC] dt-bindings: net: phy: Add subnode for LED configuration
Message-ID: <20190725183441.GL21952@lunn.ch>
References: <20190722223741.113347-1-mka@chromium.org>
 <20190724180430.GB28488@lunn.ch>
 <20190725175258.GE250418@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190725175258.GE250418@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> As of now I don't plan to expose the label to userspace by the PHY
> driver/framework itself.

Great.

With that change, i think this proposed binding is O.K.

     Andrew
