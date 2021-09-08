Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 985004040E6
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 00:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234769AbhIHWQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 18:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbhIHWQC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 18:16:02 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4ADCC061575;
        Wed,  8 Sep 2021 15:14:54 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id u18so4136291pgf.0;
        Wed, 08 Sep 2021 15:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=BW2XFQ+vdFuMwvMllsLN+uOucqZpZfhXxbldEaxy1SE=;
        b=EgAjfHwklApqowIV/mXqbc8WEGSA/W/uhdMFJfYPpFpGIbOpe4Yrw+IvwXXJ7MEg+n
         ypOmLNVd944b57tx8is+6ROMpQTMlS9DDY5Rr8z0fPNSpH5/RJPGhigu2LHSNPox9OaN
         zafqBGSm10EYrG4yDy2R0uOrTWZ63Yd7/dD5Ylt0hg0VwZs6CxrZunc8rpF1Vl03hbZ3
         1g93qnKle6Su3P5BFFtLNt44c/U4X/S8/9gcuVWOni8VqGT888GyGb4mJW3vA42rplFO
         GcAOtO8Qpy2NFWXIncM4ljuxgqePbj/RX8GlNQQcXWMVsBg86LM509Bc9HL+RK/fIIrJ
         Bpyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BW2XFQ+vdFuMwvMllsLN+uOucqZpZfhXxbldEaxy1SE=;
        b=ah99+iU/PMv/8vCv6zzL7RXEKkqTyJcsMEKG6giNhXGryEgDQBACzxbOlgiPVM+JBz
         mGMMTqL1kB1fCAYLHa2z6iBz1FC96crfluMKguglETz6X2cJUS8JgU8UJCim73XIxN4G
         k27P/V1HmX4cv+i6CBOdwuFHPMc6psSYe0elNFgyONHay4mCneNYLJ6PW6dAg4Hlws8X
         snV8vP8Q4qPJmGhWqXHUJUr0iyXRT/+6rzYYswqDlxvxW8hlH9aKbe58UO4snhtdPAgd
         mWOJKdraS0xh4GCF1Sc/IdsDf2fSGi76RXOIaq0rq4RU8abtRLU9VJPSCM3ogRPxeUZs
         adMw==
X-Gm-Message-State: AOAM532O2nBBJt0jLGt/BCtSOrGGrnzuPobEuFwcD441U0VY/x78pcLp
        29OZs/Dch35rJcatFqQjbNXUjYaxlQs=
X-Google-Smtp-Source: ABdhPJwBhSr/G+bHAWkUiI4Pu9udgZZDMeIw4Xxt+j+YkaZsvkmmK7HLqXZHJnjrxUaDj/0RUp3pmQ==
X-Received: by 2002:a65:624b:: with SMTP id q11mr356347pgv.232.1631139294180;
        Wed, 08 Sep 2021 15:14:54 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id x15sm165632pgt.34.2021.09.08.15.14.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 15:14:53 -0700 (PDT)
Message-ID: <e0567cfe-d8b6-ed92-02c6-e45dd108d7d7@gmail.com>
Date:   Wed, 8 Sep 2021 15:14:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: Circular dependency between DSA switch driver and tagging
 protocol driver
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210908220834.d7gmtnwrorhharna@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210908220834.d7gmtnwrorhharna@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/8/2021 3:08 PM, Vladimir Oltean wrote:
> Hi,
> 
> Since commits 566b18c8b752 ("net: dsa: sja1105: implement TX
> timestamping for SJA1110") and 994d2cbb08ca ("net: dsa: tag_sja1105: be
> dsa_loop-safe"), net/dsa/tag_sja1105.ko has gained a build and insmod
> time dependency on drivers/net/dsa/sja1105.ko, due to several symbols
> exported by the latter and used by the former.
> 
> So first one needs to insmod sja1105.ko, then insmod tag_sja1105.ko.
> 
> But dsa_port_parse_cpu returns -EPROBE_DEFER when dsa_tag_protocol_get
> returns -ENOPROTOOPT. It means, there is no DSA_TAG_PROTO_SJA1105 in the
> list of tagging protocols known by DSA, try again later. There is a
> runtime dependency for DSA to have the tagging protocol loaded. Combined
> with the symbol dependency, this is a de facto circular dependency.
> 
> So when we first insmod sja1105.ko, nothing happens, probing is deferred.
> 
> Then when we insmod tag_sja1105.ko, we expect the DSA probing to kick
> off where it left from, and probe the switch too.
> 
> However this does not happen because the deferred probing list in the
> device core is reconsidered for a new attempt only if a driver is bound
> to a new device. But DSA tagging protocols are drivers with no struct
> device.
> 
> One can of course manually kick the driver after the two insmods:
> 
> echo spi0.1 > /sys/bus/spi/drivers/sja1105/bind
> 
> and this works, but automatic module loading based on modaliases will be
> broken if both tag_sja1105.ko and sja1105.ko are modules, and sja1105 is
> the last device to get a driver bound to it.
> 
> Where is the problem?

I'd say with 994d2cbb08ca, since the tagger now requires visibility into 
sja1105_switch_ops which is not great, to say the least. You could solve 
this by:

- splitting up the sja1150 between a library that contains 
sja1105_switch_ops and does not contain the driver registration code

- finding a different way to do a dsa_switch_ops pointer comparison, by 
e.g.: maintaining a boolean in dsa_port that tracks whether a particular 
driver is backing that port
-- 
Florian
