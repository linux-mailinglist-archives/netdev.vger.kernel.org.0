Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9922D221A98
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 05:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727971AbgGPDLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 23:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726770AbgGPDLA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 23:11:00 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FF61C061755;
        Wed, 15 Jul 2020 20:11:00 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id lx13so4915381ejb.4;
        Wed, 15 Jul 2020 20:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=mAY+Yg/BGbcuxtFd8UR66g4d55garWGwVyThP8xJg58=;
        b=LHo7yXHcb87a/RUz8wFKaintchDJTIf+sVGZiljV3n2hSdPH+T1fs1sbSzN3ckLMak
         RZTFT2KLYiNpTZr3dZpc3z1Hx6zSBehgH/zFPHiYJdXnHVyX8sgvPkD3FFqT7QtHQocp
         /CrZ/2sTu7qOs06yZWzHfDS4jhrKmIIuU15h8PNyb+Y1Bf4SaBHJJ6q8t+Qyo6wsywUD
         HBVTAM1XzW6jjDevE0uvEnRZBYvlvpfzqd3SZgGVGnP3pXbQLaYJel0JKU9JUvrglceQ
         cJTL7QLvX/YmBLgdJcLGUSHbnM0v0wYjwThnu2fKDXbxfeSq1Vids1jhuKRPMhdwHKEv
         PZGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mAY+Yg/BGbcuxtFd8UR66g4d55garWGwVyThP8xJg58=;
        b=MLig3sbYqFTjteg7jS9gj+FxDaOTJMoZpw5MZEL3L1+DdJ8r6h6VBG+qWHSRO1E4V+
         5AiLcRsSZOgvab7lHadzlPf07QxqbJKNIKunVIfM66c20WNOcVUgBajwPl789KTeQI7u
         1bzDM3ff2u3YDFEaxP1VpeViKftkYrH2RTQUH4zX8Llst3Wv5bdlDxNHchTETXutFgEg
         ArQvNJkbYj664YdCiTIwe4pfk+gtm5SYgqmBqnsdo44cTBjcQfmneEKLQdT89fCOS8QC
         OsPfSws3wKsnSW1CU/i64/qOZgJ/G39ppAG7XzkkVeDRwucAtjXQayh14fLbySRfKK/z
         r5Kg==
X-Gm-Message-State: AOAM530It9a/dHdLsLa99/6SH5qAlRqjFQ2334MJVpwgor6g5rGVBnGc
        aA9KeeIVA2lfbT9gpVTuesto1j7i
X-Google-Smtp-Source: ABdhPJzvCTtVN/lR2+Uj76tKsMvUD9HwL+oH92EjkSu9OzNL3OVemE1hnGCAZzjFg9XSyawXzYLyQQ==
X-Received: by 2002:a17:906:e0c7:: with SMTP id gl7mr1766447ejb.264.1594869058762;
        Wed, 15 Jul 2020 20:10:58 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id s18sm3947220ejm.16.2020.07.15.20.10.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jul 2020 20:10:58 -0700 (PDT)
Subject: Re: [PATCH net-next] net: phy: sfp: Cotsworks SFF module EEPROM fixup
To:     Chris Healy <cphealy@gmail.com>, linux@armlinux.org.uk,
        andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200714175910.1358-1-cphealy@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <be18cbb8-4deb-ebdc-1097-7b1453bcf86e@gmail.com>
Date:   Wed, 15 Jul 2020 20:10:54 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200714175910.1358-1-cphealy@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/14/2020 10:59 AM, Chris Healy wrote:
> Some Cotsworks SFF have invalid data in the first few bytes of the
> module EEPROM.  This results in these modules not being detected as
> valid modules.
> 
> Address this by poking the correct EEPROM values into the module
> EEPROM when the model/PN match and the existing module EEPROM contents
> are not correct.
> 
> Signed-off-by: Chris Healy <cphealy@gmail.com>
> ---
>  drivers/net/phy/sfp.c | 44 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 44 insertions(+)
> 
> diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
> index 73c2969f11a4..2737d9b6b0ae 100644
> --- a/drivers/net/phy/sfp.c
> +++ b/drivers/net/phy/sfp.c
> @@ -1632,10 +1632,43 @@ static int sfp_sm_mod_hpower(struct sfp *sfp, bool enable)
>  	return 0;
>  }
>  
> +static int sfp_cotsworks_fixup_check(struct sfp *sfp, struct sfp_eeprom_id *id)
> +{
> +	u8 check;
> +	int err;
> +
> +	if (id->base.phys_id != SFF8024_ID_SFF_8472 ||
> +	    id->base.phys_ext_id != SFP_PHYS_EXT_ID_SFP ||
> +	    id->base.connector != SFF8024_CONNECTOR_LC) {
> +		dev_warn(sfp->dev, "Rewriting fiber module EEPROM with corrected values\n");
> +		id->base.phys_id = SFF8024_ID_SFF_8472;
> +		id->base.phys_ext_id = SFP_PHYS_EXT_ID_SFP;
> +		id->base.connector = SFF8024_CONNECTOR_LC;
> +		err = sfp_write(sfp, false, SFP_PHYS_ID, &id->base, 3);
> +		if (err != 3) {
> +			dev_err(sfp->dev, "Failed to rewrite module EEPROM: %d\n", err);
> +			return err;
> +		}
> +
> +		/* Cotsworks modules have been found to require a delay between write operations. */
> +		mdelay(50);
> +
> +		/* Update base structure checksum */
> +		check = sfp_check(&id->base, sizeof(id->base) - 1);
> +		err = sfp_write(sfp, false, SFP_CC_BASE, &check, 1);
> +		if (err != 1) {
> +			dev_err(sfp->dev, "Failed to update base structure checksum in fiber module EEPROM: %d\n", err);
> +			return err;
> +		}
> +	}
> +	return 0;
> +}
> +
>  static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
>  {
>  	/* SFP module inserted - read I2C data */
>  	struct sfp_eeprom_id id;
> +	bool cotsworks_sfbg;
>  	bool cotsworks;
>  	u8 check;
>  	int ret;
> @@ -1657,6 +1690,17 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
>  	 * serial number and date code.
>  	 */
>  	cotsworks = !memcmp(id.base.vendor_name, "COTSWORKS       ", 16);
> +	cotsworks_sfbg = !memcmp(id.base.vendor_pn, "SFBG", 4);
> +
> +	/* Cotsworks SFF module EEPROM do not always have valid phys_id,
> +	 * phys_ext_id, and connector bytes.  Rewrite SFF EEPROM bytes if
> +	 * Cotsworks PN matches and bytes are not correct.
> +	 */
> +	if (cotsworks && cotsworks_sfbg) {
> +		ret = sfp_cotsworks_fixup_check(sfp, &id);
> +		if (ret < 0)
> +			return ret;
> +	}

So with the fixup you introduce, should we ever go into a situation where:

EPROM extended structure checksum failure

is printed?
-- 
Florian
