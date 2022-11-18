Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9F8562F5D8
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 14:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240830AbiKRNWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 08:22:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242070AbiKRNWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 08:22:01 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C019667123
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 05:22:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=sd3VvYcxo7zcKPDj5Gk0M6bsVj1Syz+VwUEXI2HKPHM=; b=Gbij/Gjab9K9OuyV8lJjzLNXdn
        FCOsLuwF5YrsjkgMn14PvpwIbxj0nIVa7FLyWGsKw8AiaycJzEtcMK01z+TECegsscoAAUlNnRlD7
        ulozTinZurLxJI6FRgWTRFFXGoB5+iqCeTQ4CixbtHQdOdST7twibubvixhkCr2f+2io=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ow1Iy-002nSW-Qq; Fri, 18 Nov 2022 14:21:16 +0100
Date:   Fri, 18 Nov 2022 14:21:16 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wei Yongjun <weiyongjun@huaweicloud.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Robert Hancock <robert.hancock@calian.com>,
        Wei Yongjun <weiyongjun1@huawei.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: phy: at803x: fix error return code in
 at803x_probe()
Message-ID: <Y3eGzGC4XtpwSyNl@lunn.ch>
References: <20221118103635.254256-1-weiyongjun@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221118103635.254256-1-weiyongjun@huaweicloud.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 18, 2022 at 10:36:35AM +0000, Wei Yongjun wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> Fix to return a negative error code from the ccr read error handling
> case instead of 0, as done elsewhere in this function.
> 
> Fixes: 3265f4218878 ("net: phy: at803x: add fiber support")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>  resend with [PATCH net] prefix

In future, please always increment the version number of the patch.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
