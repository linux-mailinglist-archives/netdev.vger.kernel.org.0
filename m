Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF1D2CF038
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 16:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388092AbgLDPBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 10:01:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730406AbgLDPBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 10:01:05 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E992EC0613D1
        for <netdev@vger.kernel.org>; Fri,  4 Dec 2020 07:00:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=DVIhj9fBfJ5hSkwZSC7WdsQ+Ob+qNLjHh/BCJzFhUo8=; b=gXTk2sR4pWj3x9BKXoHh0T22I
        fBbGB570w7gXT9TuHi16YH0O8kDbP6D3OxkDzKjHQy/FxwOwbzcHp0rUUIIxZ39sslK9lwV1XcgjD
        lptHZBxLdWflC7BF09rUtwktXsJNPktQXmNn4D0IuHym4ReayPqpR1WUtwUfr7ATdy4iPZCmE5Wfg
        9r8W7fzLYQsvA3Zs6lpYbQQ3t9uSfuzOvU8LnKlYAxtI45L2Pzu1Eb4dKIrOvCsLNXLAQZWmEUG1L
        p7F5J3mdOtXta/1ZBsMaEnScQ0BWutJsM+6blc0rjFzzy/qXwbJZti9YIAkuCwFDu1A/Xg+RpqU0F
        g+SnjQFdQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:39712)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1klCZ4-0004Uq-7u; Fri, 04 Dec 2020 15:00:06 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1klCZ3-0000kq-L3; Fri, 04 Dec 2020 15:00:05 +0000
Date:   Fri, 4 Dec 2020 15:00:05 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: sfp: VSOL V2801F / CarlitoxxPro
 CPGOS03-0490 v2.0 workaround
Message-ID: <20201204150005.GM1551@shell.armlinux.org.uk>
References: <20201204143451.GL1551@shell.armlinux.org.uk>
 <E1klCB8-0001sW-Ma@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E1klCB8-0001sW-Ma@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

... and I just got another email from Pali Rohár about an hour after
giving me a Tested-by for this patch, saying...

Just to note I applied following fixup change to your patches for
fixing compile errors, there is missing "struct" keyword...

So, v2 on its way.

