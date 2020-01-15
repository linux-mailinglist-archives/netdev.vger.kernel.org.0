Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 739F013C20A
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728993AbgAOM4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:56:10 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:47002 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbgAOM4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 07:56:09 -0500
Received: by mail-wr1-f65.google.com with SMTP id z7so15585198wrl.13
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 04:56:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:reply-to:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=VxlSxGsjaw3XbLjk3Wz+oaxE7Lm4kDdZDI9fLrleqPg=;
        b=FA/XKCcJhJ4S+ARTRYu3ai3NJG3TspO4t348SKO1zQo0zJZgZAECmbcsPgeMM3S1tZ
         oRmrOYMo1wNMUVrclXPmPL0XZVqKdtR72ruGytqf98t74/AKVVIjTKSWnkXZs/isOPgD
         5vhZBMBRG8NN6B3nnnv6r659KLNIjNsrijKNOFvmG40HGzHZEbvBXyXicY5gj9ijjJt9
         C/+izWUdLQFMaQocRUpNTv6Mzzx+0u7Dy1BkCMckANW5JzOE48i3uMuLAxl3+qFiVkwU
         wK8AAtKRWp3fZDeyP9931P7VbZQfVGT2LUeN0xd99YeAqSGsWGhajbigFp3cgYH/hEtR
         I95A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:reply-to:subject:to:cc:references
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=VxlSxGsjaw3XbLjk3Wz+oaxE7Lm4kDdZDI9fLrleqPg=;
        b=ci7ah2lSEVbjDpL2hxXktdhfEzqL7Uvjqm1zF1iZH0PADSPXZ0/v7eMko3EKxLbyG/
         OLj1RKGP7nat5Hb8W7isf65+gKkG60FVH9mGwawSyR5befSWjHvJuu6YeZ4cNqGKOSLG
         mHbvElPvLo4zlNgtC0k74lNqKOuA3x+fAldhvokGVxwF1l55y8XnghLnE/yASicyz6xr
         05Mu+SKlMU2ywzUsDnYpudbQVOu+EiSYQWQV/2HlYdZ1PsJ4fuL7wdmF0EBxI/foOHvu
         MPcT9UfaU/VCzUtk0YlnbD6hGCO7dTJ8i2zAC7vr7r2rZkN55Nyb/aFZ3ylDw7QZ8WSl
         slog==
X-Gm-Message-State: APjAAAXzTUMs8Me5z60OkePn25ENHlCvzFVdBOIP30Fl3/8F0yKBh/xT
        usKlrTZ43InUgzQu41+14gA=
X-Google-Smtp-Source: APXvYqzEKxtdZjZEKuFNqjy+0W+gokbG3XdC3mU6u0DKJBH0+xlGlUe6d/byd9Ee3Ags8WqTkmC3Sw==
X-Received: by 2002:adf:a285:: with SMTP id s5mr30947034wra.118.1579092967742;
        Wed, 15 Jan 2020 04:56:07 -0800 (PST)
Received: from [192.168.84.205] ([149.224.248.209])
        by smtp.gmail.com with ESMTPSA id b17sm24908966wrx.15.2020.01.15.04.56.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2020 04:56:06 -0800 (PST)
From:   "=?UTF-8?B?4oSi1p/imLvSh8ytING8INKJIMKu?=" <vtolkm@googlemail.com>
X-Google-Original-From: =?UTF-8?B?4oSi1p/imLvSh8ytING8INKJIMKu?= <vtolkm@gmail.com>
Reply-To: vtolkm@gmail.com
Subject: Re: loss of connectivity after enabling vlan_filtering
To:     netdev@vger.kernel.org
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
References: <e5252bf0-f9c1-3e40-aebd-8c091dbb3e64@gmail.com>
 <20190629224927.GA26554@lunn.ch>
 <6226b473-b232-e1d3-40e9-18d118dd82c4@gmail.com>
 <20190629231119.GC26554@lunn.ch>
 <53bd8ffc-1c0a-334d-67d5-3a74b76670e8@gmail.com>
 <20190705132957.GB6495@t480s.localdomain>
 <4af746cc-b86a-f083-49f7-558df05148bd@gmail.com>
Message-ID: <5a23e1e0-fde0-773b-7c3a-95bfd5761482@gmail.com>
Date:   Wed, 15 Jan 2020 12:56:03 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101 Firefox/68.0
MIME-Version: 1.0
In-Reply-To: <4af746cc-b86a-f083-49f7-558df05148bd@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/01/2020 21:33, ™֟☻̭҇ Ѽ ҉ ® wrote:
> On 05/07/2019 17:29, Vivien Didelot wrote:
>> On Sun, 30 Jun 2019 01:23:02 +0200, vtolkm@googlemail.com wrote:
>>> A simple soul might infer that mv88e6xxx includes MV88E6060, at least
>>> that happened to me apparently (being said simpleton).
>> I agree that is confusing, that is why I don't like the 'xxx' naming
>> convention in general, found in many drivers. I'd prefer to stick with a
>> reference model, or product category, like soho in this case. But it was
>> initially written like this, so no reason to change its name now. I 
>> still
>> plan to merge mv88e6060 into mv88e6xxx, but it is unfortunately low 
>> priority
>> because I still don't have a platform with a 88E6060 on it.
>>
>> Thanks,
>>
>>     Vivien
>
> At long last discovered (accidentality) what causes the loss of 
> connectivity when enabling vlan_filtering, the node being dual-core 
> and each core providing a port facing the switchdev:
>
> cpu0 - eht0 [RGMII] <--- > switchdev port 6
> cpu1 - eth1 [RGMII] <--- > switchdev port 5
>
> If only one of the CPU ports is connected to the respective switchdev 
> port connectivity to the node gets severed when enabling vlan_filtering.
> With both CPU ports connected to the respective switchdev ports 
> connectivity remains uninterrupted to the node when enabling 
> vlan_filtering.

The WIP patch at the downstream distro that remedies the issue for the 
particular device (dsa-multi-cpu) is accessible here:

https://gitlab.labs.nic.cz/turris/turris-build/commit/b440de75ba0f4a8dbfb530fcae2a821f26cde2a8

