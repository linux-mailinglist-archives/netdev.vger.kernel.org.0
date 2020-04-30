Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5561C0701
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 21:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgD3TwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 15:52:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726782AbgD3TwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 15:52:08 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FCD8C035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 12:52:08 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 3DF3D22F43;
        Thu, 30 Apr 2020 21:52:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1588276326;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r3U6fq568lloj/2mEbbtDAjapLKLjPbMzahDzFVl1cQ=;
        b=WpS+2etVBxKFUD6r7LdosRXi98q2zxgXxap7zRhjcrUJyj1reM6HrdxJNqTp4NN6ACDqcS
        QlQJo71mVTyALsZpDEPAbTOY4j4yQXOMdmZdk6KJNSpk0VqQPn1Ls7TW6qCs/YpHJ1msDW
        Ruew1ib0bItzfi0xujqThNIPtkBTk9g=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 30 Apr 2020 21:52:06 +0200
From:   Michael Walle <michael@walle.cc>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, cphealy@gmail.com,
        davem@davemloft.net, hkallweit1@gmail.com, mkubecek@suse.cz,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 0/9] Ethernet Cable test support
In-Reply-To: <8b01b2d8-39cb-dd10-e432-86d32284e12b@gmail.com>
References: <20200425180621.1140452-1-andrew@lunn.ch>
 <20200429160213.21777-1-michael@walle.cc> <20200429163247.GC66424@lunn.ch>
 <c4363f2888192efc692e08cc1a4a9a57@walle.cc>
 <61eb35f8-3264-117d-59c2-22f0fdc36e96@gmail.com>
 <9caef9bbfaed5c75e72e083db8a552fd@walle.cc>
 <8b01b2d8-39cb-dd10-e432-86d32284e12b@gmail.com>
Message-ID: <c840c633c6ce82e80c3db3b848e29ce3@walle.cc>
X-Sender: michael@walle.cc
User-Agent: Roundcube Webmail/1.3.10
X-Spamd-Bar: +
X-Spam-Level: *
X-Rspamd-Server: web
X-Spam-Status: No, score=1.40
X-Spam-Score: 1.40
X-Rspamd-Queue-Id: 3DF3D22F43
X-Spamd-Result: default: False [1.40 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[7];
         FREEMAIL_TO(0.00)[gmail.com];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         FREEMAIL_CC(0.00)[lunn.ch,gmail.com,davemloft.net,suse.cz,vger.kernel.org];
         MID_RHS_MATCH_FROM(0.00)[];
         SUSPICIOUS_RECIPS(1.50)[]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2020-04-30 21:38, schrieb Florian Fainelli:
> On 4/30/20 12:31 PM, Michael Walle wrote:
>> Hi Florian,
>> 
>> Am 2020-04-30 20:34, schrieb Florian Fainelli:
>>> On 4/30/20 10:48 AM, Michael Walle wrote:
>>>> Hi Andrew,
>>>> 
>>>> Am 2020-04-29 18:32, schrieb Andrew Lunn:
>>>>> On Wed, Apr 29, 2020 at 06:02:13PM +0200, Michael Walle wrote:
>>>>>> Hi Andrew,
>>>>>> 
>>>>>> > Add infrastructure in ethtool and phylib support for triggering a
>>>>>> > cable test and reporting the results. The Marvell 1G PHY driver is
>>>>>> > then extended to make use of this infrastructure.
>>>>>> 
>>>>>> I'm currently trying this with the AR8031 PHY. With this PHY, you
>>>>>> have to select the pair which you want to start the test on. So
>>>>>> you'd have to start the test four times in a row for a normal
>>>>>> gigabit cable. Right now, I don't see a way how to do that
>>>>>> efficiently if there is no interrupt. One could start another test
>>>>>> in the get_status() polling if the former was completed
>>>>>> successfully. But then you'd have to wait at least four polling
>>>>>> intervals to get the final result (given a cable with four pairs).
>>>>>> 
>>>>>> Any other ideas?
>>>>> 
>>>>> Hi Michael
>>>>> 
>>>>> Nice to see some more PHYs getting support for this.
>>>>> 
>>>>> It is important that the start function returns quickly. However, 
>>>>> the
>>>>> get status function can block. So you could do all the work in the
>>>>> first call to get status, polling for completion at a faster rate,
>>>>> etc.
>>>> 
>>>> Ok. I do have one problem. TDR works fine for the AR8031 and the
>>>> BCM54140 as long as there is no link partner, i.e. open cable,
>>>> shorted pairs etc. But as soon as there is a link partner and a
>>>> link, both PHYs return garbage. As far as I understand TDR, there
>>>> must not be a link, correct? The link partner may send data or
>>>> link pulses. No how do you silence the local NIC or even the peer?
>>> 
>>> Michael do you use the enhanced cable diagnostics (ECD) or the simple
>>> cable diagnostics?
>> 
>> ECD. The registers looks exactly like the one from the Marvell PHYs,
>> which makes me wonder if both have the same building block or if one
>> imitated the registers of the other. There are subtle differences
>> like one bit in the broadcom PHY is "break link" and is self-clearing,
>> while the bit on the Marvell PHY is described as "perform diagnostics
>> on link break".
>> 
>> I don't know what simple cable diagnostics should be, I guess the
>> BCM54140 doesn't support it or its not documented. Actually, ECD
>> has very little documentation in general.
> 
> Yes, there is very little information, even internally. My 
> understanding
> is that diagnostics at run at auto-neg, so you need to break the link,
> and when the link comes back up is when you should have per-pair
> results. There are also some caveats, like the link parnter must also
> have auto-negotiation on for the diagnostics to work.

Ok, that was also my guess.

>>> Having tried to get older Broadcom PHYs to work with
>>> cable diagnostics, you need to calibrate the PHY prior to running
>>> diagnostics and you need to soft reset it.
>> 
>> What do you mean by calibrate it?
> 
> You need to tune the AFE and DSP of the PHY in order for it to report
> accurate cable lengths. I would not think that you have access to that,
> and what I got access to is not really well documented, which is why I
> have not had a chance to submit those changes yet.
> 
> How accurate are your results when there is no link?

I've only tested with a ~100m cable (or two in a row). The results were
104m to 107m.

-michael
