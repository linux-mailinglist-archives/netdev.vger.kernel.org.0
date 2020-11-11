Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34B052AE766
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 05:29:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbgKKE3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 23:29:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgKKE3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 23:29:01 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB2AC0613D1
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 20:29:00 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id e7so822663pfn.12
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 20:29:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=amWrgWxIKyYrkS7V8Ya8X5NRiy/uCfjKOlv2sl+7pi0=;
        b=Ngo2Yqoz2brK2h8QGc+VfNKeeWwRWtKpsqdFdFHRXFFt1Hi2ca4ZJcvol5q75G1/od
         sEduvhZP5LfnBlZkoB5DVBzICIotX8RZJRM+xSwJFcvfSlQ5vcurWoCY52QtA9buJ7Ar
         wyiJ/4wBcjmfCqG67qt5pskdjhhX0o1gDM7U6u9oNBsKB/jphCR3WbV7bIHe3siuuTwC
         WMdKNEU0ZY3Knun7QpvFBDz3+TrH1OaarhHPF8+gUM7bHzUkpSz+TuYthCLD7KnKKtOe
         GlFSXgqiUFDcKUD48ZZFf2sNF7jDkfs+ahtxwuoCCf9PtkwYz1LRchWo1hlMdptsO5JO
         IUiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=amWrgWxIKyYrkS7V8Ya8X5NRiy/uCfjKOlv2sl+7pi0=;
        b=e4S4voPQfI89hnUM/M06yJbpy3Ux7cjZMM7r6WtJENRpxuLT91a3NTsn2PiXMpykeo
         LsD0wfRsYs7umLIsA5faZ+0Fj4jFVIe/owPwHueaJdacvGd7CCrg02YEMK4Vthsx5sWj
         DiV2vtnX5lsCyg9r3BKfEtr5BvC8UxCgNVU8D2vsUi3tyIoST6E88wDhARRYpglEwzBv
         3kjPiVEnHO39f8fVlP/L036a1GJEoeYPMZpSNSmlyE6OkDBQrFaD7bUEklOCeNaxHKpC
         mi6Z/9DGmGcPcAomVjDWdfryKFe/xWsqNEkgnHgdZxQlLWuDt6lqDDX9fEGkYM6yPA55
         N+Mw==
X-Gm-Message-State: AOAM530graLSHei2NLNr5iSONRSgn7YCX3q1w9rjAPduryJTQiNK1Ssw
        tbnvG9rXzUIhOi4jGFymJUUz4bpsKSs=
X-Google-Smtp-Source: ABdhPJyS84zU6/Nj8WF4tPzWocAKFamja+6w5UzZBTGCmLui4BmvboEwy7s9txxwyB33/8LVvAYJZQ==
X-Received: by 2002:a65:4cc9:: with SMTP id n9mr20557384pgt.236.1605068939942;
        Tue, 10 Nov 2020 20:28:59 -0800 (PST)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id a25sm693950pfg.138.2020.11.10.20.28.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2020 20:28:59 -0800 (PST)
Subject: Re: [RFC PATCH 0/4] net: dsa: link aggregation support
To:     Tobias Waldekranz <tobias@waldekranz.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, olteanv@gmail.com
Cc:     netdev@vger.kernel.org
References: <20201027105117.23052-1-tobias@waldekranz.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ee27c1a0-da00-5ba5-d25a-82191c4c15b0@gmail.com>
Date:   Tue, 10 Nov 2020 20:28:57 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.2
MIME-Version: 1.0
In-Reply-To: <20201027105117.23052-1-tobias@waldekranz.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/27/2020 3:51 AM, Tobias Waldekranz wrote:
> This series starts by adding the generic support required to offload
> link aggregates to drivers built on top of the DSA subsystem. It then
> implements offloading for the mv88e6xxx driver, i.e. Marvell's
> LinkStreet family.
> 
> Posting this as an RFC as there are some topics that I would like
> feedback on before going further with testing. Thus far I've done some
> basic tests to verify that:
> 
> - A LAG can be used as a regular interface.
> - Bridging a LAG with other DSA ports works as expected.
> - Load balancing is done by the hardware, both in single- and
>   multi-chip systems.
> - Load balancing is dynamically reconfigured when the state of
>   individual links change.
> 
> Testing as been done on two systems:
> 
> 1. Single-chip system with one Peridot (6390X).
> 2. Multi-chip system with one Agate (6352) daisy-chained with an Opal
>    (6097F).
> 
> I would really appreciate feedback on the following:
> 
> All LAG configuration is cached in `struct dsa_lag`s. I realize that
> the standard M.O. of DSA is to read back information from hardware
> when required. With LAGs this becomes very tricky though. For example,
> the change of a link state on one switch will require re-balancing of
> LAG hash buckets on another one, which in turn depends on the total
> number of active links in the LAG. Do you agree that this is
> motivated?

Yes, this makes sense, I did something quite similar in this branch
nearly 3 years ago, it was tested to the point where the switch was
programmed correctly but I had not configured the CPU port to support
2Gbits/sec (doh) to verify that we got 2x the desired throughput:

https://github.com/ffainelli/linux/commits/b53-bond

Your patch looks definitively more complete.

> 
> The LAG driver ops all receive the LAG netdev as an argument when this
> information is already available through the port's lag pointer. This
> was done to match the way that the bridge netdev is passed to all VLAN
> ops even though it is in the port's bridge_dev. Is there a reason for
> this or should I just remove it from the LAG ops?
> 
> At least on mv88e6xxx, the exact source port is not available when
> packets are received on the CPU. The way I see it, there are two ways
> around that problem:
> 
> - Inject the packet directly on the LAG device (what this series
>   does). Feels right because it matches all that we actually know; the
>   packet came in on the LAG. It does complicate dsa_switch_rcv
>   somewhat as we can no longer assume that skb->dev is a DSA port.
> 
> - Inject the packet on "the designated port", i.e. some port in the
>   LAG. This lets us keep the current Rx path untouched. The problem is
>   that (a) the port would have to be dynamically updated to match the
>   expectations of the LAG driver (team/bond) as links are
>   enabled/disabled and (b) we would be presenting a lie because
>   packets would appear to ingress on netdevs that they might not in
>   fact have been physically received on.
> 
> (mv88e6xxx) What is the policy regarding the use of DSA vs. EDSA?  It
> seems like all chips capable of doing EDSA are using that, except for
> the Peridot.
> 
> (mv88e6xxx) The cross-chip PVT changes required to allow a LAG to
> communicate with the other ports do not feel quite right, but I'm
> unsure about what the proper way of doing it would be. Any ideas?
> 
> (mv88e6xxx) Marvell has historically used the idiosyncratic term
> "trunk" to refer to link aggregates. Somewhere around the Peridot they
> have switched and are now referring to the same registers/tables using
> the term "LAG". In this series I've stuck to using LAG for all generic
> stuff, and only used trunk for driver-internal functions. Do we want
> to rename everything to use the LAG nomenclature?

Yes please!
-- 
Florian
