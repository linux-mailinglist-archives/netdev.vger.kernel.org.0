Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7891194250
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 16:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbgCZPE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 11:04:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59508 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727495AbgCZPE5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 11:04:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=6dRAIG31Y9o9lqNsoig/7hXppm0i32H4kRh/mHoRuKc=; b=b+fVkMlmKKb6o3MPVGwdzyhdFD
        6iY2dtR6MSMk7K3C9gHexE4R3rwOxVe2bqGEbcSqnvSYgjRlJIHx4Eo4e7vjHEHYmSibp2lCg2meq
        lqcBG0kli+PzfRQM5kFUtR9JO+1MaQiLFFQ3r4fs5UmlyoxojPqftN02QUk0PBZfjtWs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jHU3o-0000MQ-Gl; Thu, 26 Mar 2020 16:04:44 +0100
Date:   Thu, 26 Mar 2020 16:04:44 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [RFC net-next 0/2] split phylink PCS operations and add PCS
 support for dpaa2
Message-ID: <20200326150444.GH27427@lunn.ch>
References: <20200317144944.GP25745@shell.armlinux.org.uk>
 <20200326145750.GA25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326145750.GA25745@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 02:57:50PM +0000, Russell King - ARM Linux admin wrote:
> Hi,
> 
> Was there any conclusion on this 5 patch series, and whether I should
> submit it for net-next?

Hi Russell

The basic idea seems sound. So i suggest re-submitting without the RFC
tag, and let people comment on it again.

     Andrew
