Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA87A490ABA
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 15:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237174AbiAQOto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 09:49:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234584AbiAQOtn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 09:49:43 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B787AC061574
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 06:49:42 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id bg19-20020a05600c3c9300b0034565e837b6so22545wmb.1
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 06:49:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Mj3mK5OPfl/rzY+bCfDg6Gw4vPpybZA6nXr1CNvc+kc=;
        b=Xkib6WUTfg47WFbMfC4KT/RAPraxCjBqRfFzucFWRkStP18wvsjOXjAqY4Bnn/xytW
         /pMDgHJYL5hEcceR5RH+N3vLqy53KyuX/GM2ojUJEhIqufIhRu9yGmyYbnShVtL0UWac
         0wmf5wNetaR2nh5jdd5kHLPklxF5m3LGyEfHl/cG3BSBqRNufKWxQjNaRF3mmX7f4HQE
         UdUHcUFMmemnqb08VYk+bBvL0Brhha4h/hTacQPKfzucmYXkTSoa9qLOz+Jc9VNUTm6I
         lsOpOduECYQn7/imTD6q6noUkYp+WXPeEvGJvPPSSuKTurEafF9ip5gGBOyplRezMbqw
         VH3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Mj3mK5OPfl/rzY+bCfDg6Gw4vPpybZA6nXr1CNvc+kc=;
        b=UX3KWQtBC09uJQdERpv2JQsQ4vmvqzJDSlAx5kkpRCtnq+lU7mi5z1iY6rEpJM7+Vh
         e/GNT/lJ7dBSY88T/vSRcaEGT1lwKw/u7KdsVZZEnDK7G7R5zYhiYeeSob817m+ebzUk
         xZqxQAKr7weZzU1csF9JIK20nZS97YMa+kfGN7ZEMh+1c4Rp1Nuy1tJytrIURvcp6lB5
         Wd3MowxUniaJ/T4zz7t6gGKxzTkn8Pc7tfD0xdSIqJy8gBavj6vB9G+z4z+Gr6PYNHe/
         5WzfGN2KcJoOnSTVZZGeYSRZxowUtHfqH4MWb0MoOMMIjdV361410CZwTNXQPSh9jhU6
         cAsw==
X-Gm-Message-State: AOAM532SoMmg7q+mx/Y0XZOKpNgZyrsKgJoayqM0aSlRloNEsb3Q6a2y
        rwxRhIKE0mk1jJ3X3rxTpPs=
X-Google-Smtp-Source: ABdhPJzfTltDkcaXzdDWUiLemWVJZz976coMW4nWmW08ChETTd7h8PUjsFA0pH264o2YOguh4SkOHg==
X-Received: by 2002:adf:ffc7:: with SMTP id x7mr18960862wrs.623.1642430981298;
        Mon, 17 Jan 2022 06:49:41 -0800 (PST)
Received: from debian64.daheim (p5b0d770d.dip0.t-ipconnect.de. [91.13.119.13])
        by smtp.gmail.com with ESMTPSA id t6sm11411564wmq.16.2022.01.17.06.49.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 06:49:40 -0800 (PST)
Received: from localhost.daheim ([127.0.0.1])
        by debian64.daheim with esmtp (Exim 4.95)
        (envelope-from <chunkeey@gmail.com>)
        id 1n9SNr-00086e-7l;
        Mon, 17 Jan 2022 15:49:40 +0100
Message-ID: <d027e5cc-f6a4-4a1b-066d-10c298472c3a@gmail.com>
Date:   Mon, 17 Jan 2022 15:49:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net,stable] phy: sfp: fix high power modules without diag
 mode
Content-Language: de-DE
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>,
        netdev@vger.kernel.org,
        =?UTF-8?B?54Wn5bGx5ZGo5LiA6YOO?= <teruyama@springboard-inc.jp>
References: <20211130073929.376942-1-bjorn@mork.no>
 <20211202175843.0210476e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YaoFkZ53m7cILdYu@shell.armlinux.org.uk>
 <YaoUW9KHyEQOt46b@shell.armlinux.org.uk>
 <d4533eb7-97c1-5eb1-011d-60b59ff7ccbb@gmail.com>
 <YeV8BwzyXuuvxvBN@shell.armlinux.org.uk>
