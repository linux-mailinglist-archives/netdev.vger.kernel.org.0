Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E89E3AEA7
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 07:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387575AbfFJFkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 01:40:20 -0400
Received: from smtp.knology.net ([64.8.71.112]:36237 "EHLO smtp.knology.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387464AbfFJFkU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 01:40:20 -0400
X-CTCH-AV-ThreatsCount: 
X-CTCH-VOD: Unknown
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020215.5CFDED42.0028,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X_CMAE_Category: , ,
X-CNFS-Analysis: v=2.3 cv=W+dGqiek c=1 sm=1 tr=0 a=TJn/bo6x+BmUhJ5QWj0rSA==:117 a=TJn/bo6x+BmUhJ5QWj0rSA==:17 a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=KGjhK52YXX0A:10 a=N659UExz7-8A:10 a=t3LY3UrxeVQA:10 a=dq6fvYVFJ5YA:10 a=pO7Hyq7_a4YA:10 a=5Pr6cp1LAAAA:8 a=XQhPHlg2INUB7sUMFCkA:9 a=pILNOxqGKmIA:10 a=0Hlou4YPydrkO5duKyP1:22
X-CM-Score: 0
X-Scanned-by: Cloudmark Authority Engine
X-Authed-Username: YnV1c0B3b3d3YXkuY29t
X_CMAE_Category: , ,
X-CNFS-Analysis: 
X-CM-Score: 
X-Scanned-by: Cloudmark Authority Engine
Authentication-Results:  smtp01.wow.cmh.synacor.com smtp.user=buus@wowway.com; auth=pass (LOGIN)
Received: from [96.27.15.54] ([96.27.15.54:56828] helo=[192.168.1.245])
        by smtp.mail.wowway.com (envelope-from <ubuntu@hbuus.com>)
        (ecelerity 3.6.25.56547 r(Core:3.6.25.0)) with ESMTPSA (cipher=AES128-SHA) 
        id 7F/81-16479-24DEDFC5; Mon, 10 Jun 2019 01:40:18 -0400
Subject: Re: Should b44_init lead to WARN_ON in drivers/ssb/driver_gpio.c:464?
To:     Larry Finger <Larry.Finger@lwfinger.net>,
        =?UTF-8?Q?Michael_B=c3=bcsch?= <m@bues.ch>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Michael Chan <michael.chan@broadcom.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <946c86bf-7e90-a981-b9fc-757adb98adfa@hbuus.com>
 <20190609235711.481bbac9@wiggum>
 <4fdd3b06-f3f7-87e0-93be-c5d6f2bf5ab4@lwfinger.net>
From:   H Buus <ubuntu@hbuus.com>
Message-ID: <a7c07ad7-1ca2-c16d-4082-6ddc9325a20d@hbuus.com>
Date:   Mon, 10 Jun 2019 01:40:17 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <4fdd3b06-f3f7-87e0-93be-c5d6f2bf5ab4@lwfinger.net>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/9/2019 8:13 PM, Larry Finger wrote:
> On 6/9/19 4:57 PM, Michael Büsch wrote:
>> On Sun, 9 Jun 2019 17:44:10 -0400
>> H Buus <ubuntu@hbuus.com> wrote:
>>
>>> I have an old 32 bit laptop with a BCM4401-B0 100Base-TX ethernet
>>> controller. For every kernel from 4.19-rc1 going forward, I get a
>>> warning and call trace within a few seconds of start up (see dmesg
>>> snippet below). I have traced it to a specific commit (see commit
>>> below). On the face of it, I would think it is a regression, but it
>>> doesn't seem to cause a problem, since networking over ethernet is
>>> working.
>>
>>
>> This warning is not a problem. The commit just exposes a warning, that
>> has always been there.
>> I suggest we just remove the WARN_ON from ssb_gpio_init and
>> ssb_gpio_unregister.
>> I don't see a reason to throw a warning in that case.
> 
> Michael,
> 
> I agree. Do you want to prepare the patch, or should I?
> 
> Larry

Let me know if you would like me to verify a patch when/if it is
available. Since kernels 4.19 thru 5.1 are unstable on this laptop, I
would either need to test with a 4.18 or older kernel, or limit my
testing to recovery mode & verifying that the b44 module is initialized
without causing a warning & call trace. Unless I get lucky and figure
out what commit is making newer kernels unstable on this laptop.
