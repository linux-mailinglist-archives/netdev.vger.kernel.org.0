Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9178221AE4
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 05:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728200AbgGPDhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 23:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727034AbgGPDhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 23:37:20 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D63AC061755;
        Wed, 15 Jul 2020 20:37:19 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id p20so4933912ejd.13;
        Wed, 15 Jul 2020 20:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Kc//SU1WBHhArSL1EGBi4pEoU7QX9fzfoco4jF4NECA=;
        b=hMBKIE+08titO1+wUAD1fBaPjySkW4PCfyXYqVoByjYlCt/Q5ukUSTsQ7Rcy0XpL0v
         zZP5HJ/mbdJ3YHdYZZOX03rJc8doGVUPKywLLYBLgcwF/7DUALms5zU/u7akrmLHnA3K
         ycir1wt+lBaksn0+ZOB6+MNHD4KzDjzoCArkCtRwbMgX1Q95XzJI/1hBG1zVF4GVsS96
         w6x0DW1mtBi6pWkwHUHF8U5RY3aDlA2RYHRNT05pGaNesymVOssTaKG0bdbhl18lr5yC
         asXJ3biFEFtZb8ih+CbEoeo44oTZaRJ+dqPWS21m71BoBMFv76A0zFxTgbdrtqOkXROs
         qjxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Kc//SU1WBHhArSL1EGBi4pEoU7QX9fzfoco4jF4NECA=;
        b=gWC4SU/mm5pVSkUc92F36Ymak9jiBJlf6XI8BzcPdcQJ6yjsTgdUjge6uXFv3NaOfq
         P4vWTNVQjEx1cZo5/vCIWNDB6/Lr2z86s3erOV9a9podUm8/s8pLWnxQKKTe1Mfes1FB
         6/rSH63dF1p0/tBVMhPZsitehKJqDpqEA1dhsvVa72KQwSR7PtnSVWOdN8cQQEctBFfA
         ZzRUTK74Uv9D4ZMw7w+XqGhjsyU59xF2ci2bWh2Y6eLd+3nPvgtCI4W5Sfn4oZM7WPu3
         sEXXyOIadv4q3CTNo8npelX73blalFFDnXQ3ln7eYBCJ1eQanqGO6XmGkq7DuFqGW4W/
         /pCQ==
X-Gm-Message-State: AOAM531x0YQ8t3roHiw/rqOtgNiZBcJvVj7/8zz+dFK8IsZI2qcQ3u0l
        cFh2K5dXdwOhWfb5mYbeKI95nBgU
X-Google-Smtp-Source: ABdhPJwdONK+qy2MT9KLEAxSUz4V9y7aLuTT4UKFuaCjkCr8Kdd7HJZ7jRZBnRwqUiBiF8XVKITycw==
X-Received: by 2002:a17:906:c56:: with SMTP id t22mr2068168ejf.50.1594870637956;
        Wed, 15 Jul 2020 20:37:17 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id ce12sm4030826edb.4.2020.07.15.20.37.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jul 2020 20:37:17 -0700 (PDT)
Subject: Re: [PATCH net-next] net: phy: sfp: Cotsworks SFF module EEPROM fixup
To:     Chris Healy <cphealy@gmail.com>
Cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20200714175910.1358-1-cphealy@gmail.com>
 <be18cbb8-4deb-ebdc-1097-7b1453bcf86e@gmail.com>
 <CAFXsbZpHH3rFbxG1-bGOErQZS+_3Xo8rAKDSWwgH3M7Bgj_sGw@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <0116ffea-0048-5a85-da09-fbac248b30ba@gmail.com>
