Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 027593B7590
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 17:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234875AbhF2Pgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 11:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234669AbhF2Pgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 11:36:52 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 748E1C061760
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 08:34:25 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id t80so5247110oie.8
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 08:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uOwlYcC96aHhLobin+5ZyhV7dx85ptWEke7o+JPzW7Q=;
        b=apblYTVbrWTg1iFw+u11DaSBHzw5SRubUxBlnkleXGCEcibBTC1CRvOEXtGhlPnpI7
         pDQUZRFUbCzcfOEeyhY3uAN5hoghS92bb4PkxCLZgWvNp4C3HGIkAeFPjdv8QorCirkz
         qAX+/w1c0JULDqn1SWdebxzopPleCvc7admTL602n52pLOryes0pad9SvDrBipxPVXzb
         6ihQWagRCVemaAZeF7ba34UXgYgNqeKK+RuvQ7z9cvAc74sUCXo8yswhuJcRC2H3mFiJ
         hh2zj4UzwFqJZpgqynj28NDeplP0UucVQ/mMB2lEu8dbrysgZolqqNYOUgNuGcsHQhhD
         vq2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uOwlYcC96aHhLobin+5ZyhV7dx85ptWEke7o+JPzW7Q=;
        b=WYOCU5OS6HEEVOd8mt8aBfqX283U1JszmsDOuV5jWQebIzAEPcspNUoXknRU2GIytY
         JN2ZAGMC3KCF2hI2VHErQW+y/H+eP0qywHy96w0usmGcnPaWdJOKi+hUglpCyUiPN67z
         /mcv3FAIlCIDWAlxdbYmSzL3qUk21Q/zz4OygLR2ANWVJ+tJRtSSauPPRK0KtsiPQhn+
         bf+0RKv/2WK//IkCsI62mYWmxqy93lzfVc9ydfv1GFtitg0YBV4Xk53jR5MUWkRKgeus
         FhTXWWgO2My3xrErKeVNj7YvPWZsRtDPHnCtgUCFdKfBQRVPWy0UWp1GFuv+3rGrjZ4/
         hS/g==
X-Gm-Message-State: AOAM5304JhtMW7l7wMxG+4VUqJi+ocEOYLAuLgnVIimjO2unOFFcDohb
        1ZU+n/XqbV9l/obFEk5KEGAXOYnpwhnTfw==
X-Google-Smtp-Source: ABdhPJzAe7x3AEI04jkhHyovbZ89ju0jAgF2FFlR1B850K8KkS9Pb/a7oRyglLCrYU7xi7PJ1tKQ7Q==
X-Received: by 2002:a05:6808:b22:: with SMTP id t2mr24791259oij.19.1624980864726;
        Tue, 29 Jun 2021 08:34:24 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id 94sm4155079otj.33.2021.06.29.08.34.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Jun 2021 08:34:24 -0700 (PDT)
Subject: Re: [PATCH net-next] ipv6: Add sysctl for RA default route table
 number
To:     Eyal Birger <eyal.birger@gmail.com>, antony.antony@secunet.com
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        Christian Perle <christian.perle@secunet.com>
References: <cover.1619775297.git.antony.antony@secunet.com>
 <32de887afdc7d6851e7c53d27a21f1389bb0bd0f.1624604535.git.antony.antony@secunet.com>
 <95b096f7-8ece-46be-cedb-5ee4fc011477@gmail.com>
 <20210629125316.GA18078@moon.secunet.de>
 <69e7e4e5-4219-5149-e7aa-fd26aa62260e@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b7e41f4b-04d6-2cff-038b-ccb250c2eb84@gmail.com>
Date:   Tue, 29 Jun 2021 09:34:22 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <69e7e4e5-4219-5149-e7aa-fd26aa62260e@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/29/21 8:05 AM, Eyal Birger wrote:
> Hi Antony,
> 
> On 29/06/2021 15:53, Antony Antony wrote:
>> Hi David,
>>
>> On Fri, Jun 25, 2021 at 22:47:41 -0600, David Ahern wrote:
>>> On 6/25/21 1:04 AM, Antony Antony wrote:
>>>> From: Christian Perle <christian.perle@secunet.com>
>>>>
>>>> Default routes learned from router advertisements(RA) are always placed
>>>> in main routing table. For policy based routing setups one may
>>>> want a different table for default routes. This commit adds a sysctl
>>>> to make table number for RA default routes configurable.
>>>>
>>>> examples:
>>>> sysctl net.ipv6.route.defrtr_table
>>>> sysctl -w net.ipv6.route.defrtr_table=42
>>>> ip -6 route show table 42
>>>
>>> How are the routing tables managed? If the netdevs are connected to a
>>> VRF this just works.
>>
>> The main routing table has no default route. Our scripts add routing
>> rules
>> based on interfaces. These rules use the specific routing table where

That's the VRF use case -- routing rules based on interfaces. Connect
those devices to VRFs and the RA does the right thing.

>> the RA
>> (when using SLAAC) installs the default route. The rest just works.
> 
> Could this be a devconf property instead of a global property? seems
> like the difference would be minor to your patch but the benefit is that
> setups using different routing tables for different policies could
> benefit (as mentioned when not using vrfs).

exactly. This is definitely not a global setting, but a per device
setting if at all.
