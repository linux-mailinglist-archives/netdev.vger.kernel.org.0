Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5E82700A7
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 17:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbgIRPPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 11:15:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgIRPPW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 11:15:22 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A98C0613CE
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 08:15:22 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id c10so5664607otm.13
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 08:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=J7BzP7iupf0aAfzpgXClACBnJ2mfzM3dL2+n3cNZHMk=;
        b=CfdajHjof/cxMJ2keT+CZwuRjlulcgcnYLZPv0mMPLt1TT9tTUANvGPQoV3ewYuRcP
         S8SQADeSN9na8Gyy91luka6xvbMXGIoPp2vkqm3FU/q1Z/Khx+1m1uWJ26m0ScfxNPfh
         vyOyJv+n+Kjjc7ci8FsB2YCz3mgx591W/K1g9h+dZTBQcB98M+Dl583dkFN9tYK8jxnw
         3otSGCwxrhltH9VLjcEladlBK/q+viClkSVpzJVjnVVWfSr9pBlmryrsDgqddAU4LytJ
         kcDLDlFZhIX5+Ac8E/3Qg54H22B/MmDyXtd4+afE7FTgTOkHLexpzxPPKY8H6Chnuzhu
         tqxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J7BzP7iupf0aAfzpgXClACBnJ2mfzM3dL2+n3cNZHMk=;
        b=qPdJlZssylsqzF6xkAgRQ1RuiG4fSTJjsKA4WLOF/26SvWir6nTpyvgyndoY7KnJXE
         O3sSFyt9KSprVxJpAmPz0ao43e/dDrt9zVM5OEt0A13mU4FPapEscfrugQ4m2TElvcxr
         5FQWzIBkRV9RMN0xG/OKAkcMP3D4sj9gwtV9RHg80e1Fa7HizxMXHIXSFtVmqyX46ane
         PVrDwYWSRe8iys4Gh5hr8RAZeS/kfrRUIgcGAf7mfwNDBQ4tPvtRJVKaib9W++sys2Sk
         vwtFw7VG0WCi2I8vMBNxvUr4h/BEXuZ4CUCsy3XCCrNKf96qkZT79c6fBsAzqjtI0Oa5
         YdAg==
X-Gm-Message-State: AOAM533zjTGPNUFQG41xlHVgNs/3hBcZUZqOdqpnLzjPvkmIxlm6dSQ5
        0pUZoPI8gQGu9EKDOyiFu4w=
X-Google-Smtp-Source: ABdhPJy5XRNEpACPzxmKU/s5H0R4XYuQP1RSlRHac2dBrXWVPg7y0o6SxpCNm0+6oPU8nTVso7Wo7w==
X-Received: by 2002:a05:6830:22cb:: with SMTP id q11mr24240017otc.232.1600442121581;
        Fri, 18 Sep 2020 08:15:21 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:bd0c:595:7529:c07b])
        by smtp.googlemail.com with ESMTPSA id o9sm3162750oop.1.2020.09.18.08.15.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Sep 2020 08:15:20 -0700 (PDT)
Subject: Re: [PATCH net-next v2 1/8] devlink: Introduce PCI SF port flavour
 and port attribute
To:     Parav Pandit <parav@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Jiri Pirko <jiri@nvidia.com>
References: <20200917081731.8363-8-parav@nvidia.com>
 <20200917172020.26484-1-parav@nvidia.com>
 <20200917172020.26484-2-parav@nvidia.com>
 <7b4627d3-2a69-5700-e985-2fe5c56f03cb@gmail.com>
 <BY5PR12MB43220E910463577F0D792965DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f89dca1d-4517-bf4a-b3f0-4c3a076dd2ab@gmail.com>
Date:   Fri, 18 Sep 2020 09:15:18 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <BY5PR12MB43220E910463577F0D792965DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/17/20 10:18 PM, Parav Pandit wrote:
> 
>> From: David Ahern <dsahern@gmail.com>
>> Sent: Friday, September 18, 2020 1:32 AM
>>
>> On 9/17/20 11:20 AM, Parav Pandit wrote:
>>> diff --git a/include/net/devlink.h b/include/net/devlink.h index
>>> 48b1c1ef1ebd..1edb558125b0 100644
>>> --- a/include/net/devlink.h
>>> +++ b/include/net/devlink.h
>>> @@ -83,6 +83,20 @@ struct devlink_port_pci_vf_attrs {
>>>  	u8 external:1;
>>>  };
>>>
>>> +/**
>>> + * struct devlink_port_pci_sf_attrs - devlink port's PCI SF
>>> +attributes
>>> + * @controller: Associated controller number
>>> + * @pf: Associated PCI PF number for this port.
>>> + * @sf: Associated PCI SF for of the PCI PF for this port.
>>> + * @external: when set, indicates if a port is for an external
>>> +controller  */ struct devlink_port_pci_sf_attrs {
>>> +	u32 controller;
>>> +	u16 pf;
>>> +	u32 sf;
>>
>> Why a u32? Do you expect to support that many SFs? Seems like even a u16 is
>> more than you can adequately name within an IFNAMESZ buffer.
>>
> I think u16 is likely enough, which let use creates 64K SF ports which is a lot. :-)
> Was little concerned that it shouldn't fall short in few years. So picked u32. 
> Users will be able to make use of alternative names so just because IFNAMESZ is 16 characters, do not want to limit sfnum size.
> What do you think?
> 
>>
>>> +	u8 external:1;
>>> +};
>>> +
>>>  /**
>>>   * struct devlink_port_attrs - devlink port object
>>>   * @flavour: flavour of the port
>>
>>
>>> diff --git a/net/core/devlink.c b/net/core/devlink.c index
>>> e5b71f3c2d4d..fada660fd515 100644
>>> --- a/net/core/devlink.c
>>> +++ b/net/core/devlink.c
>>> @@ -7855,6 +7889,9 @@ static int
>> __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
>>>  		n = snprintf(name, len, "pf%uvf%u",
>>>  			     attrs->pci_vf.pf, attrs->pci_vf.vf);
>>>  		break;
>>> +	case DEVLINK_PORT_FLAVOUR_PCI_SF:
>>> +		n = snprintf(name, len, "pf%usf%u", attrs->pci_sf.pf, attrs-
>>> pci_sf.sf);
>>> +		break;
>>>  	}
>>>
>>>  	if (n >= len)
>>>
>>
>> And as I noted before, this function continues to grow device names and it is
>> going to spill over the IFNAMESZ buffer and EINVAL is going to be confusing. It
>> really needs better error handling back to users (not kernel buffers).
> Alternative names [1] should help to overcome the limitation of IFNAMESZ.
> For error code EINVAL, should it be ENOSPC?
> If so, should I insert a pre-patch in this series?
> 
> [1] ip link property add dev DEVICE [ altname NAME .. ]
> 

You keep adding patches that extend the template based names. Those are
going to cause odd EINVAL failures (the absolute worst kind of
configuration failure) with no way for a user to understand why the
command is failing, and you need to handle that. Returning an extack
message back to the user is preferred.

Yes, the altnames provides a solution after the the netdevice has been
created, but I do not see how that works when the netdevice is created
as part of devlink commands using the template names approach.

