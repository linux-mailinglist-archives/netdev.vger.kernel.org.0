Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1491DB9F6
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 18:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbgETQnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 12:43:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41652 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726486AbgETQnT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 12:43:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=NywBFRjF7GgWpXTGYPudEVjq/5XYdjF+2nJ4tHCAfxE=; b=oM7UrpoKp62ygCtrl3OO3UHXwL
        q05d/E9ylGaM5dCxgRScYxmI7EbY5LxvKIWlILW6QwcGv6/DGMKLl6rcV/4FoyT4gqcpx1HkNDzgR
        6uYQNqBtFoMgsJRAyhMclV+GfqNIbdW5VcEECCJ852l8nYF0u0LXw3QTO5DMs9off5z4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jbRoH-002pB6-1B; Wed, 20 May 2020 18:43:13 +0200
Date:   Wed, 20 May 2020 18:43:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v2 3/4] dt-bindings: net: Add RGMII internal
 delay for DP83869
Message-ID: <20200520164313.GI652285@lunn.ch>
References: <20200520121835.31190-1-dmurphy@ti.com>
 <20200520121835.31190-4-dmurphy@ti.com>
 <20200520135624.GC652285@lunn.ch>
 <770e42bb-a5d7-fb3e-3fc1-b6f97a9aeb83@ti.com>
 <20200520153631.GH652285@lunn.ch>
 <95ab99bf-2fb5-c092-ad14-1b0a47c782a4@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <95ab99bf-2fb5-c092-ad14-1b0a47c782a4@ti.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I am interested in knowing where that is documented.  I want to RTM I
> grepped for a few different words but came up empty

Hi Dan

It probably is not well documented, but one example would be

Documentation/devicetree/bindings/net/ethernet-controller.yaml

says:

      # RX and TX delays are added by the MAC when required
      - rgmii

      # RGMII with internal RX and TX delays provided by the PHY,
      # the MAC should not add the RX or TX delays in this case
      - rgmii-id

      # RGMII with internal RX delay provided by the PHY, the MAC
      # should not add an RX delay in this case
      - rgmii-rxid

      # RGMII with internal TX delay provided by the PHY, the MAC
      # should not add an TX delay in this case

      Andrew
