Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9FF727CEAC
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 15:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729723AbgI2NMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 09:12:01 -0400
Received: from fallback12.mail.ru ([94.100.179.29]:43202 "EHLO
        fallback12.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729517AbgI2NL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 09:11:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=inbox.ru; s=mail;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject; bh=+pyfKZ76bb3QooImZZFmo+wJQUm0BaznhPWIl/CqxRU=;
        b=jDMWLwuxI6tQvlLIZExnuaicNAb6n7zSf22Ij4ZKZuS0GmRCMGDewgkDC9xuokDiaa8TC11iiUxgnueImnDNszcrIQz7hIde8YLdkRYrm4DrAqCQjuwwJLjMo4HRYp8XKhimCzmzSU+qqHczVC2715wup5BqIYOvkMZMfwT3YQ4=;
Received: from [10.161.64.59] (port=37642 helo=smtp51.i.mail.ru)
        by fallback12.m.smailru.net with esmtp (envelope-from <fido_max@inbox.ru>)
        id 1kNFQ7-0008WB-14; Tue, 29 Sep 2020 16:11:51 +0300
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=inbox.ru; s=mail3;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:From:Subject:Content-Type:Content-Transfer-Encoding:To:Cc; bh=+pyfKZ76bb3QooImZZFmo+wJQUm0BaznhPWIl/CqxRU=;
        b=Cb+162Vbey3VxrHKLeuqtB0sBEInUWJhBGLWCOcF+/QFjMu2+pYj2HfpMrxVnAOq+1tUH2T5sNM5XeRaVLkxqALTnr8MuwBNYUierxPRJAmoZOCbRuC+H+C6oZ8mj3A2c6pl1WJtOzB5GyS6FL0Oy2uu9scZs5hDUw0zAiQdc14=;
Received: by smtp51.i.mail.ru with esmtpa (envelope-from <fido_max@inbox.ru>)
        id 1kNFPy-0003A6-5i; Tue, 29 Sep 2020 16:11:42 +0300
Subject: Re: [PATCH v2 devicetree 2/2] powerpc: dts: t1040rdb: add ports for
 Seville Ethernet switch
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, robh+dt@kernel.org,
        shawnguo@kernel.org, mpe@ellerman.id.au, devicetree@vger.kernel.org
Cc:     benh@kernel.crashing.org, paulus@samba.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, madalin.bucur@oss.nxp.com,
        radu-andrei.bulie@nxp.com, Vladimir Oltean <olteanv@gmail.com>
References: <20200929113209.3767787-1-vladimir.oltean@nxp.com>
 <20200929113209.3767787-3-vladimir.oltean@nxp.com>
From:   Maxim Kochetkov <fido_max@inbox.ru>
Message-ID: <87dab445-d65c-c58b-86e1-4b99b8371aeb@inbox.ru>
Date:   Tue, 29 Sep 2020 16:12:15 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20200929113209.3767787-3-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-7564579A: B8F34718100C35BD
X-77F55803: 4F1203BC0FB41BD9943D5126A2FD5EE25DA69D3EAAAEDA8F95B389EA13BD1EA1182A05F538085040F669DD0626EB9F3DF2A9EB167C9B593979AD6BD07D916EFA6D40CD569F2D26CC
X-7FA49CB5: FF5795518A3D127A4AD6D5ED66289B5278DA827A17800CE7FBB2043146276655EA1F7E6F0F101C67BD4B6F7A4D31EC0BCC500DACC3FED6E28638F802B75D45FF8AA50765F79006376AFB9B40001E44068638F802B75D45FF5571747095F342E8C7A0BC55FA0FE5FCCE334833809B29258D50A2896B2E36A920A1D074714043F1389733CBF5DBD5E913377AFFFEAFD269A417C69337E82CC2CC7F00164DA146DAFE8445B8C89999725571747095F342E8C26CFBAC0749D213D2E47CDBA5A9658359CC434672EE6371117882F4460429728AD0CFFFB425014EFE57002F862A6B6676E601842F6C81A19E625A9149C048EE4B6963042765DA4B302FCEF25BFAB3454AD6D5ED66289B5218080C068C56568E6136E347CC761E07725E5C173C3A84C3A2D5570B22232E1E76E601842F6C81A1F004C90652538430FAAB00FBE355B82D93EC92FD9297F6718AA50765F79006377F02F59195295693A7F4EDE966BC389F395957E7521B51C24C7702A67D5C33162DBA43225CD8A89F616AD31D0D18CD5C57739F23D657EF2BB5C8C57E37DE458B4C7702A67D5C3316FA3894348FB808DBA1CE242F1348D5363B503F486389A921A5CC5B56E945C8DA
X-C8649E89: 366FF2574FCEA5044784A2023E002B7F0DD4D692378DFD17B8EAED530CDE420B10981C49ECB2721853D1E4615FF28C47
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2bioj50aJSQv4UNbHThM/p2aLYg==
X-Mailru-Sender: 11C2EC085EDE56FA9C10FA2967F5AB24E310B95A1118BD500857F376522F8C4ED1BD0FA3B151CBA9EE9242D420CFEBFD3DDE9B364B0DF2891A624F84B2C74EDA4239CF2AF0A6D4F80DA7A0AF5A3A8387
X-Mras: Ok
X-7564579A: 646B95376F6C166E
X-77F55803: 6242723A09DB00B4DAC42D0CFF71F59E69E12062FB1270EB7A11868DD32E73FC68F3CF0E9FE49B69332DF44F249B4C8D0593527A0CDF215E8224AEB496AEE4FBDCC19DF8F6BB2258
X-7FA49CB5: 0D63561A33F958A5F55CBEAD2A696AE70205047050B354BB45A75973B56231AD8941B15DA834481FA18204E546F3947C0A6B3CD6EB70C818117882F4460429724CE54428C33FAD30A8DF7F3B2552694A4A5EC4583E1CDF108941B15DA834481F8AA50765F7900637F6B57BC7E6449061A352F6E88A58FB8646FD315363EB3597BA3038C0950A5D3613377AFFFEAFD269176DF2183F8FC7C095DF794CB3055A917B076A6E789B0E97A8DF7F3B2552694AFAAB00FBE355B82D93EC92FD9297F6718AA50765F79006377F02F59195295693A7F4EDE966BC389F395957E7521B51C24C7702A67D5C33162DBA43225CD8A89F616AD31D0D18CD5C57739F23D657EF2BB5C8C57E37DE458B4C7702A67D5C3316FA3894348FB808DBA1CE242F1348D5363B503F486389A921A5CC5B56E945C8DA
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2bioj50aJSQv4UNbBTDIGgAlx1A==
X-Mailru-MI: 800
X-Mailru-Sender: A5480F10D64C9005F4843EF15D8AD6F858705279DDE988080C65FC021D43AB1E199531D441672C9AC099ADC76E806A99D50E20E2BC48EF5A30D242760C51EA9CEAB4BC95F72C04283CDA0F3B3F5B9367
X-Mras: Ok
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reviewed-by: Maxim Kochetkov <fido_max@inbox.ru>


29.09.2020 14:32, Vladimir Oltean пишет:
> From: Vladimir Oltean <olteanv@gmail.com>
> 
> Define the network interface names for the switch ports and hook them up
> to the 2 QSGMII PHYs that are onboard.
> 
> A conscious decision was taken to go along with the numbers that are
> written on the front panel of the board and not with the hardware
> numbers of the switch chip ports. The 2 numbering schemes are
> shifted by 8.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> Changes in v2:
> Use the existing way of accessing the mdio bus and not labels.
> 
>   arch/powerpc/boot/dts/fsl/t1040rdb.dts | 115 +++++++++++++++++++++++++
>   1 file changed, 115 insertions(+)
> 
> diff --git a/arch/powerpc/boot/dts/fsl/t1040rdb.dts b/arch/powerpc/boot/dts/fsl/t1040rdb.dts
> index 65ff34c49025..3fd08a2b6dcb 100644
> --- a/arch/powerpc/boot/dts/fsl/t1040rdb.dts
> +++ b/arch/powerpc/boot/dts/fsl/t1040rdb.dts
> @@ -64,6 +64,40 @@ mdio@fc000 {
>   				phy_sgmii_2: ethernet-phy@3 {
>   					reg = <0x03>;
>   				};
> +
> +				/* VSC8514 QSGMII PHY */
> +				phy_qsgmii_0: ethernet-phy@4 {
> +					reg = <0x4>;
> +				};
> +
> +				phy_qsgmii_1: ethernet-phy@5 {
> +					reg = <0x5>;
> +				};
> +
> +				phy_qsgmii_2: ethernet-phy@6 {
> +					reg = <0x6>;
> +				};
> +
> +				phy_qsgmii_3: ethernet-phy@7 {
> +					reg = <0x7>;
> +				};
> +
> +				/* VSC8514 QSGMII PHY */
> +				phy_qsgmii_4: ethernet-phy@8 {
> +					reg = <0x8>;
> +				};
> +
> +				phy_qsgmii_5: ethernet-phy@9 {
> +					reg = <0x9>;
> +				};
> +
> +				phy_qsgmii_6: ethernet-phy@a {
> +					reg = <0xa>;
> +				};
> +
> +				phy_qsgmii_7: ethernet-phy@b {
> +					reg = <0xb>;
> +				};
>   			};
>   		};
>   	};
> @@ -76,3 +110,84 @@ cpld@3,0 {
>   };
>   
>   #include "t1040si-post.dtsi"
> +
> +&seville_switch {
> +	status = "okay";
> +};
> +
> +&seville_port0 {
> +	managed = "in-band-status";
> +	phy-handle = <&phy_qsgmii_0>;
> +	phy-mode = "qsgmii";
> +	/* ETH4 written on chassis */
> +	label = "swp4";
> +	status = "okay";
> +};
> +
> +&seville_port1 {
> +	managed = "in-band-status";
> +	phy-handle = <&phy_qsgmii_1>;
> +	phy-mode = "qsgmii";
> +	/* ETH5 written on chassis */
> +	label = "swp5";
> +	status = "okay";
> +};
> +
> +&seville_port2 {
> +	managed = "in-band-status";
> +	phy-handle = <&phy_qsgmii_2>;
> +	phy-mode = "qsgmii";
> +	/* ETH6 written on chassis */
> +	label = "swp6";
> +	status = "okay";
> +};
> +
> +&seville_port3 {
> +	managed = "in-band-status";
> +	phy-handle = <&phy_qsgmii_3>;
> +	phy-mode = "qsgmii";
> +	/* ETH7 written on chassis */
> +	label = "swp7";
> +	status = "okay";
> +};
> +
> +&seville_port4 {
> +	managed = "in-band-status";
> +	phy-handle = <&phy_qsgmii_4>;
> +	phy-mode = "qsgmii";
> +	/* ETH8 written on chassis */
> +	label = "swp8";
> +	status = "okay";
> +};
> +
> +&seville_port5 {
> +	managed = "in-band-status";
> +	phy-handle = <&phy_qsgmii_5>;
> +	phy-mode = "qsgmii";
> +	/* ETH9 written on chassis */
> +	label = "swp9";
> +	status = "okay";
> +};
> +
> +&seville_port6 {
> +	managed = "in-band-status";
> +	phy-handle = <&phy_qsgmii_6>;
> +	phy-mode = "qsgmii";
> +	/* ETH10 written on chassis */
> +	label = "swp10";
> +	status = "okay";
> +};
> +
> +&seville_port7 {
> +	managed = "in-band-status";
> +	phy-handle = <&phy_qsgmii_7>;
> +	phy-mode = "qsgmii";
> +	/* ETH11 written on chassis */
> +	label = "swp11";
> +	status = "okay";
> +};
> +
> +&seville_port8 {
> +	ethernet = <&enet0>;
> +	status = "okay";
> +};
> 
