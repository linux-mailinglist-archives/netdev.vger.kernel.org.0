Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A95820C741
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 11:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbgF1Jgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 05:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbgF1Jgl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 05:36:41 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D051C061794
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 02:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=83+6BDIj+Ob12W0XDWe5GEsVdyTtKIdFixTlJYKaQa8=; b=FZHh56fsSx9WEWtxQIpHhDeH9
        dMWUZ5xEcXoMcSYp7IlXa9ETBY0CC2LbevO+ZI1HcRtsB8ZOPt67SvTjvHHnojw30yTEkDsJAUy9C
        SDtZJnriVxSl7clOdJNCFR3NfT+kTbrgidIxAf8mdTleTCBpyCRiJa1Y4VnF1YeVwK4V+q3ut2Vn+
        CRzmwAtwH9P/p/zmpFonnMpaGIIIxLj16bj6CRHQFUSB21F9p2iROKrimfLW5/SMJJ0W0/BLD1PrL
        MV6sMpi1qBWCFPCScohCfymLByM+Fc4nnudKon/oHHDGxIFWHt1eUD3pA2jC0mIz9xVFyirUEbWAt
        3Fzt43e6Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:60802)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jpTjn-0006eY-Ks; Sun, 28 Jun 2020 10:36:35 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jpTjn-0005zf-4C; Sun, 28 Jun 2020 10:36:35 +0100
Date:   Sun, 28 Jun 2020 10:36:35 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Colton Lewis <colton.w.lewis@protonmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v3] net: phylink: correct trivial kernel-doc
 inconsistencies
Message-ID: <20200628093634.GQ1551@shell.armlinux.org.uk>
References: <20200621154248.GB338481@lunn.ch>
 <20200621155345.GV1551@shell.armlinux.org.uk>
 <3315816.iIbC2pHGDl@laptop.coltonlewis.name>
 <20200621234431.GZ1551@shell.armlinux.org.uk>
 <3034206.AJdgDx1Vlc@laptop.coltonlewis.name>
 <20200627235803.101718-1-colton.w.lewis@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200627235803.101718-1-colton.w.lewis@protonmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 27, 2020 at 11:58:09PM +0000, Colton Lewis wrote:
> Silence documentation build warnings by correcting kernel-doc
> comments. In the case of pcs_{config,an_restart,link_up}, change the
> declaration to a normal function since these only there for
> documentation anyway.
> 
> ./include/linux/phylink.h:74: warning: Function parameter or member 'poll_fixed_state' not described in 'phylink_config'
> ./include/linux/phylink.h:74: warning: Function parameter or member 'get_fixed_state' not described in 'phylink_config'
> ./include/linux/phylink.h:336: warning: Function parameter or member 'pcs_config' not described in 'int'
> ./include/linux/phylink.h:336: warning: Excess function parameter 'config' description in 'int'
> ./include/linux/phylink.h:336: warning: Excess function parameter 'mode' description in 'int'
> ./include/linux/phylink.h:336: warning: Excess function parameter 'interface' description in 'int'
> ./include/linux/phylink.h:336: warning: Excess function parameter 'advertising' description in 'int'
> ./include/linux/phylink.h:345: warning: Function parameter or member 'pcs_an_restart' not described in 'void'
> ./include/linux/phylink.h:345: warning: Excess function parameter 'config' description in 'void'
> ./include/linux/phylink.h:361: warning: Function parameter or member 'pcs_link_up' not described in 'void'
> ./include/linux/phylink.h:361: warning: Excess function parameter 'config' description in 'void'
> ./include/linux/phylink.h:361: warning: Excess function parameter 'mode' description in 'void'
> ./include/linux/phylink.h:361: warning: Excess function parameter 'interface' description in 'void'
> ./include/linux/phylink.h:361: warning: Excess function parameter 'speed' description in 'void'
> ./include/linux/phylink.h:361: warning: Excess function parameter 'duplex' description in 'void'
> 
> Signed-off-by: Colton Lewis <colton.w.lewis@protonmail.com>
> ---
>  include/linux/phylink.h | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/phylink.h b/include/linux/phylink.h
> index cc5b452a184e..24c52d9f63d6 100644
> --- a/include/linux/phylink.h
> +++ b/include/linux/phylink.h
> @@ -62,6 +62,8 @@ enum phylink_op_type {
>   * @dev: a pointer to a struct device associated with the MAC
>   * @type: operation type of PHYLINK instance
>   * @pcs_poll: MAC PCS cannot provide link change interrupt
> + * @poll_fixed_state: poll link state with @get_fixed_state
> + * @get_fixed_state: read link state into struct phylink_link_state
>   */
>  struct phylink_config {
>  	struct device *dev;
> @@ -331,7 +333,7 @@ void pcs_get_state(struct phylink_config *config,
>   *
>   * For most 10GBASE-R, there is no advertisement.
>   */
> -int (*pcs_config)(struct phylink_config *config, unsigned int mode,
> +int pcs_config(struct phylink_config *config, unsigned int mode,
>  		  phy_interface_t interface, const unsigned long *advertising);

We seem to be having a communication breakdown.  In review to your
version 2 patch set, I said:

   However, please drop all your changes for everything but the
   "struct phylink_config" documentation change; I'm intending to change
   all these method signatures, which means your changes will conflict.

But the changes still exist in version 3.  What gives?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
