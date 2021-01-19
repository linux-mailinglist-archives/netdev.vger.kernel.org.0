Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 809DF2FAEDC
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 03:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394301AbhASCko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 21:40:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388880AbhASCka (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 21:40:30 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0FA2C061757
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 18:39:49 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id v21so619651otj.3
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 18:39:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mK17lFLYSM3FDILVRBCFSGwjHVpA0uwJrPsUIFSLGUY=;
        b=HKaZX/lIMR3MXfAVyRrCmV/eEJ1pBA0i41wBHOX1JYWMF/Z9M0PHD3rdrBV5ADI1UP
         nhX6y2SfwzHmd0bohRoryhodHFdJ/CCInopTBO/0gIhXPHa02nNnXz66DBNtC/KHTB35
         ixuvXqSHL999h1EOYdYnEhGUUwG631CMAATT4k/kH13Wf7H+hcLvZepg5VogEgiU4Lyv
         jV4a7OYcuyr6w3umrbuBj/QUKG2s/3azoeJNpGm7ozBUaQFX3gJU3ZeFTcIyHRMxF4Jk
         8ME2kHZyXIhWXOktaOfSNXqgF9sVz01zp5b2GSX0QdQJeo8FEZGZwColCx2WcZRGaIFp
         /R8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mK17lFLYSM3FDILVRBCFSGwjHVpA0uwJrPsUIFSLGUY=;
        b=gmDht0I8xearbaCBnvVnt2OAgdYH5K51bTp8kb8WP1yuMi/JEwZZnBxBqJMMUqxJeI
         CUFPzwiLwPVWRdz78N9uEdYizqc0CMyRtzPX0F//sM+PzwoPzcBJtQNCcjRMOhBsP3Tf
         a8onJZsElraQq7hze2UhiUQD9SkVdDfZYj/k422uM64d8tYYbWWrfiA0vDHXAl2smR/v
         IbM3svEHH4bhH5M11aOGQN01/VoqW1nMRJodgSTDUDXODsTwF5jS3Gr0igPQckv7BlfS
         8hrsIvXzg1dAzxvHTemB4mFrFHokf5loOnmYuhRh0//Qmxsy2KpvZb46fy/k5X6vuA1H
         O/jA==
X-Gm-Message-State: AOAM530so8YIVecAI3OJPT/shqnFTIF2mxCU8C8mRaDpY4BNM/Xn8ExS
        +Y/MZxLNpvcW23SGYy7i9aw=
X-Google-Smtp-Source: ABdhPJxYhGIoo1RGUjyX4ZXUckaE11vVAdIEFsjAH+3b9CcYSSThEQQ+qxys+x2IhZpL70BLV0EkHA==
X-Received: by 2002:a9d:6393:: with SMTP id w19mr1846062otk.204.1611023989244;
        Mon, 18 Jan 2021 18:39:49 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.6.112.59])
        by smtp.googlemail.com with ESMTPSA id l12sm3960523ooq.22.2021.01.18.18.39.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 18:39:48 -0800 (PST)
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
To:     Edwin Peer <edwin.peer@broadcom.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>, roopa@nvidia.com,
        mlxsw <mlxsw@nvidia.com>
References: <20210113121222.733517-1-jiri@resnulli.us>
 <CAKOOJTyWWsK0YgN+FVF8QgHaTbZrjpEYkG6Cfs4UVsB9Y8Mj9Q@mail.gmail.com>
 <9b940a66-8c91-34c1-e64e-42b92bf403a8@gmail.com>
 <CAKOOJTwmaqvPrF2Dr_ZqozysOUJUKuJdGgJ7xK2f66FCHXfyvg@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5ee0f841-2474-ef27-ac5d-7686d40bc18f@gmail.com>
Date:   Mon, 18 Jan 2021 19:39:47 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <CAKOOJTwmaqvPrF2Dr_ZqozysOUJUKuJdGgJ7xK2f66FCHXfyvg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/18/21 4:40 PM, Edwin Peer wrote:
> On Mon, Jan 18, 2021 at 2:57 PM David Ahern <dsahern@gmail.com> wrote:
> 
>> On 1/18/21 11:01 AM, Edwin Peer wrote:
>>> I'm facing a similar issue with NIC firmware that isn't yet ready by
>>> device open time, but have been resisting the urge to lie to the stack
>>
>> why not have the ndo_open return -EBUSY or -EAGAIN to tell S/W to try
>> again 'later'?
> 
> Indeed, this is what we ended up doing, although we still need to
> confirm Network Manager, systemd and whatever else our customers might
> use do the necessary to satisfy the user requirement to handle the
> delayed init.

I am not surprised about the issue - boot times have been improved and
devices have gotten more complicated. And I was wondering how network
managers (add ifupdown{2} to that list) would handle an EAGAIN. You
could have an event sent -- e.g., IFLA_EVENT_FW_READY -- to allow
managers to avoid polling. Redundant for multiple netdev's per device,
but makes it event driven.

> 
> Only reason I piped up is that this line card thing seems to introduce
> a similar issue.

Seems reasonable.
