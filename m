Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22DE337020
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 11:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbfFFJjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 05:39:39 -0400
Received: from mx-relay22-hz1.antispameurope.com ([94.100.132.222]:48888 "EHLO
        mx-relay22-hz1.antispameurope.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727540AbfFFJjj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 05:39:39 -0400
Received: from b2b-92-50-72-125.unitymedia.biz ([92.50.72.125]) by mx-relay22-hz1.antispameurope.com;
 Thu, 06 Jun 2019 11:39:37 +0200
Received: from [192.168.101.59] (192.168.101.59) by eks-ex.eks-engel.local
 (192.168.100.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1034.26; Thu, 6 Jun
 2019 11:39:33 +0200
Subject: Re: DSA with MV88E6321 and imx28
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>
References: <8812014c-1105-5fb6-bc20-bad0f86d33ea@eks-engel.de>
 <20190604135000.GD16951@lunn.ch>
 <854a0d9c-17a2-c502-458d-4d02a2cd90bb@eks-engel.de>
 <20190605122404.GH16951@lunn.ch>
 <414bd616-9383-073d-b3f3-6b6138c8b163@eks-engel.de>
 <20190605133102.GF19627@lunn.ch>
 <20907497-526d-67b2-c100-37047fa1f0d8@eks-engel.de>
 <20190605184724.GB19590@lunn.ch>
From:   Benjamin Beckmeyer <beb@eks-engel.de>
Message-ID: <f451fe3b-307f-fb1e-da34-8ff85a9d8243@eks-engel.de>
Date:   Thu, 6 Jun 2019 11:39:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190605184724.GB19590@lunn.ch>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [192.168.101.59]
X-ClientProxiedBy: eks-ex.eks-engel.local (192.168.100.30) To
 eks-ex.eks-engel.local (192.168.100.30)
X-cloud-security-sender: beb@eks-engel.de
X-cloud-security-recipient: netdev@vger.kernel.org
X-cloud-security-Virusscan: CLEAN
X-cloud-security-disclaimer: This E-Mail was scanned by E-Mailservice on mx-relay22-hz1.antispameurope.com with 095D811804A2
X-cloud-security-connect: b2b-92-50-72-125.unitymedia.biz[92.50.72.125], TLS=1, IP=92.50.72.125
X-cloud-security: scantime:.1706
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> I removed all phy-handle for the internal ports and in the mdio part 
>> is only port 2 and 6 by now. But the Serdes ports are still not be
>> recognized. So maybe there is still something wrong?
> What do you mean by SERDES? Do you mean they are connected to an SFP
> cage? If so, you need to add an SFP node. Take a look at
> vf610-zii-dev-rev-c.dts for an example.
>
> 	Andrew

Hey Andrew,
I've looked into the device tree. Why do they reference to i2c? We have
1x8 SFF tranceivers. Should I just add an i2c entry for it, because the 
value is required?

Now I don't have anything in the mdio part but the serdes ports are not 
recognized. Do I have to activate them in any kind? When I read the PHY
0 register of the serdes port 0 (SMI address 0xc) it is in power down mode.
Is there a problem with the mapping? Internally these serdes port PHYs are
at 0x0c and 0x0d but mapped to 0x0 and 0x1, for me this can be a reason 
why it won't be found. Is there a switch comparable to this mapping?
Maybe I'm totally wrong and misunderstanding something here?

Do you know which switch chip they use in the  vf610-zii-dev-rev-c?

Benjamin

