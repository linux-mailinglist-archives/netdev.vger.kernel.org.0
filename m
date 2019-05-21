Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB20425610
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 18:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbfEUQvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 12:51:47 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:35503 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727817AbfEUQvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 12:51:46 -0400
Received: by mail-it1-f196.google.com with SMTP id u186so5806931ith.0;
        Tue, 21 May 2019 09:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FyOEggHwGzPI5qEnDbJv+1Xb8QlwlUcmzeEqPbicyUA=;
        b=u1jKMVRbtJBmfof4As6O7aK/n5DJHoN1RkBbgLPJ12GTHexL3FSA6GqhEQOEr/S+Ei
         f8WYNH3c/dVflKHHGT7VFCxbZ7oncpC1cLiaNcdxq3ye9xdkAzRa6dGP++Uu4yISItUl
         yugJX952CTJiJilOjOTgflgIZ6JX/9kgPVa0VhXBFXonGGAPd8W3PDbw62nqC9kgEE6o
         ky+KOzsretWDUqLJGFjLO22mYHbuct+WMXRb+cTY60GEA9X74bzAV2KO2TrHwtSH2Jdp
         joseLLL1BzBoqal0FoS8rs5d0D5EaOLWZtvwr/yoQAL3SRXpquKcT5qos4aVz5xaYEKA
         oLpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FyOEggHwGzPI5qEnDbJv+1Xb8QlwlUcmzeEqPbicyUA=;
        b=KDiZradTmyyDHD8ir5lBJMsAlBlgnmxwKsGOdN62CYMRGS8IvCAsJyKVbFE/b6FODQ
         sxpUBLcdjRPROWVNJ/WGhFvsjisidUCWcGBbZD9XBZaICzDZIlZR37p1WU3y5A9K8EzV
         C1EhnR1yR1CUqhM4iXIwx33uqSLFpW+T43EzEy62dIdlvpN4Ex6KSLXpv4tZnB6w89bJ
         IyiOmeB2EgX26NA/sCJK9tXWiUNFWckP8WbDF4lSnXBt/fOSX3j1+HRKk6+Ys052Erie
         DQS4mv2j5KfDtiwZhWHoxNOT7Zv2WeG34LIfX3vgTPFUQmqm4yiaTAjZwK9Vn8yhl19n
         hSaQ==
X-Gm-Message-State: APjAAAURkyGKKy/Cd4nyJAi5JN/3wE+DpK7CGq79k5bnZOWGSC2KVsys
        3jdUiQhNIXpYT07y5AQLUx666NB5Owhz0gL0pu/gnTeeQeA=
X-Google-Smtp-Source: APXvYqxamx5g6o4eRosmxSKjsEYvCnrZmu9IaKMISy6htP3zIasonmkK6/+9dhv2dSFq3k0NmtaTGn4dSxPzq1zIlcI=
X-Received: by 2002:a24:d145:: with SMTP id w66mr4482319itg.71.1558457505431;
 Tue, 21 May 2019 09:51:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190513165547.alkkgcsdelaznw6v@csclub.uwaterloo.ca>
 <CAKgT0Uf_nqZtCnHmC=-oDFz-3PuSM6=30BvJSDiAgzK062OY6w@mail.gmail.com>
 <20190514163443.glfjva3ofqcy7lbg@csclub.uwaterloo.ca> <CAKgT0UdPDyCBsShQVwwE5C8fBKkMcfS6_S5m3T7JP-So9fzVgA@mail.gmail.com>
 <20190516183407.qswotwyjwtjqfdqm@csclub.uwaterloo.ca> <20190516183705.e4zflbli7oujlbek@csclub.uwaterloo.ca>
 <CAKgT0UfSa-dM2+7xntK9tB7Zw5N8nDd3U1n4OSK0gbWbkNSKJQ@mail.gmail.com>
 <CAKgT0Ucd0s_0F5_nwqXknRngwROyuecUt+4bYzWvp1-2cNSg7g@mail.gmail.com>
 <20190517172317.amopafirjfizlgej@csclub.uwaterloo.ca> <CAKgT0UdM28pSTCsaT=TWqmQwCO44NswS0PqFLAzgs9pmn41VeQ@mail.gmail.com>
 <20190521151537.xga4aiq3gjtiif4j@csclub.uwaterloo.ca>
