Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C246646A1
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 14:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbfGJM7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 08:59:49 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40442 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727411AbfGJM7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 08:59:48 -0400
Received: by mail-wm1-f65.google.com with SMTP id v19so2165483wmj.5
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 05:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=orbBb9a1qfFgN+xq6RnxCXAYQ4k3T2hPbN79oSDoD6A=;
        b=ldA8m8xwwRiTTIS2btCFnRuckdleBnwm0XHxSxB7e6PjcxARxDBKkRu1D4+dNXWC90
         Xx6zrhRq0ia6YkLp8DSATZ2dXVJZm8SanZSLVSObGjg5xd7IMke97ZvqXQ9XHFT9VSM0
         aM82zj3EEYaIRxhn9t9VvLWmJtO+xoLgor9HcivfxNEWdM1u+JDvTjxrbrZ4ZuEyHS47
         tq/Zh+CjCWXwYO084l04fe8Cf3gKWoq85+etFsYHC0ZxheKoF1reM5NpKBdeCXoFQRhN
         UqEQX79MY2jPlH+qXCfxEoXmFeCsURLx+f2Zoh4t8qUq0t6qshax95odHt/WPSoi+hAG
         6Yfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=orbBb9a1qfFgN+xq6RnxCXAYQ4k3T2hPbN79oSDoD6A=;
        b=WmUihkxSXgr4xzo0kACmh9IHtAcoAObzLb+sKgK4PmfU4QF9gARDbnMvssen6anRuy
         5CTjEW62gYmrLUu9/3sBO49YOwTpLgmXqNXDbOSoLrEN5uuvKUNKcLE+FjtoZ6ZsH0sW
         UErjHxjCyOSco6CKFuHM4Szx09iDL/VzykqlR0zwPRHthXdE+q15ZI8NGngiuGA+es1r
         lo0JO7Xz6RiZh0rIOSX4wphGLMImEff/Q7bWVrQEz7eRVnZBpOPX1vR8j/xJhuBJ1r6P
         xQX7u8N1b6c6Cmv5Jhoq+KoOGhdazToo/vrt7fsIdtzerX/u56ja65u2gJJmVB7BLr6I
         zkJA==
X-Gm-Message-State: APjAAAWO7KRneozcBUg9if9abqLWSPZcz5VZ0Y7gIr6ZbykRHFVfi2Yd
        SYBY8mM8ARx/iLvg7XKvdLdyx5SPEYA=
X-Google-Smtp-Source: APXvYqxFETRr0/i1rEqU4t0aMzwWbWuCsai3umAiF81aED1Fb7uqJiZsZ9ohbK20Rl73QCO0PePVPA==
X-Received: by 2002:a1c:6c14:: with SMTP id h20mr5690149wmc.168.1562763585316;
        Wed, 10 Jul 2019 05:59:45 -0700 (PDT)
Received: from localhost (ip-89-176-1-116.net.upcbroadband.cz. [89.176.1.116])
        by smtp.gmail.com with ESMTPSA id i18sm2130111wrp.91.2019.07.10.05.59.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 10 Jul 2019 05:59:44 -0700 (PDT)
Date:   Wed, 10 Jul 2019 14:59:43 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 06/15] ethtool: netlink bitset handling
Message-ID: <20190710125943.GC2291@nanopsycho>
References: <cover.1562067622.git.mkubecek@suse.cz>
 <cb614bebee1686293127194e8f7ced72955c7c7f.1562067622.git.mkubecek@suse.cz>
 <20190703114933.GW2250@nanopsycho>
 <20190703181851.GP20101@unicorn.suse.cz>
 <20190704080435.GF2250@nanopsycho>
 <20190704115236.GR20101@unicorn.suse.cz>
 <20190709141817.GE2301@nanopsycho.orion>
 <20190710123803.GB5700@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190710123803.GB5700@unicorn.suse.cz>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jul 10, 2019 at 02:38:03PM CEST, mkubecek@suse.cz wrote:
