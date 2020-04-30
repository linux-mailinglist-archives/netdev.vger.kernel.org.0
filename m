Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7D61C04E4
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 20:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbgD3SeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 14:34:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726318AbgD3SeW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 14:34:22 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6083AC035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 11:34:22 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id e9so2539337iok.9
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 11:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5QFco3scFmZsURbcO8FGGTe4Us0rmp1xGI/el6b2R04=;
        b=eYn828yPyvPLtoR8YQQXVPUyAsginoHhuhnWYqCY6fjAiyIp5IQn1UUcn6EJVm4OhI
         lUv3SltEdsOGGmlpVyxLEQfHIqcouluhOg5E75aoyERp8sd8D/I9zpydGgXK4jwwuTFz
         b4q3Y7rS73IEwj/YoSNwnCXu7cnlcogjgUi6ax6bSaRdGpcnY2Rh+Tn3KPxFxfctqEd+
         5YsBjokqkFAIP9qxdxyPTSKQfDRecfAu/Oout/dmtTblkFJ62wCosf5hhnfWVhXS+o9l
         GTfsYv7z3fwBN8/rvma1NrdnAnvl26NYOg2jmg2VPPV3oaGBEy9HNbjEPsMKT8ifNPPT
         D+Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=5QFco3scFmZsURbcO8FGGTe4Us0rmp1xGI/el6b2R04=;
        b=IHUGqsa/1F9acCAsCB/hFsXjWgF6fTEhLOXVS+AaHjMAqUBVEBChAIGqsCowQroCS/
         ZAv9nch/DgTWhjrYNtUR9Fb8Hvl65dGPdH/3SaPrcELQ4G4N6J82n2xK5joPsItv8Ydn
         yVQKC+0o0Xtiu3g6/YHoM/ltyiY437OSygYA2xDo1fYQd0AVuacq4O87M066vthYKeq9
         PLt0YuPA9v1Y1GM2RjbSJ25R2f+2wUixV3AN8QbHl6iShIFpcP/E6TvnIZ5p7rO/LCLf
         iHZ9wu3PEaXdtKMx5Oe+m5INCPTvNIMETCdU/v9JKBO9VP/hoaCE7/jbxv1YG6L5i++m
         5Dzg==
X-Gm-Message-State: AGi0PuYcDnYTPL8iD0wCdOpz2t8kh7ee5hwuXUnWB0zZhwoLarrcJPCf
        iiBoYQUFqyiYCAX1hh+5EMFAa1xM
X-Google-Smtp-Source: APiQypK1RQHE7pFQMvwreylMJgkaoio57fX7DrNpHVyembd+zaP5zVfmZMsni0fwA4APw5Y1YyM5bA==
X-Received: by 2002:a6b:f812:: with SMTP id o18mr89230ioh.87.1588271661275;
        Thu, 30 Apr 2020 11:34:21 -0700 (PDT)
Received: from [10.67.49.116] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id z86sm199780ilk.79.2020.04.30.11.34.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2020 11:34:20 -0700 (PDT)
Subject: Re: [PATCH net-next v1 0/9] Ethernet Cable test support
To:     Michael Walle <michael@walle.cc>, Andrew Lunn <andrew@lunn.ch>
Cc:     cphealy@gmail.com, davem@davemloft.net, hkallweit1@gmail.com,
        mkubecek@suse.cz, netdev@vger.kernel.org
References: <20200425180621.1140452-1-andrew@lunn.ch>
 <20200429160213.21777-1-michael@walle.cc> <20200429163247.GC66424@lunn.ch>
 <c4363f2888192efc692e08cc1a4a9a57@walle.cc>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <61eb35f8-3264-117d-59c2-22f0fdc36e96@gmail.com>
Date:   Thu, 30 Apr 2020 11:34:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <c4363f2888192efc692e08cc1a4a9a57@walle.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/30/20 10:48 AM, Michael Walle wrote:
> Hi Andrew,
> 
> Am 2020-04-29 18:32, schrieb Andrew Lunn:
>> On Wed, Apr 29, 2020 at 06:02:13PM +0200, Michael Walle wrote:
>>> Hi Andrew,
>>>
>>> > Add infrastructure in ethtool and phylib support for triggering a
>>> > cable test and reporting the results. The Marvell 1G PHY driver is
>>> > then extended to make use of this infrastructure.
>>>
>>> I'm currently trying this with the AR8031 PHY. With this PHY, you
>>> have to select the pair which you want to start the test on. So
>>> you'd have to start the test four times in a row for a normal
>>> gigabit cable. Right now, I don't see a way how to do that
>>> efficiently if there is no interrupt. One could start another test
>>> in the get_status() polling if the former was completed
>>> successfully. But then you'd have to wait at least four polling
>>> intervals to get the final result (given a cable with four pairs).
>>>
>>> Any other ideas?
>>
>> Hi Michael
>>
>> Nice to see some more PHYs getting support for this.
>>
>> It is important that the start function returns quickly. However, the
>> get status function can block. So you could do all the work in the
>> first call to get status, polling for completion at a faster rate,
>> etc.
> 
> Ok. I do have one problem. TDR works fine for the AR8031 and the
> BCM54140 as long as there is no link partner, i.e. open cable,
> shorted pairs etc. But as soon as there is a link partner and a
> link, both PHYs return garbage. As far as I understand TDR, there
> must not be a link, correct? The link partner may send data or
> link pulses. No how do you silence the local NIC or even the peer?

Michael do you use the enhanced cable diagnostics (ECD) or the simple
cable diagnostics? Having tried to get older Broadcom PHYs to work with
cable diagnostics, you need to calibrate the PHY prior to running
diagnostics and you need to soft reset it.
-- 
Florian
