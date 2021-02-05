Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95934310F9B
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 19:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232820AbhBEQ2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 11:28:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59098 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233632AbhBEQ0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 11:26:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612548425;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IxMeTZ/n+Vn7dQU1j1tpbmFULO4aEKZmIFDiE1FTlAw=;
        b=Nv+cchfNHU3u2uY6VDzGB6MAOmBnU/qBKKuqIuYmo2+KXtRJ65Sw5f1wFsorTFq+ulxr4o
        fR0xCD133vkHiuQmTAT/6g1cpPZtX7OBaxQzRFVbvqfO2JHDCuHFWA9rShlo5Xtl9jbXn2
        qoCMh3JgIsajkBP04vypd2a6nGmlfN8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-DCKDnsE1Ot6JLPzalP4PjQ-1; Fri, 05 Feb 2021 13:07:02 -0500
X-MC-Unique: DCKDnsE1Ot6JLPzalP4PjQ-1
Received: by mail-wr1-f71.google.com with SMTP id r5so5777178wrx.18
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 10:07:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IxMeTZ/n+Vn7dQU1j1tpbmFULO4aEKZmIFDiE1FTlAw=;
        b=tRxbpQI9+EmWJpEfJ+T0jouphxu1FlEhmltW9cDBlMZ9G8cQqbmlT73yErKGgNIODf
         CKFZXsb9nRHbJOac7Mbfd9yMWaRilYVT5OagYXL1fG7/6M6sOSqufnqsZengoLGuFjFR
         SfdhwP2RKsAoOPcph00HIDzt0txUXHIhgLdoJy99ZgThCuTepiCzbE+i/So6C9N6ZeUp
         GFvhdCw28UK868IQJDIXMZmQq0wROvKm/uYrv6TF6xOyFBORaPMTOUJfdpiCwu6/8bdA
         vveLxj8bTCrDD02LohCUPPkPMP4nRFztarZtd6jqX+Twd2SFJkmFOLZw+d8Bg+pwCTVq
         HfqA==
X-Gm-Message-State: AOAM533Qf6KMBTmcvZNLwePA/5m2hPgMUI7vfhzP5pTisSznRGPrjFFt
        +7ky35BZP2E5/5G/m/6Wn33YP5hdqIQLoLcqXUwZ0/4nq2fRpLHWXKXyslG2KJF6BzFCC9W1jhp
        JJlkXZAtMdlhXcacr
X-Received: by 2002:adf:f647:: with SMTP id x7mr6176350wrp.160.1612548421618;
        Fri, 05 Feb 2021 10:07:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz9mO7p2mb6binBIQPLBJQ4QFCHvu/+u1ljqwZ7soxl9KQgsExNxcqKPsHS6dmprbR05F+aXA==
X-Received: by 2002:adf:f647:: with SMTP id x7mr6176341wrp.160.1612548421486;
        Fri, 05 Feb 2021 10:07:01 -0800 (PST)
Received: from amorenoz.users.ipa.redhat.com ([94.73.56.18])
        by smtp.gmail.com with ESMTPSA id r12sm13451334wrp.13.2021.02.05.10.07.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Feb 2021 10:07:00 -0800 (PST)
Subject: Re: [PATCH iproute2-next v3 0/5] Add vdpa device management tool
To:     Jason Wang <jasowang@redhat.com>, Parav Pandit <parav@nvidia.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        dsahern@gmail.com, stephen@networkplumber.org, mst@redhat.com
References: <20210122112654.9593-3-parav@nvidia.com>
 <20210202103518.3858-1-parav@nvidia.com>
 <99106d07-1730-6ed8-c847-0400be0dcd57@redhat.com>
 <1d1ff638-d498-6675-ead5-6e09213af3a8@redhat.com>
 <0017c3d7-9b04-d26c-94e2-485e4da6a778@redhat.com>
From:   Adrian Moreno <amorenoz@redhat.com>
Message-ID: <765b73c5-b3a1-99b0-0e3c-a23a38aedf60@redhat.com>
Date:   Fri, 5 Feb 2021 19:07:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <0017c3d7-9b04-d26c-94e2-485e4da6a778@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/5/21 4:40 AM, Jason Wang wrote:
> 
> On 2021/2/4 下午7:15, Adrian Moreno wrote:
>> Sorry I have not followed this work as close as I would have wanted.
>> Some questions below.
>>
>> On 2/4/21 4:16 AM, Jason Wang wrote:
>>> On 2021/2/2 下午6:35, Parav Pandit wrote:
>>>> Linux vdpa interface allows vdpa device management functionality.
>>>> This includes adding, removing, querying vdpa devices.
>>>>
>>>> vdpa interface also includes showing supported management devices
>>>> which support such operations.
>>>>
>>>> This patchset includes kernel uapi headers and a vdpa tool.
>>>>
>>>> examples:
>>>>
>>>> $ vdpa mgmtdev show
>>>> vdpasim:
>>>>     supported_classes net
>>>>
>>>> $ vdpa mgmtdev show -jp
>>>> {
>>>>       "show": {
>>>>           "vdpasim": {
>>>>               "supported_classes": [ "net" ]
>>>>           }
>>>>       }
>>>> }
>>>>
>> How can a user establish the relationship between a mgmtdev and it's parent
>> device (pci vf, sf, etc)?
> 
> 
> Parav should know more but I try to answer.
> 
> I think there should be BDF information in the mgmtdev show command if the
> parent is a PCI device, or we can simply show the parent here?
> 
> 
>>
>>>> Create a vdpa device of type networking named as "foo2" from
>>>> the management device vdpasim_net:
>>>>
>>>> $ vdpa dev add mgmtdev vdpasim_net name foo2
>>>>
>> I guess this command will accept a 'type' parameter once more supported_classes
>> are added?
> 
> 
> This could be extended in the future.
> 
> 
>>
>> Also, will this tool also handle the vdpa driver binding or will the user handle
>> that through the vdpa bus' sysfs interface?
> 
> 
> I think not, it's the configuration below the vdpa bus. The sysfs should be the
> only interface for managing driver binding.
> 
Understood, thanks.

-- 
Adrián Moreno

