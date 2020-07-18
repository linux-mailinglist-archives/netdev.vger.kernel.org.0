Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB43224C8B
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 17:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbgGRPeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 11:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbgGRPet (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 11:34:49 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E07C0619D2;
        Sat, 18 Jul 2020 08:34:48 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id r12so13856208wrj.13;
        Sat, 18 Jul 2020 08:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hBiMsuFe9qS+uJq7UIKcZk6FkuYL7XB/UG3CgD34+TI=;
        b=Y4HGS84SKg8wqgkKwgITyr1IA+dW2QqnEmVi0+ydnHU9g0mVqkM3CK28/7KEXEZ75c
         ueLhvL7ASfrjmthDGBkYt3rvXW84iOACB3jvV3mlQCnz2YMxAWPF7aZe5BeQV5rJ8LHW
         lEzY33wbW2ukah+/fUMVtckgtXg3LW1/+h12sCI/EBq66MFUtzL1oeJoMZC8M5QSLATj
         JgFJVN4gPdO5TtJOWQfo6kFy4XbG8AEjfBvsO+Kx+DEgwFQCAboPccIre7ZWa4gzGljs
         mDkazBLi/PeoOK61nc9f7OpP6GebKbsDriPf0Uqq1t80stgpod8Naq+KLArP/BEq45Ci
         uSyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hBiMsuFe9qS+uJq7UIKcZk6FkuYL7XB/UG3CgD34+TI=;
        b=JvWg9iIijN6HLNsSXktXMg7UClzAQDxRFFQw3ZsMbKkKUeUt8aBTgCOopGcM9UMy7M
         sH2PGlhe+DhUv1Z+ex6jUZZHj1752KDxPcveIwUsUb8pZ0JJWB6yzlOdnQOcAuqjBqsh
         VypL7cavuEEQZRha3ZEGV/sPxxszQWzlQt51DDSindglPzptCJjiUdjBz0/62KcihbPq
         GlxuNoY72m8uZA3vfQJ8CEy8CjtADTUEaMhHZjv2SiF+qCAv2unEHxdG/OxWOJivhYa6
         liWLeAazGhPTYSE/qitz4f9EIYryd/uI7s+mYPbN/OOwEvLli04qJcMeWEVnCytnDQtN
         dTJg==
X-Gm-Message-State: AOAM532toUZ+QCePceKxBhoNn6rpKQT07Q0WDms+EdoQStujEYZkU1pD
        KuD5SjuYs/rKbxT7thwHV+No8Gr9
X-Google-Smtp-Source: ABdhPJwJi/58yjikmGAm/Hoe5pQPqpLqAQMa/XfBZQ+4JDl0QMOo56uZsOtOBmHkBgh6/bt1cr5tog==
X-Received: by 2002:adf:8462:: with SMTP id 89mr14678211wrf.420.1595086486774;
        Sat, 18 Jul 2020 08:34:46 -0700 (PDT)
Received: from localhost.localdomain (haganm.plus.com. [212.159.108.31])
        by smtp.gmail.com with ESMTPSA id p8sm8336627wrq.9.2020.07.18.08.34.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jul 2020 08:34:46 -0700 (PDT)
Subject: Re: [PATCH 2/2] dt-bindings: net: dsa: qca8k: Add PORT0_PAD_CTRL
 properties
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        John Crispin <john@phrozen.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jonathan McDowell <noodles@earth.li>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
References: <2e1776f997441792a44cd35a16f1e69f848816ce.1594668793.git.mnhagan88@gmail.com>
 <ea0a35ed686e6dace77e25cb70a8f39fdd1ea8ad.1594668793.git.mnhagan88@gmail.com>
 <20200716150925.0f3e01b8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <ac7f5f39-9f83-64c0-d8d5-9ea059619f67@gmail.com>
 <53851852-0efe-722e-0254-8652cdfea8fc@phrozen.org>
 <20200718132011.GQ1551@shell.armlinux.org.uk>
From:   Matthew Hagan <mnhagan88@gmail.com>
Message-ID: <0f541643-dc74-634f-30e5-c109d041d915@gmail.com>
Date:   Sat, 18 Jul 2020 16:34:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200718132011.GQ1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 18/07/2020 14:20, Russell King - ARM Linux admin wrote:
> On Fri, Jul 17, 2020 at 10:44:19PM +0200, John Crispin wrote:
>> in regards to the sgmii clk skew. I never understood the electrics fully I
>> am afraid, but without the patch it simply does not work. my eletcric foo is
>> unfortunately is not sufficient to understand the "whys" I am afraid.
> 
> Do you happen to know what frequency the clock is?  Is it 1.25GHz or
> 625MHz?  It sounds like it may be 1.25GHz if the edge is important.
> 
> If the clock is 1.25GHz, the "why" is because of hazards (it has
> nothing to do with delays in RGMII being propagated to SGMII).
> 
> Quite simply, a flip-flop suffers from metastability if the clock and
> data inputs change at about the same time.  Amongst the parametrics of
> flip-flops will be a data setup time, and a data hold time, referenced
> to the clock signal.
> 
> If the data changes within the setup and hold times of the clock
> changing, then the output of the flip-flop is unpredictable - it can
> latch a logic 1 or a logic 0, or oscillate between the two until
> settling on one state.
> 
> So, if data is clocked out on the rising edge of a clock signal, and
> clocked in on the rising edge of a clock signal - and the data and
> clock edges arrive within the setup and hold times at the flip-flop
> that is clocking the data in, there is a metastability hazard, and
> the data bit that is latched is unpredictable.
>
With default settings, in my case, the device will work at first, though
eventually problems arise with loss of connectivity, but constant
activity on the individual port led.

> One way to solve this is to clock data out on one edge, and clock data
> in on the opposite edge - this is used on buses such as SPI.  Other
> buses such as I2C define minimum separation between transitions between
> the SDA and SCL signals.
> 
Is there any case where it would matter which way round the clocks are,
or is it only relevant that they are on opposite edges? Why not do this
by default for qca8k devices?

> These solutions don't work with RGMII - the RGMII TXC clocks data on
> both edges.  The only solution there is to ensure a delay is introduced
> between the data and clock changes seen at the receiver - which can be
> done by introducing delays at the transmitter or at the receiver, or by
> serpentine routing of the traces to induce delays to separate the clock
> and data transitions sufficiently to avoid metastability.
> 
> If the clock is 625MHz (as with some Marvell devices for SGMII) then
> both clock edges are used, and both edges are used just like RGMII.
> Therefore, the same considerations as RGMII apply there to ensure that
> the data setup and hold times are not violated.
> 
By default, both tx and rx are set to rising edge.

Matthew
