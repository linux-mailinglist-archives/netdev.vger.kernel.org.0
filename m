Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E36F239A6A5
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbhFCRHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:07:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43666 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229695AbhFCRHc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:07:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=i94mZKTdzIzK1JAgAL7WiUVWsC50HEuGJnIVHUQxEOI=; b=yHgYtHTMEMsYoByJ3CVGsZnTxx
        joQq/48Kb2hmIVpbTd1Se0s8hBfpuSEuoua5Fd6scuZd3wrLmQDEP3Z3HVHYrJbWsBsAsxbO4Ikjs
        PNJb4Fc6Bir7TpS9Ka78URWHvuWzW6nRp5/l3hmz7dprOyjDuxIPxf26vqK/HO4zFglc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1loqmu-007f6h-MB; Thu, 03 Jun 2021 19:05:44 +0200
Date:   Thu, 3 Jun 2021 19:05:44 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Liang Xu <lxu@maxlinear.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "vee.khee.wong@linux.intel.com" <vee.khee.wong@linux.intel.com>,
        Hauke Mehrtens <hmehrtens@maxlinear.com>,
        Thomas Mohren <tmohren@maxlinear.com>
Subject: Re: [PATCH v2] net: phy: add Maxlinear GPY115/21x/24x driver
Message-ID: <YLkL6MWJCheuUJv1@lunn.ch>
References: <20210603073438.33967-1-lxu@maxlinear.com>
 <20210603091750.GQ30436@shell.armlinux.org.uk>
 <54b527d6-0fe6-075f-74d6-cc4c51706a87@maxlinear.com>
 <YLjzeMpRDIUV9OAI@lunn.ch>
 <1e580c98-3a0c-2e60-17e3-01ad8bfd69d9@maxlinear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e580c98-3a0c-2e60-17e3-01ad8bfd69d9@maxlinear.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The firmware version can change because of switch of the firmware during 
> running time.

Please could you explain this some more. What happens if i initialize
the PHY and then it decided to switch its firmware. Is the
configuration kept? Does it need reconfiguring?

      Andrew
