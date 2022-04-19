Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0011F506C22
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 14:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352176AbiDSMU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 08:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241359AbiDSMUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 08:20:25 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC00237CC;
        Tue, 19 Apr 2022 05:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=kF/1igt59y2TfJ2YePNkFCihKIWNIpvzG5QTYk64o6w=; b=gV7cI+0qib+6e9uGnkem4GoPRv
        ruCgmtIpE2BSfVqo5GisnzuiUAFPq8gZhp32Xn5E/gn3pIdnPIg9t4GSLzySH1B7fQw1QtUmYGhjs
        z2kCS7W7xO1LvqH64gNBfTSKZWUYeA1oWMW+srx5EfwRdf5t6mztaHuRkrMwXakwB02s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ngmnc-00GUjL-PL; Tue, 19 Apr 2022 14:17:40 +0200
Date:   Tue, 19 Apr 2022 14:17:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, UNGLinuxDriver@microchip.com,
        richardcochran@gmail.com
Subject: Re: [RFC PATCH net-next 0/2] net: phy: Extend sysfs to adjust PHY
 latency.
Message-ID: <Yl6oZLIaBnPVkeqN@lunn.ch>
References: <20220419083704.48573-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419083704.48573-1-horatiu.vultur@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 19, 2022 at 10:37:02AM +0200, Horatiu Vultur wrote:
> The previous try of setting the PHY latency was here[1]. But this approach
> could not work for multiple reasons:
> - the interface was not generic enough so it would be hard to be extended
>   in the future
> - if there were multiple time stamper in the system then it was not clear
>   to which one should adjust these values.
> 
> So the next try is to extend sysfs and configure exactly the desired PHY.

What about timestampers which are not PHYs? Ideally you want one
interface which will work for any sort of stamper, be it MAC, PHY, or
a bump in the wire between the MAC and the PHY.

  Andrew
