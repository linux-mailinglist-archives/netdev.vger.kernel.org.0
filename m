Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96E3D1E184F
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 01:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387888AbgEYXqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 19:46:13 -0400
Received: from foss.arm.com ([217.140.110.172]:45246 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726437AbgEYXqN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 19:46:13 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BCA2231B;
        Mon, 25 May 2020 16:46:10 -0700 (PDT)
Received: from [192.168.122.166] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6ADA73F305;
        Mon, 25 May 2020 16:46:10 -0700 (PDT)
Subject: Re: [RFC 04/11] net: phy: Handle c22 regs presence better
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, f.fainelli@gmail.com,
        hkallweit1@gmail.com, madalin.bucur@oss.nxp.com,
        calvin.johnson@oss.nxp.com, linux-kernel@vger.kernel.org
References: <20200522213059.1535892-1-jeremy.linton@arm.com>
 <20200522213059.1535892-5-jeremy.linton@arm.com>
 <20200523183731.GZ1551@shell.armlinux.org.uk>
 <f85e4d86-ff58-0ed2-785b-c51626916140@arm.com>
 <20200525100612.GM1551@shell.armlinux.org.uk>
 <63ca13e3-11ea-3ddf-e1c7-90597d4a5f8c@arm.com>
 <20200525220614.GC768009@lunn.ch>
 <8868af66-fc1a-8ec2-ab75-123bffe2d504@arm.com>
 <20200525230732.GQ1551@shell.armlinux.org.uk>
 <20200525231255.GF768009@lunn.ch>
From:   Jeremy Linton <jeremy.linton@arm.com>
Message-ID: <73eb7471-e724-7c1c-6521-faf74607b26a@arm.com>
Date:   Mon, 25 May 2020 18:46:10 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200525231255.GF768009@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,


On 5/25/20 6:12 PM, Andrew Lunn wrote:
>> arch/powerpc/boot/dts/fsl/t4240rdb.dts: compatible = "ethernet-phy-id13e5.1002";
>> arch/powerpc/boot/dts/fsl/t4240rdb.dts: compatible = "ethernet-phy-id13e5.1002";
>> arch/powerpc/boot/dts/fsl/t4240rdb.dts: compatible = "ethernet-phy-id13e5.1002";
>> arch/powerpc/boot/dts/fsl/t4240rdb.dts: compatible = "ethernet-phy-id13e5.1002";
>> arch/powerpc/boot/dts/fsl/t2080rdb.dts: compatible = "ethernet-phy-id13e5.1002";
>> arch/powerpc/boot/dts/fsl/t2080rdb.dts: compatible = "ethernet-phy-id13e5.1002";
> 
> Hi Jeremy
> 
> You are doing this work for NXP right? Maybe you can ask them to go
> searching in the cellar and find you one of these boards?

Yes, thats a good idea. I've been talking to various parties to let me 
run this code on some of their "odd" devices.