From:   Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <YeV8BwzyXuuvxvBN@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/01/2022 15:24, Russell King (Oracle) wrote:
> On Sat, Jan 15, 2022 at 05:58:43PM +0100, Christian Lamparter wrote:
>> On 03/12/2021 13:58, Russell King (Oracle) wrote:
>>> On Fri, Dec 03, 2021 at 11:54:57AM +0000, Russell King (Oracle) wrote:
>>> [...]
>>> Thinking a little more, how about this:
>>>
>>>    drivers/net/phy/sfp.c | 25 +++++++++++++++++++++----
>>>    1 file changed, 21 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
>>> index 51a1da50c608..4c900d063b19 100644
>>> --- a/drivers/net/phy/sfp.c
>>> +++ b/drivers/net/phy/sfp.c
>>> @@ -1752,17 +1752,20 @@ static int sfp_sm_probe_for_phy(struct sfp *sfp)
>>>    static int sfp_module_parse_power(struct sfp *sfp)
>>>    {
>>>    	u32 power_mW = 1000;
>>> +	bool supports_a2;
>>>    	if (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_POWER_DECL))
>>>    		power_mW = 1500;
>>>    	if (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_HIGH_POWER_LEVEL))
>>>    		power_mW = 2000;
>>> +	supports_a2 = sfp->id.ext.sff8472_compliance !=
>>> +				SFP_SFF8472_COMPLIANCE_NONE ||
>>> +		      sfp->id.ext.diagmon & SFP_DIAGMON_DDM;
>>> +
>>>    	if (power_mW > sfp->max_power_mW) {
>>>    		/* Module power specification exceeds the allowed maximum. */
>>> -		if (sfp->id.ext.sff8472_compliance ==
>>> -			SFP_SFF8472_COMPLIANCE_NONE &&
>>> -		    !(sfp->id.ext.diagmon & SFP_DIAGMON_DDM)) {
>>> +		if (!supports_a2) {
>>>    			/* The module appears not to implement bus address
>>>    			 * 0xa2, so assume that the module powers up in the
>>>    			 * indicated mode.
>>> @@ -1779,11 +1782,24 @@ static int sfp_module_parse_power(struct sfp *sfp)
>>>    		}
>>>    	}
>>> +	if (power_mW <= 1000) {
>>> +		/* Modules below 1W do not require a power change sequence */
>>> +		return 0;
>>> +	}
>>> +
>>> +	if (!supports_a2) {
>>> +		/* The module power level is below the host maximum and the
>>> +		 * module appears not to implement bus address 0xa2, so assume
>>> +		 * that the module powers up in the indicated mode.
>>> +		 */
>>> +		return 0;
>>> +	}
>>> +
>>>    	/* If the module requires a higher power mode, but also requires
>>>    	 * an address change sequence, warn the user that the module may
>>>    	 * not be functional.
>>>    	 */
>>> -	if (sfp->id.ext.diagmon & SFP_DIAGMON_ADDRMODE && power_mW > 1000) {
>>> +	if (sfp->id.ext.diagmon & SFP_DIAGMON_ADDRMODE) {
>>>    		dev_warn(sfp->dev,
>>>    			 "Address Change Sequence not supported but module requires %u.%uW, module may not be functional\n",
>>>    			 power_mW / 1000, (power_mW / 100) % 10);
>>>
>>
>> The reporter has problems reaching you. But from what I can tell in his reply to his
>> OpenWrt Github PR:
>> <https://github.com/openwrt/openwrt/pull/4802#issuecomment-1013439827>
>>
>> your approach is working perfectly. Could you spin this up as a fully-fledged patch (backports?)
> 
> There seems to be no problem - I received an email on the 30 December
> complete with the test logs. However, that was during the holiday period
> and has been buried, so thanks for the reminder.
> 
> However, I'm confused about who the reporter and testers actually are,
> so I'm not sure who to put in the Reported-by and Tested-by fields.
>  From what I can see, Bjørn Mork <bjorn@mork.no> reported it (at least
> to mainline devs), and the fix was tested by 照山周一郎
> <teruyama@springboard-inc.jp>.
> 
> Is that correct? Thanks.
> 

 From what I know, you are correct there. 照山周一郎 posted a patch
"skip hpower setting for the module which has no revs" to fix his
issue to the OpenWrt-Devel Mailinglist on the 28th November 2021:
<https://www.mail-archive.com/openwrt-devel@lists.openwrt.org/msg60669.html>

|
|@@ -0,0 +1,12 @@
|@@ -0,0 +1,11 @@
|--- a/drivers/net/phy/sfp.c
|+++ b/drivers/net/phy/sfp.c
|@@ -1590,6 +1590,8 @@ static int sfp_module_parse_power(struct
|
| static int sfp_sm_mod_hpower(struct sfp *sfp, bool enable)
| {
|+      if (sfp->id.ext.sff8472_compliance == SFP_SFF8472_COMPLIANCE_NONE)
|+              return 0;
|       u8 val;
|       int err;

Bjørn Mork picked this up and noted:
|This looks like a workaround for a specific buggy module.  Is that
|correct?   Why not update sfp_module_parse_power() instead so you can
|skip the HPOWER state completely?  And add an appropriate warning about
|this unexpected combination of options and sff8472_compliance..."

and the thread went from there, with Bjørn Mork notifying you/upstream
about the problem because of the language barrier.

<https://www.mail-archive.com/openwrt-devel@lists.openwrt.org/msg60697.html>

| 照山周一郎 <teruy...@springboard-inc.jp> writes:
|
|> Thank you for your quick response.
|> It worked without any problems.
|
|Thanks for testing! I submitted this to netdev with a stable hint now.
|So it should end up in Linux v5.10.x, and therefore also OpenWrt, in a
|few weeks unless there are objections.

So, one could argue that both reported this in a way and 照山周一郎 tested
it on his hardware.

Cheers,
Christian (got to catch a train)