>On Tue, Jul 09, 2019 at 04:18:17PM +0200, Jiri Pirko wrote:
>> 
>> I understand. So how about avoid the bitfield all together and just
>> have array of either bits of strings or combinations?
>> 
>> ETHTOOL_CMD_SETTINGS_SET (U->K)
>>     ETHTOOL_A_HEADER
>>         ETHTOOL_A_DEV_NAME = "eth3"
>>     ETHTOOL_A_SETTINGS_PRIV_FLAGS
>>        ETHTOOL_A_SETTINGS_PRIV_FLAG
>>            ETHTOOL_A_FLAG_NAME = "legacy-rx"
>> 	   ETHTOOL_A_FLAG_VALUE   (NLA_FLAG)
>> 
>> or the same with index instead of string
>> 
>> ETHTOOL_CMD_SETTINGS_SET (U->K)
>>     ETHTOOL_A_HEADER
>>         ETHTOOL_A_DEV_NAME = "eth3"
>>     ETHTOOL_A_SETTINGS_PRIV_FLAGS
>>         ETHTOOL_A_SETTINGS_PRIV_FLAG
>>             ETHTOOL_A_FLAG_INDEX = 0
>>  	    ETHTOOL_A_FLAG_VALUE   (NLA_FLAG)
>> 
>> 
>> For set you can combine both when you want to set multiple bits:
>> 
>> ETHTOOL_CMD_SETTINGS_SET (U->K)
>>     ETHTOOL_A_HEADER
>>         ETHTOOL_A_DEV_NAME = "eth3"
>>     ETHTOOL_A_SETTINGS_PRIV_FLAGS
>>         ETHTOOL_A_SETTINGS_PRIV_FLAG
>>             ETHTOOL_A_FLAG_INDEX = 2
>>  	    ETHTOOL_A_FLAG_VALUE   (NLA_FLAG)
>>         ETHTOOL_A_SETTINGS_PRIV_FLAG
>>             ETHTOOL_A_FLAG_INDEX = 8
>>  	    ETHTOOL_A_FLAG_VALUE   (NLA_FLAG)
>>         ETHTOOL_A_SETTINGS_PRIV_FLAG
>>             ETHTOOL_A_FLAG_NAME = "legacy-rx"
>>  	    ETHTOOL_A_FLAG_VALUE   (NLA_FLAG)
>> 
>> 
>> For get this might be a bit bigger message:
>> 
>> ETHTOOL_CMD_SETTINGS_GET_REPLY (K->U)
>>     ETHTOOL_A_HEADER
>>         ETHTOOL_A_DEV_NAME = "eth3"
>>     ETHTOOL_A_SETTINGS_PRIV_FLAGS
>>         ETHTOOL_A_SETTINGS_PRIV_FLAG
>>             ETHTOOL_A_FLAG_INDEX = 0
>>             ETHTOOL_A_FLAG_NAME = "legacy-rx"
>>  	    ETHTOOL_A_FLAG_VALUE   (NLA_FLAG)
>>         ETHTOOL_A_SETTINGS_PRIV_FLAG
>>             ETHTOOL_A_FLAG_INDEX = 1
>>             ETHTOOL_A_FLAG_NAME = "vf-ipsec"
>>  	    ETHTOOL_A_FLAG_VALUE   (NLA_FLAG)
>>         ETHTOOL_A_SETTINGS_PRIV_FLAG
>>             ETHTOOL_A_FLAG_INDEX = 8
>>             ETHTOOL_A_FLAG_NAME = "something-else"
>>  	    ETHTOOL_A_FLAG_VALUE   (NLA_FLAG)
>
>This is perfect for "one shot" applications but not so much for long
>running ones, either "ethtool --monitor" or management or monitoring
>daemons. Repeating the names in every notification message would be
>a waste, it's much more convenient to load the strings only once and

Yeah, for those aplications, the ETHTOOL_A_FLAG_NAME could be omitted


>cache them. Even if we omit the names in notifications (and possibly the
>GET replies if client opts for it), this format still takes 12-16 bytes
>per bit.
>
>So the problem I'm trying to address is that there are two types of
>clients with very different mode of work and different preferences.
>
>Looking at the bitset.c, I would rather say that most of the complexity
>and ugliness comes from dealing with both unsigned long based bitmaps
>and u32 based ones. Originally, there were functions working with
>unsigned long based bitmaps and the variants with "32" suffix were
>wrappers around them which converted u32 bitmaps to unsigned long ones
>and back. This became a problem when kernel started issuing warnings
>about variable length arrays as getting rid of them meant two kmalloc()
>and two kfree() for each u32 bitmap operation, even if most of the
>bitmaps are in rather short in practice.
>
>Maybe the wrapper could do something like
>
>int ethnl_put_bitset32(const u32 *value, const u32 *mask,
>		       unsigned int size,  ...)
>{
>	unsigned long fixed_value[2], fixed_mask[2];
>	unsigned long *tmp_value = fixed_value;
>	unsigned long *tmp_mask = fixed_mask;
>
>	if (size > sizeof(fixed_value) * BITS_PER_BYTE) {
>		tmp_value = bitmap_alloc(size);
>		if (!tmp_value)
>			return -ENOMEM;
>		tmp_mask = bitmap_alloc(size);
>		if (!tmp_mask) {
>			kfree(tmp_value);
>			return -ENOMEM;
>		}
>	}
>
>	bitmap_from_arr32(tmp_value, value, size);
>	bitmap_from_arr32(tmp_mask, mask, size);
>	ret = ethnl_put_bitset(tmp_value, tmp_mask, size, ...);
>}
>
>This way we would make bitset.c code cleaner while avoiding allocating
>short bitmaps (which is the most common case). 

I'm primarily concerned about the uapi. Plus if the uapi approach is united
for both index and string, we can omit this whole bitset abomination...


>
>Michal
