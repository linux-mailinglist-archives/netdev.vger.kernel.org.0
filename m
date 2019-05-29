Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56DC42D461
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 05:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbfE2D70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 23:59:26 -0400
Received: from sobre.alvarezp.com ([173.230.155.94]:40892 "EHLO
        sobre.alvarezp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbfE2D7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 23:59:25 -0400
Received: from [192.168.15.65] (unknown [189.205.206.165])
        by sobre.alvarezp.com (Postfix) with ESMTPSA id 14E8321898;
        Tue, 28 May 2019 22:59:25 -0500 (CDT)
Subject: Re: PROBLEM: [1/2] Marvell 88E8040 (sky2) stopped working
To:     =?UTF-8?Q?Petr_=c5=a0tetiar?= <ynezz@true.cz>
Cc:     Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
References: <26edfbe4-3c62-184b-b4cc-3d89f21ae394@alvarezp.org>
 <20190518215802.GI63920@meh.true.cz>
 <56e0a7a9-19e7-fb60-7159-6939bd6d8a45@alvarezp.org>
From:   Octavio Alvarez <octallk1@alvarezp.org>
Message-ID: <61d96859-ad26-68d8-6f91-56e7895b04d3@alvarezp.org>
Date:   Tue, 28 May 2019 22:59:24 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <56e0a7a9-19e7-fb60-7159-6939bd6d8a45@alvarezp.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: uk-UA
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/18/19 8:22 PM, Octavio Alvarez wrote:
> Hi, Petr,
> 
>> I'm just shooting out of the blue, as I don't have currently any rational
>> explanation for that now, but could you please change the line above to
>> following:
>>
>>            if (!IS_ERR_OR_NULL(iap))
> 
> It worked! Thank you for being so quick!

Hi, Petr,

I just pulled from master and I don't see any updates for sky2.c.

What would be the next step for getting the fix into the kernel? I have 
never written a patch for the kernel before and I really don't know if 
it would break anything else or disrupt any future work.

Should I write a patch or should I let you do it? And if I do, should I 
just change IS_ERR for IS_ERR_OR_NULL for all the drivers on your 
original patch or just for the sky2?

I will be glad to help.

Thanks,
Octavio.
