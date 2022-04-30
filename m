Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E942B515E8C
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 17:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239589AbiD3PJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 11:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237866AbiD3PJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 11:09:20 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9E228E39
        for <netdev@vger.kernel.org>; Sat, 30 Apr 2022 08:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=1Xj1sZz0fH9pdELwGwJRjUA5e6Uwh/SAlFBtNibS+mg=; b=CUWIGRvmRzxYHklfDVv6knW5lf
        aKm0t9BRMa26Pc1s1a8FB+VHFyQ/l4Ai7MRXBYd0eA2d04Z1OC0aGfQjrHnZ/hhXm+oN6UHQq/HGj
        c6KpFT4jlI4XQspFF5Fw0yA0MEMyCKGag8n9ghAEsZw2bTTtVe02iCFdXIlg5iuVTFlg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nkofS-000e4h-F5; Sat, 30 Apr 2022 17:05:54 +0200
Date:   Sat, 30 Apr 2022 17:05:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     netdev@vger.kernel.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
Subject: Re: [PATCH net-next] net: phy: marvell: update abilities and
 advertising when switching to SGMII
Message-ID: <Ym1QUuBjUWKi/k0I@lunn.ch>
References: <20220427193928.2155805-1-robert.hancock@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427193928.2155805-1-robert.hancock@calian.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 01:39:28PM -0600, Robert Hancock wrote:
> With some SFP modules, such as Finisar FCLF8522P2BTL, the PHY hardware
> strapping defaults to 1000BaseX mode, but the kernel prefers to set them
> for SGMII mode. When this happens and the PHY is soft reset, the BMSR
> status register is updated, but this happens after the kernel has already
> read the PHY abilities during probing. This results in support not being
> detected for, and the PHY not advertising support for, 10 and 100 Mbps
> modes, preventing the link from working with a non-gigabit link partner.
> 
> When the PHY is being configured for SGMII mode, call genphy_read_abilities
> again in order to re-read the capabilities, and update the advertising
> field accordingly.
> 
> Signed-off-by: Robert Hancock <robert.hancock@calian.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
