Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5CE84DC232
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 10:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbiCQJC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 05:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbiCQJCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 05:02:25 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A1151D08D1
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 02:01:09 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id m12so5668664edc.12
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 02:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=mqnfH2RwXdarMVwKF+nv5QuaQLBfob4wf1DSy23UJb4=;
        b=ul+xv5XYmQa87mwY3Pl+CK3Ymdn+nwciL6xvIH8oADHISfZR0NKOusBw8asM5BCN5Q
         qNFfCEriVVS79FjTiU6SruM/gVMc6CyJFqeesfFHqBHI92P6HgRR0QoT5l/q92Ujog2t
         5MvsWjoy5X8TmfL9YyRZduQqtJt66dfQV8X0rmXUYWXl34Iaw0NsuqquFf+yJPvlXqqw
         ftGEAR2D9HfB3RKrtYJIVtwp1i4nC15nfwiI1u3ekuPeFIHBOAZ+BnCRWwGUSdOn7Zwq
         phVnIBo+kgXQvTImtHkHCRbra3oO3zSP+J8qUBfLMCmxR5gSxvCI8VXQKxGb5cCjUQSj
         9uLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mqnfH2RwXdarMVwKF+nv5QuaQLBfob4wf1DSy23UJb4=;
        b=ueg7rTS58AKNpEFfE6oEGkOs9gvzG3rbQ6BboHwm2K4TXRD0Hcpeer2yQz2TDEGTY4
         ngvTIxKh9Jcgem03P7ACBXZPS2UeNGg7oRArwympCxSWNZ+aEBr7htGCGw/+CUH4DJcz
         c67RpvNY+ByfnnDa3/och5hDOxuFEgAXzoTcERGkakOnbTmsuaNOfzAPh4n+dLHai0bM
         v/8lH/vIHHv79idorY7l9f8wacUWaZuiQPuVyvF4uAN2ktZhDH9+0aw5cS71WHZVa9U2
         3UBI7VwTJtx/wCIZ2hjZDogzpyzv01EkJOnGgNfY8JI8EDqNN25lW0k7dJHzwWbNZXxz
         vAng==
X-Gm-Message-State: AOAM531Bf9zXC9+SmD15keIo3vVUWEAyCEvmjfaSrLMCGDk4PieItFX5
        VKA9rVZu4Ay2DUS+/Dm6yLtHrA==
X-Google-Smtp-Source: ABdhPJwA93yiQ1QO4LSQtMVQKkdC8xuzOclHDYnGksSW2Bv3VF1oVflM5cU1QAJkzrUl7wnTlM6Z+g==
X-Received: by 2002:a05:6402:430c:b0:416:c695:7c23 with SMTP id m12-20020a056402430c00b00416c6957c23mr3179483edc.367.1647507668159;
        Thu, 17 Mar 2022 02:01:08 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id kw3-20020a170907770300b006b2511ea97dsm2050088ejc.42.2022.03.17.02.01.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Mar 2022 02:01:07 -0700 (PDT)
Message-ID: <68e92033-1dea-87bd-bc9b-8b2abdaa4a85@blackwall.org>
Date:   Thu, 17 Mar 2022 11:01:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v5 net-next 07/15] net: bridge: mst: Add helper to map an
 MSTI to a VID set
Content-Language: en-US
To:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Russell King <linux@armlinux.org.uk>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Cooper Lees <me@cooperlees.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
References: <20220316150857.2442916-1-tobias@waldekranz.com>
 <20220316150857.2442916-8-tobias@waldekranz.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220316150857.2442916-8-tobias@waldekranz.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/03/2022 17:08, Tobias Waldekranz wrote:
> br_mst_get_info answers the question: "On this bridge, which VIDs are
> mapped to the given MSTI?"
> 
> This is useful in switchdev drivers, which might have to fan-out
> operations, relating to an MSTI, per VLAN.
> 
> An example: When a port's MST state changes from forwarding to
> blocking, a driver may choose to flush the dynamic FDB entries on that
> port to get faster reconvergence of the network, but this should only
> be done in the VLANs that are managed by the MSTI in question.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>  include/linux/if_bridge.h |  7 +++++++
>  net/bridge/br_mst.c       | 26 ++++++++++++++++++++++++++
>  2 files changed, 33 insertions(+)
> 

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>


