Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 329B2305FB1
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 16:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235607AbhA0PFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 10:05:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235250AbhA0PBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 10:01:25 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E42C06178B
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 06:57:51 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id k8so1902803otr.8
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 06:57:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=L0J3YpwusZJdl822xOJrVTRXaMAMJEEQO1Sb/VD2+vs=;
        b=XQJm7qVpHuCbf21yWITiTmp19a8GRuGc2oby6BHjeDG/4Ld5vU5pLvvT6hOVJBz9ka
         ecvf3BKi88YAuX9FsEuvSlNL/N8EKqs4rCcezjAmiQGTeansi5C1bMJPa4c4GP53cLbX
         r3s91ups2cADj8ugTSZwMlFQQMWAZXJiINEmWLEKvfzsUcnGaF2Xz9PmBpKW1ctp1pLR
         xjNYRZ0+5PILKXhUAGcNcwByPwzZYN+6Hb9t3T3tCfJgBLrtJqpkEoshxENstRNoZrI8
         DyAEgYm25D5yoWSGbPJNVvq1LuO2ztEXFZTX6a2vkGfxyQp1PCb4XWyOO5FhD/057Ive
         r8RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L0J3YpwusZJdl822xOJrVTRXaMAMJEEQO1Sb/VD2+vs=;
        b=r+yqnWVBXKGL2/fwp60gjZF4cYeW1tPzykdOMlxnmar9btOuOGCZ5Dj641EnwclAfr
         YIFnp5fxJsyW3Bs51fYHW2Y53Sx08p9MqeC1m3jZvPzkMZyRUnAQue5uM+lksIxcbea5
         +4wF+KHYotbZibfKGETfZgfVm77IQniGmPH6OHtelSua7b/5n2M0SMpDaJnpoy9tZ3wE
         7JZQV/fSoX1Jt0CgLZVvMQwo+WY4RSCGbsyYwwYmwXfeCcQmJtf7ird1meRAhCEz459+
         dFxpmzvu52AloLqM/amHMdwQzmoYkt8Ln5VvTubYGyqKI/wYGhZTV7ENSoUMjkPJawqY
         YGCg==
X-Gm-Message-State: AOAM533zoaeFFAN0hu20aKDTc03t6tJfjad/3aglWJULCctuqAML8br7
        tn54q2DclEOPZ0pv4Gvkid4=
X-Google-Smtp-Source: ABdhPJzgRKTj5QbBra6Z7HLk9XpP/nk4tPPkUHvwqXzYiLw2kyn0bDr3SiMuRMutZqVLPzLnaBYNxQ==
X-Received: by 2002:a9d:6c90:: with SMTP id c16mr8089234otr.177.1611759471422;
        Wed, 27 Jan 2021 06:57:51 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id p25sm465776oip.14.2021.01.27.06.57.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 06:57:50 -0800 (PST)
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
To:     Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@resnulli.us>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, jacob.e.keller@intel.com, roopa@nvidia.com,
        mlxsw@nvidia.com, vadimp@nvidia.com
References: <20210120083605.GB3565223@nanopsycho.orion>
 <YAg2ngUQIty8U36l@lunn.ch>
 <20210120154158.206b8752@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210121153224.GE3565223@nanopsycho.orion>
 <971e9eff-0b71-8ff9-d72c-aebe73cab599@gmail.com>
 <20210122072814.GG3565223@nanopsycho.orion> <YArdeNwXb9v55o/Z@lunn.ch>
 <20210126113326.GO3565223@nanopsycho.orion> <YBAfeESYudCENZ2e@lunn.ch>
 <20210127075753.GP3565223@nanopsycho.orion> <YBF1SmecdzLOgSIl@lunn.ch>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1ebce5ce-1f0f-a218-6c6d-34f58571d6fe@gmail.com>
Date:   Wed, 27 Jan 2021 07:57:49 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <YBF1SmecdzLOgSIl@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/27/21 7:14 AM, Andrew Lunn wrote:
>> I don't think it would apply. The thing is, i2c driver has a channel to
>> the linecard eeprom, from where it can read info about the linecard. The
>> i2c driver also knows when the linecard is plugged in, unlike mlxsw.
>> It acts as a standalone driver. Mlxsw has no way to directly find if the
>> card was plugged in (unpowered) and which type it is.
>>
>> Not sure how to "embed" it. I don't think any existing API could help.
>> Basicall mlxsw would have to register a callback to the i2c driver
>> called every time card is inserted to do auto-provision.
>> Now consider a case when there are multiple instances of the ASIC on the
>> system. How to assemble a relationship between mlxsw instance and i2c
>> driver instance?
> 
> You have that knowledge already, otherwise you cannot solve this
> problem at all. The switch is an PCIe device right? So when the bus is
> enumerated, the driver loads. How do you bind the i2c driver to the
> i2c bus? You cannot enumerate i2c, so you must have some hard coded
> knowledge somewhere? You just need to get that knowledge into the
> mlxsw driver so it can bind its internal i2c client driver to the i2c
> bus. That way you avoid user space, i guess maybe udev rules, or some
> daemon monitoring propriety /sys files?
> 
>> But again, auto-provision is only one usecase. Manual provisioning is
>> needed anyway. And that is exactly what my patchset is aiming to
>> introduce. Auto-provision can be added when/if needed later on.
> 
> I still don't actually get this use case. Why would i want to manually
> provision?
> 


+1.
