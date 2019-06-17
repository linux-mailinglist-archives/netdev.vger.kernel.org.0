Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4689548296
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 14:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbfFQMfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 08:35:05 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:36460 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725962AbfFQMfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 08:35:05 -0400
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5HCVDen016387;
        Mon, 17 Jun 2019 14:34:51 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=STMicroelectronics;
 bh=Bf2mCAHJCk8x6Ixnh6dSc1NHiHAHnvfKgorvDCTAyto=;
 b=fxfACKVNj9ccB9QXV/rSwNlnRBZyRuirF8gZAmOWFdFkcnq/QNamAG9mKqjxUkRygFJl
 eMmtdQLPH+8oEhDel/Onx9vbwaJx2o1EQsx0Pe6fgP0nbCHpQ4PfJzmFHGJZ1kdpo80a
 A7S7/wYgYt/BFcgUl7t7Hxg8kZ4ZIfR5WWgZZoln7Qs86Su6Yu4cT9GG8zx9BKeVrC5w
 rzsGAqNSbL4Srh7uM94Dzb3sq7sti9Kox5HCfi0kxNN4QX4IwXZphIa3p1cFIRsd0tzf
 VHT184Cw3OkzKtp3NtnbqURzo2mUDKpfcz2p1qWBBbKSZozQFJtoi6QoUZKwsqAaXc1H mg== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx08-00178001.pphosted.com with ESMTP id 2t4qjhtf0b-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT);
        Mon, 17 Jun 2019 14:34:51 +0200
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 916DE34;
        Mon, 17 Jun 2019 12:34:50 +0000 (GMT)
Received: from Webmail-eu.st.com (sfhdag3node2.st.com [10.75.127.8])
        by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 673C029CD;
        Mon, 17 Jun 2019 12:34:50 +0000 (GMT)
Received: from [10.48.0.204] (10.75.127.48) by SFHDAG3NODE2.st.com
 (10.75.127.8) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Mon, 17 Jun
 2019 14:34:49 +0200
Subject: Re: [PATCH 1/1] ARM: dts: stm32: replace rgmii mode with rgmii-id on
 stm32mp15 boards
To:     Christophe Roullier <christophe.roullier@st.com>,
        <robh@kernel.org>, <davem@davemloft.net>, <joabreu@synopsys.com>,
        <mark.rutland@arm.com>, <mcoquelin.stm32@gmail.com>,
        <peppe.cavallaro@st.com>
CC:     <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <andrew@lunn.ch>
References: <20190617085018.20352-1-christophe.roullier@st.com>
 <20190617085018.20352-2-christophe.roullier@st.com>
From:   Alexandre Torgue <alexandre.torgue@st.com>
Message-ID: <c53808dd-f1d2-2865-7d45-fa2ca875b95a@st.com>
Date:   Mon, 17 Jun 2019 14:34:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190617085018.20352-2-christophe.roullier@st.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.75.127.48]
X-ClientProxiedBy: SFHDAG2NODE3.st.com (10.75.127.6) To SFHDAG3NODE2.st.com
 (10.75.127.8)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-17_06:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christophe

On 6/17/19 10:50 AM, Christophe Roullier wrote:
> On disco and eval board, Tx and Rx delay are applied (pull-up of 4.7k
> put on VDD) so which correspond to RGMII-ID mode with internal RX and TX
> delays provided by the PHY, the MAC should not add the RX or TX delays
> in this case
> 
> Signed-off-by: Christophe Roullier <christophe.roullier@st.com>
> ---
>   arch/arm/boot/dts/stm32mp157a-dk1.dts | 2 +-
>   arch/arm/boot/dts/stm32mp157c-ev1.dts | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/stm32mp157a-dk1.dts b/arch/arm/boot/dts/stm32mp157a-dk1.dts
> index 098dbfb06b61..2c105740dfad 100644
> --- a/arch/arm/boot/dts/stm32mp157a-dk1.dts
> +++ b/arch/arm/boot/dts/stm32mp157a-dk1.dts
> @@ -51,7 +51,7 @@
>   	pinctrl-0 = <&ethernet0_rgmii_pins_a>;
>   	pinctrl-1 = <&ethernet0_rgmii_pins_sleep_a>;
>   	pinctrl-names = "default", "sleep";
> -	phy-mode = "rgmii";
> +	phy-mode = "rgmii-id";
>   	max-speed = <1000>;
>   	phy-handle = <&phy0>;
>   
> diff --git a/arch/arm/boot/dts/stm32mp157c-ev1.dts b/arch/arm/boot/dts/stm32mp157c-ev1.dts
> index b6aca40b9b90..ab1393caf799 100644
> --- a/arch/arm/boot/dts/stm32mp157c-ev1.dts
> +++ b/arch/arm/boot/dts/stm32mp157c-ev1.dts
> @@ -79,7 +79,7 @@
>   	pinctrl-0 = <&ethernet0_rgmii_pins_a>;
>   	pinctrl-1 = <&ethernet0_rgmii_pins_sleep_a>;
>   	pinctrl-names = "default", "sleep";
> -	phy-mode = "rgmii";
> +	phy-mode = "rgmii-id";
>   	max-speed = <1000>;
>   	phy-handle = <&phy0>;
>   
> 

Applied on stm32-next.

Thanks.
Alex
