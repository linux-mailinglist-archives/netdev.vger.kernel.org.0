Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC79636B0E5
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 11:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232520AbhDZJof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 05:44:35 -0400
Received: from regular1.263xmail.com ([211.150.70.204]:39068 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232239AbhDZJof (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 05:44:35 -0400
Received: from localhost (unknown [192.168.167.69])
        by regular1.263xmail.com (Postfix) with ESMTP id 3CBAC5F0;
        Mon, 26 Apr 2021 17:43:52 +0800 (CST)
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ADDR-CHECKED4: 1
X-ANTISPAM-LEVEL: 2
X-SKE-CHECKED: 1
X-ABS-CHECKED: 1
Received: from [172.16.12.8] (unknown [58.22.7.114])
        by smtp.263.net (postfix) whith ESMTP id P19994T140047258068736S1619430229000270_;
        Mon, 26 Apr 2021 17:43:49 +0800 (CST)
X-IP-DOMAINF: 1
X-UNIQUE-TAG: <961b36582c8993df6ca2161b3cb0b89a>
X-RL-SENDER: david.wu@rock-chips.com
X-SENDER: wdc@rock-chips.com
X-LOGIN-NAME: david.wu@rock-chips.com
X-FST-TO: kernel@collabora.com
X-RCPT-COUNT: 13
X-SENDER-IP: 58.22.7.114
X-ATTACHMENT-NUM: 0
X-System-Flag: 0
Subject: Re: [PATCH 1/3] arm64: dts: rockchip: Remove unnecessary reset in
 rk3328.dtsi
To:     Ezequiel Garcia <ezequiel@collabora.com>, netdev@vger.kernel.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org
Cc:     Jose Abreu <joabreu@synopsys.com>,
        Heiko Stuebner <heiko@sntech.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Peter Geis <pgwipeout@gmail.com>,
        Kever Yang <kever.yang@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>,
        Johan Jonker <jbx6244@gmail.com>, kernel@collabora.com
References: <20210426024118.18717-1-ezequiel@collabora.com>
From:   David Wu <david.wu@rock-chips.com>
Message-ID: <6051db67-d662-77f5-2fd9-2460c6abbe51@rock-chips.com>
Date:   Mon, 26 Apr 2021 17:43:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210426024118.18717-1-ezequiel@collabora.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ezequiel,

ÔÚ 2021/4/26 ÉÏÎç10:41, Ezequiel Garcia Ð´µÀ:
> Rockchip DWMAC glue driver uses the phy node (phy-handle)
> reset specifier, and not a "mac-phy" reset specifier.
> 
> Remove it.
> 

Well done, the "mac-phy" reset is not part of the controller. So

Reviewed-by: David Wu <david.wu@rock-chips.com>

> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> ---
>   arch/arm64/boot/dts/rockchip/rk3328.dtsi | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/boot/dts/rockchip/rk3328.dtsi b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
> index 5bab61784735..3ed69ecbcf3c 100644
> --- a/arch/arm64/boot/dts/rockchip/rk3328.dtsi
> +++ b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
> @@ -916,8 +916,8 @@ gmac2phy: ethernet@ff550000 {
>   			      "mac_clk_tx", "clk_mac_ref",
>   			      "aclk_mac", "pclk_mac",
>   			      "clk_macphy";
> -		resets = <&cru SRST_GMAC2PHY_A>, <&cru SRST_MACPHY>;
> -		reset-names = "stmmaceth", "mac-phy";
> +		resets = <&cru SRST_GMAC2PHY_A>;
> +		reset-names = "stmmaceth";
>   		phy-mode = "rmii";
>   		phy-handle = <&phy>;
>   		snps,txpbl = <0x4>;
> 


