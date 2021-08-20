Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 112C83F3150
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 18:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232053AbhHTQMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 12:12:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:32794 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231955AbhHTQMs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 12:12:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+qSVY5sV8V2bh7iMOY20ymxPZqm7yqT4YtSL85pNV4Q=; b=TM5KR+bxWA1751LM1MD0Y0FPG8
        KKHGKgBpGs8Adv8Cv9ojW9CMXJHgPsjiWnvsPGBFm7SLsaCGMLN+0WdRJDNqvZxdZkcM4vjlvrDoS
        Fef666uDtwA0ECthfDg2+0+sxGpWMom7KghSfVpndRzfbLxzr0xPGZSqYAavhvQjSZKU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mH77h-001BhH-Ut; Fri, 20 Aug 2021 18:12:01 +0200
Date:   Fri, 20 Aug 2021 18:12:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH] dt-bindings: net: brcm,unimac-mdio: convert to the
 json-schema
Message-ID: <YR/UUZ5EZDe9s969@lunn.ch>
References: <20210819100946.10748-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210819100946.10748-1-zajec5@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +  interrupts:
> +    oneOf:
> +      - description: >
> +          Tnterrupt shared with the Ethernet MAC or Ethernet switch this MDIO

Interrupt.

	Andrew
