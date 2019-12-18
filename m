Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3800C1253EB
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 21:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbfLRUyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 15:54:46 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44319 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbfLRUyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 15:54:45 -0500
Received: by mail-wr1-f68.google.com with SMTP id q10so3746216wrm.11
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 12:54:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Qiq9bAzZk96ASAHv2wH2pKZjOhYUuw0z9J/8CeLBiMo=;
        b=LddmMH8QuG6aQ1e3uZon69TroG3SAoMMXCt30FKzLkSv1k3lgmxRKKNEvSLlu8V2lp
         IvUX//X/lLeW41rBpi++RS3TFfbFp6rl61cLjF04SkymMGf2eCSEbfWCSOgCRxbw0QiB
         KvYryKH6t1i5gVT9m1qaIYgDWm2mXxuR/8Us0pLp0iqVHm1rRA6NzUc5ojWVkeXmFnHJ
         pY/ewEvMBrE2NeG4lcphkL6F5TtVkEIzYSZfKOINeong+7tV6w2aSMYKVguUmCwO3sJJ
         gtegz3sjzy/SBPjtB1T2VJQeUFk4iaHv+DFvIeu9nzERTSmfMAmiAGgiqNvEXppclwId
         0TjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Qiq9bAzZk96ASAHv2wH2pKZjOhYUuw0z9J/8CeLBiMo=;
        b=p+L4h+enAEJiRjIwARimAia9Y5HalnUVPeVuB2mgKFe4XK744q672FRmk6rwZfc8e2
         4SnyMW5Q+o0vgMM+ClHv2enFHahmHnICgvt1T7hFhqMa/9s2grHP7fBoVdRID/CTjS/v
         ecHkvdm9cfGR5lxoHZnofz/MokQ92+caiCb89zJDiEmwNGZWxXHoBNgqxW8riSDNaG/a
         Je6HN3KFKBXGyjfthNxhr0pXVBP34FdyBchBQJ0bWyLTe4xMUR5rl/Nosx8G59i/Tbp2
         yU8AtiwJvuXXl5X65nTEnVqV9+Hz5iZ3zIyHM0aK7HaGMaVOeZ6dF8Z6ogARNLffrSlH
         3dnw==
X-Gm-Message-State: APjAAAUgfTldjhXlwlnPfl8TxKVcCmBXFaE9v1EImpYdM35MdkGruq0/
        xCAzH5k6tOVVof83Gf6xIjRbxMMu
X-Google-Smtp-Source: APXvYqzaBzWZeu6kF94A4cIeU1s3wo7xSmk7eYhGpwj72itfildBUfURC9sI9G65vg02zmog6cT9Ig==
X-Received: by 2002:a5d:4e0a:: with SMTP id p10mr4929248wrt.229.1576702483309;
        Wed, 18 Dec 2019 12:54:43 -0800 (PST)
Received: from ?IPv6:2003:ea:8f4a:6300:b9f6:1ac9:d482:7fd2? (p200300EA8F4A6300B9F61AC9D4827FD2.dip0.t-ipconnect.de. [2003:ea:8f4a:6300:b9f6:1ac9:d482:7fd2])
        by smtp.googlemail.com with ESMTPSA id x18sm3905415wrr.75.2019.12.18.12.54.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Dec 2019 12:54:42 -0800 (PST)
Subject: Re: [PATCH net] net: phy: make phy_error() report which PHY has
 failed
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <E1ihCLZ-0001Vo-Nw@rmk-PC.armlinux.org.uk>
 <c96f14cd-7139-ebc7-9562-2f92d8b044fc@gmail.com>
 <20191217233436.GS25745@shell.armlinux.org.uk>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <61f23d43-1c4d-a11e-a798-c938a896ddb3@gmail.com>
Date:   Wed, 18 Dec 2019 21:54:32 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191217233436.GS25745@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.12.2019 00:34, Russell King - ARM Linux admin wrote:
> On Tue, Dec 17, 2019 at 10:41:34PM +0100, Heiner Kallweit wrote:
>> On 17.12.2019 13:53, Russell King wrote:
>>> phy_error() is called from phy_interrupt() or phy_state_machine(), and
>>> uses WARN_ON() to print a backtrace. The backtrace is not useful when
>>> reporting a PHY error.
>>>
>>> However, a system may contain multiple ethernet PHYs, and phy_error()
>>> gives no clue which one caused the problem.
>>>
>>> Replace WARN_ON() with a call to phydev_err() so that we can see which
>>> PHY had an error, and also inform the user that we are halting the PHY.
>>>
>>> Fixes: fa7b28c11bbf ("net: phy: print stack trace in phy_error")
>>> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
>>> ---
>>> There is another related problem in this area. If an error is detected
>>> while the PHY is running, phy_error() moves to PHY_HALTED state. If we
>>> try to take the network device down, then:
>>>
>>> void phy_stop(struct phy_device *phydev)
>>> {
>>>         if (!phy_is_started(phydev)) {
>>>                 WARN(1, "called from state %s\n",
>>>                      phy_state_to_str(phydev->state));
>>>                 return;
>>>         }
>>>
>>> triggers, and we never do any of the phy_stop() cleanup. I'm not sure
>>> what the best way to solve this is - introducing a PHY_ERROR state may
>>> be a solution, but I think we want some phy_is_started() sites to
>>> return true for it and others to return false.
>>>
>>> Heiner - you introduced the above warning, could you look at improving
>>> this case so we don't print a warning and taint the kernel when taking
>>> a network device down after phy_error() please?
>>>
>> I think we need both types of information:
>> - the affected PHY device
>> - the stack trace to see where the issue was triggered
> 
> Can you please explain why the stack trace is useful.  For the paths
> that are reachable, all it tells you is whether it was reached via
> the interrupt or the workqueue.
> 
> If it's via the interrupt, the rest of the backtrace beyond that is
> irrelevant.  If it's the workqueue, the backtrace doesn't go back
> very far, and doesn't tell you what operation triggered it.
> 
> If it's important to see where or why phy_error() was called, there
> are much better ways of doing that, notably passing a string into
> phy_error() to describe the actual error itself.  That would convey
> way more useful information than the backtrace does.
> 
> I have been faced with these backtraces, and they have not been at
> all useful for diagnosing the problem.
> 
"The problem" comes in two flavors:
1. The problem that caused the PHY error
2. The problem caused by the PHY error (if we decide to not
   always switch to HALTED state)

We can't do much for case 1, maybe we could add an errno argument
to phy_error(). To facilitate analyzing case 2 we'd need to change
code pieces like the following.

case a:
err = f1();
case b:
err = f2();

if (err)
	phy_error()

For my understanding: What caused the PHY error in your case(s)?
Which info would have been useful for analyzing the error?
