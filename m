Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CABA027CEA8
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 15:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729278AbgI2NLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 09:11:51 -0400
Received: from fallback10.mail.ru ([94.100.178.50]:59484 "EHLO
        fallback10.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728367AbgI2NLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 09:11:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=inbox.ru; s=mail;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject; bh=1Gbeh7SqY7rT3UEGpCPe0p3nWax1TiQOmzTpNVejyHg=;
        b=XDIw44X3EqM9Pcv7WVXd+ocdDGQvlYan8RtyKmZyBty4DBPgdDkJl+tblSvmyvhlsvz9JU8q7Dol0xcx4ba/zwaSx3cEFjgP2xNtoxSZ39ZQAE3XVSPWaKY6o/3xW+DXEQyJD+jcO1cS6UToDSyyI3IIBfGlEkOeTjaz1iR3Cb0=;
Received: from [10.161.64.57] (port=35462 helo=smtp49.i.mail.ru)
        by fallback10.m.smailru.net with esmtp (envelope-from <fido_max@inbox.ru>)
        id 1kNFQ0-0004Q5-8w; Tue, 29 Sep 2020 16:11:44 +0300
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=inbox.ru; s=mail3;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:From:Subject:Content-Type:Content-Transfer-Encoding:To:Cc; bh=1Gbeh7SqY7rT3UEGpCPe0p3nWax1TiQOmzTpNVejyHg=;
        b=SeIu7i4mLIpHKwR7w2FQQVHmeWxfwzXx5h0Agg+y196s20GZ581iqHQTNuk0p5qK+Ss7B0ar1zBEKGyj1UYtfvN3nM+/M1YjOcbVCVZ5VSPFJJe9QHecRi06P46AevHRvWJgMKBwhwtyetDMcQ71eqy6KuuENdkeUQYOkEUKRAk=;
Received: by smtp49.i.mail.ru with esmtpa (envelope-from <fido_max@inbox.ru>)
        id 1kNFPq-0004Ot-FG; Tue, 29 Sep 2020 16:11:35 +0300
Subject: Re: [PATCH v2 devicetree 1/2] powerpc: dts: t1040: add bindings for
 Seville Ethernet switch
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, robh+dt@kernel.org,
        shawnguo@kernel.org, mpe@ellerman.id.au, devicetree@vger.kernel.org
Cc:     benh@kernel.crashing.org, paulus@samba.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, madalin.bucur@oss.nxp.com,
        radu-andrei.bulie@nxp.com
References: <20200929113209.3767787-1-vladimir.oltean@nxp.com>
 <20200929113209.3767787-2-vladimir.oltean@nxp.com>
From:   Maxim Kochetkov <fido_max@inbox.ru>
Message-ID: <adfab73d-4073-2f9d-0bad-054ccb4b2534@inbox.ru>
Date:   Tue, 29 Sep 2020 16:12:05 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20200929113209.3767787-2-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-7564579A: 646B95376F6C166E
X-77F55803: 4F1203BC0FB41BD9943D5126A2FD5EE210091936F975AF0E64B7DFA945D92D76182A05F5380850407CFF446C489D55166B2335417BECA18F5A44BF6B3EE5A16E62FB829C0FED1BDA
X-7FA49CB5: FF5795518A3D127A4AD6D5ED66289B5278DA827A17800CE78CB87876C5D626D4EA1F7E6F0F101C67BD4B6F7A4D31EC0BCC500DACC3FED6E28638F802B75D45FF8AA50765F79006377E85B0EC44E8FD73EA1F7E6F0F101C674E70A05D1297E1BBC6CDE5D1141D2B1CA653A634B32B94EC035C7183CF53F2460BF327142CA1355A9FA2833FD35BB23D9E625A9149C048EE33AC447995A7AD18C26CFBAC0749D213D2E47CDBA5A96583BD4B6F7A4D31EC0BB23A54CFFDBC96A8389733CBF5DBD5E9D5E8D9A59859A8B68424CA1AAF98A6958941B15DA834481F9449624AB7ADAF372AE38A8E97BAFFB1D8FC6C240DEA76428AA50765F7900637664EAD4E21776A47D81D268191BDAD3DBD4B6F7A4D31EC0B7A15B7713DBEF166D81D268191BDAD3D78DA827A17800CE7744CB235B443BC28EC76A7562686271E8729DE7A884B61D135872C767BF85DA29E625A9149C048EE0A3850AC1BE2E7352686C055BC15B7FB4AD6D5ED66289B524E70A05D1297E1BB35872C767BF85DA227C277FBC8AE2E8B80B9CEB5436E71E375ECD9A6C639B01B4E70A05D1297E1BBC6867C52282FAC85D9B7C4F32B44FF57C2F2A386D11C4599BD9CCCA9EDD067B1EDA766A37F9254B7
X-C8649E89: 567D3D2427B229D254C52D9E10064720D20B9D7A9BD8640D88F9F4524E0D329BCE2B3B804975FD933675F7A8BF3FBA84
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2bioj50aJSQv4UNZbDLqL0K5aLg==
X-Mailru-Sender: 11C2EC085EDE56FA9C10FA2967F5AB24E01AC4CE101D31AD14451138C64F667DCA8D1FEBF3F5AE83EE9242D420CFEBFD3DDE9B364B0DF2891A624F84B2C74EDA4239CF2AF0A6D4F80DA7A0AF5A3A8387
X-Mras: Ok
X-7564579A: 646B95376F6C166E
X-77F55803: 6242723A09DB00B4DAC42D0CFF71F59E69E12062FB1270EB7A11868DD32E73FC68F3CF0E9FE49B69332DF44F249B4C8DEA273B3613DBCA359D52113C18D2DD517EE3D9379560A009
X-7FA49CB5: 0D63561A33F958A5030D96F8C768F745BA30EDD2CA877637D4D1A60F795BD0318941B15DA834481FA18204E546F3947CCE135D2742255B35F6B57BC7E64490618DEB871D839B7333395957E7521B51C2545D4CF71C94A83E9FA2833FD35BB23D27C277FBC8AE2E8BAA867293B0326636D2E47CDBA5A96583CDB5D6C1DA9E2EA8302FCEF25BFAB3454AD6D5ED66289B5278DA827A17800CE7EF7665EA8040F95CD32BA5DBAC0009BE395957E7521B51C20B4866841D68ED3567F23339F89546C55F5C1EE8F4F765FC80B9CEB5436E71E375ECD9A6C639B01BBD4B6F7A4D31EC0BC0CAF46E325F83A522CA9DD8327EE4930A3850AC1BE2E7352686C055BC15B7FBC4224003CC836476C0CAF46E325F83A50BF2EBBBDD9D6B0F8DB212830C5B42F72623479134186CDE6BA297DBC24807EABDAD6C7F3747799A
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2bioj50aJSQv4UNZPPxuJnJS5uQ==
X-Mailru-MI: 800
X-Mailru-Sender: A5480F10D64C9005989B929F85CCF0950E93C467E74FB7AD9ED703FFD30FD10EC8217CE68A9CF838C099ADC76E806A99D50E20E2BC48EF5A30D242760C51EA9CEAB4BC95F72C04283CDA0F3B3F5B9367
X-Mras: Ok
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reviewed-by: Maxim Kochetkov <fido_max@inbox.ru>


29.09.2020 14:32, Vladimir Oltean пишет:
> Add the description of the embedded L2 switch inside the SoC dtsi file
> for NXP T1040.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> Changes in v2:
> Make switch node disabled by default.
> 
>   arch/powerpc/boot/dts/fsl/t1040si-post.dtsi | 76 +++++++++++++++++++++
>   1 file changed, 76 insertions(+)
> 
> diff --git a/arch/powerpc/boot/dts/fsl/t1040si-post.dtsi b/arch/powerpc/boot/dts/fsl/t1040si-post.dtsi
> index 315d0557eefc..5cb90c66cd3f 100644
> --- a/arch/powerpc/boot/dts/fsl/t1040si-post.dtsi
> +++ b/arch/powerpc/boot/dts/fsl/t1040si-post.dtsi
> @@ -628,6 +628,82 @@ mdio@fd000 {
>   			status = "disabled";
>   		};
>   	};
> +
> +	seville_switch: ethernet-switch@800000 {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		compatible = "mscc,vsc9953-switch";
> +		reg = <0x800000 0x290000>;
> +		little-endian;
> +		status = "disabled";
> +
> +		ports {
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +
> +			seville_port0: port@0 {
> +				reg = <0>;
> +				status = "disabled";
> +			};
> +
> +			seville_port1: port@1 {
> +				reg = <1>;
> +				status = "disabled";
> +			};
> +
> +			seville_port2: port@2 {
> +				reg = <2>;
> +				status = "disabled";
> +			};
> +
> +			seville_port3: port@3 {
> +				reg = <3>;
> +				status = "disabled";
> +			};
> +
> +			seville_port4: port@4 {
> +				reg = <4>;
> +				status = "disabled";
> +			};
> +
> +			seville_port5: port@5 {
> +				reg = <5>;
> +				status = "disabled";
> +			};
> +
> +			seville_port6: port@6 {
> +				reg = <6>;
> +				status = "disabled";
> +			};
> +
> +			seville_port7: port@7 {
> +				reg = <7>;
> +				status = "disabled";
> +			};
> +
> +			seville_port8: port@8 {
> +				reg = <8>;
> +				phy-mode = "internal";
> +				status = "disabled";
> +
> +				fixed-link {
> +					speed = <2500>;
> +					full-duplex;
> +				};
> +			};
> +
> +			seville_port9: port@9 {
> +				reg = <9>;
> +				phy-mode = "internal";
> +				status = "disabled";
> +
> +				fixed-link {
> +					speed = <2500>;
> +					full-duplex;
> +				};
> +			};
> +		};
> +	};
>   };
>   
>   &qe {
> 
