Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69C1D75F93
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 09:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbfGZHT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 03:19:59 -0400
Received: from mx.0dd.nl ([5.2.79.48]:58308 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725864AbfGZHT7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jul 2019 03:19:59 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id CEE665FB2B;
        Fri, 26 Jul 2019 09:19:56 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="R+SjCCX3";
        dkim-atps=neutral
Received: from www (www.vdorst.com [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id 895E21D28756;
        Fri, 26 Jul 2019 09:19:56 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com 895E21D28756
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1564125596;
        bh=+Hr304FY5Zea1KSklbNGrmwPH40tCpigRiaIOPfi1RQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R+SjCCX3t+stiSOsHLt+RuKxZavYZr5Nma3Z+T79/74SyqB1MfgGWveqiesV40IYS
         ElsHum7l9RTHy7CxUKVvWANJ7AtTThK48tui/25wjevLDn1Nuhvt6DO9NzzXqhu7yr
         Z/IKbzuLRR1V2xHdEN5sD9B48Mk2wRBF0XUAFd0+iU3UWDddaTdioFn0fq7CXEGe5N
         pxu19y0Er8Peo1tOTfkyHsf4UtsIAPa4tkTVLUfrR+i3Bw33V+6lEFA77VkyR7aLgI
         L+aMyTahXnv2g9eVEdraRm6nbA81YDxHIjBOgyGhzTXNXeWDyQdFyK/EiLSoj6eLH2
         vtWCg/nad6Zyw==
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1]) by
 www.vdorst.com (Horde Framework) with HTTPS; Fri, 26 Jul 2019 07:19:56 +0000
Date:   Fri, 26 Jul 2019 07:19:56 +0000
Message-ID: <20190726071956.Horde.s4rfuzovwXB-d3LnV0PLRc8@www.vdorst.com>
From:   =?utf-8?b?UmVuw6k=?= van Dorst <opensource@vdorst.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, frank-w@public-files.de,
        sean.wang@mediatek.com, f.fainelli@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, matthias.bgg@gmail.com,
        vivien.didelot@gmail.com, john@phrozen.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] dt-bindings: net: ethernet: Update mt7622
 docs and dts to reflect the new phylink API
References: <20190724192411.20639-1-opensource@vdorst.com>
 <20190725193123.GA32542@lunn.ch>
In-Reply-To: <20190725193123.GA32542@lunn.ch>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Andrew Lunn <andrew@lunn.ch>:

>> +	gmac0: mac@0 {
>> +		compatible = "mediatek,eth-mac";
>> +		reg = <0>;
>> +		phy-mode = "sgmii";
>> +
>> +		fixed-link {
>> +			speed = <2500>;
>> +			full-duplex;
>> +			pause;
>> +		};
>> +	};
>
> Hi René
>

Hi Andrew,

> SGMII and fixed-link is rather odd. Why do you need this combination?

BananaPi R64 has a RTL8367S 5+2-port switch, switch interfaces with  
the SOC by a
(H)SGMII and/or RGMII interface. SGMII is mainly used for the LAN ports and
RGMII for the WAN port.

I mimic the SDK software which puts SGMII interface in 2.5GBit  
fixed-link mode.
The RTL8367S switch code also put switch mac in forge 2.5GBit mode.

So this is the reason why I put a fixed-link mode here.

Greats,

René

>       Andrew



