Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72B8D47B3B4
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 20:28:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240816AbhLTT2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 14:28:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234524AbhLTT2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 14:28:00 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7206FC061574
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 11:28:00 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id r2so8415507ilb.10
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 11:28:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=cqQYwR83tYYqX9/SMgcfRUOxietuU7zLh8DSNEx/2qA=;
        b=qflu2p8+4BSzw9JuqzDuhr4awm+jyC6t/lvzUhQUMl7p24U+HzxuOzS4m4dVwW+0WL
         lr0bRYlHtA0wwYuzMZEqyZKa9vC+4+leL2KlM2tGbx20jLz0FWKoTkohEQ4hh4HYaxKp
         CrDBOmti9QmW3P8BzESpgcZKmaRi5tPuQanf7JFc8MD7BHqY789Zt3y08urJEFEk+755
         CgRO3VQfTKOPRW8jpWRFHfJL9X9KRwf8OEAZh0L6yEzVIjk+YFFaRQ5IXqMuFyM8rjFe
         SZb2HOcQPiOqJ/0WcS2QhxVJvF6NFjvvA3yJzoSdhuNiO9JyMG+R2ODZaNXSCuwb/Jk0
         djwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cqQYwR83tYYqX9/SMgcfRUOxietuU7zLh8DSNEx/2qA=;
        b=4Jkkv5yYpsJzeCQ3CKuYma5MGKgxRI5SPx0DsKMvsKXjXmwiJI4UqqHULYJgac/v5S
         1xU6iNyc6KyEZW8vFBmtpQyKoSVsTNopMv784t138juaI1yFStKzMyz67cKivBA+n+5H
         KIQ4PY+BQv3YsJtRVCGTnEs/IsiyWXynIHcw51mY3bHDeCXijAcC1lVnpuOoRwLDMJmQ
         sZ/0+oAYPfF7wTk61Q7epNX7lisr/IBaj5UkoEpZajcgX7Zwh3bRDCPP2faB1MBGDtMA
         j2jQObKLWNhg5nlkKsuNXm3HErMPTm0I31/OH8/Ob6uGq+wSxajUdQAPPKzb4SKaKpth
         3MtA==
X-Gm-Message-State: AOAM532DMW4xEqo874IttLr/jY0Fs7R2ViQqOBBclTSsY13OMaFCuHlo
        33ZUXLnSJe2AYKj78LFQr492DA==
X-Google-Smtp-Source: ABdhPJywiphV4anxdY+jc7876EkncD5US6OlP55IHi0FLqz3xXm7YWbch9DlyiUE27JdVEVbcxQCjw==
X-Received: by 2002:a92:c246:: with SMTP id k6mr8882990ilo.280.1640028479830;
        Mon, 20 Dec 2021 11:27:59 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id k10sm11139412ilu.80.2021.12.20.11.27.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Dec 2021 11:27:59 -0800 (PST)
Message-ID: <c71f1f98-13cc-ff82-7bf5-2c733de9ab2b@linaro.org>
Date:   Mon, 20 Dec 2021 13:27:58 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: Port mirroring (RFC)
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Network Development <netdev@vger.kernel.org>,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>
References: <384e168b-8266-cb9b-196b-347a513c0d36@linaro.org>
 <YbjiCNRffWYEcWDt@lunn.ch> <3bd97657-7a33-71ce-b33a-e4eb02ee7e20@linaro.org>
 <YbmzAkE+5v7Mv89D@lunn.ch> <b00fb6e2-c923-39e9-f326-6ec485fcff21@linaro.org>
 <Yboo9PtNslU+Y4te@lunn.ch>
From:   Alex Elder <elder@linaro.org>
In-Reply-To: <Yboo9PtNslU+Y4te@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/15/21 11:42 AM, Andrew Lunn wrote:
>>> Do you have netdevs for the modem, the wifi, and whatever other
>>> interfaces the hardware might have?
>>
>> Not yet, but yes I expect that's how it will work.
>>
>>> To setup a mirror you would do something like:
>>>
>>> sudo tc filter add dev eth0 parent ffff: protocol all u32 match u32 0 0 action mirred egress mirror dev tun0
>>
>> OK so it sounds like the term "mirror" means mirroring using
>> Linux filtering.  And then I suppose "monitoring" is collecting
>> all "observed" traffic through an interface?
> 
> Yes, that seems like a good description of the difference.
>   
>> If that's the case, this seems to me more like monitoring, except
>> I suggested presenting the replicated data through a separate
>> netdev (rather than, for example, through the one for the modem).
> 
> The wifi model allows you to dynamical add netdev on top of a physical
> wireless LAN chipset. So you can have one netdev running as an access
> point, and a second netdev running as a client, both sharing the
> underlying hardware. And you should be able to add another netdev and
> put it into monitor mode. So having a dedicated netdev for your
> monitoring is not too far away from what you do with wifi.

It sound to me like WiFi monitoring mode could very much be
a model that would work.  I need to spend some time looking
at that in a little more detail.  I don't think there's any
reason the "dedicated" netdev couldn't be created dynamically.

I'll come back again after I've had a chance to look at these
suggestions (yours and others'), possibly with something closer
to a design to follow.

Thank you very much, this is a promising lead.

					-Alex

>> If it makes more sense, I could probably inject the replicated
>> packets received through this special interface into one or
>> another of the existing netdevs, rather than using a separate
>> one for this purpose.
> 
>>> Do you have control over selecting egress and ingress packets to be
>>> mirrored?
>>
>> That I'm not sure about.  If it's possible, it would be controlling
>> which originators have their traffic replicated.
> 
> You need this if you want to do mirroring, since the API requires to
> say if you want to mirror ingress or egress. WiFi monitoring is less
> specific as far as i understand. It is whatever is received on the
> antenna.
> 
>> I don't think it will take me all that long to implement this, but
>> my goal right now is to be sure that the design I implement is a good
>> solution.  I'm open to recommendations.
> 
> You probably want to look at what wifi monitor offers. And maybe check
> with the WiFi people what they actually think about monitoring, or if
> they have a better suggestion.
> 
>       Andrew
> 

