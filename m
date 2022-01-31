Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD474A4DB3
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 19:04:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237177AbiAaSEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 13:04:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbiAaSEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 13:04:50 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A4D7C061714
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 10:04:50 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id g11-20020a17090a7d0b00b001b2c12c7273so355666pjl.0
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 10:04:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=c4Q5GbHlG477GDu8eKVa3wxvGBbayrQI0q4Ora6UJKM=;
        b=tqRPGJPSBTirucVoZRcW3Pfn8BwsifiN/2zFudpAcytP87mX6mRx+Z2+R8wpSJO6rJ
         E21sG6i5x1UJi7SIERlnMvo8Jw0MLeFM6mvgDhxTj45ED5x+ylbmR3r1yaZ8mJx2fzpx
         udWsOYVxp3K/E4/g+A1Uv/ovIRjY7g5AdBlMS01qOGp/RnNoU+KHggkPTU0eVD0DU8s9
         0BeQOAnHzHWADyIK4Vu+WAIlTn0apQDnBPfgCcsWeZOXKK9/5IWZ2oh4MKVGtqnRvPWe
         5941r9GmvDJ9BaTRBHT9nHnwJ9e+INLC12aBfS+Ob2isiRQG967ObJegi9wJYUDWinQX
         qgZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=c4Q5GbHlG477GDu8eKVa3wxvGBbayrQI0q4Ora6UJKM=;
        b=LBmY/MvtZ3RliTMQBr6a5YsJWc+wKxhYtGzch9B4digF4QG4qs6v2Wq/wcLCxXIFdW
         6XPsv033eDmIppc9u9QOJeHmzbPVKtlK9X3cmiaDO8c3At3rpFGaQNI+F9cxaFrsVVQp
         +zeUttOZNXQi3fq9b4Hvuo3lJVaSYqgp1m2sPnNzu3y5TONFGPntI14D/dHE3XOEjnyq
         7ecN1J1SpRiOLXFeJ5gRQuEWXT6rHnso89WuWWohOMZKTFKh1UXG6UKiRV2rPkIt2R6K
         lYramQooXqwt/by4mAzUZHqGn5JQVq8Sp4L2Y2Rq9NDi/cIDEI7SrBzxjjpHLjoTcC3F
         8bhQ==
X-Gm-Message-State: AOAM531cmG3NNDEWtEwPszeP/jd4GW5+JowVxAS7z3OLdf5TdoG4XahO
        wBW2qY5wphmMZPcJSVmseZXaMQ==
X-Google-Smtp-Source: ABdhPJwiCZ3y7ls9K5IfS1T6T0ClceNUAK7SZtIbNYVDQUzoxeIbETevQnD06wi4x9WLSkmqa1d5tw==
X-Received: by 2002:a17:902:d2c3:: with SMTP id n3mr21984876plc.45.1643652289541;
        Mon, 31 Jan 2022 10:04:49 -0800 (PST)
Received: from [192.168.0.2] ([50.53.47.17])
        by smtp.gmail.com with ESMTPSA id y42sm19810173pfa.5.2022.01.31.10.04.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 10:04:49 -0800 (PST)
Message-ID: <e9e124b0-4ea0-e84c-cd8e-1c6ad4df9d74@pensando.io>
Date:   Mon, 31 Jan 2022 10:04:40 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH net-next] net: kbuild: Don't default net vendor configs to
 y
Content-Language: en-US
To:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Mark Einon <mark.einon@gmail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Shay Agroskin <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Chris Snook <chris.snook@gmail.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jeroen de Borst <jeroendb@google.com>,
        Catherine Sullivan <csully@google.com>,
        David Awogbemila <awogbemila@google.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Jon Mason <jdmason@kudzu.us>,
        Simon Horman <simon.horman@corigine.com>,
        Rain River <rain.1986.08.12@gmail.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>, drivers@pensando.io,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Jiri Pirko <jiri@resnulli.us>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Rob Herring <robh@kernel.org>, l.stelmach@samsung.com,
        rafal@milecki.pl, Florian Fainelli <f.fainelli@gmail.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Michael Chan <michael.chan@broadcom.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Gabriel Somlo <gsomlo@gmail.com>,
        Joel Stanley <joel@jms.id.au>, Slark Xiao <slark_xiao@163.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Liming Sun <limings@nvidia.com>,
        David Thompson <davthompson@nvidia.com>,
        Asmaa Mnebhi <asmaa@nvidia.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        Omkar Kulkarni <okulkarni@marvell.com>,
        Shai Malin <smalin@marvell.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Gary Guo <gary@garyguo.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev, intel-wired-lan@lists.osuosl.org,
        linux-hyperv@vger.kernel.org, oss-drivers@corigine.com,
        linux-renesas-soc@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com
References: <20220131172450.4905-1-saeed@kernel.org>
From:   Shannon Nelson <snelson@pensando.io>
In-Reply-To: <20220131172450.4905-1-saeed@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/31/22 9:24 AM, Saeed Mahameed wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
>
> NET_VENDOR_XYZ were defaulted to 'y' for no technical reason.
>
> Since all drivers belonging to a vendor are supposed to default to 'n',
> defaulting all vendors to 'n' shouldn't be an issue, and aligns well
> with the 'no new drivers' by default mentality.
>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
>

Is there a particular reason to change this?
Broken compiles?  Bad drivers?  Over-sized output?

sln

