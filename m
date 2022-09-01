Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFF4B5A92BB
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 11:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234493AbiIAJHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 05:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234498AbiIAJGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 05:06:55 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6DDBFC73
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 02:05:41 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id p7so12319835lfu.3
        for <netdev@vger.kernel.org>; Thu, 01 Sep 2022 02:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=K1QIsdiZZXDQyu9ZTSWU7/YTQ8jITmfkkrSk3ETOLiw=;
        b=luwvvoaftVnu/9kyn+cV5qN/UMISS2rzHnDB81Et2F8HBacNYuJ9rlivnAo6MFYTpM
         rzRnempMyoqUBWaLbKHEEplg9hXLa2+z01FcO66KgFX2OGrhc7G8UX21N9k9VVR/zwv7
         rra1qCEKBgRnFhN8rIm34wyEKBCpyXYTvINHvnMRaqlphmTeKHNfJoh8IbQtBMYSLwnC
         elp7vUyBXCMA65cmu3EVQx6HyDZaMD3Jg2+Pe+7UyXjlvqXdT6u2O0Vi2/awCpJtPUT+
         eI5WJydMlYt6ZBxPnXyhj9zk0roZZuXEhCTnqKZsd6WTctrEsFq9zLS/UtyrcJLXDTkG
         0VzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=K1QIsdiZZXDQyu9ZTSWU7/YTQ8jITmfkkrSk3ETOLiw=;
        b=7EVUStUe6XPMRBub+6m35ff+9Tn1DEkVsb5uWHIjIc+Y92xfwo+1oXJvj0YSjhi/ub
         MyAeOPpYw4e0faD8Rg0tueAx2loCBBFeqDY6Q5UIhA+r7H3+j9zupX2TCu4nreerxQ3G
         0aR1RFo0BYXQeHXEMu3rE/6pMvMi/JTqEbTi+TeyNO7D7/RHJJNvzV3Dto5/LZE+SWRy
         BfxGCi0RQ4L2oW/HSmi3P4GB99u6qm9sE8V8th/w1e4sDgV9RTBOc4DhtfGNvYV5hCr0
         Rep+g0AeDDQ2jp9+nzlVB3ainh41/HPmTtiTBVLMp8V1b9hrrrbBTHbUaeE/FDWySl3Y
         yHwg==
X-Gm-Message-State: ACgBeo2Zmxn+ZsS8DMUrCY6uLBhyD6g1Ntk3inJ0vl9afyv4wmUarzzk
        wWUIx4TI/cMgxST8HC6O1GM=
X-Google-Smtp-Source: AA6agR5M9NVdHr/OH6wHlycwm/TwLQd8Z6uFnyIyDrSQRVh8BDq34yFnvwkJl0v+vbwcJrfjyiiIpQ==
X-Received: by 2002:a05:6512:130d:b0:492:8b65:3785 with SMTP id x13-20020a056512130d00b004928b653785mr11062635lfu.351.1662023139300;
        Thu, 01 Sep 2022 02:05:39 -0700 (PDT)
Received: from [10.0.1.14] (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id h39-20020a0565123ca700b00491ee1bf301sm1128774lfv.39.2022.09.01.02.05.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Sep 2022 02:05:38 -0700 (PDT)
Message-ID: <f30871da-abec-477d-1bab-43cbc9108bec@gmail.com>
Date:   Thu, 1 Sep 2022 11:05:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v2 2/3] dsa: mv88e6xxx: Add support for RMU in
 select switches
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220826063816.948397-1-mattias.forsblad@gmail.com>
 <20220826063816.948397-3-mattias.forsblad@gmail.com>
 <20220830163515.3d2lzzc55vmko325@skbuf>
 <20220830164226.ohmn6bkwagz6n3pg@skbuf>
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
In-Reply-To: <20220830164226.ohmn6bkwagz6n3pg@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-08-30 18:42, Vladimir Oltean wrote:
> On Tue, Aug 30, 2022 at 07:35:15PM +0300, Vladimir Oltean wrote:
>>> +void mv88e6xxx_rmu_master_change(struct dsa_switch *ds, const struct net_device *master,
>>> +				 bool operational)
>>> +{
>>> +	struct mv88e6xxx_chip *chip = ds->priv;
>>> +
>>> +	if (operational)
>>> +		chip->rmu.ops = &mv88e6xxx_bus_ops;
>>> +	else
>>> +		chip->rmu.ops = NULL;
>>> +}
>>
>> There is a subtle but very important point to be careful about here,
>> which is compatibility with multiple CPU ports. If there is a second DSA
>> master whose state flaps from up to down, this should not affect the
>> fact that you can still use RMU over the first DSA master. But in your
>> case it does, so this is a case of how not to write code that accounts
>> for that.
>>
>> In fact, given this fact, I think your function prototypes for
>> chip->info->ops->rmu_enable() are all wrong / not sufficiently
>> reflective of what the hardware can do. If the hardware has a bit mask
>> of ports on which RMU operations are possible, why hardcode using
>> dsa_switch_upstream_port() and not look at which DSA masters/CPU ports
>> are actually up? At least for the top-most switch. For downstream
>> switches we can use dsa_switch_upstream_port(), I guess (even that can
>> be refined, but I'm not aware of setups using multiple DSA links, where
>> each DSA link ultimately goes to a different upstream switch).
> 
> Hit "send" too soon. Wanted to give the extra hint that the "master"
> pointer is given to you here for a reason. You can look at struct
> dsa_port *cpu_dp = master->dsa_ptr, and figure out the index of the CPU

Would this work on a system where there are multiple switches? I.e.

SOC <->port6 SC#1 <->port10 SC#2

Both have the same master interface (chan0) which gives the same
cpu_dp->dsa_ptr->index but they have different upstream ports that should 
be enabled for RMU.

> port which can be used for RMU operations. I see that the macros are
> constructed in a very strange way:
> 
> #define MV88E6352_G1_CTL2_RMU_MODE_DISABLED	0x0000
> #define MV88E6352_G1_CTL2_RMU_MODE_PORT_4	0x1000
> #define MV88E6352_G1_CTL2_RMU_MODE_PORT_5	0x2000
> #define MV88E6352_G1_CTL2_RMU_MODE_PORT_6	0x3000
> 
> it's as if this is actually a bit mask of ports, and they all can be
> combined together. The bit in G1_CTL2 whose state we can flip can be
> made to depend on the number of the CPU port attached to the DSA master
> which changed state.

