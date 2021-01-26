Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76DCA304D30
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 00:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731678AbhAZXE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:04:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731531AbhAZR3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 12:29:30 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64AE7C061574
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 09:28:50 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id f6so16949721ots.9
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 09:28:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=qceIJPuvwBhbUT4tfL0wIPP2rk7kq8akZxQazjJf5hU=;
        b=uWVwQnDl5e3JPmHE5Vkn0NSLdt7/xAvb1o1Qyk0ert41qDxI+reLoA2KYWUz2e/4YQ
         D7FXQNnbLrhfftiGsfC+U9oM6myU2tIMt4MA+B/mSQDV2WDjUz1iGW2wBr4KdWvb/ldN
         FC4qX1aSnEG8BAP+U4vkDWaxhBo6/s0nhSUgbFvba5C5s/74GdVRpZkH6eWYnE9TY1FP
         ixkoEY+BDRa3K6P9V0e9KDwpZ4DKuIr/Jz1rdVf84K196z9K1ErCrY2xO4a39CZFdxuo
         B1PfSpAn1PW9X0y4uah9aON7wCo2ZezyJKvoQN3auLjyPoINtFA4NOHwWxAbEercyBgG
         dd5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qceIJPuvwBhbUT4tfL0wIPP2rk7kq8akZxQazjJf5hU=;
        b=n/Wq53rF9tFlVpBbHeOta7/6Z9Syz3+11RSTvAbqaVAXX3uWZnoN41Mmz0XKRJUQMY
         FxSGheR+GGUAzJSmpRCVKzW1dHfqnuCoPuSpsvFVR5YDRbmtE3BId72zDYlC4Cl00ZAO
         JVgIu2z6ium589JeCqR3lsu+hAGwyjQIa+uS/OPD427YgfOvDcGSHllV8cIqMspLxiOL
         V07a8NMzjJwsXLagSL4Me0GOlzVEzMPxCePieG2A6iaWalPJ+9aJ32fuvN+Dl9TcMIkR
         BBNKMgW9+U0RLCGVwVy2JsOQiiBxYeGRkWD4+kTCHHV/EbQwq96QxVrhPE1JrgRsagZK
         y05Q==
X-Gm-Message-State: AOAM533iIu5zQSu2HTCCMfhfu9a6UDC5MzqEXjI0ZFLeuJWNGeyWnksL
        6CepaJqWJVc5Myusvg5RjrpZwXsaTSs=
X-Google-Smtp-Source: ABdhPJyf9pmn6GIUONyVsLWOVLJORX+JlG6JIrx1BEbq+l3kVfHHYcFiTmBuTIvDjpm3WVVeYuZ1aQ==
X-Received: by 2002:a05:6830:1ac3:: with SMTP id r3mr5077861otc.363.1611682129695;
        Tue, 26 Jan 2021 09:28:49 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:f5f4:6dbf:d358:29ee])
        by smtp.googlemail.com with ESMTPSA id t12sm1781929ooi.45.2021.01.26.09.28.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 09:28:48 -0800 (PST)
Subject: Re: VRF: ssh port forwarding between non-vrf and vrf interface.
To:     Ben Greear <greearb@candelatech.com>,
        netdev <netdev@vger.kernel.org>
References: <7dcd75bb-b934-e482-2e84-740c5c80efe0@candelatech.com>
 <2dbd0ccb-9209-5682-0ae2-207cc02086ab@gmail.com>
 <2ce42f10-8884-074e-9992-edd29db22d5d@candelatech.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9f442307-dd27-7493-3774-4ec72f344003@gmail.com>
Date:   Tue, 26 Jan 2021 10:28:43 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <2ce42f10-8884-074e-9992-edd29db22d5d@candelatech.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/25/21 8:18 AM, Ben Greear wrote:
> On 1/22/21 8:02 AM, David Ahern wrote:
>> On 1/22/21 8:45 AM, Ben Greear wrote:
>>> Hello,
>>>
>>> I have a system with a management interface that is not in any VRF, and
>>> then I have
>>> a port that *is* in a VRF.  I'd like to be able to set up ssh port
>>> forwarding so that
>>> when I log into the system on the management interface it will
>>> automatically forward to
>>> an IP accessible through the VRF interface.
>>>
>>> Is there a way to do such a thing?
>>>
>>
>> For a while I had a system setup with eth0 in a management VRF and setup
>> to do NAT and port forwarding of incoming ssh connections, redirecting
>> to VMs running in a different namespace. Crossing VRFs with netfilter
>> most likely will not work without some development. You might be able to
>> do it with XDP - rewrite packet headers and redirect. That too might
>> need a bit of development depending on the netdevs involved.
>>
> 
> Maybe easier to improve ssh so that it could specify a netdev to bind to
> when
> making the call to the redirected destination?
> 

maybe. I did not realize this feature made it into ssh, but it has
supported 'rdomains' since 2017 I believe. For Linux rdomain is a VRF.
