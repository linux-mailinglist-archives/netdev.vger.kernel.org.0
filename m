Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF9A2853AF
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 23:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727476AbgJFVLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 17:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727176AbgJFVLv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 17:11:51 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77CBDC061755;
        Tue,  6 Oct 2020 14:11:51 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id a200so49159pfa.10;
        Tue, 06 Oct 2020 14:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2tqJkBGJARHw0fisbVFNUFYK1tY9kLS6Zh35Q++bpoc=;
        b=hrbCklgzpYH5awrwrrE3PsY2AVZbXUZCxoXi6hUDTIv4xb4bs4hcZBBnlF6tWVhWou
         wX1FRs7vh9C8QB5lzSeO+rZtZ2ZKLs9csrIzYIP0seS0y1pHTa/A9kuu8mJZ9NomMfG7
         MUvuZRNRjH1dV+bYREfJ60lw7pnSimPL+0SJXLMlak5yGJXSYoWTt7tj77EMmqBfVBsC
         GzZEBrH9+6fgQMzswZzytanpbFFHZlMUwaIKSplHrhlcWDS4wGadWQnsFmOdqcUfHFqU
         QNVG+vJL9R/ZJuZqgnQBZ8yqHBJ8jmxROnuhrs+7ZqnR/n6ZnRBPEd955vka3TbuT3RO
         wL/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2tqJkBGJARHw0fisbVFNUFYK1tY9kLS6Zh35Q++bpoc=;
        b=jyPK4ctMBGFlgB8Ftu3/OSIbD7PuDID65h25keSvYG/JveKSXenewSFZGcPc+nYkss
         zXuUarjvGf8JdoXgeQPg41L+sw6gIwvEG2UeTBFnHMCcGQlIRXPcz9Yv7LG1/kowNlnV
         N4hnvqrmVMv9AxSay7+Cpb20n6iV1wHiQ3JYA1TDCnqGeGEIFim7AUAf3llhpHBZWYTV
         r/N6IU9Qdn6LSqGrfays7UPIc4w7zZmmmcBciycX8yEAcq5ktewPJVKCGQ4QKm8kan5H
         2zks5nhOuLeSo4Uwjrc1QqA2ri52K8w0d5PSe4OGWiwzaEsQsVTeCXtmyw6weNaqojCT
         r/GQ==
X-Gm-Message-State: AOAM530n5iQe6O9ns7qc1xtvdas/OiOtJbrLAkHZIRMQPTmqcrEiI1Iu
        7+vUFr2A9+1aIfZ1h+FVQsI=
X-Google-Smtp-Source: ABdhPJwQ7h4I2JibCyvrjDaoC8dqkF4Gm/PbNbnwlnIJtnayOi1FJHbZ5uc+lWHTY8tQGtWpq6GaYg==
X-Received: by 2002:a63:dc4f:: with SMTP id f15mr102197pgj.332.1602018711026;
        Tue, 06 Oct 2020 14:11:51 -0700 (PDT)
Received: from [10.230.29.112] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h15sm83588pfo.194.2020.10.06.14.11.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Oct 2020 14:11:50 -0700 (PDT)
To:     Marek Vasut <marex@denx.de>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de
References: <20201006080424.GA6988@pengutronix.de>
 <2cc5ea02-707e-dbb5-c081-4c5202bd5815@gmail.com>
 <42d4c4b2-d3ea-9130-ef7f-3d1955116fdc@denx.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: PHY reset question
Message-ID: <0687984c-5768-7c71-5796-8e16169f5192@gmail.com>
Date:   Tue, 6 Oct 2020 14:11:48 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <42d4c4b2-d3ea-9130-ef7f-3d1955116fdc@denx.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/6/2020 1:24 PM, Marek Vasut wrote:
> On 10/6/20 9:36 PM, Florian Fainelli wrote:
> [...]
>>> - Use compatible ("compatible = "ethernet-phy-id0022.1560") in the
>>> devicetree,
>>>     so that reading the PHYID is not needed
>>>     - easy to solve.
>>>     Disadvantage:
>>>     - losing PHY auto-detection capability
>>>     - need a new devicetree if different PHY is used (for example in
>>> different
>>>       board revision)
>>
>> Or you can punt that to the boot loader to be able to tell the
>> difference and populate different compatible, or even manage the PHY
>> reset to be able to read the actual PHY OUI. To me that is still the
>> best solution around.
> 
> Wasn't there some requirement for Linux to be bootloader-independent ?

What kind of dependency does this create here? The fact that Linux is 
capable of parsing a compatible string of the form 
"ethernet-phyAAAA.BBBB" is not something that is exclusively applicable 
to Linux. Linux just so happens to support that, but so could FreeBSD or 
any OS for that matter.

This is exactly the way firmware should be going, that is to describe 
accurately the hardware, while making the life of the OS much easier 
when it can. If we supported ACPI that is exactly what would have to 
happen IMHO.

> Some systems cannot replace their bootloaders, e.g. if the bootloader is
> in ROM, so this might not be a solution.

It is always possible to chain load a field updateable boot loader, and 
even when that is not desirable you could devise a solution that allows 
to utilize say a slightly different DTB that you could append to the 
kernel. Again, if you want to use strictly the same DTB, then you have 
to do what I just suggested and have the boot loader absorb some of this 
complexit

> 
>>> - modify PHY framework to deassert reset before identifying the PHY.
>>>     Disadvantages?
> 
> If this happens on MX6 with FEC, can you please try these two patches?
> 
> https://patchwork.ozlabs.org/project/netdev/patch/20201006135253.97395-1-marex@denx.de/
> 
> https://patchwork.ozlabs.org/project/netdev/patch/20201006202029.254212-1-marex@denx.de/

Your patches are not scaling across multiple Ethernet MAC drivers 
unfortunately, so I am not sure this should be even remotely considered 
a viable solution.
-- 
Florian
