Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73064310F95
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 19:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233552AbhBEQ1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 11:27:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54248 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233699AbhBEQZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 11:25:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612548374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/FjDDzt899a+6Dw48JUOAsTP6/4I6PwMF8aJyEspxHY=;
        b=XNXh72zmWjvMIyiEHe0FLrNqr+SZvP2G5QwknqNpHc8phnmdyUeZVmdSWCxuN8K3EFhlVn
        WsLHvSX9qHS+HgZfwhfOauK7Udp3sU/5MmzVffImH2pbqEKed5GHzWUucNLjBqbz61os7t
        F7Uh6xluzwuGSpIJxCBMcCZ6BRWouak=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-218-SKpscElNOBO8jmR8ZzYCEw-1; Fri, 05 Feb 2021 13:06:12 -0500
X-MC-Unique: SKpscElNOBO8jmR8ZzYCEw-1
Received: by mail-wr1-f72.google.com with SMTP id h17so5815200wrv.15
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 10:06:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/FjDDzt899a+6Dw48JUOAsTP6/4I6PwMF8aJyEspxHY=;
        b=rD96O0zgtqgZmOyBv0lDNNMgcQ247Z31/lZ5oE4s7SygNANMrgSR6rcMr80GZa0vnM
         /r29bm8hNM4EM+AejdDa4RfRSY6XgbjJMAA0SvsBr+q0yjZSJEa08PSHvc9M3W6aP4TV
         j4iIJHThyoghYdEJIPisL6kcE2rVPQiNlgqLmEcB04+V6Zm2kZu9tJ7vXeUf3LgY700N
         wgRN7xkP+uXPfbljO404POVE6momJRj/ghoIaf9wG4ukz7XGfayea98utH7xYSvsLceX
         nSOgK5tewm6PywcbucCcXFkLVAsAGSZdB3H8oIDnNn1iAv3+pN4mt3qnHIm5i3RAvOiz
         86Ug==
X-Gm-Message-State: AOAM532Eo+KlJ23qZa8p0vqcqpKoOL342vhIjhbI1GYyAadO4CVA7OhG
        qZbM37UMBHjFCmx8/a0G+EeLraMZhm9JgvdrIPiiS/ttSnKWJ4SirehZBt5fd7/VL1QFlB/TJL4
        RU10FOlJhYSnAR0P2
X-Received: by 2002:a05:600c:4c19:: with SMTP id d25mr1011060wmp.181.1612548370943;
        Fri, 05 Feb 2021 10:06:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyiNK6RY5vl+1amocTZGPvTluMg/eusfL4dCCwJwbcZNca6nMHi9LeGq6BuHkyFHouH3+22Cw==
X-Received: by 2002:a05:600c:4c19:: with SMTP id d25mr1011043wmp.181.1612548370719;
        Fri, 05 Feb 2021 10:06:10 -0800 (PST)
Received: from amorenoz.users.ipa.redhat.com ([94.73.56.18])
        by smtp.gmail.com with ESMTPSA id y63sm9275908wmd.21.2021.02.05.10.06.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Feb 2021 10:06:09 -0800 (PST)
Subject: Re: [PATCH iproute2-next v3 0/5] Add vdpa device management tool
To:     Parav Pandit <parav@nvidia.com>, Jason Wang <jasowang@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "mst@redhat.com" <mst@redhat.com>
References: <20210122112654.9593-3-parav@nvidia.com>
 <20210202103518.3858-1-parav@nvidia.com>
 <99106d07-1730-6ed8-c847-0400be0dcd57@redhat.com>
 <1d1ff638-d498-6675-ead5-6e09213af3a8@redhat.com>
 <0017c3d7-9b04-d26c-94e2-485e4da6a778@redhat.com>
 <BY5PR12MB4322BB72FCC893EB8D4D1B30DCB29@BY5PR12MB4322.namprd12.prod.outlook.com>
From:   Adrian Moreno <amorenoz@redhat.com>
Message-ID: <d056ca1c-8c7f-84ce-dc4a-0105e53c6773@redhat.com>
Date:   Fri, 5 Feb 2021 19:06:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <BY5PR12MB4322BB72FCC893EB8D4D1B30DCB29@BY5PR12MB4322.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/5/21 6:53 PM, Parav Pandit wrote:
> 
> 
>> From: Jason Wang <jasowang@redhat.com>
>> Sent: Friday, February 5, 2021 9:11 AM
>>
>>
>> On 2021/2/4 下午7:15, Adrian Moreno wrote:
>>> Sorry I have not followed this work as close as I would have wanted.
>>> Some questions below.
>>>
>>> On 2/4/21 4:16 AM, Jason Wang wrote:
>>>> On 2021/2/2 下午6:35, Parav Pandit wrote:
>>>>> Linux vdpa interface allows vdpa device management functionality.
>>>>> This includes adding, removing, querying vdpa devices.
>>>>>
>>>>> vdpa interface also includes showing supported management devices
>>>>> which support such operations.
>>>>>
>>>>> This patchset includes kernel uapi headers and a vdpa tool.
>>>>>
>>>>> examples:
>>>>>
>>>>> $ vdpa mgmtdev show
>>>>> vdpasim:
>>>>>     supported_classes net
>>>>>
>>>>> $ vdpa mgmtdev show -jp
>>>>> {
>>>>>       "show": {
>>>>>           "vdpasim": {
>>>>>               "supported_classes": [ "net" ]
>>>>>           }
>>>>>       }
>>>>> }
>>>>>
>>> How can a user establish the relationship between a mgmtdev and it's
>>> parent device (pci vf, sf, etc)?
>>
>>
>> Parav should know more but I try to answer.
>>
>> I think there should be BDF information in the mgmtdev show command if
>> the parent is a PCI device, or we can simply show the parent here?
>>
> Yes, it is present in the mgmtdev show command.
> I should have added the example from the kernel cover letter here.
> Link to the kernel cover letter is at 
> 
> An example for real PCI PF,VF,SF device looks like below.
> I will cover below example to the v4 cover letter while addressing David's comment for header file relocation.
> 
> $ vdpa mgmtdev list
> pci/0000:03.00:0
>   supported_classes
>     net
> pci/0000:03.00:4
>   supported_classes
>     net
> auxiliary/mlx5_core.sf.8
>   supported_classes
>     net
> 
> [1] https://lore.kernel.org/netdev/20210105103203.82508-1-parav@nvidia.com/
> 

Thanks Parav

-- 
Adrián Moreno

