Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A26F37C30
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 20:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730589AbfFFSYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 14:24:31 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42629 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729214AbfFFSYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 14:24:31 -0400
Received: by mail-wr1-f66.google.com with SMTP id x17so3426373wrl.9
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 11:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+kc/xY980n/6c1A8zXn5Mmi8OZEUE6AOTMap5BFr+Tk=;
        b=u5/YAKUQInC5gv0TBr+fPjyEbb44AdSu3Ag3nqbvNr5j175cS9X4pzXgQPvAdYv48a
         y8UEb71jZIz+ru5FccWl3/AOAyNslWqEeytCLwwTdHZO+hgVHxgNNkki0XVslmkpaR2+
         udVnTLpWw5XTPbx196DQhXpFoHFjt+GO5Nl1Eea22yGzb1X+9nOPvmfD93O8zovtXGQI
         xsQf70/OCQng+65wNfd+3JBO2PsEZ377iuq7wlJTC/SvWuV+xmq1Gy/k54k0iP7e2euV
         1Ry6fT/NFhROaSiZiA08YMB8Ohf5R+1DOWJDnhviW3sqOb3wf7LW6xHO8b4VqpQQvw0Q
         pS9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+kc/xY980n/6c1A8zXn5Mmi8OZEUE6AOTMap5BFr+Tk=;
        b=qKyG0UbzGz6M9bipl7T6p6BeyX3xRYAHJuwG234iFfXvFw88vqmHbL28m7qTUAxSt5
         egR8icnI+/75+UyhCdh8jh3mHkA2sV4wDPkao1pLdf0FdxyCu0UGIFrMHusET0bxJ2sj
         nNdEyz1eVXyLnokRDUxK7PEvnZjU0w3zH2zMt2IhQ1obX5jV7CPvLCLmSXSm8sSquL9U
         oZK5VolsF9J8K5WZsSPQQp6fnBFDFSTCCYPqQsQK0Z+Gvn8bR0bzXE0uaHM7dygzHleI
         7ZJRl7O3ZDXaksZeirg3fG0xdkwd4N7Sl7kqr+oP1kMrwoypx0Z96srbU5Tmh3ruMPbk
         TwGA==
X-Gm-Message-State: APjAAAUEq8RCiOGlJ9PSVPAZgbQJv/LOpgVhMR2q0QCIeAPBmztoVCe0
        43J3KYHgE8TUSeZ87R8DgGabGEg0
X-Google-Smtp-Source: APXvYqyr7161JaIQ8z0xYmzVJi63n6sIx4+kAd7rOUiCnHzmcSS9udlZaxxVH3S850+D9f99GskOlg==
X-Received: by 2002:a5d:6144:: with SMTP id y4mr17671094wrt.84.1559845468929;
        Thu, 06 Jun 2019 11:24:28 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:8014:725:26fa:29fd? (p200300EA8BF3BD008014072526FA29FD.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:8014:725:26fa:29fd])
        by smtp.googlemail.com with ESMTPSA id h21sm2327957wmb.47.2019.06.06.11.24.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 11:24:28 -0700 (PDT)
Subject: Re: [PATCH] net: phy: marvell10g: allow PHY to probe without firmware
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     David Miller <davem@davemloft.net>, f.fainelli@gmail.com,
        netdev@vger.kernel.org
References: <E1hYTO0-0000MZ-2d@rmk-PC.armlinux.org.uk>
 <20190605.184827.1552392791102735448.davem@davemloft.net>
 <20190606075919.ysofpcpnu2rp3bh4@shell.armlinux.org.uk>
 <20190606124218.GD20899@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <16971900-e6b9-e4b7-fbf6-9ea2cdb4dc8b@gmail.com>
Date:   Thu, 6 Jun 2019 20:24:23 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190606124218.GD20899@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06.06.2019 14:42, Andrew Lunn wrote:
> On Thu, Jun 06, 2019 at 08:59:19AM +0100, Russell King - ARM Linux admin wrote:
>> On Wed, Jun 05, 2019 at 06:48:27PM -0700, David Miller wrote:
>>> From: Russell King <rmk+kernel@armlinux.org.uk>
>>> Date: Wed, 05 Jun 2019 11:43:16 +0100
>>>
>>>> +	    (state == PHY_UP || state == PHY_RESUMING)) {
>>>
>>> drivers/net/phy/marvell10g.c: In function ‘mv3310_link_change_notify’:
>>> drivers/net/phy/marvell10g.c:268:35: error: ‘PHY_RESUMING’ undeclared (first use in this function); did you mean ‘RPM_RESUMING’?
>>>       (state == PHY_UP || state == PHY_RESUMING)) {
>>>                                    ^~~~~~~~~~~~
>>>                                    RPM_RESUMING
>>> drivers/net/phy/marvell10g.c:268:35: note: each undeclared identifier is reported only once for each function it appears in
>>> At top level:
>>> drivers/net/phy/marvell10g.c:262:13: warning: ‘mv3310_link_change_notify’ defined but not used [-Wunused-function]
>>>  static void mv3310_link_change_notify(struct phy_device *phydev)
>>>              ^~~~~~~~~~~~~~~~~~~~~~~~~
>>
>> Hmm. Looks like Heiner's changes in net-next _totally_ screw this
>> approach - it's not just about PHY_RESUMING being removed, it's
>> also about the link change notifier being moved. :(
> 
> Hi Russell
> 
> The link change notifier still seems to be called, and it is still
> part of the phy_driver structure.
> 
Before my change the link change notifier didn't do what the name states.
It was an "I'm going to run the state machine now, and something may
have changed or not" callback.
Still we have state changes happening outside the state machine and
therefore not calling the link change notifier. This brings me to the
second point:
I don't like too much state changes outside control of the state machine,
like in phy_start / phy_stop / phy_error. I think it would be better
if a state change request is sent to the state machine, and the state
machine decides whether the requested transition is allowed.
But I didn't dig deep enough into a possible solution yet.

Coming to the use case of keeping the link down if the firmware isn't
loaded. I'm not sure whether the firmware is needed for all modes, or
whether e.g. basic modes like 100BaseT work also w/o firmware.
Instead of manually changing the state it may be better to remove all
modes needing the firmware from supported and advertising bitmap in
the config_init callback.
Then modes not needing the firmware can still be used, and if no mode
remains then nothing is advertised and the link stays down anyway.

> Please could you be more specific about what changes Heiner made which
> causes this patch problems?
> 
>        Thanks
> 	Andrew
> 
Heiner
