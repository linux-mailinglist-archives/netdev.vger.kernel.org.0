Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60DAF204D83
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 11:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732198AbgFWJH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 05:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732109AbgFWJH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 05:07:28 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C941EC061573;
        Tue, 23 Jun 2020 02:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ldF/aN/WggG+cvw07PS2qf0wY+Ysa/Xufqs3vIX/7fs=; b=CfNyO82vWkKTd5/tOSOB91ztt
        gG2fiGzCuEWqnH3MABNjqRySpjdWdWACCUb0Swu7px6H/OceAZGBHBeAvpE520Qg6VezpvNCC6QyW
        mMpdTLkn+H9snD1Xd2nXA88ixm/UIQY/q6/eLd3RselqnScIMFgB6/XSH0dFbH9Z+1UZZNsHBhPHA
        8BOdfsY0Bq8vFoDHrkP01zbTs5qD0mF0B6j9MxLFXwiCHIWEcz13NcRYA52eHFcJEmX9kD8h1iqpT
        1UoWct/v8vAsi7L7dEKMnJZDk7Rk8/JHPrWbRXHrfpNXA+APnehvlZ8Sfaj9icJpxB+f7LxFX7CiI
        M3f376coQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:59008)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jnetn-0001XI-Dr; Tue, 23 Jun 2020 10:07:23 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jneti-0000tY-Fs; Tue, 23 Jun 2020 10:07:18 +0100
Date:   Tue, 23 Jun 2020 10:07:18 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v2 05/15] net: pylink.h: add kernel-doc descriptions for
 new fields at phylink_config
Message-ID: <20200623090718.GR1551@shell.armlinux.org.uk>
References: <cover.1592895969.git.mchehab+huawei@kernel.org>
 <34970f447ff86415a6cef10a785fbef81c2819a7.1592895969.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34970f447ff86415a6cef10a785fbef81c2819a7.1592895969.git.mchehab+huawei@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 09:09:01AM +0200, Mauro Carvalho Chehab wrote:
> Some fields were moved from struct phylink into phylink_config.
> Update the kernel-doc markups for the config struct accordingly
> 
> Fixes: 5c05c1dbb177 ("net: phylink, dsa: eliminate phylink_fixed_state_cb()")
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>

Thanks.

> ---
>  include/linux/phylink.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/include/linux/phylink.h b/include/linux/phylink.h
> index cc5b452a184e..02ff1419d4be 100644
> --- a/include/linux/phylink.h
> +++ b/include/linux/phylink.h
> @@ -62,6 +62,10 @@ enum phylink_op_type {
>   * @dev: a pointer to a struct device associated with the MAC
>   * @type: operation type of PHYLINK instance
>   * @pcs_poll: MAC PCS cannot provide link change interrupt
> + * @poll_fixed_state: if true, starts link_poll,
> + *		      if MAC link is at %MLO_AN_FIXED mode.
> + * @get_fixed_state: callback to execute to determine the fixed link state,
> + *		     if MAC link is at %MLO_AN_FIXED mode.
>   */
>  struct phylink_config {
>  	struct device *dev;
> -- 
> 2.26.2
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
