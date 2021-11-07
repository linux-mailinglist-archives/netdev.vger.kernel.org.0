Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB1F447659
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 23:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236634AbhKGWpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 17:45:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbhKGWpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Nov 2021 17:45:31 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B2A0C061570;
        Sun,  7 Nov 2021 14:42:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=4wFXo1xmBQ46BgCSApznbub4SvuTMqlvDLhvF+BDefs=; b=d2HI8nBTPgDYEgQaj4S+/bGR5I
        kaQ4LES1x3aHeDnWyOQmssZT1Aw96Kx9A2fgypE7KenldgCmZrSqEMYWHbFvHe2U5b7CfqzNokn/I
        jyQW+sjn4eFrdXcOTGeJM4z4opf6UgUaS+DwVFPRNuX1d2OikegGT2kYVaCDeoKvcww1c04jb28kO
        c/BB7ZWRcHWR6j+YxxEy7A5vaevNhnAs3vcrSWcyUrYNwEpFsodYz8zz73o4OgAgffMRw7vkY17Ww
        aNCwFaYEzj8EJePAg7Xi7r3ynm/oSnZWPNHfq7J+P4hz/eG+RfIeXxh/wKHwumTZ8Vve/AFh85W5z
        qqurPMaQ==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by merlin.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mjqs9-008esA-Eh; Sun, 07 Nov 2021 22:42:45 +0000
Subject: Re: [RFC PATCH 4/6] leds: trigger: add offload-phy-activity trigger
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
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
References: <20211107175718.9151-1-ansuelsmth@gmail.com>
 <20211107175718.9151-5-ansuelsmth@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <befc2591-b96b-bac2-3b34-73cd3599049d@infradead.org>
Date:   Sun, 7 Nov 2021 14:42:37 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211107175718.9151-5-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/7/21 9:57 AM, Ansuel Smith wrote:
> +config LEDS_OFFLOAD_TRIGGER_PHY_ACTIVITY
> +	tristate "LED Offload Trigger for PHY Activity"
> +	depends on LEDS_OFFLOAD_TRIGGERS
> +	help
> +	  This allows LEDs to be configured to run by HW and offloaded based
> +	  on some rules. The LED will blink or be on based on the PHY Activity
> +	  for example on packet receive of based on the link speed.

Cannot parse:                           of based on

> +	  The current rules are:


-- 
~Randy
