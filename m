Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93E067782A
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 12:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbfG0Kch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 06:32:37 -0400
Received: from mail-wr1-f41.google.com ([209.85.221.41]:42034 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbfG0Kch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 06:32:37 -0400
Received: by mail-wr1-f41.google.com with SMTP id x1so6957299wrr.9;
        Sat, 27 Jul 2019 03:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=I9urIWyfzBTbYOSOMidgQgAJ5dRa4kNEamHc41n0CB4=;
        b=D08JMQPXt/3RUaObdc1X8+6L+8vSHaCR0ke9D5Igdcmo2wCHOuHCjKSABfQxGKCtPK
         VyewGU96h6ATR5UuRnwvfs8CoohZp6jICPXFYJcZX4mamjDCEQ6ddXxRG2DxLXjr6sk5
         LFhgiZ+QpqXPlHpoQZgzoNZzn3JMW3j5WHAsZtpxHxoJnAD+Urp/TdnsCFZEJ+Jw8yJ0
         YJy0GF7gru7J6XYUF6GG0xZPG2QygHpD39iL1fro1xS0TYS7O3XmUCrvStdQR8PIbpV3
         ccM8m/h9iMmFt/NdKkjaE9+EynxLTTl5bB3hHCR6qwbQKEDW6kpo3ZMUCRWGoWtdfEPh
         Td8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=I9urIWyfzBTbYOSOMidgQgAJ5dRa4kNEamHc41n0CB4=;
        b=mnTQmNTcnjb5dA1rAf+eQM89L26tEbfDigso9mQ1mrSgVUGHebl4HIsGk4K0JgxK2L
         DHxTuqRi0OVzE1fS6qQccb/Rmifp0/GLyEvqLgWLo8r7hlZTYngLI2J617G5tk5yG7Ds
         XpZlvTrVmkOFA91qVJp0v4M5fV/wcS6F2cFn6e9NDds9UWXlhc8WfKNRq2BZyBfOkqWD
         fRkEQduUFHzYWaLhAt+kQQgct4sz1cAVBZT/3U/2PtSexBlpV7VYqQTLaes3hNMvks+l
         np7TNYFd5iLKq5zhc83BN6g5Pb8vIupTXK243Jlr3RwGemnPiPI8I46uCUt93YKgNpA7
         DPUg==
X-Gm-Message-State: APjAAAXSeTLYTB20C21VcP43mnLgLySp8eUtaAt/dN6qTypIkwA9hARj
        qR1tlfxJQHdp1RUx7+s7Kf+R2cTo
X-Google-Smtp-Source: APXvYqxDNZmdyAMjswJgvBjZzalaaqC1Szyson1mZJ5ZiQmYZ7RuwdNLSUctMM+/yVdLnjQ2UXoR1w==
X-Received: by 2002:adf:f6cb:: with SMTP id y11mr21486105wrp.245.1564223554872;
        Sat, 27 Jul 2019 03:32:34 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f43:4200:c0a4:381:9a20:d2e8? (p200300EA8F434200C0A403819A20D2E8.dip0.t-ipconnect.de. [2003:ea:8f43:4200:c0a4:381:9a20:d2e8])
        by smtp.googlemail.com with ESMTPSA id j33sm112993820wre.42.2019.07.27.03.32.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 27 Jul 2019 03:32:34 -0700 (PDT)
Subject: Re: [REGRESSION] 5.3-rc1: r8169: remove 1000/Half from supported
 modes
To:     Bernhard Held <berny156@gmx.de>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>
References: <a291af45-310c-8b60-ae7e-392e73e3bad1@gmx.de>
 <0a48ecd7-7134-222d-833d-c1f65e055c02@gmail.com>
 <9af99856-2e5d-0e3a-34d3-0582da869919@gmx.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <603ca390-eeb2-d50b-c2e6-9e22d92c535b@gmail.com>
Date:   Sat, 27 Jul 2019 12:27:22 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <9af99856-2e5d-0e3a-34d3-0582da869919@gmx.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.07.2019 22:45, Bernhard Held wrote:
> On 26.07.19 at 22:24, Heiner Kallweit wrote:
>> On 26.07.2019 22:16, Bernhard Held wrote:
>>> Hi Heiner,
>>>
>>> with commit a6851c613fd7 "r8169: remove 1000/Half from supported modes" my RTL8111B GB-link stops working. It thinks that it established a link, however nothing is actually transmitted. Setting the mode with `mii-tool -F 100baseTx-HD` establishes a successful connection.
>>>
>> Can you provide standard ethtool output w/ and w/o this patch? Also a full dmesg output
>> with the patch would be helpful.
>> Is "100baseTx-HD" a typo and you mean GBit? And any special reason why you set half duplex?
>>
> 
> The requested files are attached.
> 
Looks all normal. So it seems to be a HW issue with the integrated PHY (RTL8211B).
This PHY version is used also e.g. in RTL8168d. So better revert the original change.

> mii-tool doesn't offer GBit settings. I used HD only while playing around, both FD and HD are working.
> 
> Hope it helps!
> Bernhard
Heiner
