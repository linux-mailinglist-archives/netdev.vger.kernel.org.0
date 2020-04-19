Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 151591AFBA3
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 17:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726209AbgDSPMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 11:12:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48346 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725910AbgDSPMQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 11:12:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=SoRCxIvpuCeHu1TIxvBTK9F+yJrLj3NNUim4UUn1SVw=; b=te/iy5+PcILtcbIkQgl746MUu+
        BKgEXochwUq9tR/JK710+SPJEyCVzFcfDgDElOBzGPaYsA9sGQqu0NRCYCcQVdiDT5CYB3TQkV1oE
        IuCLEz/znltZ15pzz4+oSTDnGazGQ7hvzQL42YLPApSWL7RqMVQUrMkQvSuZTcJCMyKk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jQBcC-003eJQ-Eb; Sun, 19 Apr 2020 17:12:12 +0200
Date:   Sun, 19 Apr 2020 17:12:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/2] dt-bindings: net: mdio: Make
 descriptions more general
Message-ID: <20200419151212.GG836632@lunn.ch>
References: <20200419030843.18870-1-f.fainelli@gmail.com>
 <20200419030843.18870-3-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200419030843.18870-3-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 18, 2020 at 08:08:43PM -0700, Florian Fainelli wrote:
> A number of descriptions assume a PHY device, but since this binding
> describes a MDIO bus which can have different kinds of MDIO devices
> attached to it, rephrase some descriptions to be more general in that
> regard.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
