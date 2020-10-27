Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C0C29C913
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 20:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1830338AbgJ0TiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 15:38:04 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:43873 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2504319AbgJ0TiD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 15:38:03 -0400
Received: by mail-lj1-f193.google.com with SMTP id d24so3107693ljg.10
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 12:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=NkVTrLYjwiqx7nHJvLva3j33YB/EaGDASWIlc2ET5KQ=;
        b=aKcwZ+7vgGewYJ+drGS5yhF0nmWyKbZfDbdTVy5/mk7zCbpGWakFs1KgJ5ypM3v4HL
         biq5xwsJTT3k7deB7vbY0SwNFv0GXdC6muZOF3McUWlkUvtfKcwp+ReP072D2s+h9UsP
         XMusjuORlp8bLp3CAzwy+vO8ZSvVzFaytGRhe545q/vVYvJmRsvqtHrEzqdttBJ43E+Q
         xB/J4WjNjhlLUZ35PJc51tr6x4nYd4G+4H+pOFKElNbPixQVZ7qsRzJITHsVoP6X6GbO
         BJYpgKBe1B73cHQpm7JyzeH+1y1gzu2+C9VKJ4aP5gsegWQ6zKGHDfsAkiHV5YI9Z7RL
         mlNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=NkVTrLYjwiqx7nHJvLva3j33YB/EaGDASWIlc2ET5KQ=;
        b=fzGlSLEwuPP8CUKh6dqD9cQw4zrPpClTFjxxnOrTs0rCrTVJvR2wH5ngv8FiaYBHGm
         2k2nzNEGlfrjeVSotpods8gc2oYsRMqe8MgRZAd2ZnnG98Do4bD2SC0GblIyKoZG7J9y
         PEANacDuk3hZ0RK9yRe2XC40U4V1uGOFvZMp/LS6+MqG6zKbcwQXaddsqqEVOt9wtJXe
         P+QtBtkcv8UV+6vN/I9raF8ir+xy9OWqaZDr6+iEz2fLbD7llgCEIweXMpv8C5yOXlQt
         kqhM4xWrnmL0OTXDSxVjAFvmc8DtqYzFHlNrZt9Iaw6HdCi7Y0WM3E1zCjf3wiL3CkSE
         ESaw==
X-Gm-Message-State: AOAM532X/vcH9knN74PJALaA+bEVgfBRPDo1LJrK6i4IqLywJXfaio1g
        HjFsldMZxiRea+xmOw530kvd3J0qJ5CFtwsE
X-Google-Smtp-Source: ABdhPJzbNJ9yduFr7yOxQMf+9HQk93pVrDugSh9Cw1h7wE0B4sNsOT1avCeEbmeL99E4Qf/wawv8aQ==
X-Received: by 2002:a05:651c:388:: with SMTP id e8mr1664175ljp.404.1603827479698;
        Tue, 27 Oct 2020 12:37:59 -0700 (PDT)
Received: from wkz-x280 (h-79-28.A259.priv.bahnhof.se. [79.136.79.28])
        by smtp.gmail.com with ESMTPSA id j12sm291463ljg.22.2020.10.27.12.37.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 12:37:58 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Marek Behun <marek.behun@nic.cz>,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] net: dsa: link aggregation support
In-Reply-To: <20201027190034.utk3kkywc54zuxfn@skbuf>
References: <20201027105117.23052-1-tobias@waldekranz.com> <20201027160530.11fc42db@nic.cz> <20201027152330.GF878328@lunn.ch> <87k0vbv84z.fsf@waldekranz.com> <20201027190034.utk3kkywc54zuxfn@skbuf>
Date:   Tue, 27 Oct 2020 20:37:58 +0100
Message-ID: <87blgnv4rt.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 21:00, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Tue, Oct 27, 2020 at 07:25:16PM +0100, Tobias Waldekranz wrote:
>> > 1) trunk user ports, with team/bonding controlling it
>> > 2) trunk DSA ports, i.e. the ports between switches in a D in DSA setup
>> > 3) trunk CPU ports.
> [...]
>> I think that (2) and (3) are essentially the same problem, i.e. creating
>> LAGs out of DSA links, be they switch-to-switch or switch-to-cpu
>> connections. I think you are correct that the CPU port can not be a
>> LAG/trunk, but I believe that limitation only applies to TO_CPU packets.
>
> Which would still be ok? They are called "slow protocol PDUs" for a reason.

Oh yes, completely agree. That was the point I was trying to make :)

>> In order for this to work on transmit, we need to add forward offloading
>> to the bridge so that we can, for example, send one FORWARD from the CPU
>> to send an ARP broadcast to swp1..4 instead of four FROM_CPUs.
>
> That surely sounds like an interesting (and tough to implement)
> optimization to increase the throughput, but why would it be _needed_
> for things to work? What's wrong with 4 FROM_CPU packets?

We have internal patches that do this, and I can confirm that it is
tough :) I really would like to figure out a way to solve this, that
would also be acceptable upstream. I have some ideas, it is on my TODO.

In a single-chip system I agree that it is not needed, the CPU can do
the load-balancing in software. But in order to have the hardware do
load-balancing on a switch-to-switch LAG, you need to send a FORWARD.

FROM_CPUs would just follow whatever is in the device mapping table. You
essentially have the inverse of the TO_CPU problem, but on Tx FROM_CPU
would make up 100% of traffic.

Other than that there are some things that, while strictly speaking
possible to do without FORWARDs, become much easier to deal with:

- Multicast routing. This is one case where performance _really_ suffers
  from having to skb_clone() to each recipient.

- Bridging between virtual interfaces and DSA ports. Typical example is
  an L2 VPN tunnel or one end of a veth pair. On FROM_CPUs, the switch
  can not perform SA learning, which means that once you bridge traffic
  from the VPN out to a DSA port, the return traffic will be classified
  as unknown unicast by the switch and be flooded everywhere.
