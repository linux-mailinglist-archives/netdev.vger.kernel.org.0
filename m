Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7CC3FC792
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 14:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233635AbhHaMuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 08:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233098AbhHaMuA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 08:50:00 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78BFEC06175F
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 05:49:04 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id q17so26659262edv.2
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 05:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ubique-spb-ru.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1cbiRqCKbbnjFPMuqxU9pzl3is1JghiOlnA5OtFXB2U=;
        b=G5/uLfdB5e/PNccmx/EDnnInPUdnlVRsoxsU5g9EoDxhwzm/cNTEX0vNDcDlmqjou7
         vDCKgSikjbUwjRJfoFu+EQ5L+NdlmpanOYqUD04T3UtFZC9HkRJZ9y5L+sdXgdvm67fC
         gUQP0VtmHkTZ1I6170BMo+5N0XuM0ZBePGuvB6h7nUKOB6rCkyPjXJr+MpRh9vis3GEV
         5FOafRyYQXazX26tsfp7u8mJWs+teJq+NwGisMf5509t0YGubbXn2ydZf+c3q5l0roXT
         scNYJMgFkEEfetsNIsEHKZCebviA5ofNmjbd/PZNHWzLnKPnDgLoTkZxFLgWUPcrH3n+
         KQtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1cbiRqCKbbnjFPMuqxU9pzl3is1JghiOlnA5OtFXB2U=;
        b=pJ/Q39JZFQcf7WgGuEHOrCJiXeYLE6PmmSd0I83RSG1F5t6gPfBvnzu1nAMf3qIXkU
         lTaf7yheJhDvGoz/hHeuVZdpFdrGVjHiO41g+3CRhYplxIvUyoPZwjGurnGUno3FSn8g
         KmJsN8W4olfaWDmLKROGiAws9IXT72+XXaJgk0ZN/8xyW8pSpfoKHQvpjosIijlRWscS
         PCSrIKIV5njPyYji9Aq6DrQJKLDYnllllmq1McRIvw4U8sM8D1FIyYYQxDWales1KW0k
         fAPjLFDaXodSM/2JpaJMCYI3E1dxsaW3abK27iKd/g28y2FHdpwDQEcljguRYGRjshD8
         iJ2A==
X-Gm-Message-State: AOAM5335BOp7RVUsWKJGtFrYfY7H1ZmWloLF+JZ1Rsaq8m8ZzwubieHK
        NcOkt0sv/VaQ2KObivs6VhBsFw==
X-Google-Smtp-Source: ABdhPJw4Dfa1IhTO5pkue+ot8FcJfqr3PwHLb/S74lA41FgwgBoM0F5FJRVS/FeI/mD4rz24TnURJQ==
X-Received: by 2002:a05:6402:2691:: with SMTP id w17mr18584907edd.339.1630414142902;
        Tue, 31 Aug 2021 05:49:02 -0700 (PDT)
Received: from localhost ([154.21.15.43])
        by smtp.gmail.com with ESMTPSA id d16sm9358989edu.8.2021.08.31.05.49.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 05:49:02 -0700 (PDT)
Date:   Tue, 31 Aug 2021 16:48:56 +0400
From:   Dmitrii Banshchikov <me@ubique.spb.ru>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, davem@davemloft.net,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, rdna@fb.com
Subject: Re: [PATCH bpf-next v2 00/13] bpfilter
Message-ID: <20210831124856.fucr676zd365va7c@amnesia>
References: <20210829183608.2297877-1-me@ubique.spb.ru>
 <a4039e82-9184-45bf-6aee-e663766d655a@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4039e82-9184-45bf-6aee-e663766d655a@mojatatu.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 30, 2021 at 09:56:18PM -0400, Jamal Hadi Salim wrote:
> On 2021-08-29 2:35 p.m., Dmitrii Banshchikov wrote:
> 
> [..]
> 
> > And here are some performance tests.
> > 
> > The environment consists of two machines(sender and receiver)
> > connected with 10Gbps link via switch.  The sender uses DPDK to
> > simulate QUIC packets(89 bytes long) from random IP. The switch
> > measures the generated traffic to be about 7066377568 bits/sec,
> > 9706553 packets/sec.
> > 
> > The receiver is a 2 socket 2680v3 + HT and uses either iptables,
> > nft or bpfilter to filter out UDP traffic.
> > 
> > Two tests were made. Two rulesets(default policy was to ACCEPT)
> > were used in each test:
> > 
> > ```
> > iptables -A INPUT -p udp -m udp --dport 1500 -j DROP
> > ```
> > and
> > ```
> > iptables -A INPUT -s 1.1.1.1/32 -p udp -m udp --dport 1000 -j DROP
> > iptables -A INPUT -s 2.2.2.2/32 -p udp -m udp --dport 2000 -j DROP
> > ...
> > iptables -A INPUT -s 31.31.31.31/32 -p udp -m udp --dport 31000 -j DROP
> > iptables -A INPUT -p udp -m udp --dport 1500 -j DROP
> > ```
> > 
> > The first test measures performance of the receiver via stress-ng
> > [3] in bogo-ops. The upper-bound(there are no firewall and no
> > traffic) value for bogo-ops is 8148-8210. The lower bound value
> > (there is traffic but no firewall) is 6567-6643.
> > The stress-ng command used: stress-ng -t60 -c48 --metrics-brief.
> > 
> > The second test measures the number the of dropped packets. The
> > receiver keeps only 1 CPU online and disables all
> > others(maxcpus=1 and set number of cores per socket to 1 in
> > BIOS). The number of the dropped packets is collected via
> > iptables-legacy -nvL, iptables -nvL and bpftool map dump id.
> > 
> > Test 1: bogo-ops(the more the better)
> >              iptables            nft        bpfilter
> >    1 rule:  6474-6554      6483-6515       7996-8008
> > 32 rules:  6374-6433      5761-5804       7997-8042
> > 
> > 
> > Test 2: number of dropped packets(the more the better)
> >              iptables            nft         bpfilter
> >    1 rule:  234M-241M           220M            900M+
> > 32 rules:  186M-196M        97M-98M            900M+
> > 
> > 
> > Please let me know if you see a gap in the testing environment.
> 
> General perf testing will depend on the nature of the use case
> you are trying to target.
> What is the nature of the app? Is it just receiving packets and
> counting? Does it exemplify something something real in your
> network or is just purely benchmarking? Both are valid.
> What else can it do (eg are you interested in latency accounting etc)?
> What i have seen in practise for iptables deployments is a default
> drop and in general an accept list. Per ruleset IP address aggregation
> is typically achieved via ipset. So your mileage may vary...

This was a pure benchmarking with the single goal - show that
there might exist scenarios when using bpfilter may provide some
performance benefits.

> 
> Having said that:
> Our testing[1] approach is typically for a worst case scenario.
> i.e we make sure you structure the rulesets such that all of the
> linear rulesets will be iterated and we eventually hit the default
> ruleset.
> We also try to reduce variability in the results. A lot of small
> things could affect your reproducibility, so we try to avoid them.
> For example, from what you described:
> You are sending from a random IP - that means each packet will hit
> a random ruleset (for the case of 32 rulesets). And some rules will
> likely be hit more often than others. The likelihood of reproducing the
> same results for multiple runs gets lower as you increase the number
> of rulesets.
> From a collection perspective:
> Looking at the nature of the CPU utilization is important
> Softirq vs system calls vs user app.
> Your test workload seems to be very specific to ingress host.
> So in reality you are more constrained by kernel->user syscalls
> (which will be hidden if you are mostly dropping in the kernel
> as opposed to letting packets go to user space).


> 
> Something is not clear from your email:
> You seem to indicate that no traffic was running in test 1.
> If so, why would 32 rulesets give different results than 1?

I mentioned the lower and upper bound values for bogo-ops on the
machine. The lower bound is when there is traffic and no firewall
at all. The upper bound is when there is no firewall and no
traffic. Then the first test measures bogo-ops for two rule sets
when there is traffic for either iptables, nft or bpfilter.

> 
> cheers,
> jamal
> 
> [1] https://netdevconf.info/0x15/session.html?Linux-ACL-Performance-Analysis

-- 

Dmitrii Banshchikov
