Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7E1244CB62
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 22:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233491AbhKJVp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 16:45:56 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55336 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233284AbhKJVp4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 16:45:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=RiSyE+EVKYVY2Tb3uQccY7RA9TLCliIY6PxoCw7V/h4=; b=Eg4j/MQZYXmcjoZS+NYQrga7RG
        R195QVs1SdBax2wK/Tv5J3go84XrzuNZZY3r1JkJCsfULcCJ3fthwX02X/IV4k/t7Nv/LWRqEoO7Q
        1JXKcxR5+zODycC3xtmQzCwaNPTElby3+3Wav7qb1aNePlTFjGCIawtJeOC6Rg57JLvk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mkvMy-00D8tO-IS; Wed, 10 Nov 2021 22:43:00 +0100
Date:   Wed, 10 Nov 2021 22:43:00 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Apeksha Gupta <apeksha.gupta@nxp.com>
Cc:     qiangqing.zhang@nxp.com, davem@davemloft.net, kuba@kernel.org,
        arnd@arndb.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-devel@linux.nxdi.nxp.com,
        LnxRevLi@nxp.com, sachin.saxena@nxp.com, hemant.agrawal@nxp.com,
        nipun.gupta@nxp.com
Subject: Re: [PATCH 1/3] fec_phy: add new PHY file
Message-ID: <YYw85MeF8sbRRiXM@lunn.ch>
References: <20211110053617.13497-1-apeksha.gupta@nxp.com>
 <20211110053617.13497-2-apeksha.gupta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211110053617.13497-2-apeksha.gupta@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 10, 2021 at 11:06:15AM +0530, Apeksha Gupta wrote:
> Added common file for both fec and fec_uio driver.
> fec_phy.h and fec_phy.c have phy related API's.
> Now the PHY functions can be used in both FEC and
> FEC_UIO driver independently.

You appear to be missing a patch. I don't see any changes to FEC_UIO
driver to make use of this.

	Andrew
