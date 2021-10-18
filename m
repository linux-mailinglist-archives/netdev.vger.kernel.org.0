Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 045A74323BC
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 18:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232625AbhJRQZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 12:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232002AbhJRQZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 12:25:05 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EA6DC06161C;
        Mon, 18 Oct 2021 09:22:54 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id f5so16735413pgc.12;
        Mon, 18 Oct 2021 09:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=K9RWkzeMAfSwlhLw/IZbyIy/WvLVAmgmUE5Uc2jrZgM=;
        b=FZ4p4ILnOq44RnNmos7gOOxBh4D+4krW5UQbP40kSYM1BaKw7cajbBbMqHKTsUFlTD
         u2WujMP7V/jo6gorFgbfKgvy7paXnZDhewXJxO4VtHCHmauxFJKjP2dvI44xxL5oIT1b
         3eJyoTXIZ8HaC2x0B3kEEvEmPbRW4eTQ3c+JdOVW+ZjbeV8mpMauce76LF4pe99cf40r
         LSZNj6gM5hCOIbuoUKd6xLdsIjnVOcCKCWZgVqqMUZaPVZ8elImebqjSfF6z5/V1O6H+
         9V5FdtTgZ7U4XKG7Qezff2UdQakb3k6oTqOSscCBxkIUx2yabA3KGiHIEjI8HHRBcMgD
         F3jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K9RWkzeMAfSwlhLw/IZbyIy/WvLVAmgmUE5Uc2jrZgM=;
        b=gMxQ6o6nzZ47evQxoiaXkHMDACyE0ZOZMK7WyybmUt7GxQ66b12ba5mzyOABRaLP22
         H6ZfWkXLB07nsEKNjVkLPQlB0xVgsXAMS8NcI92mJqKfZk8y6UdneJGZSs9mDWmxkY8t
         KqS5/sH0iklQAfMlhYCggFcBVcLSh6K0Sgu4G/UJnHR5W0M1+azyr8yB1qY/DzbBbza6
         BRNVJgb6FekjGAZOUtx6eAV/GVbRBVncCOQQNqKox3IArr07lAJKrdrNMyp6p+jdRsU2
         cpY230AT7V52Sq5ROsdMroF6OY+cJ1nILkNm2QGPpJfUcEj8yMUo8Pw4Nqt06aZpeD8P
         EUcg==
X-Gm-Message-State: AOAM530gCT7vbKlCHp01GrNWyPuSmlnayPUEWXoVOvz66iUCijaLmOHy
        cF7/YH6fGDRJwhjnKDTzNL62eoAGqqw=
X-Google-Smtp-Source: ABdhPJxRVOVDeLyMBPWn36zcpI7DgFqX6WU0NUjkv+GOII8wdKYQh2sAg+1C9Z8jboLdwXCg6BmHhg==
X-Received: by 2002:a63:7355:: with SMTP id d21mr12764671pgn.179.1634574173231;
        Mon, 18 Oct 2021 09:22:53 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id bb12sm350785pjb.0.2021.10.18.09.22.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 09:22:52 -0700 (PDT)
Subject: Re: [PATCH net] net: dsa: mt7530: correct ds->num_ports
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20211016062414.783863-1-dqfext@gmail.com>
 <cd6a03b9-af49-97b4-6869-d51b461bf50a@gmail.com>
 <20211018084230.6710-1-dqfext@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7b5e5fcf-8e7f-45ec-de3f-57b3da77b479@gmail.com>
Date:   Mon, 18 Oct 2021 09:22:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211018084230.6710-1-dqfext@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/18/21 1:42 AM, DENG Qingfang wrote:
> On Sat, Oct 16, 2021 at 07:36:14PM -0700, Florian Fainelli wrote:
>> On 10/15/2021 11:24 PM, DENG Qingfang wrote:
>>> Setting ds->num_ports to DSA_MAX_PORTS made DSA core allocate unnecessary
>>> dsa_port's and call mt7530_port_disable for non-existent ports.
>>>
>>> Set it to MT7530_NUM_PORTS to fix that, and dsa_is_user_port check in
>>> port_enable/disable is no longer required.
>>>
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
>>
>> Do you really want to target the net tree for this change?
> 
> Yes because I consider this a bug fix.


OK, why not provide a Fixes tag to help with targeting the back port
then? This has been applied anyway, so hopefully the auto selection will
do its job and tell you where it stops applying cleanly.
-- 
Florian
