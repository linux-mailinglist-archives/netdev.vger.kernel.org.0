Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AACA144F04B
	for <lists+netdev@lfdr.de>; Sat, 13 Nov 2021 01:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234920AbhKMAzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 19:55:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232571AbhKMAzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 19:55:43 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEFCFC061766;
        Fri, 12 Nov 2021 16:52:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:
        Subject:Sender:Reply-To:Cc:Content-ID:Content-Description;
        bh=vS9RsdabAwyFhYcmzcLUuXES/pza4Xr5axksmwSiF6U=; b=T7nGPd0G8rl6ro46O1ayFEK+tW
        NbNlQcq5WSrmJbVbdLxvT3phpR5Ki+44FESmqsUg+U1V+BUDzkYB74am5DVXKYEOPbllF3AAzPo7m
        ZoJcwxXoXXnBAftFWtEjO1+ec45lHO00j344+7CAlfYjuu40vzIsjpyK+4mdWw88WIujOW38hBw5C
        2ghFbARJbKdDl2S13o2b8AVn7l/1k2MeZ94IT/WPVe8upFNLPke1wz/k2wMa4E36zeNj3XjU4hS+1
        G/soOP9El5CzCLH9ufIsZtgFbzgBQ+2nv5/1DGTr7TzCbBRzE5m3jvp29Rn6IbYKt/3G8lg/zf2Vu
        VBY5Ecng==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mlhHn-00Bx7U-Ck; Sat, 13 Nov 2021 00:52:51 +0000
Subject: Re: [PATCH v5 6/8] leds: trigger: add hardware-phy-activity trigger
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>
References: <20211112153557.26941-1-ansuelsmth@gmail.com>
 <20211112153557.26941-7-ansuelsmth@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <ec0620e4-becd-c3c9-9006-6e04009a7b99@infradead.org>
Date:   Fri, 12 Nov 2021 16:52:50 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211112153557.26941-7-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/12/21 7:35 AM, Ansuel Smith wrote:
> diff --git a/drivers/leds/trigger/Kconfig b/drivers/leds/trigger/Kconfig
> index 18a8970bfae6..ea7b33995e8d 100644
> --- a/drivers/leds/trigger/Kconfig
> +++ b/drivers/leds/trigger/Kconfig
> @@ -162,4 +162,31 @@ config LEDS_TRIGGER_TTY
>   
>   	  When build as a module this driver will be called ledtrig-tty.
>   
> +config LEDS_TRIGGER_HARDWARE_PHY_ACTIVITY
> +	tristate "LED Trigger for PHY Activity for Hardware Controlled LED"

	                                           Hardware-controlled

> +	help
> +	  This allows LEDs to run by hardware and offloaded based on some

	                   to be run by hardware and be offloaded based on some

> +	  rules. The LED will blink or be on based on the PHY

	                            or be "on"
or:	                            or be ON
[for about the third time]

> +	  activity for example on packet receive or based on the link speed.


-- 
~Randy
