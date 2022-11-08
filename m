Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B77B3621DEC
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 21:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbiKHUpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 15:45:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbiKHUo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 15:44:27 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E4392EB;
        Tue,  8 Nov 2022 12:44:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=/SNM6E6H65YIODP35xPJGqkkSXZId2E7TVtIokYS0E0=; b=HYj5MdvZTN7nJuBZKqZm3OyEsF
        2kXi1DdLnl1v3vDRy37VTI+47PVVOd7tVJk1o82r/+5ir1k6IvZhbQzR45QnDOwojpvqIHgfvqZ9r
        F47ou/v2aPv+j46+W/4kI8OajEhWr1WPOaxuJtF8I6URczCgq1Y4KHhoIvLTWS430VMA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1osVRi-001r9c-SD; Tue, 08 Nov 2022 21:43:46 +0100
Date:   Tue, 8 Nov 2022 21:43:46 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Looi Hong Aun <hong.aun.looi@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        Zulkifli Muhammad Husaini <muhammad.husaini.zulkifli@intel.com>,
        Gan Yi Fang <yi.fang.gan@intel.com>
Subject: Re: [PATCH net 1/1] net: phy: dp83867: Fix SGMII FIFO depth for non
 OF devices
Message-ID: <Y2q/gseHADE+G/t0@lunn.ch>
References: <20221108101218.612499-1-michael.wei.hong.sit@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108101218.612499-1-michael.wei.hong.sit@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 06:12:18PM +0800, Michael Sit Wei Hong wrote:
> Current driver code will read device tree node information,
> and set default values if there is no info provided.
> 
> This is not done in non-OF devices leading to SGMII fifo depths being
> set to the smallest size.
> 
> This patch sets the value to the default value of the PHY as stated in the
> PHY datasheet.
> 
> Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
