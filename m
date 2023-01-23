Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5676678596
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 19:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbjAWS5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 13:57:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233191AbjAWS5X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 13:57:23 -0500
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B177915CA6
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 10:57:22 -0800 (PST)
Received: by mail-qv1-xf2f.google.com with SMTP id t7so9756616qvv.3
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 10:57:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tbpbjohEtLJYWU/WkU+8Siyo5LQUGOcQvkISNCRttHE=;
        b=K4zoSl8Ei+oH3pgbt5U2yZs9KlGMtSyjYz5VcsHlb19luXZ+YHQDyz3qFVOUlUpc1a
         LbmqqMqn3UWCBeHxymjNXw6WXCiwz68OwhcAeqgLlSWkBig3NKWMdtAzA7wSGB+qGKRH
         4+G+Uzr2UOzlanxJ3ercLt1O2LIjn51fyxgP0fqPBgcOLONJEznkvcksOBTNnu3Saf5C
         3yABkD56fT3nwRJ7aWUB8vU9QDeEKW/f5pCGZBoSRmOT+ry4HZymgyWzb0GEVHhKsT/o
         WWL4nl7KIigmPW8lv/KCLTGp3d5S4uq7vOOpPHCfhd25GY1TWcRfq34KML8C1TI5iscC
         xXyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tbpbjohEtLJYWU/WkU+8Siyo5LQUGOcQvkISNCRttHE=;
        b=J/6SGLphc33d46NG9Alae5VBpTCZJZTLsiV69wQWPrPBAwmRC7nxmQtt2JcZmSAiV3
         ZC0dOx6VMVs+PgD7dVle5NpZo8uT05iWxDDMUSobzk/N0E+uQjODqOIp9p1FD1ovsI7a
         c2bZuddfbr16pi0/geaZcfszJjvYNKcR5779li59ZKpOJOwnWBx9FOCY4IsegtmCjn4z
         K2eOqH/GofMTRWvdSPojEjIt/T1STvcMqwFQ+pQGslq0OCrFeX/0gAGmUUZuF7G6f6t0
         NvYek1K8VifF6Xg33cV+eH2QaJ/yGvKnsFQlnKFVha1W8lX5m7PTrQxG0aIAWh1GCpGg
         BD1w==
X-Gm-Message-State: AFqh2kpRko0fGq7G9BmGfjjt9go7yJeHjV0fnaSUcKmW24yCbRq8kGQN
        om1omFZwZC91VEwAt5MVxdA=
X-Google-Smtp-Source: AMrXdXuNOrvU6cffmha7KmsYJ4JhoVW5T1F41ErjsVL2kixm6gVEh8dlZCsK2VeEk/bw0d9Bmb/5hQ==
X-Received: by 2002:ad4:5893:0:b0:535:59ca:6c6b with SMTP id dz19-20020ad45893000000b0053559ca6c6bmr22764201qvb.19.1674500241735;
        Mon, 23 Jan 2023 10:57:21 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id q44-20020a05620a2a6c00b006fc9fe67e34sm18154927qkp.81.2023.01.23.10.57.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 10:57:21 -0800 (PST)
Message-ID: <6b63fe0f-a435-1fdf-bc56-10622b832419@gmail.com>
Date:   Mon, 23 Jan 2023 10:57:10 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: dsa: phy started on dsa_register_switch()
Content-Language: en-US
To:     "Sverdlin, Alexander" <alexander.sverdlin@siemens.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Cc:     "Freihofer, Adrian" <adrian.freihofer@siemens.com>
References: <f95cdab0940043167ddf69a4b21292ee63fc9054.camel@siemens.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <f95cdab0940043167ddf69a4b21292ee63fc9054.camel@siemens.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/23/23 10:35, Sverdlin, Alexander wrote:
> Dear DSA maintainers,
> 
> I've been puzzled by the fact ports of the DSA switches are enabled on
> bootup by default (PHYs configured, LEDs ON, etc) in contrast to the
> normal Ethernet ports.
> 
> Some people tend to think this is a security issue that port is "open"
> even though no configuration has been performed on the port, so I
> looked into the differences between Ethernet drivers and DSA
> infrastructure.

If you are concerned about security with a switch, then clearly the 
switch should have an EEPROM which configures it to isolate all of the 
ports from one another, and possibly do additional configuration to 
prevent any packets from leaking. The PHY and Ethernet link being active 
would not be a reliable way to ensure you start up in a secure state, it 
may participate into it, but it is not the only thing you can rely upon.

> 
> Traditionally phylink_of_phy_connect() and phylink_connect_phy() are
> being called from _open() callbacks of the Ethernet drivers so
> as long as the Ethernet ports are !IFF_UP PHYs are not running,
> LEDs are OFF, etc.

This is what is advised for Ethernet controller drivers to do, but is 
not strictly enforced or true throughout the entire tree, that is, it 
depends largely upon whether people writing/maintaining those drivers 
are sensitive to that behavior.

> 
> Now with DSA phylink_of_phy_connect() is being called by
> dsa_slave_phy_setup() which in turn is being called already in
> dsa_slave_create(), at the time a switch is being DT-parsed and
> created.
> 
> This confuses users a bit because neither CPU nor user ports have
> been setup yet from userspace via netlink, yet the LEDs are ON.

You seem to be assuming a certain user visible behavior that actually 
relies on both hardware and software to be configured properly. Having 
LEDs remain OFF from the time you apply power to the system, till you 
actually have your operating system and its switch driver running and 
issue "ip link set dev sw0p0 up" requires a lot more coordination.

I am sensitive to the power management aspect that getting the PHY and 
Ethernet link negotiated and then (re)negotiated several times through a 
products' boot cycle is a waste of energy and too many times do we break 
and make the link. The security aspect, I am less sensitive since the 
PHY is not how it should be enforced.

> 
> The things get worse when a user performs
> "ip link set dev lan1 up; ip link set dev lan1 down", because now
> the LEDs go OFF.

That seems to be exactly the behavior you want based upon the previous 
paragraph as it indicates that the PHY has been powered down.

> 
> Is this behaviour intended? Shall I try to develop patches moving
> phylink_.*phy_connect to dsa_slave_open() and something similar
> for CPU port?

Yes this was intentional since the beginning to speed up 
auto-negotiation, and it dates back to when DSA was brought into the 
kernel circa 2008.

We are almost guaranteed to be breaking someone's behavior if we 
postpone the connection to the PHY, however we could introduce a flag 
and make the deferring of connecting to the PHY to ndo_open() a driver 
by driver decision when proven this has no ill effect.
-- 
Florian

