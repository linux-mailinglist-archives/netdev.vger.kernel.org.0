Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDA0475AFA
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 15:48:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237842AbhLOOry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 09:47:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237689AbhLOOry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 09:47:54 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A79E2C061574
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 06:47:53 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id z26so30435888iod.10
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 06:47:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Q9CN6SO3RP9S5GhQgwdT2vrKKpdACwv2K6adHjgM8XA=;
        b=imdT8U6xGCJJnA2SIYBQ1+xOcxL2iXOlJ0pBda33g5MrBqqlTbxBIMVjexcDcRDZdk
         1zDjWpl2xiUMAnhnTkJI6HzjdIwzVQDr1qFoU0KQcV6/O19uRVjXZ2jy3Fe+fr8XAsGB
         o7o2u0KjKIWYg4puy5lGtzairB/vrXtgUACS0erIMx/X5RrvW77sQUuYxAqp+ZzmTS6W
         pL1sv7tkzf6gtBCCAiQYtB8ke7uspA5JMDcsmiQFlvsXt+Ba758wB5LM/yXYQuO03t/L
         LpGDp7SxjN3KGIOULanDHPRgMez0lCEP+z2YeVgpNNea6hKbMllsGTncAfUukKqDaHay
         Kg/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Q9CN6SO3RP9S5GhQgwdT2vrKKpdACwv2K6adHjgM8XA=;
        b=Du2gJgp+HNASZj6WpC28OW8Gv614fO2sD2isCD21esuAcKnV3vGh/07W9TXI6qxcXC
         tKyB4oBuYud67Yf53U/EWcc/o0af28NcEwNd+YUs6szBOmGw0uR/YfIoggqLxCPwgG7f
         BwMRfC/YTvi49UMYGzoUkg4kQ/nbj+FkZVNEIfEsMz4VEGSVwraQTtDDJUlrxlkekxek
         SFC+2WAFMlcscmnQiGKZTToFOvhryT3k8Spz4zzFTibfFcOW/kpzti4hL2iaWB2k5d4/
         swswtZRKPtWWXZhmuxDl4E13zc2L/KbkI9BvNxzdqP2XzDEtVSHckkvj9jUd1G6G2++x
         qmhA==
X-Gm-Message-State: AOAM5317yd6sM3MbAFW3EV4+cIe4abts9fIhvPWyviZqUAqbtA3w6mob
        CAzF74XHIJES1ZjBHQarNTBJYLH3rNITOUrl
X-Google-Smtp-Source: ABdhPJw518KuglimqRVvs9pfLlsh8qIGpSrIBDatyk10ZlooY7i64s9MAIT2xNx76CbmK8uDTMpQLQ==
X-Received: by 2002:a05:6638:2501:: with SMTP id v1mr6122327jat.289.1639579672956;
        Wed, 15 Dec 2021 06:47:52 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id d16sm966601ila.51.2021.12.15.06.47.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Dec 2021 06:47:52 -0800 (PST)
Message-ID: <b00fb6e2-c923-39e9-f326-6ec485fcff21@linaro.org>
Date:   Wed, 15 Dec 2021 08:47:51 -0600
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
 <YbmzAkE+5v7Mv89D@lunn.ch>
From:   Alex Elder <elder@linaro.org>
In-Reply-To: <YbmzAkE+5v7Mv89D@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/15/21 3:18 AM, Andrew Lunn wrote:
>> IPA is a device that sits between the main CPU and a modem,
>> carrying WWAN network data between them.
>>
>> In addition, there is a small number of other entities that
>> could be reachable through the IPA hardware, such as a WiFi
>> device providing access to a WLAN.
>>
>> Packets can travel "within IPA" between any of these
>> "connected entities."  So far only the path between the
>> AP and the modem is supported upstream, but I'm working
>> on enabling more capability.
>>
>> Technically, the replicated packets aren't visible on
>> any one port; the only way to see that traffic is in
>> using this special port.  To me this seemed like port
>> mirroring, which is why I suggested that.  I'm want to
>> use the proper model though, so I appreciate your
>> response.
> 
> Do you have netdevs for the modem, the wifi, and whatever other
> interfaces the hardware might have?

Not yet, but yes I expect that's how it will work.

> To setup a mirror you would do something like:
> 
> sudo tc filter add dev eth0 parent ffff: protocol all u32 match u32 0 0 action mirred egress mirror dev tun0

OK so it sounds like the term "mirror" means mirroring using
Linux filtering.  And then I suppose "monitoring" is collecting
all "observed" traffic through an interface?

If that's the case, this seems to me more like monitoring, except
I suggested presenting the replicated data through a separate
netdev (rather than, for example, through the one for the modem).

If it makes more sense, I could probably inject the replicated
packets received through this special interface into one or
another of the existing netdevs, rather than using a separate
one for this purpose.

> where you are mirroring eth0 to tun0. eth0 would have to be your modem
> netdev, or your wifi netdev, and tun0 would be your monitor device.
> 
> If you do have a netdev on the host for each of these network
> interfaces, mirroring could work. Architecturally, it would make sense
> to have these netdevs, so you can run wpa_supplicant on the wifi
> interface to do authentication, etc.
> 
> Do you have control over selecting egress and ingress packets to be
> mirrored?

That I'm not sure about.  If it's possible, it would be controlling
which originators have their traffic replicated.

I don't think it will take me all that long to implement this, but
my goal right now is to be sure that the design I implement is a good
solution.  I'm open to recommendations.

Thanks.

					-Alex

> 	Andrew
> 

