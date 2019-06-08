Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC3339A11
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 03:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730186AbfFHByM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 21:54:12 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44127 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730083AbfFHByM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 21:54:12 -0400
Received: by mail-pl1-f196.google.com with SMTP id c5so1458373pll.11
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 18:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=qt1Fiyt5vMokROumWWs2KUuhlvFbuXQvB+nny+1WkIg=;
        b=sKejeBwwB3F8vWXRh25ibKAKTXGI+dsRJOtO8tZv/vuoTrTVnIpI2AV2cvbPjY+Zd/
         PHVyMlQ/Cb7GJNyjJftYS03ViQUP+XSJWGu6TD9qqLL4TVTV6Z7nAmx9SeMsksuJPibV
         VXNv5weM6pECTtABEF03dOs/xnQmeLerA6Prye4lv4hCKDdTvjdiqTLktZ+KVgHWyUpB
         lCfZWvvXaImEUH8To5Q/eNOmurXwysAPFtDaklHrEfMulBuGB3X5/ha6PROP0/Jf/wWz
         MQ11iV12FTO0LuUgu4UXkoR+i7Ivs3KtE3Eulg1/F900R8vJ4ZhSXs+40ig2nXpFYNxo
         v/1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=qt1Fiyt5vMokROumWWs2KUuhlvFbuXQvB+nny+1WkIg=;
        b=RYMp467/zpD/hpmLb6y1EXlux5lBcB9IwOhIOKwUbt9bxJ0MmYKxhnZ5I8HbZAqQ9V
         oOL+KMY0E/GnxQ6dUCi9DA7WXXMOZSjUTvgVd9LGpfX/+fYnLiubomXhljYH5J5hsZS+
         PIqFaSURjGW1NnzXNLMRIRb9jx2mZSSr5EDCr2TJRKxOKEo1bWrz9Dz0l3E5HDpZKDdI
         cR/ZpBB7UsUm88XZKK69o/j4ykoQPdP01yXDvJ0oQaMruwOVGqGCzXW6SDQ0HVtnj8gQ
         DJYBABykzUsqXFeZ/PCRnhORSn2u2C1swMtp4uHbQVRXLwit6eHIlXlH5oAeA9iHuyjS
         brVw==
X-Gm-Message-State: APjAAAV/aYH663kpGYQc14/Oxo7YTuWwNT2ChpmbIFbfVUoAYe1Fk+jZ
        c//xYfXgeq7smIXK7xTd9zY=
X-Google-Smtp-Source: APXvYqyxbjFD6bJFhkdeR18LCGaCpi9cVwFhvCQ4WEYmhAGvxIsGBejSBqnwMkInuLodBwPsxrfhqw==
X-Received: by 2002:a17:902:b215:: with SMTP id t21mr58498984plr.152.1559958851201;
        Fri, 07 Jun 2019 18:54:11 -0700 (PDT)
Received: from [192.168.1.101] (122-58-182-39-adsl.sparkbb.co.nz. [122.58.182.39])
        by smtp.gmail.com with ESMTPSA id z68sm3818144pfb.37.2019.06.07.18.54.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jun 2019 18:54:10 -0700 (PDT)
Subject: Re: [PATCH net v3] net: phy: rename Asix Electronics PHY driver
To:     Andrew Lunn <andrew@lunn.ch>
References: <20190514105649.512267cd@canb.auug.org.au>
 <1559885854-15904-1-git-send-email-schmitzmic@gmail.com>
 <20190607130014.GL20899@lunn.ch>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Geert Uytterhoeven <geert@linux-m68k.org>
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <8ace326e-b9fe-92d0-6617-5347c4389fcc@gmail.com>
Date:   Sat, 8 Jun 2019 13:54:05 +1200
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:45.0) Gecko/20100101
 Icedove/45.4.0
MIME-Version: 1.0
In-Reply-To: <20190607130014.GL20899@lunn.ch>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Am 08.06.2019 um 01:00 schrieb Andrew Lunn:
> On Fri, Jun 07, 2019 at 05:37:34PM +1200, Michael Schmitz wrote:
>> [Resent to net instead of net-next - may clash with Anders Roxell's patch
>> series addressing duplicate module names]
>>
>> Commit 31dd83b96641 ("net-next: phy: new Asix Electronics PHY driver")
>> introduced a new PHY driver drivers/net/phy/asix.c that causes a module
>> name conflict with a pre-existiting driver (drivers/net/usb/asix.c).
>>
>> The PHY driver is used by the X-Surf 100 ethernet card driver, and loaded
>> by that driver via its PHY ID. A rename of the driver looks unproblematic.
>>
>> Rename PHY driver to ax88796b.c in order to resolve name conflict.
>>
>> Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
>> Tested-by: Michael Schmitz <schmitzmic@gmail.com>
>> Fixes: 31dd83b96641 ("net-next: phy: new Asix Electronics PHY driver")
>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Thanks for your review, Andrew.

Which reminds me - I had submitted two patches as cleanup for the 
xsurf100.c driver that would allow us to drop including lib8390.c there. 
The patches were reviewed by Geert but never picked up by Dave.

The card-specific block_output function provided by the xsurf100.c 
driver needs to execute reset_8380() when transfers get stuffed up. 
According to the comment at the head of lib8390.c, a reset must always 
be followed by a call to __NS8390_init(), so this function is also 
needed by our block_output. The current xsurf100.c includes lib8390.c 
just for the benefit of that single function.

My solution was to export ax_8390_init() through a public wrapper, but 
that didn't find favour, apparently. The only other solution I can see 
would be to add an init_8380 function pointer to the ei_device struct, 
but as init_8390 isn't really board specific, that would be abusing 
ei_device a little, no?

Any feedback welcome.

Cheers,

	Michael


>
>     Andrew
>
