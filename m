Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA3FA5B00AC
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 11:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbiIGJit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 05:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiIGJir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 05:38:47 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFCDFB14C7;
        Wed,  7 Sep 2022 02:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=jGLUAyN4WBC7ZkwS6LsB0mO/kpRXd9GgONv16gVjrak=; b=1Bg1Oz59XoW8AlgxRN51V8jlKR
        xiGVymL1Q/bWZ12dS0LzK1Hq+CkBrW2E/Ly0IlKKFxGpWmdwcb/W5ES65bp8LnK14o7v9yjJ5LAaD
        X7xuqQBcuw9R1eYLBKgp0KOqcOTy8TztqbmnBg91tykhcJSZHGuQ9/qagUrLEFItlBx9sjxXwY8/u
        2gHuNvwPwO9NHCtdGWO2qrFj6aQ129LF0fv5fgy5Zi64UdtyRuNfS5yTelNtZYb3HPR4rY4mNWlHb
        6MSpRS5gZJ0a8ev82RvgfsHwuViCYKsY0JcK3x9BVAjZM7CDLrxw13lW2f4khEYu+nTsBTnaztSGt
        rRhx9RfA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34166)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oVrW4-0005Bj-Dx; Wed, 07 Sep 2022 10:38:40 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oVrW1-0000rW-7y; Wed, 07 Sep 2022 10:38:37 +0100
Date:   Wed, 7 Sep 2022 10:38:37 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next v5 1/8] net: phylink: Document MAC_(A)SYM_PAUSE
Message-ID: <YxhmnVIB+qT0W/5v@shell.armlinux.org.uk>
References: <20220906161852.1538270-1-sean.anderson@seco.com>
 <20220906161852.1538270-2-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906161852.1538270-2-sean.anderson@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 06, 2022 at 12:18:45PM -0400, Sean Anderson wrote:
> This documents the possible MLO_PAUSE_* settings which can result from
> different combinations of MLO_(A)SYM_PAUSE. These are more-or-less a
> direct consequence of IEEE 802.3 Table 28B-2.
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
> 
> (no changes since v3)
> 
> Changes in v3:
> - New
> 
>  include/linux/phylink.h | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/include/linux/phylink.h b/include/linux/phylink.h
> index 6d06896fc20d..a431a0b0d217 100644
> --- a/include/linux/phylink.h
> +++ b/include/linux/phylink.h
> @@ -21,6 +21,22 @@ enum {
>  	MLO_AN_FIXED,	/* Fixed-link mode */
>  	MLO_AN_INBAND,	/* In-band protocol */
>  
> +	/* MAC_SYM_PAUSE and MAC_ASYM_PAUSE correspond to the PAUSE and
> +	 * ASM_DIR bits used in autonegotiation, respectively. See IEEE 802.3

"used in our autonegotiation advertisement" would be more clear.

> +	 * Annex 28B for more information.
> +	 *
> +	 * The following table lists the values of MLO_PAUSE_* (aside from
> +	 * MLO_PAUSE_AN) which might be requested depending on the results of
> +	 * autonegotiation or user configuration:
> +	 *
> +	 * MAC_SYM_PAUSE MAC_ASYM_PAUSE Valid pause modes
> +	 * ============= ============== ==============================
> +	 *             0              0 MLO_PAUSE_NONE
> +	 *             0              1 MLO_PAUSE_NONE, MLO_PAUSE_TX
> +	 *             1              0 MLO_PAUSE_NONE, MLO_PAUSE_TXRX
> +	 *             1              1 MLO_PAUSE_NONE, MLO_PAUSE_TXRX,
> +	 *                              MLO_PAUSE_RX

Any of none, tx, txrx and rx can occur with both bits set in the last
case, the tx-only case will be due to user configuration.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
