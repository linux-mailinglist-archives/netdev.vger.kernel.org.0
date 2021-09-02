Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35B0A3FE81F
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 05:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238426AbhIBDoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 23:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233122AbhIBDod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 23:44:33 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8330DC061575
        for <netdev@vger.kernel.org>; Wed,  1 Sep 2021 20:43:35 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id x16so349145pll.2
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 20:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=06oJVobgJMN4H7fdxz+D5+jN5GKZmFGLPHb9wm8u/60=;
        b=MTLKgC5LnTnxridTmWA4UvW1QddK6t1gg+bNnli38NTNOLt1Ft0NaNszH9UYWakNDS
         ezX32zSVpFPIR1s5RPDw2Lh3GE4pnPpdwJ+kIam0RZIsQo1CLDzONXDQTE2CFH/+l2VS
         tyYHUaH4zdFijiZOXvsJWvxzSNFSWP4PtF0BRFWz8WQhELzpgG92RlepCCWcx6nf2z+X
         H1bmjFcZ4lBR7dMlZah+4L8UfgYyoL+hXbsN63DszCYvcyw3dJXrcg5dD2bfXPvDl/A5
         SzULfv2i8KNfWb4JXSlzaQeWl1mX8lsfCr7VLoodVBzU+7BWDnAP3VxCEGkXBW5vsp25
         bT4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=06oJVobgJMN4H7fdxz+D5+jN5GKZmFGLPHb9wm8u/60=;
        b=c1H1AJg7Bx0NM47b1Bg4Mumb75eWLwMh9eGlz7tqPt64lUfjaP+akJnO3d4ldinxRO
         ugIAc4WSAk/6rzA/WUQdU4N3AIDN4O2V8H+DFwaTUmygVGkhWQmR9L/KY6wOpMq7bieQ
         QAF770G/Z0CkC6PUDGsKbBqhTCE0xpD32Z4pOBrenz8OisWBkr4EbmeSzvg39pMiG5aR
         fYz//oRlbXi554yLvUg+UeKtxMonnKqAxlPwCYr5a6hAp5elFC4ABXFOiOTYoULu1XTI
         U3RIxorT2dMhNialbuYvSElWt+EoAPl4xywchRqA1VuFa59Va797F4aZWee0nVuDdKFQ
         34+w==
X-Gm-Message-State: AOAM533VtLyjRq+cwu67fuTQROE/RzgZlDustaYffgRgp9Y+Vfl1Z95a
        5nf2q+7Gxe84B5k2pmdCSk4=
X-Google-Smtp-Source: ABdhPJzQnkG4rt0lUpzrZI7kp4S5j/PfWYEs/ADIIBgYDSgrsp22OyLR7rq4y9jaDYXgqaCSVHW+0g==
X-Received: by 2002:a17:90a:1a4c:: with SMTP id 12mr1392673pjl.195.1630554214978;
        Wed, 01 Sep 2021 20:43:34 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.45.42.119])
        by smtp.googlemail.com with ESMTPSA id i21sm392816pfr.183.2021.09.01.20.42.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 20:43:15 -0700 (PDT)
Subject: Re: [EXTERNAL] Re: Change in behavior for bound vs unbound sockets
To:     Saikrishna Arcot <sarcot@microsoft.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Mike Manning <mmanning@vyatta.att-mail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
References: <BL0PR2101MB13167E456C5E839426BCDBE6D9CB9@BL0PR2101MB1316.namprd21.prod.outlook.com>
 <06425eb5-906a-5805-d293-70d240a1197b@molgen.mpg.de>
 <e8ea879b-7075-e79d-5da8-0483e7da21af@gmail.com>
 <BL0PR2101MB1316DCC9FFC2B0BBA9F66815D9CE9@BL0PR2101MB1316.namprd21.prod.outlook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5cada65e-9d75-ca9b-e0cc-0722ad71086d@gmail.com>
Date:   Wed, 1 Sep 2021 20:41:57 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <BL0PR2101MB1316DCC9FFC2B0BBA9F66815D9CE9@BL0PR2101MB1316.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/1/21 5:16 PM, Saikrishna Arcot wrote:
> 
>> On 8/31/21 7:29 PM, Paul Menzel wrote:
>>>> Is the intention of those commits also meant to affect sockets that
>>>> are bound to just regular interfaces (and not only VRFs)? If so,
>>>> since this change breaks a userspace application, is it possible to
>>>> add a config that reverts to the old behavior, where bound sockets
>>>> are preferred over unbound sockets?
>>> If it breaks user space, the old behavior needs to be restored
>>> according to Linux' no regression policy. Let's hope, in the future,
>>> there is better testing infrastructure and such issues are noticed earlier.
>>
>> 5.0 was 2-1/2 years ago.
> 
> Does that mean that this should be considered the new behavior? Is it
> possible to at least add a sysctl config to use the older behavior for
> non-VRF socket bindings?
> 
>>
>> Feel free to add tests to tools/testing/selftests/net/fcnal-test.sh to cover any
>> missing permutations, including what you believe is the problem here. Both IPv4
>> and IPv6 should be added for consistency across protocols.
>>
>> nettest.c has a lot of the networking APIs, supports udp, tcp, raw, ...
> 
> Let me try to add a test case there. I'm guessing test cases added there
> should pass with the current version of the kernel (i.e. should reflect the
> current behavior)?
> 

Let's start by seeing test cases that demonstrate the problem.
