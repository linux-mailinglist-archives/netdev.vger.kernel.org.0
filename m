Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C23D2B906C
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 11:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgKSKvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 05:51:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726274AbgKSKvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 05:51:15 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7427FC0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 02:51:15 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id oq3so7248690ejb.7
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 02:51:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sCRm2417uymLyP9qgk6rBBg1y7KRyS3NklAtfzL4uhw=;
        b=gZJF289JxDgVonLtB2NZveVYysJNfw0WyVP9Zq/1byP2Z13XheAZXQPZhqLdb4pPxt
         Nj56Jfo5h1ZkHBdVK3RCrj9Ga8xSI6Kspd/TPdu0kCGtarOKgpyoDGRM1hdn6Uye7cre
         zvKlB1scqG0bswfZeCeox4NzRWcPXRN5DyvZP2B64rU3H2sr5h7/hFkS1SI43GNx3UsZ
         tcCc5MRa9JZda5IqjJG5YmJGVZE2b15lAOlwe/aQ9dYH6BMS4oBGtIu9W2WLqNVxCbwJ
         0iqFlrbxA/nY6VmvWbsRljWvjlS8OoF/ja/guiggZBmQQYt5S4Qj4TwEzRlP4V2PBrPU
         7tAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sCRm2417uymLyP9qgk6rBBg1y7KRyS3NklAtfzL4uhw=;
        b=rlhuwIdPJoWptIK2Dk3QjLqoKZQeG1qR8R/dN3utscttbUSzrleswdZJcXnyqwsqDS
         PO/JCDKPzwd3Acz59BJrDJApkVD2Qb5fY4YHIFw3yULj6Z0xWq26HOsIvuRVLBShhkZ4
         /oucx/3hoj2AVXQiJTsaNISNTdXdf/xvkO081z1vI7ZxWXbd6PAEEKNvYGA8wR/JwvZM
         ylicgToRPqcJ1bu/63x8ciTWrLoGYmK1VSNtM5jvtruvdzYA8m5ghTQiIa66QFeIGvlG
         DfGoPfT/Ou7JCKaLI2HWRVqoWaeS3S40T2Cq6GiGbiolDgYKTbZAnAIcfAHJ4r49hPpX
         qufw==
X-Gm-Message-State: AOAM533N9Bpz+UYYSvVYBqS+fPlEwiw+AETSaRqkVSp+nhP13bu449aV
        I+34+jSob6kDT4RYubP8hBg=
X-Google-Smtp-Source: ABdhPJykg5gcupcT+Ix+5Nu8JLgiUy3D18/8w/eB3ZHFBo4u91b9QtQdGweH61rivO50U+872djuxA==
X-Received: by 2002:a17:906:60c4:: with SMTP id f4mr28081148ejk.336.1605783074081;
        Thu, 19 Nov 2020 02:51:14 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id zm12sm14103019ejb.62.2020.11.19.02.51.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 02:51:13 -0800 (PST)
Date:   Thu, 19 Nov 2020 12:51:12 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] net: dsa: link aggregation support
Message-ID: <20201119105112.ahkf6g5tjdbmymhk@skbuf>
References: <20201027105117.23052-1-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201027105117.23052-1-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 11:51:13AM +0100, Tobias Waldekranz wrote:
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

I have tested these patches on ocelot/felix and all is OK there, I would
appreciate if you could resend as non-RFC. In the case of my hardware,
it appears that I don't need the .port_lag_change callback, and that the
source port that is being put in the DSA header is still the physical
port ID and not the logical port ID (the LAG number). That being said,
the framework you've built is clearly nice and works well even with
bridging a bond.