Date:   Wed, 15 Jul 2020 20:37:13 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAFXsbZpHH3rFbxG1-bGOErQZS+_3Xo8rAKDSWwgH3M7Bgj_sGw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/15/2020 8:32 PM, Chris Healy wrote:
> 
> 
> On Wed, Jul 15, 2020 at 8:10 PM Florian Fainelli <f.fainelli@gmail.com
> <mailto:f.fainelli@gmail.com>> wrote:
> 
> 
> 
>     On 7/14/2020 10:59 AM, Chris Healy wrote:
>     > Some Cotsworks SFF have invalid data in the first few bytes of the
>     > module EEPROM.  This results in these modules not being detected as
>     > valid modules.
>     >
>     > Address this by poking the correct EEPROM values into the module
>     > EEPROM when the model/PN match and the existing module EEPROM contents
>     > are not correct.
>     >
>     > Signed-off-by: Chris Healy <cphealy@gmail.com
>     <mailto:cphealy@gmail.com>>
>     > ---
>     >  drivers/net/phy/sfp.c | 44
>     +++++++++++++++++++++++++++++++++++++++++++
>     >  1 file changed, 44 insertions(+)
>     >
>     > diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
>     > index 73c2969f11a4..2737d9b6b0ae 100644
>     > --- a/drivers/net/phy/sfp.c
>     > +++ b/drivers/net/phy/sfp.c
>     > @@ -1632,10 +1632,43 @@ static int sfp_sm_mod_hpower(struct sfp
>     *sfp, bool enable)
>     >       return 0;
>     >  }
>     > 
>     > +static int sfp_cotsworks_fixup_check(struct sfp *sfp, struct
>     sfp_eeprom_id *id)
>     > +{
>     > +     u8 check;
>     > +     int err;
>     > +
>     > +     if (id->base.phys_id != SFF8024_ID_SFF_8472 ||
>     > +         id->base.phys_ext_id != SFP_PHYS_EXT_ID_SFP ||
>     > +         id->base.connector != SFF8024_CONNECTOR_LC) {
>     > +             dev_warn(sfp->dev, "Rewriting fiber module EEPROM
>     with corrected values\n");
>     > +             id->base.phys_id = SFF8024_ID_SFF_8472;
>     > +             id->base.phys_ext_id = SFP_PHYS_EXT_ID_SFP;
>     > +             id->base.connector = SFF8024_CONNECTOR_LC;
>     > +             err = sfp_write(sfp, false, SFP_PHYS_ID, &id->base, 3);
>     > +             if (err != 3) {
>     > +                     dev_err(sfp->dev, "Failed to rewrite module
>     EEPROM: %d\n", err);
>     > +                     return err;
>     > +             }
>     > +
>     > +             /* Cotsworks modules have been found to require a
>     delay between write operations. */
>     > +             mdelay(50);
>     > +
>     > +             /* Update base structure checksum */
>     > +             check = sfp_check(&id->base, sizeof(id->base) - 1);
>     > +             err = sfp_write(sfp, false, SFP_CC_BASE, &check, 1);
>     > +             if (err != 1) {
>     > +                     dev_err(sfp->dev, "Failed to update base
>     structure checksum in fiber module EEPROM: %d\n", err);
>     > +                     return err;
>     > +             }
>     > +     }
>     > +     return 0;
>     > +}
>     > +
>     >  static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
>     >  {
>     >       /* SFP module inserted - read I2C data */
>     >       struct sfp_eeprom_id id;
>     > +     bool cotsworks_sfbg;
>     >       bool cotsworks;
>     >       u8 check;
>     >       int ret;
>     > @@ -1657,6 +1690,17 @@ static int sfp_sm_mod_probe(struct sfp
>     *sfp, bool report)
>     >        * serial number and date code.
>     >        */
>     >       cotsworks = !memcmp(id.base.vendor_name, "COTSWORKS       ",
>     16);
>     > +     cotsworks_sfbg = !memcmp(id.base.vendor_pn, "SFBG", 4);
>     > +
>     > +     /* Cotsworks SFF module EEPROM do not always have valid phys_id,
>     > +      * phys_ext_id, and connector bytes.  Rewrite SFF EEPROM
>     bytes if
>     > +      * Cotsworks PN matches and bytes are not correct.
>     > +      */
>     > +     if (cotsworks && cotsworks_sfbg) {
>     > +             ret = sfp_cotsworks_fixup_check(sfp, &id);
>     > +             if (ret < 0)
>     > +                     return ret;
>     > +     }
> 
>     So with the fixup you introduce, should we ever go into a situation
>     where:
> 
>     EPROM extended structure checksum failure
> 
>     is printed?
> 
> 
> From what I've been told, Cotsworks had an ordering problem where both
> the base and extended checksums were being programmed before other
> fields were programmed during manufacturing resulting in both the base
> and extended checksums being incorrect.  (I've also heard that Cotsworks
> has resolved this issue late last year for all new units but units
> manufactured before late last year will have incorrect checksums.)
> 
> Given that I was touching the base structure in this patch, I felt that
> updating the base checksum was warranted.  I did not consider updating
> the extended structure checksum as I wasn't changing anything else with
> the extended structure.  As such, we would still have an invalid
> extended structure checksum and get the associated error message.

That makes sense and thanks for providing the context here!
-- 
Florian
