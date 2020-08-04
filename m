Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B73D823BE3E
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 18:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729760AbgHDQij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 12:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729147AbgHDQia (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 12:38:30 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 795FCC06174A;
        Tue,  4 Aug 2020 09:38:29 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id b2so8744083qvp.9;
        Tue, 04 Aug 2020 09:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vo5CBTxynn6OI5pj/G92x3kgRqO2haV0tH8JKjkkGxQ=;
        b=oPBAZ1Z3XEyeMcetYb7Hx3O9tLIzSyyi8YhxQA6FdZhng8kx1xUqv9tA7B9boO8J7P
         VXnDbsEQez/axS9w1hh4b/eqyz3POAh41TfA+BwlKRv3WgWytKqvm8n8+shZPYOQZDuJ
         UclNz7ckC9ZO4k9GyZZNnRAKYqprvlLyDXAEwaMd4+SmEA8NazA2u0SNYKvmea+UXG0V
         Jbzj2QstWPkCiopdbE0hH9usXr8qw83QwIPwE5l7mYr2xvyciDObuWH3CQCbYV6I5haR
         agr+y0wcg4BsN2EG3LdQgbQZ9VOjC5eMWYUxjgsQCUFVC7z8v1h0Zxn4mV+Zqy305Q7B
         t4gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vo5CBTxynn6OI5pj/G92x3kgRqO2haV0tH8JKjkkGxQ=;
        b=ggFV2+tkogXBkquD9ePMaIE5FlBVtpEw/6AEdOlHgVC9JSeNdeWCbwQORqKOi3ISGR
         yT9y9RoAqszaVGx+jhietDbudJk1lqzf2CU7aYi+Gg0YiQ8ryoLkVIzwuOQa0pc4+0Hu
         mambCSQSlL4uzGGJsV8MwZCo8tCjNFoXaVp4iMUORhIROTC8+k4DmHDTczIegr//me5G
         4NyXaNscpSHj0D3eioMrqkUuvU6PuqmH9a46ad7TY/nIUt1wbNmAMl4p1skP8e7CYVZ1
         2PmXpxpUBBIO4ITFKRUW+h2UfAIKkVTylxwfu0exGmB3eI5xlsIeqGS+YuDD1A6oc3EY
         Uv0w==
X-Gm-Message-State: AOAM530CN5CNU3JLikNQKSYBeYuG5U0G4DBLcc6CelQC6radw6NgEJV8
        EIgTEkpjQc4CIc+ns75Q0VA=
X-Google-Smtp-Source: ABdhPJyTA3Hqz8Ea0WQ/6iDDJL3/EzVtXGW5gXKjTsk8vuaDOwsjhwZoQ3QcP50gwug572g+AXsemA==
X-Received: by 2002:ad4:470f:: with SMTP id k15mr22795613qvz.216.1596559106978;
        Tue, 04 Aug 2020 09:38:26 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id f31sm26567863qte.35.2020.08.04.09.38.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2020 09:38:26 -0700 (PDT)
Subject: Re: [EXT] Re: [PATCH v4 2/2] net: dsa: ocelot: Add support for QinQ
 Operation
To:     Hongbo Wang <hongbo.wang@nxp.com>,
        David Miller <davem@davemloft.net>
Cc:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Leo Li <leoyang.li@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "idosch@idosch.org" <idosch@idosch.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "nikolay@cumulusnetworks.com" <nikolay@cumulusnetworks.com>,
        "roopa@cumulusnetworks.com" <roopa@cumulusnetworks.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "ivecera@redhat.com" <ivecera@redhat.com>
References: <20200730102505.27039-1-hongbo.wang@nxp.com>
 <20200730102505.27039-3-hongbo.wang@nxp.com>
 <20200803.145843.2285407129021498421.davem@davemloft.net>
 <VI1PR04MB51039B32C580321D99B8DEE8E14A0@VI1PR04MB5103.eurprd04.prod.outlook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <2906dc1e-fe37-e9d8-984d-2630549f0462@gmail.com>
Date:   Tue, 4 Aug 2020 09:38:21 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <VI1PR04MB51039B32C580321D99B8DEE8E14A0@VI1PR04MB5103.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/3/2020 11:36 PM, Hongbo Wang wrote:
>>> +     if (vlan->proto == ETH_P_8021AD) {
>>> +             ocelot->enable_qinq = true;
>>> +             ocelot_port->qinq_mode = true;
>>> +     }
>>  ...
>>> +     if (vlan->proto == ETH_P_8021AD) {
>>> +             ocelot->enable_qinq = false;
>>> +             ocelot_port->qinq_mode = false;
>>> +     }
>>> +
>>
>> I don't understand how this can work just by using a boolean to track the
>> state.
>>
>> This won't work properly if you are handling multiple QinQ VLAN entries.
>>
>> Also, I need Andrew and Florian to review and ACK the DSA layer changes that
>> add the protocol value to the device notifier block.
> 
> Hi David,
> Thanks for reply.
> 
> When setting bridge's VLAN protocol to 802.1AD by the command "ip link set br0 type bridge vlan_protocol 802.1ad", it will call dsa_slave_vlan_rx_add(dev, proto, vid) for every port in the bridge, the parameter vid is port's pvid 1,
> if pvid's proto is 802.1AD, I will enable switch's enable_qinq, and the related port's qinq_mode,
> 
> When there are multiple QinQ VLAN entries, If one VLAN's proto is 802.1AD, I will enable switch and the related port into QinQ mode.

The enabling appears fine, the problem is the disabling, the first
802.1AD VLAN entry that gets deleted will lead to the port and switch no
longer being in QinQ mode, and this does not look intended.
-- 
Florian
