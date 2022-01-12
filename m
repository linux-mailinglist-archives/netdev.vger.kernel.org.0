Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90E6A48C3AE
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 13:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240374AbiALMGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 07:06:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237350AbiALMGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 07:06:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FED9C06173F;
        Wed, 12 Jan 2022 04:06:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E58EE6189D;
        Wed, 12 Jan 2022 12:06:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99650C36AEA;
        Wed, 12 Jan 2022 12:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641989180;
        bh=HjLAGiICEdBjyy57hSRIlZqgutrx5Bc1oaXf7MmzTqw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xrbeYF37jTAC/ZI7OAVid6rJcE47n2V9lxMuI5iGDChOMv/GblmE3ImXt4dZtoJOV
         qEHZJcpHaqQKVo8ESNv+JFu2EJ30olVzq36bDZl9mPXjDTutPNxF5ZvSIwaoiov89j
         PCcPWV9T7cnr2Vf41TdUfzTHBBaS1ImLfElElFG8=
Date:   Wed, 12 Jan 2022 13:06:17 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     =?iso-8859-1?B?Suly9G1l?= Pouiller <jerome.pouiller@silabs.com>,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, linux-mmc@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH v9 08/24] wfx: add bus_sdio.c
Message-ID: <Yd7EOcx/zHJFeJUv@kroah.com>
References: <20220111171424.862764-1-Jerome.Pouiller@silabs.com>
 <20220111171424.862764-9-Jerome.Pouiller@silabs.com>
 <20220112105859.u4j76o7cpsr4znmb@pali>
 <42104281.b1Mx7tgHyx@pc-42>
 <20220112114332.jadw527pe7r2j4vv@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220112114332.jadw527pe7r2j4vv@pali>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 12:43:32PM +0100, Pali Rohár wrote:
> Btw, is there any project which maintains SDIO ids, like there is
> pci-ids.ucw.cz for PCI or www.linux-usb.org/usb-ids.html for USB?

Both of those projects have nothing to do with the kernel drivers or
values at all, they are only for userspace tools to use.

So even if there was such a thing for SDIO ids, I doubt it would help
here.

thanks,

greg k-h
