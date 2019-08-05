Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F09AA811CA
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 07:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbfHEFy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 01:54:27 -0400
Received: from mail-wm1-f50.google.com ([209.85.128.50]:36983 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbfHEFy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 01:54:27 -0400
Received: by mail-wm1-f50.google.com with SMTP id f17so71688964wme.2
        for <netdev@vger.kernel.org>; Sun, 04 Aug 2019 22:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jaSRKa6NboBKbINxsWecx4ULsiqMvob5Un8Y+vVKIew=;
        b=nz1lRTnbxaBYmTunGG0Q0C3y+61cRsRmyIylSFdEgBZR94p/f3GbFHCQFitxyg8yU+
         6llRBIcNzrM2F2NrlZ/4MzJbJl/dgatlfL5r6IPu+87+a2MaSqpS26K5U/VaQVqPojwe
         TAWZZbrMhimtBjCKcXCk+BKh9+ViC5D+Oijm3Ccnj8GF3CryG3kHulylxKMyXWeuGByo
         nLhVKMCZ3M0dFZmV/LPkaxoRolNcjg8GFXEm+7RKGgjRWc9qeUKXvciozzn2OGhdxAYx
         sPiYakWufiSqY6Tp3Qc68uFhj8oxpfpMqed4pHKp75K/37gbzZmKxtMQUcJGXJQOfNnm
         lIsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jaSRKa6NboBKbINxsWecx4ULsiqMvob5Un8Y+vVKIew=;
        b=Xk3L9VuDOYfxEIYNvskxcwwhRf2OzHQhvsMJQjISDmRaaZl8tXCce6oV6frYmUUdna
         dz/4noxH3RB5F1dtb9IcRu/AoytoQ7yTH20TNAxsEHrJp6i8ZJ8lFB0LAYho1LNMiJKA
         N5/siQ/RGwXg6UTPUfsUzZp0nZewxY79R3sEZckXFxKKu03IBEPILvyCcjKZxwHVokjg
         GGeDK5SP9UkM+5MxdYPwZy+4XM8XQ1nDLlbX4VSb74dX7L/H8UcDv1Ipn/nFOFZXMxpi
         eIY73MaCUQr7hCUdUFIAAbvmISlytmVyomjBvRfuH2VR9rPpwaYsgmmv1o7g30kkvFSU
         /kdg==
X-Gm-Message-State: APjAAAXCDwd3mHd6SS4zhB7GkJmqfqbAz5ub1DF2j4JuzHbtLt/rsDmw
        HuGQ0hrfb6EemcaupEE7I54=
X-Google-Smtp-Source: APXvYqzUC3rtO35nB61F8043FonDEFccqt9tED3EpEjON7gDkq7gXTSvPa0hoHwfW9EovUdLxQCwcg==
X-Received: by 2002:a1c:18a:: with SMTP id 132mr16696077wmb.15.1564984464969;
        Sun, 04 Aug 2019 22:54:24 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id p63sm33873941wmp.45.2019.08.04.22.54.23
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 04 Aug 2019 22:54:23 -0700 (PDT)
Date:   Mon, 5 Aug 2019 07:54:22 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, davem@davemloft.net,
        sthemmin@microsoft.com, mlxsw@mellanox.com
Subject: Re: [patch net-next v2 1/3] net: devlink: allow to change namespaces
Message-ID: <20190805055422.GA2349@nanopsycho.orion>
References: <20190730085734.31504-1-jiri@resnulli.us>
 <20190730085734.31504-2-jiri@resnulli.us>
 <20190730153952.73de7f00@cakuba.netronome.com>
 <20190731192627.GB2324@nanopsycho>
 <c4f83be2-adee-1595-f241-de4c26ea55ca@gmail.com>
 <20190731194502.GC2324@nanopsycho>
 <087f584d-06c5-f4b9-722b-ccb72ce0e5de@gmail.com>
 <89dc6908-68b8-5b0d-0ef7-1eaf1e4e886b@gmail.com>
 <20190802074838.GC2203@nanopsycho>
 <6f05d200-49d4-4eb1-cd69-bd88cf8b0167@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f05d200-49d4-4eb1-cd69-bd88cf8b0167@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Aug 02, 2019 at 05:45:36PM CEST, dsahern@gmail.com wrote:
>On 8/2/19 1:48 AM, Jiri Pirko wrote:
>> Wed, Jul 31, 2019 at 09:58:10PM CEST, dsahern@gmail.com wrote:
>>> On 7/31/19 1:46 PM, David Ahern wrote:
>>>> On 7/31/19 1:45 PM, Jiri Pirko wrote:
>>>>>> check. e.g., what happens if a resource controller has been configured
>>>>>> for the devlink instance and it is moved to a namespace whose existing
>>>>>> config exceeds those limits?
>>>>>
>>>>> It's moved with all the values. The whole instance is moved.
>>>>>
>>>>
>>>> The values are moved, but the FIB in a namespace could already contain
>>>> more routes than the devlink instance allows.
>>>>
>>>
>>>From a quick test your recent refactoring to netdevsim broke the
>>> resource controller. It was, and is intended to be, per network namespace.
>> 
>> unifying devlink instances with network namespace in netdevsim was
>> really odd. Netdevsim is also a device, like any other. With other
>> devices, you do not do this so I don't see why to do this with netdevsim.
>> 
>> Now you create netdevsim instance in sysfs, there is proper bus probe
>> mechanism done, there is a devlink instance created for this device,
>> there are netdevices and devlink ports created. Same as for the real
>> hardware.
>> 
>> Honestly, creating a devlink instance per-network namespace
>> automagically, no relation to netdevsim devices, that is simply wrong.
>> There should be always 1:1 relationshin between a device and devlink
>> instance.
>> 
>
>Jiri: prior to your recent change netdevsim had a fib resource
>controller per network namespace. Please return that behavior or revert
>the change.

There was implicit devlink instance creation per-namespace. No relation
any actual device. It was wrong and misuse of devlink.

Now you have 1 devlink instance per 1 device as it should be. Also, you
have fib resource control for this device, also as it is done for real
devices, like mlxsw.

Could you please describe your usecase? Perhaps we can handle
it differently.
