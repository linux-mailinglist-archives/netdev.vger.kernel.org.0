Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 447F417B7A3
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 08:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725923AbgCFHnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 02:43:47 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33205 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbgCFHnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 02:43:47 -0500
Received: by mail-pf1-f194.google.com with SMTP id n7so716710pfn.0
        for <netdev@vger.kernel.org>; Thu, 05 Mar 2020 23:43:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=verVD0oCaesK+RURCxs2/EO8m2SOOOgaQIvuULLM3wU=;
        b=HEzGmREnYtC381rd4rJDjBUFk/x7sLQpzRPxF42M6gcyA7ycEgo4yAXEaSVIZhZGTr
         z7yriXL9Y+xjlWHbxf+50SLHoSYBnQi7xVE9iAs9WjZvafveU5+ZYgcyJYYCn8wV9pfY
         LRw9yx738dGORTsuXlLWeemgd2Bx5cf2TVRD4SPrEzxoYNqmgEZWyquazE1oWXhy5qJW
         cHqeRMMohQ0HmwDSBfX71MbFqkQ8vtvPv+LR7vjd6/6jbTnNaTvUKchgTiwx8vQ38T1/
         92XTvOH/wpyYXzF7Vp/xhJvhx4/YqGKgb9XQYcE5UzFt1go7MSH0yAxfPEMsZB/M3rBT
         lgog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=verVD0oCaesK+RURCxs2/EO8m2SOOOgaQIvuULLM3wU=;
        b=bbXE/YVqBb5RWQCMqDfMI4JeYaDp7LqIazffW8twGFROwA0mFWDc+SUK1WGKgGFmED
         xnMz88CfuxkOwlUVGNqksgzBpSCM/YU7w9Oe457pJ15czKawSI3wgvPluMiND1rbxkmU
         lgXcJwSFIBpqF/eiX1bXwO7bCFZITnb5hyV3S1hjpE4BUFeRD8eJ6fVDFkShDrtJw7MI
         G81nq3POpQl86Wa2owOgn7dzgonMdQuK14UiIMh1Ttf+4n/ND9UBIjMp7Gp1L/om3bUX
         KQJU7K+0OnMae5kx+fbt5Zb+5dPBOYdOsOFF7jnZUw+ZEHKoW00Z50X8RfzxtbycLYAR
         S+xA==
X-Gm-Message-State: ANhLgQ2axw505N+DU3E3qn77Y6jXy/3VMSfLakSXChhbeTlBTLH/+FhD
        MDd47ta+5VmqlErJZSCUleMT0QzGI7s=
X-Google-Smtp-Source: ADFU+vtpe6faK5YbwxUyr/xIkE52F5sTS5wdbCyuA2Mj49M3SqkRIgpDVKSEYkakEiAN9hWMZYB6pA==
X-Received: by 2002:a63:2c50:: with SMTP id s77mr2043234pgs.182.1583480626225;
        Thu, 05 Mar 2020 23:43:46 -0800 (PST)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id cm2sm8700867pjb.23.2020.03.05.23.43.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Mar 2020 23:43:45 -0800 (PST)
Subject: Re: [PATCH v3 net-next 7/8] ionic: add support for device id 0x1004
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20200305052319.14682-1-snelson@pensando.io>
 <20200305052319.14682-8-snelson@pensando.io>
 <20200305140322.2dc86db0@kicinski-fedora-PC1C0HJN>
 <d9df0828-91d6-9089-e1b4-d82c6479d44c@pensando.io>
 <20200305171834.6c52b5e9@kicinski-fedora-PC1C0HJN>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <3b85a630-8387-2dc6-2f8c-8543102d8572@pensando.io>
Date:   Thu, 5 Mar 2020 23:43:44 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200305171834.6c52b5e9@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/5/20 5:18 PM, Jakub Kicinski wrote:
> On Thu, 5 Mar 2020 16:41:48 -0800 Shannon Nelson wrote:
>> On 3/5/20 2:03 PM, Jakub Kicinski wrote:
>>> On Wed,  4 Mar 2020 21:23:18 -0800 Shannon Nelson wrote:
>>>> Add support for an additional device id.
>>>>
>>>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
>>> I have thought about this for a while and I wanted to ask you to say
>>> a bit more about the use of the management device.
>>>
>>> Obviously this is not just "additional device id" in the traditional
>>> sense where device IDs differentiate HW SKUs or revisions. This is the
>>> same exact hardware, just a different local feature (as proven by the
>>> fact that you make 0 functional changes).
>>>
>>> In the past we (I?) rejected such extensions upstream from Netronome and
>>> Cavium, because there were no clear use cases which can't be solved by
>>> extending standard kernel APIs. Do you have any?
>> Do you by chance have any references handy to such past discussions?
>> I'd be interested in reading them to see what similarities and
>> differences we have.
> Here you go:
>
> https://lore.kernel.org/netdev/20170718115827.7bd737f2@cakuba.netronome.com/

Interesting - thanks.

>
>> The network device we present is only a portion of the DSC's functions.
>> The device configuration and management for the various services is
>> handled in userspace programs on the OS running inside the device.
>> These are accessed through a secured REST API, typically through the
>> external management ethernet port.  In addition to our centralized
>> management user interface, we have a command line tool for managing the
>> device configuration using that same REST interface.
> We try to encourage vendors to create common interfaces, as you'd
> understand that command line tool is raising red flags.
>
> Admittedly most vendors have some form of command line tool which can
> poke directly into registers, anyway, but IMHO we should avoid any
> precedents of merging driver patches with explicit goal of enabling
> such tools.

Yes, and if we were just writing registers, that would make sense. When 
I can get to it I do intend to try expand our use of the devlink 
interfaces where it will work for us.

However, this device id does exist on some of the DSC configurations, 
and I'd prefer to explicitly acknowledge its existence in the driver and 
perhaps keep better control over it, whether or not it gets used by our 
3rd party tool, rather than leave it as some obscure port for someone to 
"discover".

sln

>
>> In some configurations we make it possible to open a network connection
>> into the device through the host PCI, just as if you were to connect
>> through the external mgmt port.  This is the PCI deviceid that
>> corresponds to that port, and allows use of the command line tool on the
>> host.
>>
>> The host network driver doesn't have access to the device management
>> commands, it only can configure the NIC portion for what it needs for
>> passing network packets.

