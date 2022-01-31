Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D25A54A52E1
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 00:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236986AbiAaXGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 18:06:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235258AbiAaXGI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 18:06:08 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 953C7C061714;
        Mon, 31 Jan 2022 15:06:08 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id i186so11714587pfe.0;
        Mon, 31 Jan 2022 15:06:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=v5RcyeeHHXW9j3hXHNrkcObjXy4CdCazV/xa6UgsjRk=;
        b=FuLO1unfVDoVExaEbAXmMG9VT/XrOxSzURa4tb2lWs/3zb6PQsqobF2i9HNgnVWIcZ
         6TEtH+pMj/eZ1ZbIrdxWCmJ7akU6yPujMiyI27+AQj4RgErAG05Yejjm0B5E0kINMMpJ
         PUPEIzwCcqDYsP53mzCSk2flxEPLDTCLy3MxEVCQ0Cc9Lj+h1pija49ucqBL85K5GzNB
         +3S+rtiU+gSpJFO8H2sRj80O6cuUCz0wg2mIUj1OTcnA4BKaLNG/+6h0VNq9FtPjuukX
         bBs2XgOgHjsrEldPoKWc6dxLTS0NM9vTBwwCoq1OEfeQMbBG1j/K/AyPKMobKYpDJoN4
         RmXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=v5RcyeeHHXW9j3hXHNrkcObjXy4CdCazV/xa6UgsjRk=;
        b=G4/YBZgFTSui22vivbmr5Adf+r8LymQjv/Dnwzem0y5ai9KPx76PznlKr2CWhdN5YO
         paDlJfOelPwfzN/OpF0OCsQkEAgA1NT9S3BYlp4jGS5k9D+bmiFrNWOe4RUzZ0gSnW/l
         yJXBvdqutrFntFaivxXuQGSAR6BqeurrGo0hm+xQibnubIb3zTuR9yTio53Yxln7y6wn
         Qa9dN7WBapLvo14+QGSpFSRWdNeByJQ37KIlbA4G7il2m30ussqQw0QqB7U3xglT8DBd
         DwBeQsoVQ0j5qlJZY4FTOkV3vfcKdnPCWPwLyrEt/FGIk0dW6TDIUMdR23AI6Q1uMoPv
         hOiw==
X-Gm-Message-State: AOAM532hpqGg0djmLEqHSNFW2tzemTvzcnpTKiyyA99Vkg+O8hl6hAcs
        61e4Nu7qy8cctgNJO0fTwqM=
X-Google-Smtp-Source: ABdhPJxMwfga3XoB5eRlYJq/i2A2qtV8l3tyBpCJBLUAjc8jZ8QlVgn8/0C8xDn+lZCxVhz2OOPsEQ==
X-Received: by 2002:a63:8ac9:: with SMTP id y192mr18240787pgd.409.1643670367856;
        Mon, 31 Jan 2022 15:06:07 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id gb5sm366101pjb.16.2022.01.31.15.06.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 15:06:07 -0800 (PST)
Message-ID: <7dc930c6-4ffc-0dd0-8385-d7956e7d16ff@gmail.com>
Date:   Mon, 31 Jan 2022 15:06:01 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next] net: kbuild: Don't default net vendor configs to
 y
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Einon <mark.einon@gmail.com>,
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
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Jon Mason <jdmason@kudzu.us>,
        Simon Horman <simon.horman@corigine.com>,
        Rain River <rain.1986.08.12@gmail.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>,
        Shannon Nelson <snelson@pensando.io>, drivers@pensando.io,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Jiri Pirko <jiri@resnulli.us>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Rob Herring <robh@kernel.org>, l.stelmach@samsung.com,
        rafal@milecki.pl, Edwin Peer <edwin.peer@broadcom.com>,
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
 <20220131095905.08722670@hermes.local>
 <CAMuHMdU17cBzivFm9q-VwF9EG5MX75Qct=is=F2h+Kc+VddZ4g@mail.gmail.com>
 <20220131183540.6ekn3z7tudy5ocdl@sx1>
 <30ed8220-e24d-4b40-c7a6-4b09c84f9a1f@gmail.com>
 <20220131121027.4fe3e8dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220131121027.4fe3e8dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/31/2022 12:10 PM, Jakub Kicinski wrote:
> On Mon, 31 Jan 2022 10:40:38 -0800 Florian Fainelli wrote:
>>>> And changing the defaults means all defconfigs must be updated first,
>>>> else the user's configs will end up without drivers needed.
>>>>   
>>>
>>> As I understand correctly, at least for most common net drivers, having
>>> NET_VENDOR_XYZ=y doesn't actually build anything, we have flags per
>>> module for each vendor and those are defaulted to N.
>>
>> Right, but once you start hiding NET_VENDOR_DRIVER_XYZ under a
>> NET_VENDOR_XYZ Kconfig symbol dependency, if NET_VENDOR_XYZ is not set
>> to Y, then you have no way to select NET_VENDOR_DRIVER_XYZ and so your
>> old defconfig breaks.
> 
> To be clear do we actually care about *old* configs or *def* configs?

I think we care about oldconfig but maybe less so about defconfigs which 
are in tree and can be updated.

> 
> Breaking defconfigs seems bad, but I don't think we can break
> reasonable oldconfigs at this point?

No preference either way for me, just like Richard, all of the systems I 
typically work with either require a carefully curated configuration 
file to strip out unwanted features. I do like Geert's suggestion of 
adding default ARCH_ for slightly esoteric controllers that are not 
found in off the shelf hardware.

> 
>>>> It might make sense to tune some of the defaults (i.e. change to
>>>> "default y if ARCH_*") for drivers with clear platform dependencies.
>>>>   
>>>
>>> either set hard default to 'n' or just keep it as is, anything else is just
>>> more confusion.
>>
>> Maybe the rule should go like this: any new driver vendor defaults to n,
>> and existing ones remain set to y, until we deprecate doing that and
>> switching them all off to n by 5.18?
> 
> I'd be afraid that given the work of fixing up defconfigs is
> non-trivial we may end up never switching old drivers. And then we'd
> have a semi-random soup of defaults :(

Fair enough.
-- 
Florian