On Fri, Dec 04, 2020 at 02:35:22PM +0000, Russell King wrote:
> Add a workaround for the detection of VSOL V2801F / CarlitoxxPro
> CPGOS03-0490 v2.0 GPON module which CarlitoxxPro states needs single
> byte I2C reads to the EEPROM.
> 
> Pali Rohár reports that he also has a CarlitoxxPro-based V2801F module,
> which reports a manufacturer of "OEM". This manufacturer can't be
> matched as it appears in many different modules, so also match the part
> number too.
> 
> Reported-by: Thomas Schreiber <tschreibe@gmail.com>
> Reported-by: Pali Rohár <pali@kernel.org>
> Tested-by: Pali Rohár <pali@kernel.org>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/phy/sfp.c | 63 +++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 58 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
> index 34aa196b7465..0b26495973ff 100644
> --- a/drivers/net/phy/sfp.c
> +++ b/drivers/net/phy/sfp.c
> @@ -219,6 +219,7 @@ struct sfp {
>  	struct sfp_bus *sfp_bus;
>  	struct phy_device *mod_phy;
>  	const struct sff_data *type;
> +	size_t i2c_block_size;
>  	u32 max_power_mW;
>  
>  	unsigned int (*get_state)(struct sfp *);
> @@ -335,10 +336,19 @@ static int sfp_i2c_read(struct sfp *sfp, bool a2, u8 dev_addr, void *buf,
>  			size_t len)
>  {
>  	struct i2c_msg msgs[2];
> -	u8 bus_addr = a2 ? 0x51 : 0x50;
> +	size_t block_size;
>  	size_t this_len;
> +	u8 bus_addr;
>  	int ret;
>  
> +	if (a2) {
> +		block_size = 16;
> +		bus_addr = 0x51;
> +	} else {
> +		block_size = sfp->i2c_block_size;
> +		bus_addr = 0x50;
> +	}
> +
>  	msgs[0].addr = bus_addr;
>  	msgs[0].flags = 0;
>  	msgs[0].len = 1;
> @@ -350,8 +360,8 @@ static int sfp_i2c_read(struct sfp *sfp, bool a2, u8 dev_addr, void *buf,
>  
>  	while (len) {
>  		this_len = len;
> -		if (this_len > 16)
> -			this_len = 16;
> +		if (this_len > block_size)
> +			this_len = block_size;
>  
>  		msgs[1].len = this_len;
>  
> @@ -1632,6 +1642,28 @@ static int sfp_sm_mod_hpower(struct sfp *sfp, bool enable)
>  	return 0;
>  }
>  
> +/* Some modules (Nokia 3FE46541AA) lock up if byte 0x51 is read as a
> + * single read. Switch back to reading 16 byte blocks unless we have
> + * a CarlitoxxPro module (rebranded VSOL V2801F). Even more annoyingly,
> + * some VSOL V2801F have the vendor name changed to OEM.
> + */
> +static int sfp_quirk_i2c_block_size(const sfp_eeprom_base *base)
> +{
> +	if (!memcmp(base->vendor_name, "VSOL            ", 16))
> +		return 1;
> +	if (!memcmp(base->vendor_name, "OEM             ", 16) &&
> +	    !memcmp(base->vendor_pn,   "V2801F          ", 16))
> +		return 1;
> +
> +	/* Some modules can't cope with long reads */
> +	return 16;
> +}
> +
> +static void sfp_quirks_base(struct sfp *sfp, const sfp_eeprom_base *base)
> +{
> +	sfp->i2c_block_size = sfp_quirk_i2c_block_size(base);
> +}
> +
>  static int sfp_cotsworks_fixup_check(struct sfp *sfp, struct sfp_eeprom_id *id)
>  {
>  	u8 check;
> @@ -1673,14 +1705,20 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
>  	u8 check;
>  	int ret;
>  
> -	ret = sfp_read(sfp, false, 0, &id, sizeof(id));
> +	/* Some modules (CarlitoxxPro CPGOS03-0490) do not support multibyte
> +	 * reads from the EEPROM, so start by reading the base identifying
> +	 * information one byte at a time.
> +	 */
> +	sfp->i2c_block_size = 1;
> +
> +	ret = sfp_read(sfp, false, 0, &id.base, sizeof(id.base));
>  	if (ret < 0) {
>  		if (report)
>  			dev_err(sfp->dev, "failed to read EEPROM: %d\n", ret);
>  		return -EAGAIN;
>  	}
>  
> -	if (ret != sizeof(id)) {
> +	if (ret != sizeof(id.base)) {
>  		dev_err(sfp->dev, "EEPROM short read: %d\n", ret);
>  		return -EAGAIN;
>  	}
> @@ -1719,6 +1757,21 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
>  		}
>  	}
>  
> +	/* Apply any early module-specific quirks */
> +	sfp_quirks_base(sfp, &id.base);
> +
> +	ret = sfp_read(sfp, false, SFP_CC_BASE + 1, &id.ext, sizeof(id.ext));
> +	if (ret < 0) {
> +		if (report)
> +			dev_err(sfp->dev, "failed to read EEPROM: %d\n", ret);
> +		return -EAGAIN;
> +	}
> +
> +	if (ret != sizeof(id.ext)) {
> +		dev_err(sfp->dev, "EEPROM short read: %d\n", ret);
> +		return -EAGAIN;
> +	}
> +
>  	check = sfp_check(&id.ext, sizeof(id.ext) - 1);
>  	if (check != id.ext.cc_ext) {
>  		if (cotsworks) {
> -- 
> 2.20.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
