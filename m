Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F07DC865EE
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 17:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403986AbfHHPfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 11:35:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44646 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732549AbfHHPfS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 11:35:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=nu6rJdx/OR9M7kX9A1CXYGTkDCwz7C7JPL3VD4fk9lE=; b=ece1Oj7EG1wH5/v87qfjAICuR7
        nHNvwuia4csDzGJE1k8b9wsdNaBuHSO/cLwprhyp4cVDSIwyNN0SnOnsgGec9MY0u/0Humd/OAz2h
        BhGVEkOYkfORX2UEcOf2knt/nzv/qv9jDRXjtv/61AKOWaIE0IqDmXwm/5q1A0VWaauo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hvkRe-0003sF-6V; Thu, 08 Aug 2019 17:35:14 +0200
Date:   Thu, 8 Aug 2019 17:35:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: Re: [PATCH v2 05/15] net: phy: adin: add {write,read}_mmd hooks
Message-ID: <20190808153514.GE27917@lunn.ch>
References: <20190808123026.17382-1-alexandru.ardelean@analog.com>
 <20190808123026.17382-6-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190808123026.17382-6-alexandru.ardelean@analog.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 08, 2019 at 03:30:16PM +0300, Alexandru Ardelean wrote:
> Both ADIN1200 & ADIN1300 support Clause 45 access.
> The Extended Management Interface (EMI) registers are accessible via both
> Clause 45 (at register MDIO_MMD_VEND1) and using Clause 22.
> 
> However, the Clause 22 MMD access operations differ from the implementation
> in the kernel, in the sense that it uses registers ExtRegPtr (0x10) &
> ExtRegData (0x11) to access Clause 45 & EMI registers.

It is not that they differ from what the kernel supports. Its that
they differ from what the Standard says they should use. These
registers are defined in 802.3, part of C22, and this hardware
implements the standard incorrectly.

	   Andrew
