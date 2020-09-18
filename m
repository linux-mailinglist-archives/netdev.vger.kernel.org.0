Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D109026EF11
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 04:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729019AbgIRCcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 22:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729971AbgIRCcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 22:32:47 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94CF4C06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 19:32:47 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id l71so2557978pge.4
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 19:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jtQzfdjb16J0qJH4lNyH6SwJ1q3Pk5eeTGzrrrU1voY=;
        b=aDnwjDFlPoGDksuon2tu8ag64fenxIB8nFqnSl63MGE2UAu7KSaEov4gRgAG5I5a8x
         9DEF7dCfleS7nN2WadJ+qCf35iIidxjpNOCjVVqic5rJSWaDmUDC9VIq9inc7Cx/YXjp
         o2guObjVaEHx/b5fAihEWhOXnPwQPpzcDEL9421NZPBqYJ0/VRAEfaESLGUtmT7/Bl3X
         4mwhd/LczmukbpvWGrjnJWjcmtEzUNsk4xW9XA1XCZ0MDcmKS4E4H99xq8NQLZZailsa
         eTDWHDUvT+FOjd1WJSmjkrJ72QdTY3BBqXtVg2mFBwEOO1OitpZ82qulOU4vYV/rmDoL
         dOlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jtQzfdjb16J0qJH4lNyH6SwJ1q3Pk5eeTGzrrrU1voY=;
        b=as5Hw4frJ3URsGA8PI5/jYN9NaPJ+8svojTqht4+Za4mNY6UuMlnElbODZamzYPXBb
         Hy/LkCm1azOYb0yeFWCOFA0Agu9MhjDDO3LSjU9k+OVHsV0ugh4XsgGGOu8TpYawBJLQ
         dVtRPiQWu87aBwpKvYNGLFaI8rho65f+xYTXQHkDRt9B9/K/uXjvmjr1BVOl1uQFrxgy
         JH8lp0c0kVy1UJSMZpXOlh2TlbjVWyrfkyI8SQHAGsBFfpXVU8VAJiVCMDoyx3wFgg7Y
         4GaEPuezpTnHvAbx2rVMTDxYBiLc6mZA6zoYiDjCpPm/26JpnGTy9z2wV+gf45sl56pj
         Ro2Q==
X-Gm-Message-State: AOAM530bS0oHXaVcrePtB6alkXThF81NKK/MNgoqwbyNvn9BP1T8/H+i
        KTNxraYQNjBtBeQBdY++PcQ8NqVtYu+TMw==
X-Google-Smtp-Source: ABdhPJy37lx1y99i47d9dtgq/71RToeUaUQak4iCPKjasFOoAJESAJk97zA+udOIGPjtqpyPvB8w5w==
X-Received: by 2002:aa7:934e:0:b029:13f:d056:593 with SMTP id 14-20020aa7934e0000b029013fd0560593mr24120021pfn.15.1600396367177;
        Thu, 17 Sep 2020 19:32:47 -0700 (PDT)
Received: from [10.230.28.120] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 84sm1045743pfw.14.2020.09.17.19.32.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2020 19:32:46 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 8/9] net: dsa: wire up devlink info get
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Vladimir Oltean <olteanv@gmail.com>
References: <20200909235827.3335881-1-andrew@lunn.ch>
 <20200909235827.3335881-9-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <54fdd7e3-01b3-91ad-cfd3-b22829648e83@gmail.com>
Date:   Thu, 17 Sep 2020 19:32:40 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200909235827.3335881-9-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/9/2020 4:58 PM, Andrew Lunn wrote:
> Allow the DSA drivers to implement the devlink call to get info info,
> e.g. driver name, firmware version, ASIC ID, etc.
> 
> v2:
> Combine declaration and the assignment on a single line.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
