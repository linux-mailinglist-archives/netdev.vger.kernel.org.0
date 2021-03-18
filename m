Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65383340B0E
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 18:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbhCRRJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 13:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231918AbhCRRJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 13:09:18 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0715C06174A;
        Thu, 18 Mar 2021 10:09:17 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id v11so6331530wro.7;
        Thu, 18 Mar 2021 10:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jfBPppmZKEaOwYPVKPxjdq20YbX7kVFBgfv46nqcYC8=;
        b=jKwjDl7rn62K1CATEQcf3tS+h0alfurpVYcrO5uOTC87CEqZGUs0p44yUni5uPXov4
         xHJKEhkSXohoSHNuaTb0/kv8YtuQ7IyyQtsZcZlqaqozexcUC8YfKTuSWnMkrAwoaCAR
         0fm7pWr5pVFw67qSPNFulbinoVw5RWMvlSdmHFjgWvuMXaR4454TSSR1yZSikJrMBhMr
         I/GRM2vZTJM5aPQd+RGe5KV+TiX6bRol58YZoSHGa8LetUQIJDZuy5iSyu2pSZhl/Weo
         fAWiuXo/Y9RC4vSYCRELBvsGxNUDaAbDVYn0O0nIMZRPPfQbkkGBfj01JHeg7KUYGhYs
         4FMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jfBPppmZKEaOwYPVKPxjdq20YbX7kVFBgfv46nqcYC8=;
        b=H+ORlC7qbrjaLbgo0rloP7eB4iB5da4II+H6pFuuYe6kEBZobfIEGOCODzCd5RZqof
         nMsOOMUYfWHFrgSrkWSfToPrGyBoRc3bTIYCzqyfzilMCAHyQFNDjl0kLq5kGvKSDJL5
         UUueY8aZfHI5UV3jr14xQfGFVG+GJ29RkB40D5aCb/9n6n4n1kCrrB8cLR2ezLozDf0p
         RcdiEgafOCXNP4pnIns+z1ZpZsM9Vix9Amo/lAAE7QUH5/U7mnWyG89RhhBTiavJcaoR
         Vljm7tT7GWPa4T3/ofbfCpYG0uNU2co1kNdN3Wo6rfspn9SVGlGxJWFpNz9DbXOqFMil
         MkuA==
X-Gm-Message-State: AOAM5318KJN69VhzveamZF6pcUdTAwBCy2cTfICp/XBxinPs9u+Ccvme
        Rd2vGNPDpTAd75Z1qJRmubaRQYSM2YKoUA==
X-Google-Smtp-Source: ABdhPJyKmnnDaEvkqcDrTI2oWu4vTGEqX3hQENPkxnDXgvvZeREOqn6rb61ZRT9sPeg365ofyZwlyg==
X-Received: by 2002:a5d:640b:: with SMTP id z11mr235508wru.327.1616087356559;
        Thu, 18 Mar 2021 10:09:16 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f1f:bb00:8d2c:8cc:6c7f:1a84? (p200300ea8f1fbb008d2c08cc6c7f1a84.dip0.t-ipconnect.de. [2003:ea:8f1f:bb00:8d2c:8cc:6c7f:1a84])
        by smtp.googlemail.com with ESMTPSA id d8sm3789661wrr.35.2021.03.18.10.09.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 10:09:16 -0700 (PDT)
Subject: Re: [PATCH net-next] net: phy: at803x: remove at803x_aneg_done()
To:     Vladimir Oltean <olteanv@gmail.com>,
        Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210318142356.30702-1-michael@walle.cc>
 <411c3508-978e-4562-f1e9-33ca7e98a752@gmail.com>
 <20210318151712.7hmdaufxylyl33em@skbuf>
 <ee24b531-df8b-fa3d-c7fd-8c529ecba4c8@gmail.com>
 <ae201dadd6842f533aaa2e1440209784@walle.cc>
 <20210318170401.mvvwryi7exouyrzy@skbuf>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <c7285d14-134c-1f9b-9bd6-3343248598d5@gmail.com>
Date:   Thu, 18 Mar 2021 18:09:10 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210318170401.mvvwryi7exouyrzy@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.03.2021 18:04, Vladimir Oltean wrote:
> On Thu, Mar 18, 2021 at 05:38:13PM +0100, Michael Walle wrote:
>> Am 2021-03-18 17:21, schrieb Heiner Kallweit:
>>> On 18.03.2021 16:17, Vladimir Oltean wrote:
>>>> On Thu, Mar 18, 2021 at 03:54:00PM +0100, Heiner Kallweit wrote:
>>>>> On 18.03.2021 15:23, Michael Walle wrote:
>>>>>> at803x_aneg_done() is pretty much dead code since the patch series
>>>>>> "net: phy: improve and simplify phylib state machine" [1].
>>>>>> Remove it.
>>>>>>
>>>>>
>>>>> Well, it's not dead, it's resting .. There are few places where
>>>>> phy_aneg_done() is used. So you would need to explain:
>>>>> - why these users can't be used with this PHY driver
>>>>> - or why the aneg_done callback isn't needed here and the
>>>>>   genphy_aneg_done() fallback is sufficient
>>>>
>>>> The piece of code that Michael is removing keeps the aneg reporting as
>>>> "not done" even when the copper-side link was reported as up, but the
>>>> in-band autoneg has not finished.
>>>>
>>>> That was the _intended_ behavior when that code was introduced, and
>>>> you
>>>> have said about it:
>>>> https://www.spinics.net/lists/stable/msg389193.html
>>>>
>>>> | That's not nice from the PHY:
>>>> | It signals "link up", and if the system asks the PHY for link details,
>>>> | then it sheepishly says "well, link is *almost* up".
>>>>
>>>> If the specification of phy_aneg_done behavior does not include
>>>> in-band
>>>> autoneg (and it doesn't), then this piece of code does not belong
>>>> here.
>>>>
>>>> The fact that we can no longer trigger this code from phylib is yet
>>>> another reason why it fails at its intended (and wrong) purpose and
>>>> should be removed.
>>>>
>>> I don't argue against the change, I just think that the current commit
>>> description isn't sufficient. What you just said I would have expected
>>> in the commit description.
>>
>> I'll come up with a better one, Vladimir, may I use parts of the text
>> above?
> 
> My words aren't copyrighted, so feel free, however you might want to
> check with Heiner too for his part, you never know.
> 
I'm not paid for the content of my mails, so feel free to quote.
