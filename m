Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A0C3CF003
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 01:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442927AbhGSW4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 18:56:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34816 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1387933AbhGSUif (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 16:38:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+UXHuhiBXJh8sCVJzWzeJLyuG6EnDPs48BDBi11ywpo=; b=cR7qSJjobG5gPBRl1ZFupFBCfs
        EGU4LNZQR2Q8Ovmw92KqSaxVGKI1mubZ8v8inAAJQ7qX5ArPxsjK+VvvWifHxBcdexKBrR0Ye45E8
        NQNaKVBHrftcieB0LZgSOu6gj3oiK9po+WKbTjk18OBJloYTAO1xxSJPLJHSRzbKgrLk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m5aBE-00DxgN-Ca; Mon, 19 Jul 2021 22:48:00 +0200
Date:   Mon, 19 Jul 2021 22:48:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Xu Liang <lxu@maxlinear.com>
Cc:     hkallweit1@gmail.com, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, vee.khee.wong@linux.intel.com,
        linux@armlinux.org.uk, hmehrtens@maxlinear.com,
        tmohren@maxlinear.com, mohammad.athari.ismail@intel.com
Subject: Re: [PATCH v6 2/2] net: phy: add Maxlinear GPY115/21x/24x driver
Message-ID: <YPXlAFZCU3T+ua93@lunn.ch>
References: <20210719053212.11244-1-lxu@maxlinear.com>
 <20210719053212.11244-2-lxu@maxlinear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719053212.11244-2-lxu@maxlinear.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/* PHY ID */
> +#define PHY_ID_GPYx15B_MASK	0xFFFFFFFC
> +#define PHY_ID_GPY21xB_MASK	0xFFFFFFF9

That is an odd mask. Is that really correct?

     Andrew
