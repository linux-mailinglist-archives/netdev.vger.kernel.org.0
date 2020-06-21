Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD8C202B7A
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 17:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730335AbgFUPxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 11:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729210AbgFUPxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 11:53:54 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA25EC061794
        for <netdev@vger.kernel.org>; Sun, 21 Jun 2020 08:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=+6pmKj52i3AV+yqkNMkjjSZPGUHcd9xlrxK2OU9Pla0=; b=hFuDwaYj69TX1YfZV0PMZkr0T
        gr4uGW9WogG2oO8+5AdfCVdr+g0D+NcazbTx3w+pd3HlOatWN0DpcqGy4T0U04+bgUKI4iARn0d+e
        8jKLpVpVL0teAzXoA2J0vYGKE4eN5jCuZszT5S1Z3pxwbL2MU+vtrWFB1Fd7O0d49RRls60xlO3XD
        63OPtsVHMi8GgbJzRIovojj2m1wz942uExvM4fYb9tNsEcaD7KGXBX+Q7FEVfJZDSKdT9xxEH6ew8
        slCph5XsZ5sFtlW3Jh4+M9d47E2xdg90Pp413nwHEOVg8NMcXntBvrKjk8frTM64Vxn2QL5o2dnXx
        LLcuvPGSA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58906)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jn2I0-00081t-Vc; Sun, 21 Jun 2020 16:53:49 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jn2Hx-0007dk-Or; Sun, 21 Jun 2020 16:53:45 +0100
Date:   Sun, 21 Jun 2020 16:53:45 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Colton Lewis <colton.w.lewis@protonmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: FWD: [PATCH 3/3] net: phylink: correct trivial kernel-doc
 inconsistencies
Message-ID: <20200621155345.GV1551@shell.armlinux.org.uk>
References: <20200621154248.GB338481@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200621154248.GB338481@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 21, 2020 at 05:42:48PM +0200, Andrew Lunn wrote:
> FYI:
> 
> 	Andrew

Thanks for forwarding - Colton, please copy me directly.

> 
> ----- Forwarded message from Colton Lewis <colton.w.lewis@protonmail.com> -----
> 
> Date: Sun, 21 Jun 2020 02:23:04 +0000
> From: Colton Lewis <colton.w.lewis@protonmail.com>
> To: davem@davemloft.net
> Cc: netdev@vger.kernel.org, Colton Lewis <colton.w.lewis@protonmail.com>
> Subject: [PATCH 3/3] net: phylink: correct trivial kernel-doc inconsistencies
> X-Spam-Status: No, score=-1.0 required=4.0 tests=BAYES_00,DKIM_SIGNED,
> 	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
> 	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS, SPF_PASS autolearn=no autolearn_force=no
> 	version=3.4.4
> 
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

Not all of those are valid complaints against the code.

> Signed-off-by: Colton Lewis <colton.w.lewis@protonmail.com>
> ---
>  include/linux/phylink.h | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/phylink.h b/include/linux/phylink.h
> index cc5b452a184e..cb3230590a1f 100644
> --- a/include/linux/phylink.h
> +++ b/include/linux/phylink.h
> @@ -62,6 +62,8 @@ enum phylink_op_type {
>   * @dev: a pointer to a struct device associated with the MAC
>   * @type: operation type of PHYLINK instance
>   * @pcs_poll: MAC PCS cannot provide link change interrupt
> + * @poll_fixed_state: poll link state with @get_fixed_state
> + * @get_fixed_state: read link state into struct phylink_link_state

Ack for this change.

>   */
>  struct phylink_config {
>  	struct device *dev;
> @@ -331,7 +333,7 @@ void pcs_get_state(struct phylink_config *config,
>   *
>   * For most 10GBASE-R, there is no advertisement.
>   */
> -int (*pcs_config)(struct phylink_config *config, unsigned int mode,
> +int *pcs_config(struct phylink_config *config, unsigned int mode,
>  		  phy_interface_t interface, const unsigned long *advertising);

*Definitely* a NAK on this and two changes below.  You're changing the
function signature to be incorrect.  If the documentation can't parse
a legitimate C function pointer declaration and allow it to be
documented, then that's a problem with the documentation's parsing of
C code, rather than a problem with the C code itself.

>  
>  /**
> @@ -341,7 +343,7 @@ int (*pcs_config)(struct phylink_config *config, unsigned int mode,
>   * When PCS ops are present, this overrides mac_an_restart() in &struct
>   * phylink_mac_ops.
>   */
> -void (*pcs_an_restart)(struct phylink_config *config);
> +void *pcs_an_restart(struct phylink_config *config);
>  
>  /**
>   * pcs_link_up() - program the PCS for the resolved link configuration
> @@ -356,7 +358,7 @@ void (*pcs_an_restart)(struct phylink_config *config);
>   * mode without in-band AN needs to be manually configured for the link
>   * and duplex setting. Otherwise, this should be a no-op.
>   */
> -void (*pcs_link_up)(struct phylink_config *config, unsigned int mode,
> +void *pcs_link_up(struct phylink_config *config, unsigned int mode,
>  		    phy_interface_t interface, int speed, int duplex);
>  #endif
>  
> -- 
> 2.26.2
> 
> 
> 
> ----- End forwarded message -----
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
