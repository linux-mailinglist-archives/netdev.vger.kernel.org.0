Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8F116D979D
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 15:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236863AbjDFNHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 09:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236599AbjDFNHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 09:07:51 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35871123
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 06:07:49 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-54bfa5e698eso71882397b3.13
        for <netdev@vger.kernel.org>; Thu, 06 Apr 2023 06:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680786468; x=1683378468;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FVAuKwn36IMarn0SWRi8zj1ZksaDJch6bideTiqDloc=;
        b=j6thaytXCnOc2qEKFICJ4GpIHKEqp4P673QTU8M9Vwj4h/6jRaocPmbr4QkyxqfT4D
         nKXMMGRHNybKmviYPKOFZHVr9NgRpJahLCR8kH63F8gVhuwezUe2yCIdljHHDSPVwVVi
         +TcV9P6jSXtcx5c7gCnXWGR3V2DZ8iE8fQqIim3/4x2Y1s1MUvXRHCWJfVNNVjHvBmXJ
         AhtnBsWle7ahOCdzzDVL90S+hYdQoLyl1M8dOulAc6aFaJnn8HN/LELYUK4+A9wwJxHo
         2t62zQS1zHSTEN3jEMSVCKqzWveXb447g1ad4AmL4N4MbX9+/lf09uUYAfbEo9OCtrao
         LYxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680786468; x=1683378468;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FVAuKwn36IMarn0SWRi8zj1ZksaDJch6bideTiqDloc=;
        b=RJ36HbOKWdChRyWgnFi6Q6xozY16DD3nuJ4j2+HV0Z31//2HIAfGAlgxlE/7GWEg5j
         WcVj0RREr5I/IimxakNiX80qOvBzyxQqjDUSvoOYCFSZnINY8ZVrQFAReiLoaLXnE6Fs
         MeTBA2REknrGHfuUMmVMqfPZCiaPTEs+/CS5oWxAS1vVS1dbUWXf3b0/VkwIdeMF2zro
         Deo6yVFZ5jr8XO5GMMBW7beDw363yXQFhBMpY4aID1mYrT+xRTwj2QN696wSZP3df9f7
         oN+BReipreS9mb4pq6QzM14qvlycFd0mZroYpVl15EMwrtIG/cYLs4seQW8ibL7LE59i
         gkDg==
X-Gm-Message-State: AAQBX9e12Rj/tZcJk4nlzzyCZ+UiZ1K3aUcafIJilabZKOEJjEU5HUDA
        zxTOrWETKQTZ7F5opSQgocc6JnH9Qmf5JA==
X-Google-Smtp-Source: AKy350awxPG1VmlxGbTSvA/Q4+7QZL4cOfZOCJtrwX7D5CTrOUN6RNRc06pDY+YfDb3S508MCEainQ==
X-Received: by 2002:a05:7500:2d08:b0:fc:e97b:3758 with SMTP id et8-20020a0575002d0800b000fce97b3758mr422206gab.15.1680786468239;
        Thu, 06 Apr 2023 06:07:48 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id i4-20020a378604000000b007426e664cdcsm440518qkd.133.2023.04.06.06.07.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Apr 2023 06:07:47 -0700 (PDT)
Message-ID: <93ae54eb-5287-8d63-5109-973bfacc6b74@gmail.com>
Date:   Thu, 6 Apr 2023 06:07:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v2 net-next] net: dsa: replace NETDEV_PRE_CHANGE_HWTSTAMP
 notifier with a stub
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>
References: <20230406114246.33150-1-vladimir.oltean@nxp.com>
Content-Language: en-US
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230406114246.33150-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/6/2023 4:42 AM, Vladimir Oltean wrote:
> There was a sort of rush surrounding commit 88c0a6b503b7 ("net: create a
> netdev notifier for DSA to reject PTP on DSA master"), due to a desire
> to convert DSA's attempt to deny TX timestamping on a DSA master to
> something that doesn't block the kernel-wide API conversion from
> ndo_eth_ioctl() to ndo_hwtstamp_set().
> 
> What was required was a mechanism that did not depend on ndo_eth_ioctl(),
> and what was provided was a mechanism that did not depend on
> ndo_eth_ioctl(), while at the same time introducing something that
> wasn't absolutely necessary - a new netdev notifier.
> 
> There have been objections from Jakub Kicinski that using notifiers in
> general when they are not absolutely necessary creates complications to
> the control flow and difficulties to maintainers who look at the code.
> So there is a desire to not use notifiers.

Jakub is there a general desire to move away from notifiers? If so, do 
you have a list of things that may no longer belong there?

> 
> In addition to that, the notifier chain gets called even if there is no
> DSA in the system and no one is interested in applying any restriction.
> 
> Take the model of udp_tunnel_nic_ops and introduce a stub mechanism,
> through which net/core/dev_ioctl.c can call into DSA even when
> CONFIG_NET_DSA=m.
> 
> Compared to the code that existed prior to the notifier conversion, aka
> what was added in commits:
> - 4cfab3566710 ("net: dsa: Add wrappers for overloaded ndo_ops")
> - 3369afba1e46 ("net: Call into DSA netdevice_ops wrappers")
> 
> this is different because we are not overloading any struct
> net_device_ops of the DSA master anymore, but rather, we are exposing a
> rather specific functionality which is orthogonal to which API is used
> to enable it - ndo_eth_ioctl() or ndo_hwtstamp_set().
> 
> Also, what is similar is that both approaches use function pointers to
> get from built-in code to DSA.
> 
> There is no point in replicating the function pointers towards
> __dsa_master_hwtstamp_validate() once for every CPU port (dev->dsa_ptr).
> Instead, it is sufficient to introduce a singleton struct dsa_stubs,
> built into the kernel, which contains a single function pointer to
> __dsa_master_hwtstamp_validate().
> 
> I find this approach preferable to what we had originally, because
> dev->dsa_ptr->netdev_ops->ndo_do_ioctl() used to require going through
> struct dsa_port (dev->dsa_ptr), and so, this was incompatible with any
> attempts to add any data encapsulation and hide DSA data structures from
> the outside world.
> 
> Link: https://lore.kernel.org/netdev/20230403083019.120b72fd@kernel.org/
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
