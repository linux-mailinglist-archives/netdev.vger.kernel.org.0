Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D611D22121
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 03:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728459AbfERBRb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 21:17:31 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45880 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727450AbfERBRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 21:17:31 -0400
Received: by mail-pg1-f193.google.com with SMTP id i21so4054931pgi.12
        for <netdev@vger.kernel.org>; Fri, 17 May 2019 18:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=ufPK5KfqnyNHGrSx9X8kkrjj9OPNGBEp/1EOBqKYf6s=;
        b=vHW1w4CBzOakP6qXjSYDNd7lbMmE+cc3z08b+flhEPgC566zT1LANvFV2G6eccempD
         B1cYeRi6J19sYIr8YN59oKW/JFpIg8qaSwIrFl4+5pgyIcTVPDC/eDMDi/4eFAHW2n8H
         ibnJ3LIg6I6hIo69Thii1vrnU6/8HWFRy7Ag88Z5P9cTOGgYhao2f3IluC7vTnrrCGiB
         YwKtnID2ZDAEjmjWHrtSDvlfMQu/DKYgXQsEOXT6Kf017gQG692mE5MOAcKy1B5rsFBk
         LIhIIEGHVbMCrLIYi7TmVWM2WoszDojhKMZJVBewKEvZoKg9jnozLObkltNTvS/naMeO
         dX2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=ufPK5KfqnyNHGrSx9X8kkrjj9OPNGBEp/1EOBqKYf6s=;
        b=WLjqDQk5Bdo/Fho1Hq2s3cdOqRd9An1sewf73pyIkpI16qHAnaBGXE6YUisMLfegUv
         amKgdr4xAlGWOnkrIuU5pEUon6JENO5zv23XCSBiqfjF5t2UJBz6ozQY0QsU3UEs3k9k
         t0KBrXlXoqR4bsTtajUS9cSRHP4Mbrnp9DUdiKI1ShMAf/q+Xl/afdn8NPZgXM551L63
         AKrfWj1CLMtA5d2rIy+yR3f6mVSn2SYNh2QtayyFeksGNW6c6nU5mQ8Y6k4jnkhliaWt
         TOuAh823zMwo8dtI7Trx54GCstM3ZSA8h6MWRozYhB0Uis7UeWOJz/hPBYlwR/63diDt
         +nZA==
X-Gm-Message-State: APjAAAWkxF3Ch2nMB9RQS2isnx/MaEMn+b8OS8TxxoMZ6XlRdmff5U15
        2y3IVqbIALWEQ0oLTXIZ1xI=
X-Google-Smtp-Source: APXvYqwNFtwQLB+rfjtwSdtrQQ7dLZYegYrIqcbE0/5Y8vm7qolAfZbcBve0GMwjUyNBN4Qbkdl2gA==
X-Received: by 2002:a63:4c15:: with SMTP id z21mr16643006pga.395.1558142250751;
        Fri, 17 May 2019 18:17:30 -0700 (PDT)
Received: from [192.168.1.101] (122-58-182-39-adsl.sparkbb.co.nz. [122.58.182.39])
        by smtp.gmail.com with ESMTPSA id i7sm5430497pfo.19.2019.05.17.18.17.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 May 2019 18:17:30 -0700 (PDT)
Subject: Re: [PATCH 0/3] resolve module name conflict for asix PHY and USB
 modules
To:     Andrew Lunn <andrew@lunn.ch>
References: <20190514105649.512267cd@canb.auug.org.au>
 <1558124718-19209-1-git-send-email-schmitzmic@gmail.com>
 <20190517212002.GA22024@lunn.ch>
Cc:     netdev@vger.kernel.org, sfr@canb.auug.org.au, davem@davemloft.net
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <cf0f6da1-efd5-1d28-0141-5082f8b2bea1@gmail.com>
Date:   Sat, 18 May 2019 13:17:25 +1200
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:45.0) Gecko/20100101
 Icedove/45.4.0
MIME-Version: 1.0
In-Reply-To: <20190517212002.GA22024@lunn.ch>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Andrew,

makes perfect sense - patch resent.

Cheers,

	Michael

Am 18.05.2019 um 09:20 schrieb Andrew Lunn:
> On Sat, May 18, 2019 at 08:25:15AM +1200, Michael Schmitz wrote:
>> Haven't heard back in a while, so here goes:
>>
>> Commit 31dd83b96641 ("net-next: phy: new Asix Electronics PHY driver")
>> introduced a new PHY driver drivers/net/phy/asix.c that causes a module
>> name conflict with a pre-existiting driver (drivers/net/usb/asix.c).
>>
>> The PHY driver is used by the X-Surf 100 ethernet card driver, and loaded
>> by that driver via its PHY ID. A rename of the driver looks unproblematic.
>>
>> Rename PHY driver to ax88796b.c in order to resolve name conflict.
>
> Hi Michael
>
> Please just use git mv and do it all one patch. It then makes it clear
> you have not changed the driver, just renamed it.
>
> Thanks
> 	Andrew
>
