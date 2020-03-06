Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCB1C17C719
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 21:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbgCFUcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 15:32:55 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:54100 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbgCFUcz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 15:32:55 -0500
Received: by mail-pj1-f66.google.com with SMTP id cx7so1533828pjb.3
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 12:32:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=FevXuXkbBSNzjJoPi8mR2Q9A6Kzc1ZBKowax738uaac=;
        b=3geey0i1snIJwP4S4K65cS2C7GHWXgqZwLgu33bxL5/Rg0oZFhHAWttqQG/Bzshm1Q
         f3778BWjEpXo3LOAdaN9RG/dwwIWrRqdM1hRrNXDzsR6z+UfYg9sx9pagYkTauKM9/wB
         L8SZLcGFN3lfA7t1PMSWRAIs8uwujHHNMQpkl/seyxcU6+HUFT3A9OpH2SoooJFLQxco
         zLeInLgfY9mk5iiZxi7xd0z3Ghsp2ItClhpLbSGZyLqOO38Qa/oq7pzuHSbxrVmGMytg
         oV+A2c2FHwJSvks98zdZaXXHI+NJmt6uHG1qJeaHbJgvqnu/ROiOYmNCBvPo/HrWvPdz
         pXug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=FevXuXkbBSNzjJoPi8mR2Q9A6Kzc1ZBKowax738uaac=;
        b=JfKNrdJlhQy3WAVK68Tknc/B4PAhsAsOErUsTcCyp+y1eafXTzUcv8Vyj1m2a/XslH
         TVKH+ct3GqPFgh36iaKx6XeO7gKYyPKkFSuuQosrmbY2pAtGT84X1BrfXiK+9+B6AXnW
         986Arm6QJ2qreCDrmxEsCmcPSyuywg/d1pQkWhdw0c/qyVpMLB5kwqbAsODPjdu9Dh6Z
         0epJ+9jsGZBRnzpvoALA/8dRn8LKgCMJ+6fGJQSqVZhDHN+EBW11XFUBduNK0UfTXMCp
         FZHOUKNY/V4zlpszXtotqRcJ3IpbPpn0r5ci3VY/sd6F/PoEMwQGl4Oz+4/3ed48dSG9
         9A1A==
X-Gm-Message-State: ANhLgQ0VBQoavCave4Ofkf7/lvAHdXA7aU84LjMebJsVNhq1PgJgty2e
        +zFUdP9xs/ukXmjLXA5CKvgOQ3xGZX0=
X-Google-Smtp-Source: ADFU+vtvOhcD6daBD4wZbvs0r8cXdtIVtPPcOH8uGzi+cH13k795aijD7qKzqTJ3A/+Rt5qhbYpPdQ==
X-Received: by 2002:a17:90b:30d6:: with SMTP id hi22mr5308807pjb.63.1583526774079;
        Fri, 06 Mar 2020 12:32:54 -0800 (PST)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id w14sm35582688pgi.22.2020.03.06.12.32.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2020 12:32:53 -0800 (PST)
Subject: Re: [PATCH v3 net-next 7/8] ionic: add support for device id 0x1004
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20200305052319.14682-1-snelson@pensando.io>
 <20200305052319.14682-8-snelson@pensando.io>
 <20200305140322.2dc86db0@kicinski-fedora-PC1C0HJN>
 <d9df0828-91d6-9089-e1b4-d82c6479d44c@pensando.io>
 <20200305171834.6c52b5e9@kicinski-fedora-PC1C0HJN>
 <3b85a630-8387-2dc6-2f8c-8543102d8572@pensando.io>
 <20200306102009.0817bb06@kicinski-fedora-PC1C0HJN>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <5ac3562b-47b1-a684-c7f2-61da1a233859@pensando.io>
Date:   Fri, 6 Mar 2020 12:32:51 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200306102009.0817bb06@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/6/20 10:20 AM, Jakub Kicinski wrote:
> On Thu, 5 Mar 2020 23:43:44 -0800 Shannon Nelson wrote:
>> Yes, and if we were just writing registers, that would make sense. When
>> I can get to it I do intend to try expand our use of the devlink
>> interfaces where it will work for us.
> Yes, please do that.
>
>> However, this device id does exist on some of the DSC configurations,
>> and I'd prefer to explicitly acknowledge its existence in the driver and
>> perhaps keep better control over it, whether or not it gets used by our
>> 3rd party tool, rather than leave it as some obscure port for someone to
>> "discover".
> I understand, but disagree. Your driver can certainly bind to that
> management device but it has to be for the internal use of the kernel.
> You shouldn't just expose that FW interface right out to user space as
> a netdev.
So for now the driver should simply capture and configure the PCI 
device, but stop at that point and not setup a netdev.  This would leave 
the device available for devlink commands.

If that sounds reasonable to you, I'll add it and respin the patchset.

sln

