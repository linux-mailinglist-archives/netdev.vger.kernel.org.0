Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4F02700DA
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 17:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgIRPXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 11:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgIRPXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 11:23:45 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8653AC0613CE
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 08:23:45 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id o6so5737830ota.2
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 08:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0z2Ch4F//ICW3hY/pS36w3A3DftaX+Vk+qEu0n+Qthc=;
        b=huwPk8aqFm9oKwOShOeqkqUo6VnYcl41L/V1q114acGfSfUjaNEulkHw4bIHt7sZu5
         XxFdrdYUfRrxEv8ShcmAhsiTi6WCXWA2QRaehmrmOi/GraqKiLFYSUVzGfJXXT5YkW7T
         BvMYlxPEJmsKpVHoW0lQjCh2wob2hGwVb4jWt8LXtelrjOP1dx+MaADPpyAUzHbJySzM
         7hxhKylPQBvNEqmBncYcICqdHS1S85lDWmlhRrxi74WZZnv1Uak7RI8zvJSPF+hhM3mc
         HAovjEPhDipWQmrX3RZi841iJLMcrzyoWEFEz5pnzXsDE9YZtPwIIq9cE75/Kcs/JVDU
         YNsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0z2Ch4F//ICW3hY/pS36w3A3DftaX+Vk+qEu0n+Qthc=;
        b=m1fTuRpOAr+nXGTOFDl6IuQifU48rBx1Yr3X+3Bs4h9cdFYFmEOQdkHJDer9HR6vDv
         psLu3RJ7g+lqtRUxFN3jDJQbKmn8v4F8BTfQxYGnVBBbY70o4m2pynlPDEtb65N9ZsIp
         feffvT7bWEmFxKXhygil2R9SwOeO8/l7oiUGRWG0fO2uOamXkuhUT9Q3I5UXD6iwyPnS
         GW+m/PcfPJhmA43o1uRuVak42rEjfUFCaWEeRkXk+a4r5mQhxOjAkE4Dikk0T24qRERp
         lzDNnv4ddGmQ/B6ZrZXsxJK3WFJQjTQ8c6yYyw+VHaxT2vKIBGEajqY6PqtPzg7y5YUF
         liRQ==
X-Gm-Message-State: AOAM532kzq81s8z3XLEYbN5ZrR0Sz79a49gkgX35eoJ5H1UP7iqIpnVI
        5R0UX+ZKOdfAsGEJb6eWUfE=
X-Google-Smtp-Source: ABdhPJzPdCR3LFLwmt2xkrvTLnyWtAOkWH82EYKuNVOHZy6TN8Qal06r/b7XSrrpHTC6Zz7Ta2KgfA==
X-Received: by 2002:a05:6830:10c4:: with SMTP id z4mr21219967oto.254.1600442624826;
        Fri, 18 Sep 2020 08:23:44 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:bd0c:595:7529:c07b])
        by smtp.googlemail.com with ESMTPSA id x21sm2913919oie.49.2020.09.18.08.23.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Sep 2020 08:23:43 -0700 (PDT)
Subject: Re: [PATCH net-next v2 8/8] netdevsim: Add support for add and delete
 PCI SF port
To:     Parav Pandit <parav@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Jiri Pirko <jiri@nvidia.com>
References: <20200917081731.8363-8-parav@nvidia.com>
 <20200917172020.26484-1-parav@nvidia.com>
 <20200917172020.26484-9-parav@nvidia.com>
 <e14f216f-19d9-7b4a-39ff-94ea89cd36c0@gmail.com>
 <BY5PR12MB43222EEBBC3B008918B82B98DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <c95859c8-e9cf-d218-e186-4f5d570c1298@gmail.com>
 <BY5PR12MB43220D8961B4F676CBA65A55DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5cd529c8-cd55-b270-7f3c-227ef957b6e8@gmail.com>
Date:   Fri, 18 Sep 2020 09:23:42 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <BY5PR12MB43220D8961B4F676CBA65A55DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/17/20 10:41 PM, Parav Pandit wrote:
> Hi David,
> 
>> From: David Ahern <dsahern@gmail.com>
>> Sent: Friday, September 18, 2020 9:08 AM
>>
>> On 9/17/20 9:29 PM, Parav Pandit wrote:
>>>>> Examples:
>>>>>
>>>>> Create a PCI PF and PCI SF port.
>>>>> $ devlink port add netdevsim/netdevsim10/10 flavour pcipf pfnum 0 $
>>>>> devlink port add netdevsim/netdevsim10/11 flavour pcisf pfnum 0
>>>>> sfnum
>>>>> 44 $ devlink port show netdevsim/netdevsim10/11
>>>>> netdevsim/netdevsim10/11: type eth netdev eni10npf0sf44 flavour
>>>>> pcisf
>>>> controller 0 pfnum 0 sfnum 44 external true splittable false
>>>>>   function:
>>>>>     hw_addr 00:00:00:00:00:00 state inactive
>>>>>
>>>>> $ devlink port function set netdevsim/netdevsim10/11 hw_addr
>>>>> 00:11:22:33:44:55 state active
>>>>>
>>>>> $ devlink port show netdevsim/netdevsim10/11 -jp {
>>>>>     "port": {
>>>>>         "netdevsim/netdevsim10/11": {
>>>>>             "type": "eth",
>>>>>             "netdev": "eni10npf0sf44",
>>>>
>>>> I could be missing something, but it does not seem like this patch
>>>> creates the netdevice for the subfunction.
>>>>
>>> The sf port created here is the eswitch port with a valid switch id similar to PF
>> and physical port.
>>> So the netdev created is the representor netdevice.
>>> It is created uniformly for subfunction and pf port flavours.
>>
>> To be clear: If I run the devlink commands to create a sub-function, `ip link
>> show` should list a net_device that corresponds to the sub-function?
> 
> In this series only representor netdevice corresponds to sub-function will be visible in ip link show, i.e. eni10npf0sf44.
> 
> Netdevsim is only simulating the eswitch side or control path at present for pf/vf/sf ports.
> So other end of this port (netdevice/rdma device/vdpa device) are not yet created.
> 
> Subfunction will be anchored on virtbus described in RFC [1], which is not yet in-kernel yet.
> Grep for "every SF a device is created on virtbus" to jump to this part of the long RFC.
> 
> [1] https://lore.kernel.org/netdev/20200519092258.GF4655@nanopsycho/
> 

Thanks for the reference. I have seen that. I am interested in this idea
of creating netdevs for 'slices' of an asic or nic, but it is not clear
to me how it connects end to end. Will you be able to create a
sub-function based netdevice, assign it limited resources from the nic
and then assign that netdevice to a container for example?
