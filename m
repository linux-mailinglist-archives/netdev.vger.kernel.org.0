Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD6443D1D3
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 21:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243723AbhJ0Tmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 15:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240198AbhJ0Tmu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 15:42:50 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5030AC061745
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 12:40:25 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id y1so2742152plk.10
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 12:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=UKvxmgEWSbJ2Hm18qUpQARw9Aprrt+YRAWy21QT8WZI=;
        b=RbJLS7cY1vfWFcaIrMiu5eE5ss/0VJ6P+HKlx0W5Z+UfNOLqEtoWdHZ51AbCiksXag
         UUEKma217Y76jbX7DNQ+LZHBCENHOuB8ThtEzzEr+YKwEPw8kJP0MTDWuS7L3ufEoDGh
         GuoqZKihZYjAwzY121ux3xRDLydaE0DEP/cN7+iVyyCTd+CVk+/OtIfPsEuWNEaa2EV4
         rJ4u4T328xmqjOZTkCbOTyJb8G78saIRSSOd598QKYoBXibD+XrJZbW6spVgJmAKSn61
         gPrKwOzLXOIXYO6ePoZJp6TRGX7EGBl7AcOWlfIh22CfRIhrLcJKuLNHkSEX0vEMoknY
         NGeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=UKvxmgEWSbJ2Hm18qUpQARw9Aprrt+YRAWy21QT8WZI=;
        b=iSj1ROjpGU+Z/uUbxUk/Evl5w5k4TBLXuz0WdI5E26NFLqKXXZEQj6TXF8+MApDNhR
         SFeQyjCXMAUb03W6gd3HLW06Hx08wcLodoNBrAmgozebe2LqdSeETokwbL28Cu/Bbbp6
         FjvxrXsiWTu0vF9914CJxJ/hdQ/4i9F73GWWc+4EYbX6QykwVJpAsj2V1QD/Mlk9WIbX
         jvDhNcxlDbdFhhk9ODLVhREDNNGfNgmqYh4tEyxlQGKFFyxctVABcLt8iqHeCn40thSG
         f+QBDr3ArWDL6uE4BfNhHPWGAwXndgVt1nvrXlPmXjEo+zOcZv+uauWmTX5ktc0xvnPF
         xd7A==
X-Gm-Message-State: AOAM530dghQm2XbuaBoYsfBUZWAe4vkxh8x9Dv1FhiDVnFWenLDIR1hV
        yXfOLWZprSBZO4+cBqufIhyWrQ==
X-Google-Smtp-Source: ABdhPJxpj+imBC8EEuIT1jIjYqQ5tNGOiZr4IKw3CFnjtsPq1CLe/QExxyoZRskePRhKkdHXWcuPSg==
X-Received: by 2002:a17:90b:17d2:: with SMTP id me18mr7931427pjb.132.1635363624831;
        Wed, 27 Oct 2021 12:40:24 -0700 (PDT)
Received: from [192.168.0.14] ([50.53.47.17])
        by smtp.gmail.com with ESMTPSA id h12sm738874pfv.117.2021.10.27.12.40.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 12:40:24 -0700 (PDT)
Message-ID: <3d076307-5a85-8db7-ae42-fd696f79519b@pensando.io>
Date:   Wed, 27 Oct 2021 12:40:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: Unsubscription Incident
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        John 'Warthog9' Hawley <warthog19@eaglescrag.net>
Cc:     Slade Watkins <slade@sladewatkins.com>,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Lijun Pan <lijunp213@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
References: <CAOhMmr7bWv_UgdkFZz89O4=WRfUFhXHH5hHEOBBfBaAR8f4Ygw@mail.gmail.com>
 <CA+h21hqrX32qBmmdcNiNkp6_QvzsX61msyJ5_g+-FFJazxLgDw@mail.gmail.com>
 <YXY15jCBCAgB88uT@d3>
 <CA+pv=HPyCEXvLbqpAgWutmxTmZ8TzHyxf3U3UK_KQ=ePXSigBQ@mail.gmail.com>
 <61f29617-1334-ea71-bc35-0541b0104607@pensando.io>
 <20211027123408.0d4f36f2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Shannon Nelson <snelson@pensando.io>
In-Reply-To: <20211027123408.0d4f36f2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/27/21 12:34 PM, Jakub Kicinski wrote:
> On Mon, 25 Oct 2021 11:34:28 -0700 Shannon Nelson wrote:
>>>> It happened to a bunch of people on gmail:
>>>> https://lore.kernel.org/netdev/1fd8d0ac-ba8a-4836-59ab-0ed3b0321775@mojatatu.com/t/#u
>>> I can at least confirm that this didn't happen to me on my hosted
>>> Gmail through Google Workspace. Could be wrong, but it seems isolated
>>> to normal @gmail.com accounts.
>>>
>>> Best,
>>>                -slade
>> Alternatively, I can confirm that my pensando.io address through gmail
>> was affected until I re-subscribed.
> Did it just work after re-subscribing again? Without cleaning the inbox?
> John indicated off list that Gmail started returning errors related to
> quota, no idea what that translates to in reality maybe they added some
> heuristic on too many emails from one source?

I have two separate accounts through gmail, both of which got dropped:
snelson@pensando.io
shannon.lee.nelson@gmail.com

All I did to restore service was resubscribe to the mailing list for 
both of these accounts.

Neither account has any issue with quota or available storage space that 
I am aware of.

sln