In-Reply-To: <20190521151537.xga4aiq3gjtiif4j@csclub.uwaterloo.ca>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 21 May 2019 09:51:33 -0700
Message-ID: <CAKgT0UfpZ-ve3Hx26gDkb+YTDHvN3=MJ7NZd2NE7ewF5g=kHHw@mail.gmail.com>
Subject: Re: [Intel-wired-lan] i40e X722 RSS problem with NAT-Traversal IPsec packets
To:     Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 21, 2019 at 8:15 AM Lennart Sorensen
<lsorense@csclub.uwaterloo.ca> wrote:
>
> On Fri, May 17, 2019 at 03:20:02PM -0700, Alexander Duyck wrote:
> > I was hoping it would work too. It seemed like it should have been the
> > answer since it definitely didn't seem right. Now it has me wondering
> > about some of the other code in the driver.
> >
> > By any chance have you run anything like DPDK on any of the X722
> > interfaces on this system recently? I ask because it occurs to me that
> > if you had and it loaded something like a custom parsing profile it
> > could cause issues similar to this.
>
> I have never used DPDK on anything.  I was hoping never to do so. :)
>
> This system has so far booted Debian (with a 4.19 kernel) and our own OS
> (which has a 4.9 kernel).
>
> > A debugging step you might try would be to revert back to my earlier
> > patch that only displayed the input mask instead of changing it. Once
> > you have done that you could look at doing a full power cycle on the
> > system by either physically disconnecting the power, or using the
> > power switch on the power supply itself if one is available. It is
> > necessary to disconnect the motherboard/NIC from power in order to
> > fully clear the global state stored in the device as it is retained
> > when the system is in standby.
> >
> > What I want to verify is if the input mask that we have ran into is
> > the natural power-on input mask of if that is something that was
> > overridden by something else. The mask change I made should be reset
> > if the system loses power, and then it will either default back to the
> > value with the 6's if that is it's natural state, or it will match
> > what I had if it was not.
> >
> > Other than that I really can't think up too much else. I suppose there
> > is the possibility of the NVM either setting up a DCB setting or
> > HREGION register causing an override that is limiting the queues to 1.
> > However, the likelihood of that should be really low.
>
> Here is the register dump after a full power off:
>
> 40e: Intel(R) Ethernet Connection XL710 Network Driver - version 2.1.7-k
> i40e: Copyright (c) 2013 - 2014 Intel Corporation.
> i40e 0000:3d:00.0: fw 3.10.52896 api 1.6 nvm 4.00 0x80001577 1.1767.0
> i40e 0000:3d:00.0: The driver for the device detected a newer version of the NVM image than expected. Please install the most recent version of the network driver.
> i40e 0000:3d:00.0: MAC address: a4:bf:01:4e:0c:87
> i40e 0000:3d:00.0: flow_type: 63 input_mask:0x0000000000004000
> i40e 0000:3d:00.0: flow_type: 46 input_mask:0x0007fff800000000
> i40e 0000:3d:00.0: flow_type: 45 input_mask:0x0007fff800000000
> i40e 0000:3d:00.0: flow_type: 44 input_mask:0x0007ffff80000000
> i40e 0000:3d:00.0: flow_type: 43 input_mask:0x0007fffe00000000
> i40e 0000:3d:00.0: flow_type: 42 input_mask:0x0007fffe00000000
> i40e 0000:3d:00.0: flow_type: 41 input_mask:0x0007fffe00000000
> i40e 0000:3d:00.0: flow_type: 40 input_mask:0x0007fffe00000000
> i40e 0000:3d:00.0: flow_type: 39 input_mask:0x0007fffe00000000
> i40e 0000:3d:00.0: flow_type: 36 input_mask:0x0006060000000000
> i40e 0000:3d:00.0: flow_type: 35 input_mask:0x0006060000000000
> i40e 0000:3d:00.0: flow_type: 34 input_mask:0x0006060780000000
> i40e 0000:3d:00.0: flow_type: 33 input_mask:0x0006060600000000
> i40e 0000:3d:00.0: flow_type: 32 input_mask:0x0006060600000000
> i40e 0000:3d:00.0: flow_type: 31 input_mask:0x0006060600000000
> i40e 0000:3d:00.0: flow_type: 30 input_mask:0x0006060600000000
> i40e 0000:3d:00.0: flow_type: 29 input_mask:0x0006060600000000
> i40e 0000:3d:00.0: Features: PF-id[0] VSIs: 34 QP: 12 TXQ: 13 RSS VxLAN Geneve VEPA
> i40e 0000:3d:00.1: fw 3.10.52896 api 1.6 nvm 4.00 0x80001577 1.1767.0
> i40e 0000:3d:00.1: The driver for the device detected a newer version of the NVM image than expected. Please install the most recent version of the network driver.
> i40e 0000:3d:00.1: MAC address: a4:bf:01:4e:0c:88
> i40e 0000:3d:00.1: flow_type: 63 input_mask:0x0000000000004000
> i40e 0000:3d:00.1: flow_type: 46 input_mask:0x0007fff800000000
> i40e 0000:3d:00.1: flow_type: 45 input_mask:0x0007fff800000000
> i40e 0000:3d:00.1: flow_type: 44 input_mask:0x0007ffff80000000
> i40e 0000:3d:00.1: flow_type: 43 input_mask:0x0007fffe00000000
> i40e 0000:3d:00.1: flow_type: 42 input_mask:0x0007fffe00000000
> i40e 0000:3d:00.1: flow_type: 41 input_mask:0x0007fffe00000000
> i40e 0000:3d:00.1: flow_type: 40 input_mask:0x0007fffe00000000
> i40e 0000:3d:00.1: flow_type: 39 input_mask:0x0007fffe00000000
> i40e 0000:3d:00.1: flow_type: 36 input_mask:0x0006060000000000
> i40e 0000:3d:00.1: flow_type: 35 input_mask:0x0006060000000000
> i40e 0000:3d:00.1: flow_type: 34 input_mask:0x0006060780000000
> i40e 0000:3d:00.1: flow_type: 33 input_mask:0x0006060600000000
> i40e 0000:3d:00.1: flow_type: 32 input_mask:0x0006060600000000
> i40e 0000:3d:00.1: flow_type: 31 input_mask:0x0006060600000000
> i40e 0000:3d:00.1: flow_type: 30 input_mask:0x0006060600000000
> i40e 0000:3d:00.1: flow_type: 29 input_mask:0x0006060600000000
> i40e 0000:3d:00.1: Features: PF-id[1] VSIs: 34 QP: 12 TXQ: 13 RSS VxLAN Geneve VEPA
> i40e 0000:3d:00.1 eth2: NIC Link is Up, 1000 Mbps Full Duplex, Flow Control: None
>
> Pretty sure that is identical to before.
>
> If I dump the registers after doing the update I see this (just did a
> reboot this time, not a power cycle):
>
> i40e: Intel(R) Ethernet Connection XL710 Network Driver - version 2.1.7-k
> i40e: Copyright (c) 2013 - 2014 Intel Corporation.
> i40e 0000:3d:00.0: fw 3.10.52896 api 1.6 nvm 4.00 0x80001577 1.1767.0
> i40e 0000:3d:00.0: The driver for the device detected a newer version of the NVM image than expected. Please install the most recent version of the network driver.
> i40e 0000:3d:00.0: MAC address: a4:bf:01:4e:0c:87
> i40e 0000:3d:00.0: flow_type: 63 input_mask:0x0000000000004000
> i40e 0000:3d:00.0: flow_type: 46 input_mask:0x0007fff800000000
> i40e 0000:3d:00.0: flow_type: 45 input_mask:0x0007fff800000000
> i40e 0000:3d:00.0: flow_type: 44 input_mask:0x0007ffff80000000
> i40e 0000:3d:00.0: flow_type: 43 input_mask:0x0007fffe00000000
> i40e 0000:3d:00.0: flow_type: 42 input_mask:0x0007fffe00000000
> i40e 0000:3d:00.0: flow_type: 41 input_mask:0x0007fffe00000000
> i40e 0000:3d:00.0: flow_type: 40 input_mask:0x0007fffe00000000
> i40e 0000:3d:00.0: flow_type: 39 input_mask:0x0007fffe00000000
> i40e 0000:3d:00.0: flow_type: 36 input_mask:0x0006060000000000
> i40e 0000:3d:00.0: flow_type: 35 input_mask:0x0006060000000000
> i40e 0000:3d:00.0: flow_type: 34 input_mask:0x0006060780000000
> i40e 0000:3d:00.0: flow_type: 33 input_mask:0x0006060600000000
> i40e 0000:3d:00.0: flow_type: 32 input_mask:0x0006060600000000
> i40e 0000:3d:00.0: flow_type: 31 input_mask:0x0006060600000000
> i40e 0000:3d:00.0: flow_type: 30 input_mask:0x0006060600000000
> i40e 0000:3d:00.0: flow_type: 29 input_mask:0x0006060600000000
> i40e 0000:3d:00.0: flow type: 36 update input mask from:0x0006060000000000, to:0x0001801800000000
> i40e 0000:3d:00.0: flow type: 35 update input mask from:0x0006060000000000, to:0x0001801800000000
> i40e 0000:3d:00.0: flow type: 34 update input mask from:0x0006060780000000, to:0x0001801f80000000
> i40e 0000:3d:00.0: flow type: 33 update input mask from:0x0006060600000000, to:0x0001801e00000000
> i40e 0000:3d:00.0: flow type: 32 update input mask from:0x0006060600000000, to:0x0001801e00000000
> i40e 0000:3d:00.0: flow type: 31 update input mask from:0x0006060600000000, to:0x0001801e00000000
> i40e 0000:3d:00.0: flow type: 30 update input mask from:0x0006060600000000, to:0x0001801e00000000
> i40e 0000:3d:00.0: flow type: 29 update input mask from:0x0006060600000000, to:0x0001801e00000000
> i40e 0000:3d:00.0: flow_type after update: 63 input_mask:0x0000000000004000
> i40e 0000:3d:00.0: flow_type after update: 46 input_mask:0x0007fff800000000
> i40e 0000:3d:00.0: flow_type after update: 45 input_mask:0x0007fff800000000
> i40e 0000:3d:00.0: flow_type after update: 44 input_mask:0x0007ffff80000000
> i40e 0000:3d:00.0: flow_type after update: 43 input_mask:0x0007fffe00000000
> i40e 0000:3d:00.0: flow_type after update: 42 input_mask:0x0007fffe00000000
> i40e 0000:3d:00.0: flow_type after update: 41 input_mask:0x0007fffe00000000
> i40e 0000:3d:00.0: flow_type after update: 40 input_mask:0x0007fffe00000000
> i40e 0000:3d:00.0: flow_type after update: 39 input_mask:0x0007fffe00000000
> i40e 0000:3d:00.0: flow_type after update: 36 input_mask:0x0001801800000000
> i40e 0000:3d:00.0: flow_type after update: 35 input_mask:0x0001801800000000
> i40e 0000:3d:00.0: flow_type after update: 34 input_mask:0x0001801f80000000
> i40e 0000:3d:00.0: flow_type after update: 33 input_mask:0x0001801e00000000
> i40e 0000:3d:00.0: flow_type after update: 32 input_mask:0x0001801e00000000
> i40e 0000:3d:00.0: flow_type after update: 31 input_mask:0x0001801e00000000
> i40e 0000:3d:00.0: flow_type after update: 30 input_mask:0x0001801e00000000
> i40e 0000:3d:00.0: flow_type after update: 29 input_mask:0x0001801e00000000
> i40e 0000:3d:00.0: Features: PF-id[0] VSIs: 34 QP: 12 TXQ: 13 RSS VxLAN Geneve VEPA
>
> So at least it appears the update did apply.
>
> --
> Len Sorensen

I think we need to narrow this down a bit more. Let's try forcing the
lookup table all to one value and see if traffic is still going to
queue 0.

Specifically what we need to is run the following command to try and
force all RSS traffic to queue 8, you can verify the result with
"ethtool -x":
ethtool -X <iface> weight 0 0 0 0 0 0 0 0 1

If that works and the IPSec traffic goes to queue 8 then we are likely
looking at some sort of input issue, either in the parsing or the
population of things like the input mask that we can then debug
further.

If traffic still goes to queue 0 then that tells us the output of the
RSS hash and lookup table are being ignored, this would imply either
some other filter is rerouting the traffic or is directing us to limit
the queue index to 0 bits.

Thanks.

- Alex
