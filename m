Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16AC3193DC
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 22:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbfEIUzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 16:55:36 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36977 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbfEIUzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 16:55:35 -0400
Received: by mail-wm1-f66.google.com with SMTP id y5so4822937wma.2
        for <netdev@vger.kernel.org>; Thu, 09 May 2019 13:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=z30COJbILdQmeYwQKIFpxK+dC3uLfD0Z4o7wlT6vX+4=;
        b=j9vbkLEnnX0KHQCuW8qZJxRQOptPksjtCi9Y/amYqW94IW+6ZYRNPsq4NoxnfL9Buw
         w2l50imMYPoolmnBWnjiKTs3HCgl5KrCfwBczOslcs/uJFuOzkjeFyQNLdYxt0l/U31y
         oDDp5Kg7R0J2+7s/xlqi3h0PmZRvM8kgD/GroX3+T6N4t36xCf2fmEUyJ1281y16B4Rt
         nXEqGbcAbYyZ5wFUAVlVCYe7OEWXvRsu+K+9iGVcTnDrr45unhel1vdpji/RUVxw0iMF
         NPNc77rYiSrf9ChdwCeQo1I0/k1c/PC/ni+Ct3OFKBISt2mRg1mOwL8Xq3y/u1Xu7QKf
         IqBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z30COJbILdQmeYwQKIFpxK+dC3uLfD0Z4o7wlT6vX+4=;
        b=Q681m3sppKcU1tOLbLTpr/tUEVRQLMd+24l9VaoX01t+wS+Ap3SOsCZ+zKhN5Huzx4
         quXRCi3fxg8L1hcglbEHTqZGQ3WI64chkNtDC2MJvu2Rr/RzYLIp057iIvzG0nzPnShH
         VcK4igHo9nrSWXQFp/7dEsh7Jwo2TLxClW4KSzDvQOKVCs/YPnkDvk24+AcTARlvudo1
         yt1Bpa3hhEhP3Pp7DAKkP1IqMfBRxN+C/IPNSmFwy5r8PBA4PFUKnnRNCV6WaxhexY9J
         fOhjys/dqymoDfY3raAmnl0lO1CZ6z/UdkIIr/Hla5ErX5m5GvIu9UoefU0/ggMje9lE
         dvww==
X-Gm-Message-State: APjAAAX8PBYhsyfJsAaVHsZq6Cb7L/6LStql5tRpZkHHaK70yIs3uGsi
        kirJym9gwdQoj1kHC5ozm0g=
X-Google-Smtp-Source: APXvYqyZq/SD95Opxjt7kfZOwpt2K/v79gjqegEMliOez694V8RyogP/mUyuZxLIlwwiLPVepH7BfQ==
X-Received: by 2002:a7b:c04c:: with SMTP id u12mr4108650wmc.59.1557435333763;
        Thu, 09 May 2019 13:55:33 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd4:5700:98d0:1d78:ee4c:b108? (p200300EA8BD4570098D01D78EE4CB108.dip0.t-ipconnect.de. [2003:ea:8bd4:5700:98d0:1d78:ee4c:b108])
        by smtp.googlemail.com with ESMTPSA id g3sm5501471wmh.27.2019.05.09.13.55.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 13:55:33 -0700 (PDT)
Subject: Re: net: micrel: confusion about phyids used in driver
To:     =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Yuiko Oshino <yuiko.oshino@microchip.com>
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de
References: <20190509202929.wg3slwnrfhu4f6no@pengutronix.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <da599967-c423-80dd-945d-5b993c041e90@gmail.com>
Date:   Thu, 9 May 2019 22:55:29 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190509202929.wg3slwnrfhu4f6no@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09.05.2019 22:29, Uwe Kleine-König wrote:
> Hello,
> 
> I have a board here that has a KSZ8051MLL (datasheet:
> http://ww1.microchip.com/downloads/en/DeviceDoc/ksz8051mll.pdf, phyid:
> 0x0022155x) assembled. The actual phyid is 0x00221556.
> 
I think the datasheets are the source of the confusion. If the
datasheets for different chips list 0x0022155x as PHYID each, and
authors of support for additional chips don't check the existing code,
then happens what happened.
However it's not a rare exception and not Microchip-specific that
sometimes vendors use the same PHYID for different chips.

And it seems you even missed one: KSZ8795
It's a switch and the internal PHY's have id 0x00221550.

If the drivers for the respective chips are actually different then we
may change the driver to match the exact model number only.
However, if there should be a PHY with e.g. id 0x00221554 out there,
it wouldn't be supported any longer and the generic PHY driver would
be used (what may work or not).

Obviously best would be get some input from Microchip.

> When enabling the micrel driver it successfully binds and claims to have
> detected a "Micrel KSZ8031" because phyid & 0x00ffffff ==
> PHY_ID_KSZ8031 (with PHY_ID_KSZ8031 = 0x00221556). I found a datasheet
> for KSZ8021RNL and KSZ8031RNL in our collection, there the phyid is
> documented as 0x0022155x, too. (So there is a deviation between driver
> and data sheet.)
> 
> A difference between these two parts are register bits 0x16.9 and
> 0x1f.7. (I didn't check systematically and there are definitely more
> differences, for example 0x16.7 which isn't handled at all in the
> driver.)
> 
> The driver does the right thing with KSZ8051MLL for bit 0x16.9 (which is
> setting a reserved bit on KSZ8021RNL/KSZ8031RNL) and for 0x1f.7 it's the
> other way round.
> 
> To make the situation still more interesting there is another phy entry
> "Micrel KSZ8051" that has .phy_id = 0x00221550 and .phy_id_mask =
> 0x00fffff0, which just judging from the name would be the better match.
> (This isn't used however because even though it matches "Micrel KSZ8031"
> is listed before and so is preferred.) With this the handling of the
> register bit 0x16.9 isn't right for the KSZ8051MLL. (I think it would if
> ksz8051_type had .has_broadcast_disable = true.)
> 
> I'm unclear what the right approach is to fix this muddle, maybe someone
> with more insight in the driver and maybe also in possession of more
> data sheets and hardware can tell?
> 
> My impression is that it is not possible to determine all features by
> just using the phyid. Would it be sensible to not difference between
> KSZ8031 and KSZ8051 and assume that writing to a reserved register bit
> does nothing?
> 
> Best regards
> Uwe
> 
Heiner

