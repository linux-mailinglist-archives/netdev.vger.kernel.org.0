Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 139AE1A64BD
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 11:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728141AbgDMJi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 05:38:57 -0400
Received: from mta-out1.inet.fi ([62.71.2.202]:37946 "EHLO julia1.inet.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727792AbgDMJi4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 05:38:56 -0400
X-RazorGate-Vade-Verdict: clean 0
X-RazorGate-Vade-Classification: clean
X-RazorGate-Vade: gggruggvucftvghtrhhoucdtuddrgeduhedrvdelgddulecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfupfevtfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepuffvfhfhkffffgggjggtgfesthejredttdefjeenucfhrhhomhepnfgruhhrihculfgrkhhkuhcuoehlrghurhhirdhjrghkkhhusehpphdrihhnvghtrdhfiheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeegrddvgeekrdeftddrudelheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhephhgvlhhopegludelvddrudeikedruddrudefgegnpdhinhgvthepkeegrddvgeekrdeftddrudelhedpmhgrihhlfhhrohhmpeeolhgruhhjrghkqdefsehmsghogidrihhnvghtrdhfihequceuqfffjgepkeeukffvoffkoffgpdhrtghpthhtohepoehhkhgrlhhlfigvihhtudesghhmrghilhdrtghomheqpdhrtghpthhtohepoehnvghtuggvvhesvhhgvghrrdhkvghrnhgvlhdrohhrgheq
Received: from [192.168.1.134] (84.248.30.195) by julia1.inet.fi (9.0.019.26-1) (authenticated as laujak-3)
        id 5E93CD2F0001C821; Mon, 13 Apr 2020 12:38:53 +0300
Subject: Re: NET: r8169 driver fix/enchansments
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org
References: <43733c62-7d0b-258a-93c0-93788c05e475@pp.inet.fi>
 <7e637dd4-73af-5106-90f7-1d261df06fd2@gmail.com>
From:   Lauri Jakku <lauri.jakku@pp.inet.fi>
Message-ID: <801973b1-7b7a-00cc-e228-89d94e3308b9@pp.inet.fi>
Date:   Mon, 13 Apr 2020 12:38:53 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <7e637dd4-73af-5106-90f7-1d261df06fd2@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The fix is that on 5.4 and above kernels the r8169 driver stopped working properly after kernel update, and i've
proposed identifying that is the driver loaded by checking driver id.



On 2020-04-13 02:18, Heiner Kallweit wrote:
> On 12.04.2020 14:55, Lauri Jakku wrote:
>> Hi,
>>
>>
>> I've made r8169 driver improvements & fixes, please see attachments.
>>
>>
>> --Lauri J.
>>
>>
> This mail doesn't meet a single formal criteria for a patch. I suggest
> you start here:
> https://www.kernel.org/doc/Documentation/networking/netdev-FAQ.txt
> 
> At first it would be helpful to know what you're trying to fix:
> Which issue on which kernel version?
> 
> "Added soft depency from realtec phy to libphy"
> That's completely redundant as the Realtek PHY driver has a hard
> dependency on phylib.
> 
> "u32 phydev_match = !0;"
> That's weird. Do you mean ~0 here?
> 
> Then you mix completely different things in one patch.
> 
> Best first learn about how to submit a formally correct patch series,
> and to whom it should be submitted. Once you submit such a RFC series,
> we have a basis for a discussion.
> 

-- 
Br,
Lauri J.
