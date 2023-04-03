Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2455E6D463C
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 15:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232550AbjDCNwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 09:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232096AbjDCNwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 09:52:07 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 153026EAF
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 06:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=cpdNyeOfRiYTNGC6FW4n2Zp9GrVAqrDfFgVfQqkO0hY=; b=BtnP2nSSNJkMAGLam66UbWmBMv
        du1BjRKdwOVmCZUz1KJZBZz80EZbBqstdmCekaEzepn3mPkB4da9fFCxr8tYBipmnSzfCOBFOV7yW
        +JP/uQDcnKhga670PS0PF4itpzC9t6byl/u3RGy0FDn4ouDotQ7XfuGufHjltndcrROAiB/EJOhX2
        yrlT4Ixj7dU9ANp4zCIG2BoeQr3cyR1qYIgTZAZ90fpo4pGLRXi9Qp408l9fJNAdl2Aujyry2Y8LW
        5tGenfI4MzRgMRhzP28rr8JLvIlu+D6ASOvW0pv9XQJ6OUq8QJTScvSXCl+jstS9+4VT9TdDoNl+m
        elLsH44A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:60738)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pjKbA-0002rj-CR; Mon, 03 Apr 2023 14:51:52 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pjKb9-0004I8-Pw; Mon, 03 Apr 2023 14:51:51 +0100
Date:   Mon, 3 Apr 2023 14:51:51 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>, netdev@vger.kernel.org,
        mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next 6/6] net: txgbe: Support phylink MAC layer
Message-ID: <ZCrZ93yxnwWP8QeT@shell.armlinux.org.uk>
References: <20230403064528.343866-1-jiawenwu@trustnetic.com>
 <20230403064528.343866-7-jiawenwu@trustnetic.com>
 <ca3c82a9-4160-422a-a618-04ab04a19015@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca3c82a9-4160-422a-a618-04ab04a19015@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 03, 2023 at 03:22:03PM +0200, Andrew Lunn wrote:
> > +static void txgbe_mac_config(struct phylink_config *config, unsigned int mode,
> > +			     const struct phylink_link_state *state)
> > +{
> > +}
> 
> That is very likely to be wrong. Lets see what Russell says.

I don't think that's a problem if the MAC is just something that
pumps data into the PCS at whatever rate the PCS wants.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
