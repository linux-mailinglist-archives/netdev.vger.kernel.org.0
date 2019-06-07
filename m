Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52852383CB
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 07:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbfFGFij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 01:38:39 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37953 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbfFGFij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 01:38:39 -0400
Received: by mail-pl1-f194.google.com with SMTP id f97so377232plb.5
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 22:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=fBLHoBBFLjWFQj+vWI/zOnyuH0YEQ6j6IoW3YJzYQyA=;
        b=Ltp8PcMq/Oy63oh2S0kIw1o1I0t97dEIulKY67yZNx2/w6TgzIGIf42bSZQ/rPvwPZ
         tUl1ObwH4wshnj/Jhv9nyUp+6TZOR7pmud7m7F8p4ctAHCOtlwUVgPSMmNDT8rtKJJPd
         ypVUWyc5pVaHVXFnUTDAVECWT56/NDeuC0li4fvdfXPh3qIpff+ZgjHsHku0OgIeVyYo
         TeXj/6GnIEcxTt9nXziuCvGqmK9oolEvHKdTrQv6eY8VBsdVon+rHnZ3yEorZC02GgmA
         RAB/NYtVZP0ESL+/Ox1bu3B68SIE3xBBFRDxuo2WC3dzm1s3nDI9n7Sdp5PUdWq9Waa5
         Hflw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=fBLHoBBFLjWFQj+vWI/zOnyuH0YEQ6j6IoW3YJzYQyA=;
        b=S8IxrSMU6UyGMchiqEBqJN3VnaaBvdwkE4mH5oRkZMz5TtdJN2Os2OUa9myFqujFty
         HVFC8N8oB9aktI86GvN3ox26iZrthRnH1iruomWkVKlCEyN33aiTvAJMNOAh/MYMOqXn
         dgZYZNzdqfw4BASzoFTemvYd33z0PgDV1OYM3vPMM6p7DgHT9440Dgj3+HT3qR7csaiL
         KYrBdqlF7rMs6wN3YyV5SKQk7HzR2j1p+RmgmVH+LSRmhDRS8M3asAY7xD3zZRwhCT87
         Gwkokr+ZuRPAQyWE0AuJ7hLyrk+Cm9H+iKEH9fhkNPcSnYmEc4eW2jMKukfnxRBaGons
         //Mg==
X-Gm-Message-State: APjAAAW2cmqn8jP3ReodET7moYUoUF77T8IP9QSJtl4phD3eLMGfHnoG
        fc1PgstjMJK0CSputo0EBxgkd1uw
X-Google-Smtp-Source: APXvYqw5GxZ8fX0IM4LGcw+Hm6rAgozJdutY9xL5haZk8yIqS6pXMueAHZh1/Ek0lIEAVjPzTUiBlQ==
X-Received: by 2002:a17:902:bd06:: with SMTP id p6mr53060813pls.112.1559885918710;
        Thu, 06 Jun 2019 22:38:38 -0700 (PDT)
Received: from [192.168.1.101] (122-58-182-39-adsl.sparkbb.co.nz. [122.58.182.39])
        by smtp.gmail.com with ESMTPSA id o192sm989647pgo.74.2019.06.06.22.38.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 22:38:38 -0700 (PDT)
Subject: Re: [PATCH 6/8] drivers: net: phy: fix warning same module names
To:     Andrew Lunn <andrew@lunn.ch>
References: <20190606094727.23868-1-anders.roxell@linaro.org>
 <20190606125817.GF20899@lunn.ch>
 <e56b59ce-5d5d-b28f-4886-d606fee19152@gmail.com>
 <20190607015912.GI20899@lunn.ch>
Cc:     Anders Roxell <anders.roxell@linaro.org>, f.fainelli@gmail.com,
        hkallweit1@gmail.com, davem@davemloft.net, netdev@vger.kernel.org
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <55fff7d9-064a-c2dc-8d6a-080749dfedd9@gmail.com>
Date:   Fri, 7 Jun 2019 17:38:32 +1200
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:45.0) Gecko/20100101
 Icedove/45.4.0
MIME-Version: 1.0
In-Reply-To: <20190607015912.GI20899@lunn.ch>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Am 07.06.2019 um 13:59 schrieb Andrew Lunn:
> On Fri, Jun 07, 2019 at 12:34:47PM +1200, Michael Schmitz wrote:
>> Hi Andew, Anders,
>>
>> sorry I dropped the ball on that one - I've got a patch for the ax88796b PHY
>> driver that I just forgot to resend.
>>
>> It'll clash with your patch, Anders - are you happy to drop the
>> CONFIG_ASIX_PHY from your series?
>
> Hi Michael
>
> Please send your patch. Anders needs to split up his patchset anyway,
> so dropping one is not a problem.

Done, thanks for your feedback.

Cheers,

	Michael

>
>    Andrew
>
