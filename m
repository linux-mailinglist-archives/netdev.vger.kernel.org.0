Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0573B8838B
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 21:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbfHIT53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 15:57:29 -0400
Received: from mailproxy03.manitu.net ([217.11.48.67]:44718 "EHLO
        mailproxy03.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbfHIT53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 15:57:29 -0400
X-Greylist: delayed 457 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Aug 2019 15:57:28 EDT
Received: from [10.0.30.7] (dslb-092-074-039-194.092.074.pools.vodafone-ip.de [92.74.39.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: wg@grandegger.com)
        by mailproxy03.manitu.net (Postfix) with ESMTPSA id 7BFCBD40051;
        Fri,  9 Aug 2019 21:49:49 +0200 (CEST)
Subject: Re: tcan4x5x on a Raspberry Pi
To:     "FIXED-TERM Buecheler Konstantin (ETAS-SEC/ECT-Mu)" 
        <fixed-term.Konstantin.Buecheler@escrypt.com>,
        Dan Murphy <dmurphy@ti.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <845ea24f71b74b42821c7fce20bc0476@escrypt.com>
 <d1badcdb-7635-705d-35d5-448297e8fafa@ti.com>
 <ee351bd74b764759bb0258af3651bd4a@escrypt.com>
From:   Wolfgang Grandegger <wg@grandegger.com>
Openpgp: preference=signencrypt
Autocrypt: addr=wg@grandegger.com; prefer-encrypt=mutual; keydata=
 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
 8QEfHnPzgykCs2DOOQ==
Message-ID: <09c773a9-6b50-5633-c597-dcc67e938920@grandegger.com>
Date:   Fri, 9 Aug 2019 21:49:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <ee351bd74b764759bb0258af3651bd4a@escrypt.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Konstantin,

m 09.08.19 um 18:46 schrieb FIXED-TERM Buecheler Konstantin
(ETAS-SEC/ECT-Mu):
> 
>> Konstantin
> 
>>> On 7/29/19 6:19 AM, FIXED-TERM Buecheler Konstantin (ETAS-SEC/ECT-Mu) wrote:
>>> Hi all,
>>>
>>> I am currently working on a project where I am trying to use the tcan4550 chip with a Raspberry PI 3B.
>>> I am struggling to create a working device tree overlay file for the Raspberry Pi.
>>> Has anyone here tried this already? I would appreciate any help.
> 
>> Are you using the driver from net-next?
> 
>> https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/tree/drivers/net/can/m_can
> 
> Yes, I am using the driver from net-next. 
> 
> 
>> DT documentation here
> 
>> https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/tree/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
> 
> I saw this documentation but it didn’t help much (As I said, I don’t have much experience with device trees) . My dts file currently looks like this:  
> 
> /dts-v1/;
> /plugin/;
> 
> / {
>     compatible = "brcm,bcm2835", "brcm,bcm2836", "brcm,bcm2708", "brcm,bcm2709";
>     fragment@0 {
>         target = <&spi0>;
> 	__overlay__ {
>             status = "okay";
> 	    spidev@0{
> 	        status = "disabled";
> 	    };
> 	};
>     };
> 
>     fragment@2 {
>         compatible = "bosch, m_can";
> 	target = <&spi0>;
> 	__overlay__ {
> 	    tcan4x5x: tcan4x5x@0 {
> 	             compatible = "ti,tcan4x5x";
>                           reg = <0>;
> 		#address-cells = <1>;
>                          #size-cells = <1>;
> 		spi-max-frequency = <10000000>;
>                          bosch,mram-cfg = <0x0 0 0 32 0 0 1 1>;
> 		data-ready-gpios = <&gpio 23 0>;
> 		device-wake-gpios = <&gpio 24 1>;
> 				
> 	    };		
> 	};
>     };
> };
> 
> 
> Checking dmesg I always see these errors:
> [    5.409051] tcan4x5x spi0.0: no clock found
> [    5.409064] tcan4x5x spi0.0: no CAN clock source defined
> [    5.409125] tcan4x5x spi0.0: data-ready gpio not defined
> [    5.409135] tcan4x5x spi0.0: Probe failed, err=-22
> 
> I already fixed the clock issue once by doing something like this:
> clocks = <&can0_osc>,
>               <&can0_osc>;
> clock-names = "hclk", "cclk";
> But that didn’t fix the " data-ready gpio not defined" error.
> 
> 
>> I did the development on a BeagleBone Black.

Before fiddling with the dynamic device tree, I would try to patch
normal device tree source files first.

Wolfgang
