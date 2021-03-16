Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DAF933CFFA
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 09:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235089AbhCPIgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 04:36:02 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47877 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235058AbhCPIfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 04:35:40 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id BEC5E5C0156;
        Tue, 16 Mar 2021 04:35:39 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 16 Mar 2021 04:35:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=PSt7jvL1q8aLRndMEWWP+sSXM/m75mJlvq6ApFgPI
        1M=; b=KdjygmBD9Hne5F9HtvwKvfcYKC6B8eR+G8dGe8Ke0jr19XYBiHuDxjJuV
        M+1s+N1Ecd4nS3TdxOTTCnD9qtVcAxBFj8l/4cqZ8to0aTx58rUG8JHZPt7Jt7Gc
        a4PoT2jo/uRwW4LIZjG1nsatNn62v657VGMOtg0LGetj0yJe1Wob/mG6fFOYeDE6
        NguHUviavli7G9wOWQdOEJJjwtCqfwKEOQKVT8LJ5goOgnbij0fKqm1aggEBlgP1
        PVm4Or4xB0ZnirH6LvMOBd+snOFRTdlO7LLPG0EVB9+h1alRnaQtVI6osOXDBAUW
        PMYjJp8wlEBc/JLjm5ldLRPJM1xtA==
X-ME-Sender: <xms:221QYH66-kcnMqeYSyTx4pukkKYzFY7UmuYfjpd-Lt5u2P3WbtDEyA>
    <xme:221QYM63bGGPQANPRYgCcclAtyRY9VI_fNizBdIoCrljg1c2Yefy-MgOJAc6TcElT
    7VkbV7ucdElhnU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudefuddguddvvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrg
    htthgvrhhnpeefheethffhhfdvueevkeffffefjeejffefuedtfedvgfettdetkedtgfej
    tdehudenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekgedrvddvledrud
    ehfedrgeegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhho
    mhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:221QYOeutTXqQtNvgtnfJU1-xIqU51U_gRB74PkDRblhzkVgf1NyIA>
    <xmx:221QYIJuVu0SC3f_Lzr4dS6B7GRCCwvgTLtdNWbdZmxfvQs9DN9EMA>
    <xmx:221QYLKdMY3W66-5YjmN_N4bhIEUA-gYYaiAYAq2gGhZRDiFQDy5aw>
    <xmx:221QYIGZbIh-5RfgjNuAJrl-gyldB0glsTn2IhRRtZxLCFi4G2oq5Q>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id D957424005C;
        Tue, 16 Mar 2021 04:35:38 -0400 (EDT)
Date:   Tue, 16 Mar 2021 10:35:35 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Simon Horman <simon.horman@netronome.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Xingfeng Hu <xingfeng.hu@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@netronome.com>
Subject: Re: [PATCH v3 net-next 0/3] net/sched: act_police: add support for
 packet-per-second policing
Message-ID: <YFBt19zVIH6Dgw8w@shredder.lan>
References: <20210312140831.23346-1-simon.horman@netronome.com>
 <YE3GofZN1jAeOyFV@shredder.lan>
 <20210315144155.GA2053@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210315144155.GA2053@netronome.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry for the delay. Was AFK yesterday

On Mon, Mar 15, 2021 at 03:41:56PM +0100, Simon Horman wrote:
> On Sun, Mar 14, 2021 at 10:17:37AM +0200, Ido Schimmel wrote:
> > On Fri, Mar 12, 2021 at 03:08:28PM +0100, Simon Horman wrote:
> > > This series enhances the TC policer action implementation to allow a
> > > policer action instance to enforce a rate-limit based on
> > > packets-per-second, configurable using a packet-per-second rate and burst
> > > parameters.
> > > 
> > > In the hope of aiding review this is broken up into three patches.
> > > 
> > > * [PATCH 1/3] flow_offload: add support for packet-per-second policing
> > > 
> > >   Add support for this feature to the flow_offload API that is used to allow
> > >   programming flows, including TC rules and their actions, into hardware.
> > > 
> > > * [PATCH 2/3] flow_offload: reject configuration of packet-per-second policing in offload drivers
> > > 
> > >   Teach all exiting users of the flow_offload API that allow offload of
> > >   policer action instances to reject offload if packet-per-second rate
> > >   limiting is configured: none support it at this time
> > > 
> > > * [PATCH 3/3] net/sched: act_police: add support for packet-per-second policing
> > > 
> > >   With the above ground-work in place add the new feature to the TC policer
> > >   action itself
> > > 
> > > With the above in place the feature may be used.
> > > 
> > > As follow-ups we plan to provide:
> > > * Corresponding updates to iproute2
> > > * Corresponding self tests (which depend on the iproute2 changes)
> > 
> > I was about to ask :)
> > 
> > FYI, there is this selftest:
> > tools/testing/selftests/net/forwarding/tc_police.sh
> > 
> > Which can be extended to also test packet rate policing
> 
> Thanks Ido,
> 
> The approach we have taken is to add tests to
> tools/testing/selftests/tc-testing/tc-tests/actions/police.json
> 
> Do you think adding a test to tc_police.sh is also worthwhile? Or should be
> done instead of updating police.json?

IIUC, police.json only performs configuration tests. tc_police.sh on the
other hand, configures a topology, injects traffic and validates that
the bandwidth after the police action is according to user
configuration. You can test the software data path by using veth pairs
or the hardware data path by using physical ports looped to each other.

So I think that extending both tests is worthwhile.

> 
> Lastly, my assumption is that the tests should be posted once iproute2
> changes they depend on have been accepted. Is this correct in your opinion?

Personally, I prefer selftests to be posted together with the
implementation, regardless if they depend on new iproute2 functionality.
In the unlikely case that the kernel patches were accepted, but changes
were requested for the command line interface, you can always patch the
selftests later.

Jakub recently added this section:
https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html#how-do-i-post-corresponding-changes-to-user-space-components

He writes "User space code exercising kernel features should be posted
alongside kernel patches."

And you can see that in the example the last patch is a selftest:

```
[PATCH net-next 0/3] net: some feature cover letter
 └─ [PATCH net-next 1/3] net: some feature prep
 └─ [PATCH net-next 2/3] net: some feature do it
 └─ [PATCH net-next 3/3] selftest: net: some feature

[PATCH iproute2-next] ip: add support for some feature
```

> 
> In any case, I'll get moving on posting the iproute2 changes.

Thanks!

> 
> > > * Hardware offload support for the NFP driver
> > > 
> > > Key changes since v2:
> > > * Added patches 1 and 2, which makes adding patch 3 safe for existing
> > >   hardware offload of the policer action
> > > * Re-worked patch 3 so that a TC policer action instance may be configured
> > >   for packet-per-second or byte-per-second rate limiting, but not both.
> > > * Corrected kdoc usage
> > 
> > Thanks!
