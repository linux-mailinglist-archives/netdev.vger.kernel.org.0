Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF75D4A52F8
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 00:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237525AbiAaXL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 18:11:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237496AbiAaXL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 18:11:58 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB7BC061714;
        Mon, 31 Jan 2022 15:11:58 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id oa14-20020a17090b1bce00b001b61aed4a03so612913pjb.5;
        Mon, 31 Jan 2022 15:11:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=cGOS+Nyrfrva77yTD/51CrK+yFfIoEbOtxB/UrQlxFU=;
        b=LY55A26qk+XCzgxbFZskiQBuJDdUBQTyA3xeqUEzD1/C0rjwRSJQhzWGj/p6cE5dAQ
         eeI4JKrHAgeVNIdYQimNeL8w/IocVjDrRzIeuXktciq+EtH36AtR94fz24YcLpDnSrM7
         HMqEXulKzGuVaz6WPr8Afgw4HMmLb0gCQRPAElcicHgj4vxD30E+2d1C1b2Q/eyeGr31
         2FqVtE9dS+IPU7T1r5ZDI7zGScVJxdnZ8LQwmDSHjm4E/20+3yDSOg2oZqIwB5RDcbW0
         jo8XMZ/Wlr5UXKIfiUatTAnPFOEOya7sCkTwCQ+wp4MjYWrcKAoxrfeerbrmFS8UdgZ+
         CWnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cGOS+Nyrfrva77yTD/51CrK+yFfIoEbOtxB/UrQlxFU=;
        b=kFmy5iXUeI4FvMZ3nRQFTJrTG/8XrhmOfSoP517Gaal06y5l/6XW9Gc3lX0UpTqNFR
         OPJSjbAV8r2t/z3iBlLRXsmyj/teQ7LwMngXRpViZjQ7lIZ6UatxnBNYAUQtEhDisZY9
         WUyYrfH/yGIhhFnaFfMbHr53k7S3ju+wBIoIkDmgdA8bgUylHllqucdVv9Xftru6RHVV
         wnFglZ4YFh0UBflJaBN6iDB+4Inh85qcrXIyRE2nm/DB55HfOeePZOTC40+maadVkZHU
         FXlmP7T3yUMxdKv2L2WMUnkbSWONPRctfaqxKuGHnr3odzyXQkgo84QZY+k2pwTl/Rmu
         +1GA==
X-Gm-Message-State: AOAM531FH7wAMs0GhQ0jmJsCiDBoeyrbHRjEIwox1A06TqzbDE6PRA9y
        HBMhKfq7f62zs5e1gB6/fmw=
X-Google-Smtp-Source: ABdhPJxZX91M5Ns4TvGMkeNVwmqs7D2OAHaHvOFpkaAOe48cqFJGBkiw1BKC54j9eanSZyI3unxfJw==
X-Received: by 2002:a17:902:c402:: with SMTP id k2mr22697198plk.131.1643670718005;
        Mon, 31 Jan 2022 15:11:58 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id g207sm6349044pfb.21.2022.01.31.15.11.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 15:11:57 -0800 (PST)
Message-ID: <f9e160d8-09e9-46af-df7d-8f128b5eab4b@gmail.com>
Date:   Mon, 31 Jan 2022 15:11:55 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC v6 net-next 2/9] pinctrl: microchip-sgpio: allow sgpio
 driver to be used as a module
Content-Language: en-US
To:     Colin Foster <colin.foster@in-advantage.com>,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>, katie.morris@in-advantage.com
References: <20220129220221.2823127-1-colin.foster@in-advantage.com>
 <20220129220221.2823127-3-colin.foster@in-advantage.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220129220221.2823127-3-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/29/2022 2:02 PM, Colin Foster wrote:
> As the commit message suggests, this simply adds the ability to select
> SGPIO pinctrl as a module. This becomes more practical when the SGPIO
> hardware exists on an external chip, controlled indirectly by I2C or SPI.
> This commit enables that level of control.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
