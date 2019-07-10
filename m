Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2C3D64C95
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 21:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728007AbfGJTNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 15:13:06 -0400
Received: from mail-io1-f44.google.com ([209.85.166.44]:40313 "EHLO
        mail-io1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727612AbfGJTNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 15:13:06 -0400
Received: by mail-io1-f44.google.com with SMTP id h6so7127170iom.7
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 12:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VxSqNnFjCAOcacK4L3opP40vRnWk56QHAMZu/RcZn9c=;
        b=PPCsDVhPZV1HI2YPTWxLQtygmCVvkDthj2HV8gtIeYrPFOQ4SIOAtL/O+ZTt4ki6Ja
         6fhtVeUxZQkYZ5T+mFF4phPhlKAiBPAq6jJFYQw+E7PIiGP4eEb2DWkvW3/g1qbHbpde
         XSuwc9bg28ICtKLJbXZLGR5j08pC0fMH4ZdPR9WVkYoIoZuIZzz6vFyvp9u9lnEoO93Z
         bLPvaLsNRwgv097xLKw1ew1Rt6onIMcCTXWYUbh8/GLNZoKc5fOHY6e0Q8DpIHhlOCTQ
         QnHCs23bT+mcunWbCrxSasOqr5Ju16z10RAvTbgSR76pUOG08Vb1yfWr8j8+0r3j12Cp
         iUSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VxSqNnFjCAOcacK4L3opP40vRnWk56QHAMZu/RcZn9c=;
        b=NqxfKgaDuj9GWhi6fZEfpicHpBz199Pqzv5CejsNVClwR/R4rH6WD8Flk/b/HHgvi2
         xzDZPWIn2gpoKr/nWfjyGK28zny6Yo2BCxTOU+NHafrHCebhKtZPneNhRVjd25YO9NDm
         iumaPv245eANAd3i9PL+mL+cIMKEDJY2I7LXctNqRgWtZ8heLsowi9K8BIOMPfY93qel
         KoHS073u5S7U2NCk4VNF9L5OMc2IkIh78UHbjczcVt4o3MykHKR10gncWqR29MTq4+oW
         9D2ZOm6G/Ym7wkuya6ZMXZj8iQolVq1pbu3ndOOTzvKkcJ/Ci2f3Jgu68EhINTjTbmkI
         f5RQ==
X-Gm-Message-State: APjAAAWFXJQsROa6gFcJTIgUdJl9PKLW1OUp6ooH2DApSF41n0e2r8HV
        eg1ahcdpyUlutbsfekgYGHRm0QcE
X-Google-Smtp-Source: APXvYqy03RyHJdwjubG/wcqa04UnQ1C0N69pcxAXRve7VTKYAhV+FpC+WsAnn/xjYkNvgZiF1T6uNQ==
X-Received: by 2002:a6b:dc13:: with SMTP id s19mr16235127ioc.53.1562785985243;
        Wed, 10 Jul 2019 12:13:05 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:3913:d4da:8ed6:bdf3? ([2601:282:800:fd80:3913:d4da:8ed6:bdf3])
        by smtp.googlemail.com with ESMTPSA id c81sm3588065iof.28.2019.07.10.12.13.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Jul 2019 12:13:04 -0700 (PDT)
Subject: Re: Question about linux kernel commit: "net/ipv6: move metrics from
 dst to rt6_info"
To:     Stefano Brivio <sbrivio@redhat.com>,
        Jan Szewczyk <jan.szewczyk@ericsson.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Wei Wang <weiwan@google.com>, Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>
References: <AM6PR07MB56397A8BC53D9A525BC9C489F2F00@AM6PR07MB5639.eurprd07.prod.outlook.com>
 <cb0674df-8593-f14b-f680-ce278042c88c@gmail.com>
 <AM6PR07MB5639E2AEF438DD017246DF13F2F00@AM6PR07MB5639.eurprd07.prod.outlook.com>
 <20190710210954.530d72a5@elisabeth>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5981b8d0-cfdf-d230-fa22-cfcfaa5ee4b9@gmail.com>
Date:   Wed, 10 Jul 2019 13:13:03 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190710210954.530d72a5@elisabeth>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/10/19 1:09 PM, Stefano Brivio wrote:
> Jan,
> 
> On Wed, 10 Jul 2019 12:59:41 +0000
> Jan Szewczyk <jan.szewczyk@ericsson.com> wrote:
> 
>> Hi!
>> I digged up a little further and maybe it's not a problem with MTU
>> itself. I checked every entry I get from RTM_GETROUTE netlink message
>> and after triggering "too big packet" by pinging ipv6address I get
>> exactly the same messages on 4.12 and 4.18, except that the one with
>> that pinged ipv6address is missing on 4.18 at all. What is weird -
>> it's visible when running "ip route get to ipv6address". Do you know
>> why there is a mismatch there?
> 
> If I understand you correctly, an implementation equivalent to 'ip -6
> route list show' (using the NLM_F_DUMP flag) won't show the so-called
> route exception, while 'ip -6 route get' shows it.
> 
> If that's the case: that was broken by commit 2b760fcf5cfb ("ipv6: hook
> up exception table to store dst cache") that landed in 4.15, and fixed
> by net-next commit 1e47b4837f3b ("ipv6: Dump route exceptions if
> requested"). For more details, see the log of this commit itself.
> 

ah, good point. My mind locked on RTM_GETROUTE as a specific route
request not a dump.
