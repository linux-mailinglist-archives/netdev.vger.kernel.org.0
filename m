Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95C85348758
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 04:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbhCYDI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 23:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbhCYDIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 23:08:46 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BDE2C06174A
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 20:08:45 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id l4so510850ejc.10
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 20:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eiH/f20JXf80S7r+wt8BDdMH8hUCl1kZz8m0idNG86Y=;
        b=nc5bt8eh63o/j08cD/HOhxHcLvkqXj9CgYIdyCs4ccjiYJjkkVA+apVeIaWtZa1eb5
         0eTsPTqlK6HU6edYMLN1t1sbe5oBD3Gv1Kx5bT6V0cx35n9ohqrsIbBF6ZGxPthH8Ybz
         sFxURa0R+YeFQsLJhep1KNMlN5BGIT0fwPj3uM/o59M3FNlR2cSGyxzwqLtek99Bmxt2
         KuKRPco4/43RnBOZcSeM7Ku++2sg1LOvCMHXn1SNmVF98uXspxkQsJYhnQuP/thE8MDc
         wCyDb9/PkgGapsWouoif8M/S7uP0GJxReHU/QUzJZCYSpdvieSC4NoQDPRzOlKCAIYpq
         fPZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eiH/f20JXf80S7r+wt8BDdMH8hUCl1kZz8m0idNG86Y=;
        b=nlWRQri/Utet54kRtphL/Z8Ml5u3SGpXeT/7LQCQc9oQaR0cZe9imVGXGKLyAkWY9h
         3/CoRnsLUDXTv+f/drroLirqtdnDiZWZMvYImrwxcRlnjpLtIsG/PGi557b7fmGDZueR
         G86KHqFQI/BOTQ92B4uJBpNw629VnIWjPyYHASM+322G6QIF5aLUTlB8yPBRrvtof+8d
         ixu9hCxN3iLbrhB3ST73sSx7NWz820H4WsHb8tYZVwPjN/5yCxKlSDcqU1cspU6kDZUJ
         PbgamPj7PvGzsPzYu9VI0ZZYDDAwbrNXn+mda9eI6Spm40QZr0CXcrGkgJEtcJtzpUJA
         5kxQ==
X-Gm-Message-State: AOAM532oxVZohSshWT5zd52iyylAu0khwtOHOL35tjB702DCpZYnePtR
        J9LlBq61251CIodq0CIf/xg=
X-Google-Smtp-Source: ABdhPJwq589NMGbi4+iWBofV0FoOxM47X3fSBGzGzVoSWQeGNjMSkRD3k4pjX4jOhQLQbCDODEL+mw==
X-Received: by 2002:a17:907:2112:: with SMTP id qn18mr6847556ejb.220.1616641724321;
        Wed, 24 Mar 2021 20:08:44 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id b18sm1767616ejb.77.2021.03.24.20.08.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Mar 2021 20:08:43 -0700 (PDT)
Subject: Re: lantiq_xrx200: Ethernet MAC with multiple TX queues
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        netdev@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        andrew@lunn.ch, vivien.didelot@gmail.com, davem@davemloft.net,
        kuba@kernel.org
References: <CAFBinCArx6YONd+ohz76fk2_SW5rj=VY=ivvEMsYKUV-ti4uzw@mail.gmail.com>
 <20210324201331.camqijtggfbz7c3f@skbuf>
 <874dd389-dd67-65a6-8ccc-cc1d9fa904a2@gmail.com>
 <20210324222114.4uh5modod373njuh@skbuf>
 <7510c29a-b60f-e0d7-4129-cb90fe376c74@gmail.com>
 <20210325011815.fj6m4p5k6spbjefc@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <4855cadd-8613-e8e0-14e9-a7feb96ba214@gmail.com>
Date:   Wed, 24 Mar 2021 20:08:40 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210325011815.fj6m4p5k6spbjefc@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/24/2021 6:18 PM, Vladimir Oltean wrote:
> On Wed, Mar 24, 2021 at 04:07:47PM -0700, Florian Fainelli wrote:
>>> What are the benefits of mapping packets to TX queues of the DSA master
>>> from the DSA layer?
>>
>> For systemport and bcm_sf2 this was explained in this commit:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d156576362c07e954dc36e07b0d7b0733a010f7d
>>
>> in a nutshell, the switch hardware can return the queue status back to
>> the systemport's transmit DMA such that it can automatically pace the TX
>> completion interrupts. To do that we need to establish a mapping between
>> the DSA slave and master that is comprised of the switch port number and
>> TX queue number, and tell the HW to inspect the congestion status of
>> that particular port and queue.
>>
>> What this is meant to address is a "lossless" (within the SoC at least)
>> behavior when you have user ports that are connected at a speed lower
>> than that of your internal connection to the switch typically Gigabit or
>> more. If you send 1Gbits/sec worth of traffic down to a port that is
>> connected at 100Mbits/sec there will be roughly 90% packet loss unless
>> you have a way to pace the Ethernet controller's transmit DMA, which
>> then ultimately limits the TX completion of the socket buffers so things
>> work nicely. I believe that per queue flow control was evaluated before
>> and an out of band mechanism was preferred but I do not remember the
>> details of that decision to use ACB.
> 
> Interesting system design.
> 
> Just to clarify, this port to queue mapping is completely optional, right?
> You can send packets to a certain switch port through any TX queue of
> the systemport?

Absolutely, the Broadcom tags allow you to steer traffic towards any TX
queue of any switch port. If ring inspection is disabled then there is
no flow control applied whatsoever.
-- 
Florian
