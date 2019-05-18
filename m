Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E27D622451
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 19:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728551AbfERRsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 13:48:46 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42173 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbfERRsp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 May 2019 13:48:45 -0400
Received: by mail-pf1-f194.google.com with SMTP id 13so5196383pfw.9
        for <netdev@vger.kernel.org>; Sat, 18 May 2019 10:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=LkIvKlb+w5xwl210BHrFRXDJzm2c3bLDj4FUb8ioGtQ=;
        b=o6sPS90FSCxkfVCsdt3OhYkbkyEo5IpE5CpG7NUvcHBu+IvN1d818/cavKsej2SRDQ
         fQBait5GVr7ZjOsINe/vuWMWz6/2ocfN2N6KyxqtUz7GYOI0etGR7AeU5J06JjYOVmfm
         rVFiiHr9md3s2cO4FxyVKAgpDdprOWmQqI44Ts0fNgf83hRE6OeX2j9Hht604Q3IAHLb
         j7F87ugvIOzOMXBJZofwn9Tan9Dkw5tDvAY3pQMBTBQ8hAe5wf3lryakonHpm6c+MvVt
         jWQzA5E/g/qyMypiuBQ02rxNFcSU/8GhjCEoeStLGrX4z3p8voR8Kts1B1D6Kuc4hLA2
         vI2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=LkIvKlb+w5xwl210BHrFRXDJzm2c3bLDj4FUb8ioGtQ=;
        b=bi6U9H3uAWf1mF/Uw5cLFgh+KoBCxhnOKvzZUZSEf9HujygOiKi2Ct7qZZVHVywEs+
         zaEjhYhOsmwNTUGuHtnB7x9JdMVKhYEqDR1tcnTcJrO1wIT0iAs2Yy/mtmYGbHuNatbd
         0xpg4IX5BzmxOrfAusQpAAG4EY0gWCwXocTCg+SkxU9S/gi0m3mnK5TNVgNg0ZyrH3zv
         b0vd8/ISqdJnFMGOOSjB6ggSRYbXTGv3b2WyWa8iqkgZxpPcGbj25ZA9aorfXKkL/oHR
         UgafnUwA1+LHVvDpebnlj2bSLwNv/u3zyu/8GYJPuffCz7wn4hfzwI7v8geikskB42a/
         QMPw==
X-Gm-Message-State: APjAAAULjveA8lMJ7RjM15QLfemlx0uYz5lcPh4wRf8tyGLdcGKT9cly
        +B59dRf17sA/R8vSv4wHovz4rjrJ
X-Google-Smtp-Source: APXvYqzLChn8mxZBL1w4RdV+78CEORF+Fi0mhPK/zSOUfR4z/fnKNPy818DIbLq/4P8DCkWN6fS7AA==
X-Received: by 2002:a63:2325:: with SMTP id j37mr64306703pgj.137.1558201725375;
        Sat, 18 May 2019 10:48:45 -0700 (PDT)
Received: from [192.168.1.101] (122-58-182-39-adsl.sparkbb.co.nz. [122.58.182.39])
        by smtp.gmail.com with ESMTPSA id l141sm16732654pfd.24.2019.05.18.10.48.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 18 May 2019 10:48:44 -0700 (PDT)
Subject: Re: [PATCH v2] net: phy: rename Asix Electronics PHY driver
To:     Andrew Lunn <andrew@lunn.ch>
References: <20190514105649.512267cd@canb.auug.org.au>
 <1558142095-20307-1-git-send-email-schmitzmic@gmail.com>
 <20190518142010.GL14298@lunn.ch>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, sfr@canb.auug.org.au
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <cebbb214-c79f-ab7c-8238-0bc0576ddfbd@gmail.com>
Date:   Sun, 19 May 2019 05:48:40 +1200
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:45.0) Gecko/20100101
 Icedove/45.4.0
MIME-Version: 1.0
In-Reply-To: <20190518142010.GL14298@lunn.ch>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Am 19.05.2019 um 02:20 schrieb Andrew Lunn:
> On Sat, May 18, 2019 at 01:14:55PM +1200, Michael Schmitz wrote:
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
>> Fixes: 31dd83b96641 ("net-next: phy: new Asix Electronics PHY driver")
>> ---
>>
>> Changes from v1:
>>
>> - merge into single commit (suggested by Andrew Lunn)
>
> Hi Michael
>
> There is a flag you can pass to git which will make it issue a rename,
> rather than delete and then add. That will make the patch much
> smaller.

Thanks, will do.

> net-next is closed at the moment.

My apologies - I had hoped that as a bugfix. this could go straight to net.

Cheers,

	Michael

>
> http://vger.kernel.org/~davem/net-next.html
>
> Once it reopens, please send a v3, and it will be merged.
>
> Thanks
> 	Andrew
>
