Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0983165468
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 02:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbgBTBj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 20:39:26 -0500
Received: from foss.arm.com ([217.140.110.172]:60764 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726784AbgBTBjZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 20:39:25 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1EE0031B;
        Wed, 19 Feb 2020 17:39:24 -0800 (PST)
Received: from [192.168.3.111] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BFD413F703;
        Wed, 19 Feb 2020 17:39:19 -0800 (PST)
Subject: Re: [RFC PATCH 00/11] Removing Calxeda platform support
To:     Olof Johansson <olof@lixom.net>
Cc:     Rob Herring <robh@kernel.org>,
        Linux ARM Mailing List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        SoC Team <soc@kernel.org>,
        Robert Richter <rrichter@marvell.com>,
        Jon Loeliger <jdl@jdl.com>, Alexander Graf <graf@amazon.com>,
        Matthias Brugger <mbrugger@suse.com>,
        Mark Langsdorf <mlangsdo@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        DTML <devicetree@vger.kernel.org>,
        Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org,
        James Morse <james.morse@arm.com>,
        Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
        kvm@vger.kernel.org, linux-clk <linux-clk@vger.kernel.org>,
        linux-edac@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Robin Murphy <robin.murphy@arm.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Will Deacon <will@kernel.org>
References: <20200218171321.30990-1-robh@kernel.org>
 <20200218181356.09ae0779@donnerap.cambridge.arm.com>
 <CAOesGMg=-w6+gpAmBDV6yfAg-HUk5AZfsKxQ+kYOn56NcB59vA@mail.gmail.com>
From:   =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Autocrypt: addr=andre.przywara@arm.com; prefer-encrypt=mutual; keydata=
 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
 i4aIXCH3Wv6K
Organization: ARM Ltd.
Message-ID: <9723b5df-e218-1ea9-e8eb-9e781b23af49@arm.com>
Date:   Thu, 20 Feb 2020 01:38:48 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <CAOesGMg=-w6+gpAmBDV6yfAg-HUk5AZfsKxQ+kYOn56NcB59vA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/02/2020 22:54, Olof Johansson wrote:

Hi,

> On Tue, Feb 18, 2020 at 10:14 AM Andre Przywara <andre.przywara@arm.com> wrote:
>>
>> On Tue, 18 Feb 2020 11:13:10 -0600
>> Rob Herring <robh@kernel.org> wrote:
>>
>> Hi,
>>
>>> Calxeda has been defunct for 6 years now. Use of Calxeda servers carried
>>> on for some time afterwards primarily as distro builders for 32-bit ARM.
>>> AFAIK, those systems have been retired in favor of 32-bit VMs on 64-bit
>>> hosts.
>>>
>>> The other use of Calxeda Midway I'm aware of was testing 32-bit ARM KVM
>>> support as there are few or no other systems with enough RAM and LPAE. Now
>>> 32-bit KVM host support is getting removed[1].
>>>
>>> While it's not much maintenance to support, I don't care to convert the
>>> Calxeda DT bindings to schema nor fix any resulting errors in the dts files
>>> (which already don't exactly match what's shipping in firmware).
>>
>> While every kernel maintainer seems always happy to take patches with a negative diffstat, I wonder if this is really justification enough to remove a perfectly working platform. I don't really know about any active users, but experience tells that some platforms really are used for quite a long time, even if they are somewhat obscure. N900 or Netwinder, anyone?
> 
> One of the only ways we know to confirm whether there are active users
> or not, is to propose removing a platform.
> 
> The good news is that if/when you do, and someone cares enough about
> it to want to keep it alive, they should also have access to hardware
> and can help out in maintaining it and keeping it in a working state.
> 
> For some hardware platforms, at some point in time it no longer makes
> sense to keep the latest kernel available on them, especially if
> maintainers and others no longer have easy access to hardware and
> resources/time to keep it functional.
> 
> It's really more about "If you care about this enough to keep it
> going, please speak up and help out".

I understand that, hence this email ;-)

I just wanted to avoid the impression that, by looking at the replies on
the list, *everybody* seems to be happy with the removal and it just
goes ahead. I have no idea how many actual *users* read this list and
this email.

>> So to not give the impression that actually *everyone* (from that small subset of people actively reading the kernel list) is happy with that, I think that having support for at least Midway would be useful. On the one hand it's a decent LPAE platform (with memory actually exceeding 4GB), and on the other hand it's something with capable I/O (SATA) and networking, so one can actually stress test the system. Which is the reason I was using that for KVM testing, but even with that probably going away now there remain still some use cases, and be it for general ARM(32) testing.
> 
> How many bugs have you found on this platform that you would not have
> on a more popular one? And, how many of those bugs only affected this
> platform, i.e. just adding onto the support burden without positive
> impact to the broader community?

I have found and helped fixing (or fixed myself) multiple bugs on the
Midway in the past. The mixture of decent I/O and 8GB of DRAM seemed to
be unique enough to spot bugs that didn't easily show on other systems.
Most were on KVM, but some were generic, and I remember at least one
LPAE related. And some bugs only showed under stress, because you can
actually run something useful on that machine before it goes on its knees.

>> I don't particularly care about the more optional parts like EDAC, cpuidle, or cpufreq, but I wonder if keeping in at least the rather small SATA and XGMAC drivers and basic platform support is feasible.
> 
> At what point are you better off just running under QEMU/virtualization?

For many things we are looking at that's not really an option.
If it would be very involved or painful to keep the support alive (as in
the KVM/arm32 case), I would see your point, but just some isolated
drivers (really a few and mostly quite small) don't justify a removal,
IMHO. I think we have far worse and older code in the kernel to worry about.

>> If YAML DT bindings are used as an excuse, I am more than happy to convert those over.
>>
>> And if anyone has any particular gripes with some code, maybe there is a way to fix that instead of removing it? I was always wondering if we could get rid of the mach-highbank directory, for instance. I think most of it is Highbank (Cortex-A9) related.
> 
> Again, how do you fix it if nobody has signed up for maintaining and
> keeping it working? Doing blind changes that might or might not work
> is not a way to keep a platform supported.
> 
> Just because code is removed, it doesn't mean it can't be reintroduced
> when someone comes along and wants to do that. Look at some of the
> recent additions of old OLPC hardware support, for example. But
> there's a difference between this and keeping the code around hoping
> that someone will care about it. It's not lost, and it's easy to bring
> back.

OK, maybe I should have been more explicit: If Rob does not want to
maintain it anymore, I am happy to throw my hat in the ring.

I have a working Midway system under my desk, with at least four working
nodes, two of them have an SSD connected and are running some
off-the-shelf Ubuntu 18.04 or Debian userland. I mostly run mainline
kernels, but try the distro kernels as well from time to time.
Routinely I test at least every -rc1 for regressions.

I also have updates to the A-15 firmware parts (U-Boot and PSCI runtime,
including PSCI 1.0 support and a Spectre V2 workaround), and have a
working setup to either chainload or actually update the firmware on the
flash. Happy to share that if someone is interested. For U-Boot I wanted
to send updates anyway.
I also have an old Highbank system lying around, but haven't turned that
on in years.

So would just a patch to MAINTAINERS be a solution?

Cheers,
Andre
