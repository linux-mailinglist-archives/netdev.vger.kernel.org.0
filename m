Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8E5445B9
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730313AbfFMQqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:46:11 -0400
Received: from mx-relay47-hz2.antispameurope.com ([94.100.136.247]:51716 "EHLO
        mx-relay47-hz2.antispameurope.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730316AbfFMFkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 01:40:35 -0400
Received: from b2b-92-50-72-125.unitymedia.biz ([92.50.72.125]) by mx-relay47-hz2.antispameurope.com;
 Thu, 13 Jun 2019 07:40:33 +0200
Received: from [192.168.101.59] (192.168.101.59) by eks-ex.eks-engel.local
 (192.168.100.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1034.26; Thu, 13 Jun
 2019 07:40:31 +0200
Subject: Re: DSA setup IMX6ULL and Marvell 88E6390 with 2 Ethernet Phys - CPU
 Port is not working
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>
References: <944bfcc1-b118-3b4a-9bd7-53e1ca85be0a@eks-engel.de>
 <20190523050909.B87FB134148@control02-haj2.antispameurope.com>
 <25a1f661-277b-e4b3-ffee-9092af6abf5d@eks-engel.de>
 <20190523124348.GB15531@lunn.ch>
From:   Benjamin Beckmeyer <beb@eks-engel.de>
Message-ID: <1a87fb7e-dfea-f5f5-904b-25204ef24f91@eks-engel.de>
Date:   Thu, 13 Jun 2019 07:40:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190523124348.GB15531@lunn.ch>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [192.168.101.59]
X-ClientProxiedBy: eks-ex.eks-engel.local (192.168.100.30) To
 eks-ex.eks-engel.local (192.168.100.30)
X-cloud-security-sender: beb@eks-engel.de
X-cloud-security-recipient: netdev@vger.kernel.org
X-cloud-security-Virusscan: CLEAN
X-cloud-security-disclaimer: This E-Mail was scanned by E-Mailservice on mx-relay47-hz2.antispameurope.com with 2A6E240324
X-cloud-security-connect: b2b-92-50-72-125.unitymedia.biz[92.50.72.125], TLS=1, IP=92.50.72.125
X-cloud-security: scantime:1.119
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> thanks for your reply. You're right, both PHYs are 10/100.
>>
>> I already added a fixed-link like this:
>>
>> 			port@0 {
>> 				reg = <0>;
>> 				label = "cpu";
>> 				ethernet = <&fec1>;
>> 				phy-mode = "rmii";
>> 				phy-handle = <&switch0phy0>;
>>                                 fixed-link {
>>                                         speed = <100>;
>>                                         full-duplex;
>>                                 };
>> 			};
>>
>> I hope you mean that with fixed-phy? But this doesn't changed anything.
> You probably have multiple issues, and it is not going to work until
> you have them all solved.
>
> You can get access to the registers etc, using patches from:
>
> https://github.com/vivien/linux.git dsa/debugfs
>
> I've only seen the external MDIO bus on the 6390 used for C45 PHYs. So
> there is a chance the driver code for C22 is broken?
>
>       Andrew
>
Hi Andrew,
after you helped me a lot with my other custom board this board is now
up and running too. 

I deleted the whole MDIO part from the device tree except the external MDIO
part (mdio1) and set up the bridge.

For both boards I haven't tested the fiber (serdes) channels but I will 
soon. When I'm running into problems with that, I will contact the mailing 
list again. 

Thanks,
Benjamin

